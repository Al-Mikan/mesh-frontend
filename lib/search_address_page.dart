import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_webservice/places.dart';
import 'dart:async'; //

const String _googleApiKey = String.fromEnvironment("GOOGLE_MAPS_API_KEY");

class SearchAddressPage extends StatefulWidget {
  final LatLng? initialLocation;

  const SearchAddressPage({super.key, this.initialLocation});

  @override
  _SearchAddressPageState createState() => _SearchAddressPageState();
}

class _SearchAddressPageState extends State<SearchAddressPage> {
  final TextEditingController _controller = TextEditingController();
  final GoogleMapsPlaces _places = GoogleMapsPlaces(apiKey: _googleApiKey);
  List<PlacesSearchResult> _results = [];
  Timer? _debounce; // 🔹 デバウンス用のタイマー

  void _onTextChanged(String query) {
    if (_debounce?.isActive ?? false) _debounce!.cancel();

    _debounce = Timer(const Duration(milliseconds: 1000), () {
      _searchAddress(query);
    });
  }

  void _searchAddress(String query) async {
    final location = widget.initialLocation; // 🔹 受け取った現在地
    final response = await _places.searchByText(
      query.isEmpty ? "日本" : query,
      language: "ja",
      location:
          location != null
              ? Location(lat: location.latitude, lng: location.longitude)
              : null,
    );

    if (response.status == "OK") {
      setState(() {
        _results = response.results;
      });
    } else {
      setState(() {
        _results.clear();
      });
    }
  }

  /// 🔎 選択した住所を前の画面に返す
  void _selectAddress(PlacesSearchResult result) async {
    final lat = result.geometry?.location.lat;
    final lng = result.geometry?.location.lng;
    if (lat != null && lng != null) {
      Navigator.of(context).pop(LatLng(lat, lng));
    }
  }

  @override
  void dispose() {
    _debounce?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CupertinoNavigationBar(middle: const Text('住所検索')),
      body: Column(
        children: [
          // 🔹 1文字ずつ入力を検知するTextField
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: _controller,
              onChanged: _onTextChanged, // 🔹 デバウンス付きの検索
              decoration: InputDecoration(
                labelText: "住所を入力",
                labelStyle: TextStyle(color: Colors.grey[700]),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: const BorderSide(color: Colors.grey, width: 1.0),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: const BorderSide(
                    color: Colors.orange,
                    width: 2.0,
                  ),
                ),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.clear),
                  onPressed: () {
                    _controller.clear();
                    _onTextChanged("");
                  },
                ),
              ),
            ),
          ),

          // 🔹 検索結果リスト
          Expanded(
            child: ListView.builder(
              itemCount: _results.length,
              itemBuilder: (context, index) {
                final result = _results[index];

                return Column(
                  children: [
                    ListTile(
                      title: Text(result.name),
                      subtitle: Text(result.formattedAddress ?? ""),
                      onTap: () => _selectAddress(result),
                    ),
                    if (index < _results.length - 1) // 🔹 最後の要素の後には線を入れない
                      const Divider(
                        color: Colors.grey, // 🔹 薄いグレーのライン
                        thickness: 0.5, // 🔹 0.5ptの細さ
                        indent: 16, // 🔹 左側の余白
                        endIndent: 16, // 🔹 右側の余白
                      ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
