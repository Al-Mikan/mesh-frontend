import 'dart:convert';
import 'package:http/http.dart' as http;

class TravelTime {
  final int? walking;
  final int? transit;
  final int? driving;

  TravelTime({
    this.walking,
    this.transit,
    this.driving,
  });
}

class GoogleMapsDirections {
  final String apiKey;

  GoogleMapsDirections({required this.apiKey});

  Future<TravelTime> getTravelTimes(
      double originLat, double originLng, double destLat, double destLng) async {
    final baseUrl = 'https://maps.googleapis.com/maps/api/directions/json';

    // 移動手段ごとのURLパラメータ
    final modes = ['walking', 'transit', 'driving'];
    final travelTimes = <String, int>{};

    for (final mode in modes) {
      final url = Uri.parse(
          '$baseUrl?origin=$originLat,$originLng&destination=$destLat,$destLng&mode=$mode&key=$apiKey');

      final response = await http.get(url);
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['status'] == 'OK') {
          final duration = data['routes'][0]['legs'][0]['duration']['value'];
          travelTimes[mode] = (duration / 60).round(); // 秒を分に変換
        }
      }
    }

    return TravelTime(
      walking: travelTimes['walking'],
      transit: travelTimes['transit'],
      driving: travelTimes['driving'],
    );
  }
}