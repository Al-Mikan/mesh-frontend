import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'dart:isolate';
import 'dart:ui';
import 'package:background_locator_2/background_locator.dart';
import 'package:background_locator_2/location_dto.dart';
import 'package:mesh_frontend/components/custom_goal_pin.dart';
import 'package:mesh_frontend/home_page.dart';
import 'package:mesh_frontend/utils/location_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:mesh_frontend/components/custom_user_pin.dart';
import 'package:mesh_frontend/components/arrival_confirmation_card.dart';

//https://www.cloudbuilders.jp/articles/4214/
class MapSharePage extends StatefulWidget {
  final String groupId;

  const MapSharePage({super.key, required this.groupId});

  @override
  State<MapSharePage> createState() => _MapSharePageState();
}

class _MapSharePageState extends State<MapSharePage> {
  late GoogleMapController mapController;
  LocationDto? _currentLocation;
  final location = Location();
  static const String isolateName = "LocatorIsolate";
  ReceivePort port = ReceivePort();
  Set<Marker> _markers = {};
  bool hasArrived = false; // 到着済みかどうかのフラグ

  //テスト用のデータ
  final List<Map<String, dynamic>> _participants = [
    {"name": "山田", "lat": 35.681236, "lng": 139.777125}, // 東京駅
    {"name": "usatyo", "lat": 35.689487, "lng": 139.691711}, // 新宿
    {"name": "mikan", "lat": 35.658581, "lng": 139.745433}, // 東京タワー
  ];
  // 待ち合わせ場所
  // LatLng meetingLocation = LatLng(35.669626, 139.765539);
  LatLng meetingLocation = LatLng(35.6813, 139.767066);

  @override
  void initState() {
    super.initState();
    _initializeServices();
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
    Set<Marker> markers = {};

    for (var user in _participants) {
      final BitmapDescriptor icon = await CustomUserPin.createCustomMarker(
        user["name"],
      );

      markers.add(
        Marker(
          markerId: MarkerId(user["name"]),
          position: LatLng(user["lat"], user["lng"]),
          icon: icon,
          infoWindow: InfoWindow(title: user["name"]),
        ),
      );
    }

    final BitmapDescriptor goalIcon = await CustomGoalPin.createGoalMarker();

    markers.add(
      Marker(
        markerId: const MarkerId("goal"),
        position: meetingLocation,
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

    double distance = _calculateDistance(
      _currentLocation!.latitude,
      _currentLocation!.longitude,
      meetingLocation.latitude,
      meetingLocation.longitude,
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
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_currentLocation == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    final cameraPosition = CameraPosition(
      target: LatLng(_currentLocation!.latitude, _currentLocation!.longitude),
      zoom: 14.0,
    );

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
            bottom: 20,
            left: 20,
            right: 20,
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('○月○日 14:00集合'),
                  const Text('残り10分20秒'),
                  const Text('山田, usatyo, mikan が到着済みです'),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
