import 'package:flutter/material.dart';
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

  //テスト用のデータ
  final List<Map<String, dynamic>> _participants = [
    {"name": "山田", "lat": 35.681236, "lng": 139.767125}, // 東京駅
    {"name": "usatyo", "lat": 35.689487, "lng": 139.691711}, // 新宿
    {"name": "mikan", "lat": 35.658581, "lng": 139.745433}, // 東京タワー
  ];
  // 🏁 待ち合わせ場所
  LatLng meetingLocation = LatLng(35.669626, 139.765539);

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
          Positioned(
            top: 40,
            right: 20,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              onPressed: () => onTapExit(context),
              child: const Text('退出', style: TextStyle(color: Colors.black)),
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
                  const Text('あと10分20秒'),
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
