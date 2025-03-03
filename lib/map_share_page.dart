import 'dart:async';
import 'dart:math';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:location/location.dart';
import 'dart:isolate';
import 'dart:ui';
import 'package:background_locator_2/background_locator.dart';
import 'package:background_locator_2/location_dto.dart';
import 'package:mesh_frontend/all_gathered_page.dart';
import 'package:mesh_frontend/components/custom_goal_pin.dart';
import 'package:mesh_frontend/grpc/gen/server.pb.dart';
import 'package:mesh_frontend/grpc/grpc_channel_provider.dart';
import 'package:mesh_frontend/grpc/grpc_service.dart';
import 'package:mesh_frontend/home_page.dart';
import 'package:mesh_frontend/utils/format_date.dart';
import 'package:mesh_frontend/utils/location_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:mesh_frontend/components/custom_user_pin.dart';
import 'package:mesh_frontend/components/arrival_confirmation_card.dart';

//https://www.cloudbuilders.jp/articles/4214/
class MapSharePage extends ConsumerStatefulWidget {
  final String groupId;

  const MapSharePage({super.key, required this.groupId});

  @override
  ConsumerState<MapSharePage> createState() => _MapSharePageState();
}

class _MapSharePageState extends ConsumerState<MapSharePage> {
  late GoogleMapController mapController;
  LocationDto? _currentLocation;
  final location = Location();
  static const String isolateName = "LocatorIsolate";
  ReceivePort port = ReceivePort();
  Set<Marker> _markers = {};
  bool hasArrived = false; // 到着済みかどうかのフラグ
  ShareGroup? group;
  String? accessToken;

  // timer
  Timer? fetchTimer;
  Timer? countdownTimer;
  String remainingTimeText = "計算中..."; // 初期値

  @override
  void initState() {
    super.initState();
    _loadAccessToken();
    _initializeServices();
    _fetchGroup();
    _startCountdownTimer();
  }

  Future<void> _loadAccessToken() async {
    final prefs = await SharedPreferences.getInstance();
    accessToken = prefs.getString('accessToken');
  }

  Future<void> _fetchGroup() async {
    final channel = ref.read(grpcChannelProvider);

    fetchTimer = Timer.periodic(const Duration(seconds: 3), (
      Timer timer,
    ) async {
      final res = await GrpcService.getShareGroupByLinkKey(
        channel,
        widget.groupId,
      );
      if (mounted) {
        setState(() {
          group = res.shareGroup;
        });
        _setCustomMarkers();
        _fetchCurrentUser();
        if (_checkAllArrived()) {
          //groupIdを削除
          final prefs = await SharedPreferences.getInstance();
          await prefs.remove('groupId');
          _navigateToAllGatheredPage();
        }
      }
    });
  }

  //getCurrentUserを呼び出す
  Future<void> _fetchCurrentUser() async {
    if (accessToken == null) return;

    final channel = ref.read(grpcChannelProvider);
    final res = await GrpcService.getCurrentUser(channel, accessToken!);

    if (res.user != null && mounted) {
      final userJson = res.user.toProto3Json() as Map<String, dynamic>?;

      setState(() {
        hasArrived =
            userJson != null &&
            userJson.containsKey('isArrived') &&
            res.user.isArrived;
      });
    }
  }

  void _navigateToAllGatheredPage() {
    if (!mounted) return; // Widgetが破棄されていたら処理しない

    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => const AllGatheredPage()),
      (Route<dynamic> route) => false, // すべての前の画面を削除
    );
  }

  void _startCountdownTimer() {
    countdownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (group == null || group!.meetingTime.isEmpty) {
        setState(() {
          remainingTimeText = "未設定";
        });
        return;
      }

      DateTime meetingTime = DateTime.parse(
        group!.meetingTime,
      ); // 文字列からDateTimeに変換
      Duration difference = meetingTime.difference(DateTime.now());

      if (difference.isNegative) {
        setState(() {
          remainingTimeText = "集合時間を過ぎました";
          countdownTimer?.cancel(); // タイマー停止
        });
      } else {
        int minutes = difference.inMinutes;
        int seconds = difference.inSeconds % 60;
        setState(() {
          remainingTimeText = "集合まで残り $minutes分$seconds秒";
        });
      }
    });
  }

  Future<void> _initializeServices() async {
    await _requestLocationPermission();
    await _initializeLocationService();
    LocationCallbackHandler.startLocationService();
  }

  Future<void> _initializeLocationService() async {
    IsolateNameServer.registerPortWithName(port.sendPort, isolateName);
    port.listen((dynamic data) async {
      // debugPrint("received location: $data");
      if (data != null) {
        setState(() {
          _currentLocation = LocationDto.fromJson(data);
        });

        if (accessToken != null) {
          final channel = ref.read(grpcChannelProvider);
          final res = await GrpcService.updatePosition(
            channel,
            _currentLocation!.latitude,
            _currentLocation!.longitude,
            accessToken!,
          );
        }
      }
    });
    await initPlatformState();
  }

  Future<void> _requestLocationPermission() async {
    await RequestLocationPermission.request(location);
  }

  void onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  void onTapExit(BuildContext context) async {
    IsolateNameServer.removePortNameMapping(isolateName);
    BackgroundLocator.unRegisterLocationUpdate();
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('groupId');
    await prefs.remove('accessToken');
    if (context.mounted) {
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => const HomePage()),
        (Route<dynamic> route) => false, // すべての前のルートを削除
      );
    }
  }

  void _setCustomMarkers() async {
    if (group == null) return;

    Set<Marker> markers = {};

    for (var user in group!.users) {
      if (!user.hasLat() || !user.hasLon()) continue;

      final BitmapDescriptor icon = await CustomUserPin.createCustomMarker(
        user.name,
      );

      markers.add(
        Marker(
          markerId: MarkerId(user.name),
          position: LatLng(user.lat, user.lon),
          icon: icon,
          infoWindow: InfoWindow(title: user.name),
          zIndex: 1,
        ),
      );
    }

    final BitmapDescriptor goalIcon = await CustomGoalPin.createGoalMarker();

    markers.add(
      Marker(
        markerId: const MarkerId("goal"),
        position: LatLng(group!.destLat, group!.destLon),
        icon: goalIcon,
        infoWindow: const InfoWindow(title: "待ち合わせ場所"),
        zIndex: 2,
      ),
    );

    if (mounted) {
      setState(() {
        _markers = markers;
      });
    }
  }

  /// 目的地との距離を計算
  bool _isNearMeetingPoint() {
    if (_currentLocation == null) return false;
    if (group == null) return false;

    double distance = _calculateDistance(
      _currentLocation!.latitude,
      _currentLocation!.longitude,
      group!.destLat,
      group!.destLon,
    );

    return distance < 50; // 50メートル以内なら到着とみなす
  }

  /// Haversine Formula で距離を計算
  double _calculateDistance(
    double lat1,
    double lon1,
    double lat2,
    double lon2,
  ) {
    const double radius = 6371000; // 地球の半径 (メートル)
    double dLat = (lat2 - lat1) * (3.141592653589793 / 180);
    double dLon = (lon2 - lon1) * (3.141592653589793 / 180);
    double a =
        (sin(dLat / 2) * sin(dLat / 2)) +
        cos(lat1 * (3.141592653589793 / 180)) *
            cos(lat2 * (3.141592653589793 / 180)) *
            (sin(dLon / 2) * sin(dLon / 2));
    double c = 2 * atan2(sqrt(a), sqrt(1 - a));
    return radius * c;
  }

  /// 「到着」ボタンが押されたとき
  void _onArrived() async {
    if (accessToken == null) return; // 認証情報がない場合は処理しない

    final channel = ref.read(grpcChannelProvider);

    try {
      // 🔹 サーバーに到着情報を送信
      await GrpcService.arriveDest(channel, accessToken!);

      // 🔹 最新のグループ情報を取得して画面を更新
      await _fetchGroup();
    } catch (e) {
      debugPrint("到着処理エラー: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("到着情報の更新に失敗しました"),
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  /// 参加者全員が到着したかをチェック
  bool _checkAllArrived() {
    if (group == null || group!.users.isEmpty) {
      return false;
    }
    return group!.users.every((user) => user.isArrived);
  }

  @override
  void dispose() {
    countdownTimer?.cancel();
    IsolateNameServer.removePortNameMapping(isolateName);
    BackgroundLocator.unRegisterLocationUpdate();
    port.close();
    fetchTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_currentLocation == null) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(Color(0xFFFAE3E2)),
          ),
        ),
      );
    }

    final cameraPosition = CameraPosition(
      target: LatLng(_currentLocation!.latitude, _currentLocation!.longitude),
      zoom: 14.0,
    );

    if (group == null) {
      return Scaffold(
        body: Center(
          child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(Color(0xFFFAE3E2)),
          ),
        ),
      );
    }

    return Scaffold(
      body: Stack(
        children: [
          GoogleMap(
            mapType: MapType.normal,
            onMapCreated: onMapCreated,
            initialCameraPosition: cameraPosition,
            myLocationButtonEnabled: false,
            markers: _markers.toSet(),
          ),
          if (!hasArrived && _isNearMeetingPoint()) // 近くにいるかつ未到着なら表示
            Positioned(
              top: 120,
              left: 12,
              right: 12,
              child: ArrivalConfirmationCard(onArrived: _onArrived),
            ),
          Positioned(
            top: 60,
            right: 12,
            child: Row(
              children: [
                // 🔹 招待をコピーするボタン
                ElevatedButton.icon(
                  onPressed: () {
                    Clipboard.setData(
                      ClipboardData(text: group!.inviteUrl),
                    ).then((_) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text("招待リンクをコピーしました！"),
                          duration: Duration(seconds: 2),
                        ),
                      );
                    });
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white, // 🔹 背景を白に
                    foregroundColor: Colors.black, // 🔹 文字とアイコンを黒に
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    padding: const EdgeInsets.symmetric(
                      vertical: 10,
                      horizontal: 16,
                    ),
                  ),
                  icon: const Icon(Icons.content_copy, size: 20),
                  label: const Text("招待をコピー", style: TextStyle(fontSize: 14)),
                ),

                const SizedBox(width: 8), // ボタン間のスペース
                // 🔹 退出ボタン
                ElevatedButton.icon(
                  onPressed: () => onTapExit(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white, // 🔹 背景を白に
                    foregroundColor: Colors.black, // 🔹 文字とアイコンを黒に
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    padding: const EdgeInsets.symmetric(
                      vertical: 10,
                      horizontal: 16,
                    ),
                  ),
                  icon: const Icon(Icons.exit_to_app, size: 20),
                  label: const Text("退出", style: TextStyle(fontSize: 14)),
                ),
              ],
            ),
          ),
          Positioned(
            bottom: 12,
            left: 12,
            right: 12,
            child: _BottomCard(group: group, remainingTimeText: remainingTimeText),
          ),
        ],
      ),
    );
  }
}

class _BottomCard extends StatelessWidget {
  const _BottomCard({
    required this.group,
    required this.remainingTimeText,
  });

  final ShareGroup? group;
  final String remainingTimeText;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(32),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.7),
                borderRadius: BorderRadius.circular(32),
                border: Border.all(
                  color: Colors.grey.withOpacity(0.3), // 薄いグレーの枠線
                  width: 1.0,
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 16,
                  horizontal: 16,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [          // 🔹 待ち合わせ日時
                    Text(
                      '${formatDateTime(group!.meetingTime)} 集合', // ここは動的に変更可能
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    // 残り時間の表示
                    Row(
                      children: [
                        const Icon(
                          Icons.timer,
                          size: 24,
                          color: Colors.red,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          remainingTimeText,
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: Colors.black54,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // 旗アイコン
                        ShaderMask(
                          shaderCallback: (Rect bounds) {
                            return ui.Gradient.linear(
                              bounds.topCenter,
                              bounds.bottomCenter,
                              [
                                const Color(0xFFF86594), // ピンク
                                const Color(0xFFFCC373), // オレンジ
                              ],
                            );
                          },
                          child: const Icon(
                            Icons.flag,
                            size: 24,
                            color: Colors.white, // 白をベースにグラデーションを適用
                          ),
                        ),
                        const SizedBox(width: 6),
                        // 住所
                        Expanded(
                          child: Text(
                            group!.address, // 住所を表示
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: Colors.black54,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      "メンバーへひとこと",
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: Colors.black,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    TextField(
                      decoration: InputDecoration(
                        contentPadding: const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: const BorderSide(color: Colors.orangeAccent),
                        ),
                        hintText: 'ちょっと遅れる！',
                        hintStyle: const TextStyle(color: Colors.grey),
                        filled: true,
                        fillColor: Colors.white,
                      ),
                      style: const TextStyle(fontSize: 14),
                      maxLines: 1,
                      onSubmitted: (value) {
                        // 送信処理
                      },
                    ),
        
                    // 🔹 メンバー一覧
                    Theme(
                      data: Theme.of(
                        context,
                      ).copyWith(dividerColor: Colors.transparent),
                      child: ExpansionTile(
                        tilePadding: EdgeInsets.all(0),
                        title: Row(
                          children: [
                            Icon(
                              Icons.people,
                              size: 24,
                              color: Colors.blue,
                            ),
                            const SizedBox(width: 6),
                            Text(
                              "${group!.users.length}人中 ${group!.users.where((p) => p.isArrived).length}人が到着済み",
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: Colors.black54,
                              ),
                            ),
                          ],
                        ),
                        children:
                            group!.users.map((user) {
                              bool isArrived = user.isArrived;
                              return Padding(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 6,
                                  horizontal: 10,
                                ),
                                child: Row(
                                  children: [
                                    Text(
                                      user.name,
                                      style: const TextStyle(fontSize: 16),
                                    ),
                                    const Spacer(),
                                    Row(
                                      children: [
                                        Icon(
                                          isArrived
                                              ? Icons.check_circle
                                              : Icons.access_time,
                                          color:
                                              isArrived
                                                  ? Colors.green
                                                  : Colors.grey,
                                          size: 20,
                                        ),
                                        const SizedBox(width: 4),
                                        Text(
                                          isArrived ? "到着済み" : "未到着",
                                          style: TextStyle(
                                            fontSize: 14,
                                            color:
                                                isArrived
                                                    ? Colors.green
                                                    : Colors.grey,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              );
                            }).toList(),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
