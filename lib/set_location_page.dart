import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:mesh_frontend/search_address_page.dart';
import 'package:mesh_frontend/set_details_page.dart';
import 'package:mesh_frontend/components/button.dart';
import 'package:google_maps_webservice/geocoding.dart' as geo;
import 'package:location/location.dart';

const String _googleApiKey = String.fromEnvironment("GOOGLE_MAPS_API_KEY");

class SetLocationPage extends StatefulWidget {
  const SetLocationPage({super.key});

  @override
  State<SetLocationPage> createState() => _SetLocationPageState();
}

class _SetLocationPageState extends State<SetLocationPage> {
  GoogleMapController? _mapController;
  LatLng? _selectedLocation;
  String? _fetchedAddress;
  String? _fetchedAddressErrMessage;
  bool _isFetchingAddress = false; // 🔹 住所取得中かどうかのフラグ

  final geo.GoogleMapsGeocoding _geocoding = geo.GoogleMapsGeocoding(
    apiKey: _googleApiKey,
  );

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
  }

  @override
  void dispose() {
    _mapController?.dispose();
    super.dispose();
  }

  Future<void> _getCurrentLocation() async {
    Location location = Location();

    // 🔹 位置情報サービスが有効か確認
    bool serviceEnabled = await location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await location.requestService();
      if (!serviceEnabled) return;
    }

    // 🔹 位置情報の権限確認
    PermissionStatus permissionGranted = await location.hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await location.requestPermission();
      if (permissionGranted != PermissionStatus.granted) return;
    }

    // 🔹 現在地の取得
    try {
      final currentLocation = await location.getLocation();
      setState(() {
        _selectedLocation = LatLng(
          currentLocation.latitude!,
          currentLocation.longitude!,
        );
      });

      _mapController?.animateCamera(CameraUpdate.newLatLng(_selectedLocation!));

      _fetchAddress(_selectedLocation!);
    } catch (e) {
      print("❌ 位置情報の取得エラー: $e");
    }
  }

  /// 📌 **カメラが移動したとき**
  void _onCameraMove(CameraPosition position) {
    setState(() {
      _selectedLocation = position.target;
      _isFetchingAddress = true; // 🔹 住所取得中にする
      _fetchedAddress = null; // クリア
    });
  }

  /// 📌 **カメラが停止したとき**
  void _onCameraIdle() async {
    if (_isFetchingAddress == false || _selectedLocation == null) return;
    _isFetchingAddress = true;
    await _fetchAddress(_selectedLocation!);
    _isFetchingAddress = false;
  }

  /// 📌 **緯度経度から住所を取得（日本語）**
  Future<void> _fetchAddress(LatLng latLng) async {
    try {
      final response = await _geocoding.searchByLocation(
        geo.Location(lat: latLng.latitude, lng: latLng.longitude),
        language: "ja",
      );

      if (response.status == "OK" && response.results.isNotEmpty) {
        setState(() {
          _fetchedAddress = response.results.first.formattedAddress;
        });
      } else {
        setState(() {
          _fetchedAddress = null;
          _fetchedAddressErrMessage = "住所が取得できませんでした";
        });
      }
    } catch (e) {
      debugPrint("Error fetching address: $e");
      setState(() {
        _fetchedAddress = null;
        _fetchedAddressErrMessage = "住所を取得中にエラーが発生しました";
      });
    }
  }

  /// 📌 **住所を検索してマップを移動**
  Future<void> _searchAddress() async {
    final selectedLocation = await Navigator.of(context).push(
      MaterialPageRoute(
        builder:
            (context) => SearchAddressPage(
              // 🔹 現在地を渡す
              initialLocation: _selectedLocation,
            ),
      ),
    );

    if (selectedLocation != null && selectedLocation is LatLng) {
      setState(() {
        _selectedLocation = selectedLocation;
      });

      _mapController?.animateCamera(CameraUpdate.newLatLng(selectedLocation));
      await _fetchAddress(selectedLocation);
    }
  }

  /// 📌 **目的地決定**
  void _confirmLocation() {
    if (_selectedLocation == null) return;

    final destLat = _selectedLocation!.latitude;
    final destLon = _selectedLocation!.longitude;
    Navigator.of(context).push(
      MaterialPageRoute(
        builder:
            (context) => SetDetailsPage(
              destLat: destLat,
              destLon: destLon,
              address: _fetchedAddress,
            ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:
          _selectedLocation == null
              ? const Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Color(0xFFFAE3E2)),
                ),
              )
              : Stack(
                children: [
                  GoogleMap(
                    initialCameraPosition: CameraPosition(
                      target: _selectedLocation!,
                      zoom: 15.0,
                    ),
                    onMapCreated: (controller) => _mapController = controller,
                    onCameraMove: _onCameraMove,
                    onCameraIdle: _onCameraIdle,
                    myLocationEnabled: true,
                    myLocationButtonEnabled: false,
                  ),

                  // 画面中央に固定されたピン
                  Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          height: 60,
                          width: 80,
                          child: const Icon(
                            Icons.location_on,
                            size: 65,
                            color: Color.fromARGB(255, 255, 118, 33),
                          ),
                        ),
                        SizedBox(height: 60),
                      ],
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

                            // 🔹 住所 & 検索ボタンを横並びにする
                            Row(
                              children: [
                                // 住所の表示部分
                                Expanded(
                                  child: Text(
                                    _isFetchingAddress
                                        ? "住所取得中..."
                                        : _fetchedAddress ??
                                            _fetchedAddressErrMessage ??
                                            "${_selectedLocation!.latitude.toStringAsFixed(6)}, ${_selectedLocation!.longitude.toStringAsFixed(6)}",
                                    style: const TextStyle(fontSize: 16),
                                  ),
                                ),

                                const SizedBox(width: 10), // 余白
                                // 🔹 検索ボタン
                                ElevatedButton(
                                  onPressed: _searchAddress,
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.white, // 白背景
                                    shape: const CircleBorder(),
                                    padding: const EdgeInsets.all(
                                      12,
                                    ), // ボタンのサイズ調整
                                  ),
                                  child: const Icon(
                                    Icons.search,
                                    size: 24,
                                    color: Colors.black, // アイコンの色もオレンジ
                                  ),
                                ),
                              ],
                            ),

                            const SizedBox(height: 15),

                            OriginalButton(
                              text: "ここを目的地にする",
                              onPressed: _confirmLocation,
                              fill: true,
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
