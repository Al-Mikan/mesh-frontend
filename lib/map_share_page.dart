import 'dart:async';
import 'dart:ffi';
import 'dart:math';
import 'dart:ui' as ui;

import 'package:flutter/cupertino.dart';
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
import 'package:mesh_frontend/utils/googlemaps_direction.dart';
import 'package:mesh_frontend/utils/location_service.dart';
import 'package:pull_down_button/pull_down_button.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:mesh_frontend/components/custom_user_pin.dart';
import 'package:mesh_frontend/components/arrival_confirmation_card.dart';
import 'package:url_launcher/url_launcher.dart';

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
  Set<Polyline> _polylines = {};
  bool hasArrived = false; // 到着済みかどうかのフラグ
  ShareGroup? group;
  String? accessToken;
  int? userId;

  // timer
  Timer? fetchTimer;
  Timer? countdownTimer;
  String remainingTimeText = "計算中..."; // 初期値

  //経路の時間
  late GoogleMapsDirections directionsService;
  TravelTime? travelTime;
  bool isFetchedDirections = false;

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
    userId = prefs.getInt('userId');
    const apiKay = String.fromEnvironment('GOOGLE_MAPS_API_KEY');
    directionsService = GoogleMapsDirections(apiKey: apiKay);
  }

  Future<void> _fetchGroup() async {
    final channel = ref.read(grpcChannelProvider);

    fetchTimer = Timer.periodic(const Duration(seconds: 3), (
      Timer timer,
    ) async {
      try {
        final res = await GrpcService.getShareGroupByLinkKey(
          channel,
          widget.groupId,
        );

        if (mounted) {
          setState(() {
            group = res.shareGroup;
          });
          if (_currentLocation != null && travelTime == null) {
            await _calculateTravelTimes();
          }
          _setCustomMarkers();
          _fetchCurrentUser();
          if (_checkAllArrived()) {
            _removeAuthenticationState();
            _navigateToAllGatheredPage();
          }
        }
      } catch (e) {
        print(e);
      }
    });
  }

  //getCurrentUserを呼び出す
  Future<void> _fetchCurrentUser() async {
    if (accessToken == null) return;

    final channel = ref.read(grpcChannelProvider);
    final res = await GrpcService.getCurrentUser(channel, accessToken!);

    if (mounted) {
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
        int days = difference.inDays;
        int hours = difference.inHours % 24;
        int minutes = difference.inMinutes % 60;
        int seconds = difference.inSeconds % 60;

        String timeText = "集合まで残り ";
        if (days > 0) {
          timeText += "$days日";
        }
        if (hours > 0) {
          timeText += "$hours時間";
        }
        if (minutes > 0) {
          timeText += "$minutes分";
        }
        timeText += "$seconds秒";

        setState(() {
          remainingTimeText = timeText;
        });
      }
    });
  }

  // 集合場所と現在地との移動時間を計算
  Future<void> _calculateTravelTimes() async {
    if (_currentLocation == null || group == null) return;

    final times = await directionsService.getTravelTimes(
      _currentLocation!.latitude,
      _currentLocation!.longitude,
      group!.destLat,
      group!.destLon,
    );

    if (mounted) {
      setState(() {
        travelTime = times;
      });
    }
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
        if (group != null && travelTime == null) {
          await _calculateTravelTimes();
        }

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

    if (context.mounted) {
      await _removeAuthenticationState();
      await Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => const HomePage()),
        (Route<dynamic> route) => false, // すべての前のルートを削除
      );
    }
  }

  void _setCustomMarkers() async {
    if (group == null) return;

    Set<Marker> markers = {};
    Set<Polyline> polylines = {};

    for (var user in group!.users) {
      if (!user.hasLat() || !user.hasLon()) continue;

      final BitmapDescriptor icon = await CustomUserPin.createCustomMarker(
        user.name,
      );
      final lineWidth = (user.id == userId) ? 5 : 5;
      final lineColor = (user.id == userId) ? Colors.orange : Colors.black12;
      final linePattern =
          (user.id == userId)
              ? <PatternItem>[PatternItem.dash(70), PatternItem.gap(30)]
              : <PatternItem>[PatternItem.dash(50), PatternItem.gap(50)];

      markers.add(
        Marker(
          markerId: MarkerId(user.name),
          position: LatLng(user.lat, user.lon),
          icon: icon,
          infoWindow: InfoWindow(title: user.name),
          zIndex: 1,
        ),
      );

      // 曲線の制御点を計算
      final points = _calculateBezierCurve(
        LatLng(user.lat, user.lon),
        LatLng(group!.destLat, group!.destLon),
      );

      polylines.add(
        Polyline(
          polylineId: PolylineId('${user.name}_route'),
          points: points,
          color: lineColor,
          width: lineWidth,
          geodesic: true, // 地球の曲率を考慮
          jointType: JointType.round,
          startCap: Cap.roundCap,
          endCap: Cap.roundCap,
          patterns: linePattern,
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
        _polylines = polylines;
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

  Future<void> _removeAuthenticationState() async {
    final channel = ref.read(grpcChannelProvider);
    await GrpcService.leaveShareGroup(channel, accessToken!);

    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('groupId');
    await prefs.remove('accessToken');
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
            polylines: _polylines,
          ),
          if (!hasArrived && _isNearMeetingPoint()) // 近くにいるかつ未到着なら表示
            Positioned(
              top: 120,
              left: 12,
              right: 12,
              child: ArrivalConfirmationCard(onArrived: _onArrived),
            ),
          if (group != null)
            _TopAddressCard(
              address: group!.address,
              lat: group!.destLat,
              lon: group!.destLon,
            ),
          Positioned(
            bottom: 12,
            left: 12,
            right: 12,
            child: _BottomCard(
              group: group,
              remainingTimeText: remainingTimeText,
              travelTime: travelTime,
              currentLocation: _currentLocation,
              onTapExit: () => onTapExit(context),
            ),
          ),
        ],
      ),
    );
  }

  List<LatLng> _calculateBezierCurve(LatLng start, LatLng end) {
    // 中間地点
    double midLat = (start.latitude + end.latitude) / 2;
    double midLng = (start.longitude + end.longitude) / 2;
    double latDiff = (start.latitude - end.latitude).abs();
    double lngDiff = (start.longitude - end.longitude).abs();
    LatLng controlPoint1 = LatLng(midLat, start.longitude);
    LatLng controlPoint2 = LatLng(midLat, end.longitude);
    if (latDiff < lngDiff) {
      controlPoint1 = LatLng(start.latitude, midLng);
      controlPoint2 = LatLng(end.latitude, midLng);
    }

    // ベジェ曲線を補間
    List<LatLng> bezierPoints = [];
    for (double t = 0; t <= 1; t += 0.1) {
      double lat =
          (1 - t) * (1 - t) * (1 - t) * start.latitude +
          3 * (1 - t) * (1 - t) * t * controlPoint1.latitude +
          3 * (1 - t) * t * t * controlPoint2.latitude +
          t * t * t * end.latitude;

      double lng =
          (1 - t) * (1 - t) * (1 - t) * start.longitude +
          3 * (1 - t) * (1 - t) * t * controlPoint1.longitude +
          3 * (1 - t) * t * t * controlPoint2.longitude +
          t * t * t * end.longitude;

      bezierPoints.add(LatLng(lat, lng));
    }

    return bezierPoints;
  }
}

class _TopAddressCard extends StatelessWidget {
  const _TopAddressCard({
    required this.address,
    required this.lat,
    required this.lon,
  });

  final String address;
  final double lat;
  final double lon;

  // 地図アプリを開く
  void _openMap() async {
    final Uri googleMapsUri = Uri.parse(
      "https://www.google.com/maps/search/?api=1&query=$lat,$lon",
    );
    final Uri appleMapsUri = Uri.parse("maps://?q=$lat,$lon");

    if (await canLaunchUrl(googleMapsUri)) {
      await launchUrl(googleMapsUri);
    } else if (await canLaunchUrl(appleMapsUri)) {
      await launchUrl(appleMapsUri);
    } else {
      debugPrint("地図アプリを開けませんでした");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 60,
      left: 12,
      right: 12,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(32),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.7),
              borderRadius: BorderRadius.circular(32),
              border: Border.all(
                color: Colors.grey.withOpacity(0.3),
                width: 1.0,
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
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
                      address, // 住所を表示
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),

                  // 「地図アプリを開く」ボタン（iOS スタイルの外部リンクアイコン）
                  GestureDetector(
                    onTap: _openMap,
                    child: const Padding(
                      padding: EdgeInsets.only(left: 6),
                      child: Icon(
                        Icons.open_in_new, // 🔹 iOS風の外部リンクアイコン
                        size: 20,
                        color: Colors.blueGrey,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _BottomCard extends StatelessWidget {
  const _BottomCard({
    required this.group,
    required this.remainingTimeText,
    this.travelTime,
    this.currentLocation,
    required this.onTapExit,
  });

  final ShareGroup? group;
  final String remainingTimeText;
  final TravelTime? travelTime;
  final LocationDto? currentLocation;
  final VoidCallback onTapExit;

  String _calculateDepartureTime(int? durationMinutes) {
    if (group == null ||
        group!.meetingTime.isEmpty ||
        durationMinutes == null) {
      return '--:--';
    }

    final meetingTime = DateTime.parse(group!.meetingTime);
    final departureTime = meetingTime.subtract(
      Duration(minutes: durationMinutes),
    );
    return '${departureTime.hour}:${departureTime.minute.toString().padLeft(2, '0')}';
  }

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
                  children: [
                    Row(
                      children: [
                        Text(
                          '${formatDateTime(group!.meetingTime)} 集合', // ここは動的に変更可能
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const Spacer(),
                        PullDownButton(
                          itemBuilder:
                              (context) => [
                                PullDownMenuItem(
                                  onTap: () {
                                    Clipboard.setData(
                                      ClipboardData(text: group!.inviteUrl),
                                    ).then((_) {
                                      ScaffoldMessenger.of(
                                        context,
                                      ).showSnackBar(
                                        const SnackBar(
                                          content: Text("招待リンクをコピーしました！"),
                                          duration: Duration(seconds: 2),
                                        ),
                                      );
                                    });
                                  },

                                  title: '招待をコピーする',
                                  icon: CupertinoIcons.doc_on_clipboard,
                                ),
                                PullDownMenuItem(
                                  onTap: () {
                                    onTapExit();
                                  },
                                  title: 'グループから退出する',
                                  isDestructive: true,
                                  icon: CupertinoIcons.delete,
                                ),
                              ],
                          buttonBuilder:
                              (context, openMenu) => IconButton(
                                icon: const Icon(Icons.more_vert),
                                onPressed: openMenu,
                              ),
                        ),
                      ],
                    ),
                    // 残り時間の表示
                    Row(
                      children: [
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

                    const SizedBox(height: 4),
                    const Text(
                      "出発目安",
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        MapRouteButton(
                          by: '徒歩',
                          duration:
                              travelTime?.walking != null
                                  ? '${travelTime?.walking}分'
                                  : '--分',
                          departureTime: _calculateDepartureTime(
                            travelTime?.walking,
                          ),
                          icon: Icons.directions_walk,
                          onTap: () {},
                          isCalculated: travelTime != null,
                        ),
                        const SizedBox(width: 8),
                        MapRouteButton(
                          by: '公共交通',
                          duration:
                              travelTime?.transit != null
                                  ? '${travelTime?.transit}分'
                                  : '--分',
                          departureTime: _calculateDepartureTime(
                            travelTime?.transit,
                          ),
                          icon: Icons.directions_bus,
                          onTap: () {},
                          isCalculated: travelTime != null,
                        ),
                        const SizedBox(width: 8),
                        MapRouteButton(
                          by: '車',
                          duration:
                              travelTime?.driving != null
                                  ? '${travelTime?.driving}分'
                                  : '--分',
                          departureTime: _calculateDepartureTime(
                            travelTime?.driving,
                          ),
                          icon: Icons.directions_car,
                          onTap: () {},
                          isCalculated: travelTime != null,
                        ),
                      ],
                    ),

                    const SizedBox(height: 8),
                    const Text(
                      "メンバーへひとこと",
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(height: 4),
                    TextField(
                      decoration: InputDecoration(
                        contentPadding: const EdgeInsets.symmetric(
                          vertical: 6,
                          horizontal: 12,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: const BorderSide(
                            color: Colors.orangeAccent,
                          ),
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
                            Icon(Icons.people, size: 24, color: Colors.blue),
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

class MapRouteButton extends StatelessWidget {
  const MapRouteButton({
    super.key,
    required this.by,
    required this.duration,
    required this.departureTime,
    required this.icon,
    this.onTap,
    this.isCalculated = false,
  });

  final String by;
  final String duration;
  final String departureTime;
  final IconData icon;
  final VoidCallback? onTap;
  final bool isCalculated;

  @override
  Widget build(BuildContext context) {
    return Flexible(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          width: double.infinity,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            color: isCalculated ? Colors.black12 : Colors.grey[300],
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 4),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      icon,
                      size: 24,
                      color: isCalculated ? Colors.deepOrange : Colors.grey,
                    ),
                    Text(
                      departureTime,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: isCalculated ? Colors.black : Colors.grey,
                      ),
                    ),
                  ],
                ),
                Text(
                  '$byで$duration',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: isCalculated ? Colors.grey[700] : Colors.grey,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
