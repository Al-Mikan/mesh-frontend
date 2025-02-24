import 'dart:isolate';
import 'dart:ui';
import 'package:background_locator_2/background_locator.dart';
import 'package:background_locator_2/location_dto.dart';
import 'package:background_locator_2/settings/android_settings.dart';
import 'package:background_locator_2/settings/ios_settings.dart';
import 'package:background_locator_2/settings/locator_settings.dart';
import 'package:dio/dio.dart';

class LocationService {
  static const String isolateName = "LocatorIsolate";
  final Dio dio = Dio();

  static Future<void> initPlatformState() async {
    await BackgroundLocator.initialize();
  }

  @pragma('vm:entry-point')
  static Future<void> _callback(LocationDto locationDto) async {
    final SendPort? send = IsolateNameServer.lookupPortByName(isolateName);
    send?.send(locationDto.toJson());

    // サーバーに位置情報を送信
    await Dio().post('https://your-api-endpoint.com/location', data: {
      'latitude': locationDto.latitude,
      'longitude': locationDto.longitude,
      'timestamp': locationDto.time
    });
  }

  static void startLocationService() {
    BackgroundLocator.registerLocationUpdate(
      _callback,
      autoStop: false,
      iosSettings: const IOSSettings(
        accuracy: LocationAccuracy.NAVIGATION,
        distanceFilter: 0,
      ),
      androidSettings: const AndroidSettings(
        accuracy: LocationAccuracy.NAVIGATION,
        interval: 5,
        distanceFilter: 0,
      ),
    );
  }

  static void stopLocationService() {
    BackgroundLocator.unRegisterLocationUpdate();
  }
}