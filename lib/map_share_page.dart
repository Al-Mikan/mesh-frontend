import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'dart:isolate';
import 'dart:ui';
import 'package:mesh_frontend/utils/location_service.dart';
//https://www.cloudbuilders.jp/articles/4214/
class MapSharePage extends StatefulWidget {
  final String groupId;

  const MapSharePage({super.key, required this.groupId});

  @override
  State<MapSharePage> createState() => _MapSharePageState();
}

class _MapSharePageState extends State<MapSharePage> {
  late GoogleMapController mapController;
  LatLng _center = const LatLng(35.681236, 139.767125);
  Position? _currentPosition;
  ReceivePort port = ReceivePort();

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
    _initializeLocationService();
    _startBackgroundLocationTracking();
  }

  Future<void> _getCurrentLocation() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return;
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return;
      }
    }

    Position position = await Geolocator.getCurrentPosition();
    setState(() {
      _currentPosition = position;
    });
  }

  Future<void> _initializeLocationService() async {
    await LocationService.initPlatformState();
    IsolateNameServer.registerPortWithName(port.sendPort, LocationService.isolateName);
    port.listen((dynamic data) {
      // バックグラウンドで取得した位置情報を処理
      print('Background location: $data');
    });
  }

  void _startBackgroundLocationTracking() {
    LocationService.startLocationService();
  }

  void _stopBackgroundLocationTracking() {
    LocationService.stopLocationService();
  }

  void onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  void onTapExit(BuildContext context) async {
    _stopBackgroundLocationTracking();
    // ... existing exit logic ...
  }

  @override
  void dispose() {
    IsolateNameServer.removePortNameMapping(LocationService.isolateName);
    port.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_currentPosition == null) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    final cameraPosition = CameraPosition(
      target: LatLng(_currentPosition!.latitude, _currentPosition!.longitude),
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
