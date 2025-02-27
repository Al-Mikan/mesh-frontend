import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:mesh_frontend/set_details_page.dart';
import 'package:mesh_frontend/components/button.dart';

class SetLocationPage extends StatefulWidget {
  final String groupId;

  const SetLocationPage({super.key, required this.groupId});

  @override
  State<SetLocationPage> createState() => _SetLocationPageState();
}

class _SetLocationPageState extends State<SetLocationPage> {
  late GoogleMapController _mapController;
  LatLng _selectedLocation = const LatLng(35.6812, 139.7671); // デフォルトは東京駅

  /// マップが動いたとき、中心座標を更新
  void _onCameraMove(CameraPosition position) {
    setState(() {
      _selectedLocation = position.target;
    });
  }

  /// 「ここを目的地にする」ボタンを押したとき
  void _confirmLocation() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder:
            (context) => SetDetailsPage(
              groupId: widget.groupId,
              location:
                  "${_selectedLocation.latitude}, ${_selectedLocation.longitude}",
            ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LayoutBuilder(
        builder: (context, constraints) {
          double cardHeight = 160; // 🔹 Card の高さ
          double pinOffset = cardHeight / 2; // 🔹 Pin を Card の縦幅分上に移動

          return Stack(
            children: [
              // Google Maps
              Positioned.fill(
                child: GoogleMap(
                  initialCameraPosition: CameraPosition(
                    target: _selectedLocation,
                    zoom: 15.0,
                  ),
                  onMapCreated: (GoogleMapController controller) {
                    _mapController = controller;
                  },
                  onCameraMove: _onCameraMove, // マップ移動時に座標更新
                  myLocationEnabled: true,
                  myLocationButtonEnabled: false,
                ),
              ),

              // 中央に固定された Goal Pin (Card の高さ分上に配置)
              Positioned(
                top:
                    (constraints.maxHeight / 2) -
                    pinOffset, // 🔹 中央から Card の高さ分ずらす
                left: (constraints.maxWidth / 2) - 25, // 🔹 アイコンサイズ調整
                child: const Icon(
                  Icons.location_on,
                  size: 50,
                  color: Colors.red,
                ),
              ),

              // 下部の情報カード
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
                      vertical: 30,
                      horizontal: 20,
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Text(
                          "待ち合わせ場所を設定してください",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 15),
                        Text(
                          "${_selectedLocation.latitude.toStringAsFixed(6)}, ${_selectedLocation.longitude.toStringAsFixed(6)}",
                          style: const TextStyle(fontSize: 16),
                        ),
                        const SizedBox(height: 15),
                        OriginalButton(
                          text: "ここを目的地にする",
                          onPressed: _confirmLocation,
                          fill: true, // ✅ デザイン統一
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
