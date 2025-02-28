import 'dart:async';
import 'dart:math';

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

  // timer
  Timer? fetchTimer;

  @override
  void initState() {
    super.initState();
    _initializeServices();
    _fetchGroup();
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

      setState(() {
        group = res.shareGroup;
      });
    });
  }

  Future<void> _initializeServices() async {
    await _requestLocationPermission();
    await _initializeLocationService();
    LocationCallbackHandler.startLocationService();

    _setCustomMarkers();
  }

  Future<void> _initializeLocationService() async {
    IsolateNameServer.registerPortWithName(port.sendPort, isolateName);
    port.listen((dynamic data) {
      debugPrint("received location: $data");
      if (data != null) {
        setState(() {
          _currentLocation = LocationDto.fromJson(data);
        });
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
      final BitmapDescriptor icon = await CustomUserPin.createCustomMarker(
        user.name,
      );

      markers.add(
        Marker(
          markerId: MarkerId(user.name),
          position: LatLng(user.lat, user.lon),
          icon: icon,
          infoWindow: InfoWindow(title: user.name),
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
      ),
    );

    setState(() {
      _markers = markers;
    });
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

  /// 参加者全員が到着したかをチェック
  bool _checkAllArrived() {
    //TODO: 参加者全員が到着したかをチェックする処理を実装

    return false;
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
    setState(() {
      hasArrived = true;
    });

    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('hasArrived', true);
  }

  /// 保存されている到着状況を取得
  Future<void> _checkArrivalStatus() async {
    final prefs = await SharedPreferences.getInstance();
    bool? arrived = prefs.getBool('hasArrived');
    if (arrived != null) {
      setState(() {
        hasArrived = arrived;
      });
    }
  }

  @override
  void dispose() {
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
      return const Center(
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(Color(0xFFFAE3E2)),
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
            myLocationEnabled: true,
            myLocationButtonEnabled: false,
            markers: _markers.toSet(),
          ),
          if (!hasArrived && _isNearMeetingPoint()) // 近くにいるかつ未到着なら表示
            Positioned(
              top: 100,
              left: 20,
              right: 20,
              child: ArrivalConfirmationCard(onArrived: _onArrived),
            ),
          Positioned(
            top: 50,
            right: 20,
            child: Row(
              children: [
                // 🔹 招待をコピーするボタン
                ElevatedButton.icon(
                  onPressed: () {
                    Clipboard.setData(
                      const ClipboardData(text: "https://example.com/invite"),
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
            left: 20,
            right: 20,
            bottom: 300,
            child: ElevatedButton(
              onPressed: () {
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const AllGatheredPage(),
                  ),
                  (Route<dynamic> route) => false,
                );
              },
              child: const Text("全員集合ページへ"),
            ),
          ),

          Positioned(
            bottom: 20,
            left: 20,
            right: 20,
            child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 5,
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 20,
                  horizontal: 20,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // 🔹 待ち合わせ日時
                    const Center(
                      child: Text(
                        '○月○日 14:00 集合', // ここは動的に変更可能
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),

                    // 🔹 残り時間の表示
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.timer,
                          size: 20,
                          color: Colors.deepOrange,
                        ),
                        const SizedBox(width: 6),
                        const Text(
                          '残り10分20秒', // ここは動的に変更可能
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),

                    // 🔹 区切り線
                    const Divider(
                      thickness: 1,
                      color: Color.fromARGB(255, 184, 184, 184),
                    ),

                    // 🔹 メンバー一覧
                    Theme(
                      data: Theme.of(
                        context,
                      ).copyWith(dividerColor: Colors.transparent),
                      child: ExpansionTile(
                        title: Text(
                          "${group!.users.length}人中 ${group!.users.where((p) => true).length}人が到着済み",
                          style: const TextStyle(
                            fontSize: 16,
                            // fontWeight: FontWeight.bold,
                          ),
                        ),
                        children:
                            group!.users.map((user) {
                              bool isArrived = true;
                              return Padding(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 6,
                                  horizontal: 10,
                                ),
                                child: Row(
                                  children: [
                                    // 🔹 メンバー名 (左側)
                                    Text(
                                      user.name,
                                      style: const TextStyle(fontSize: 16),
                                    ),

                                    // 🔹 スペースを追加し、アイコンを右寄せ
                                    const Spacer(),

                                    // 🔹 到着状況 (右側)
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
        ],
      ),
    );
  }
}
