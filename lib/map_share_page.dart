import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
// ... existing imports ...

class MapSharePage extends StatefulWidget {
  final String groupId;

  const MapSharePage({super.key, required this.groupId});

  @override
  State<MapSharePage> createState() => _MapSharePageState();
}

class _MapSharePageState extends State<MapSharePage> {
  late GoogleMapController mapController;
  final LatLng _center = const LatLng(35.681236, 139.767125); // 東京駅の座標

  void onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  void onTapExit(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('groupId');
    if (context.mounted) {
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => const HomePage()),
        (Route<dynamic> route) => false, // すべての前のルートを削除
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text('GroupID: $groupId はSharedPreferenceに保存されました'),
            const SizedBox(height: 20),
            const Text('画面全体に地図表示'),
            ElevatedButton(
              onPressed: () async {
                onTapExit(context);
              },
              child: const Text('グループから抜ける'),
            ),
            // ここに地図表示Widgetを追加
          ],
        ),
        myLocationEnabled: true,
        myLocationButtonEnabled: true,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => onTapExit(context),
        child: const Icon(Icons.exit_to_app),
      ),
    );
  }
}