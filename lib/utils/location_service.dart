import 'dart:isolate';
import 'dart:ui';

import 'package:background_locator_2/background_locator.dart';
import 'package:background_locator_2/location_dto.dart';
import 'package:background_locator_2/settings/android_settings.dart';
import 'package:background_locator_2/settings/ios_settings.dart';
import 'package:background_locator_2/settings/locator_settings.dart' as s;
import 'package:dio/dio.dart';
import 'package:location/location.dart';
import 'package:permission_handler/permission_handler.dart';

export 'location_service.dart';

final dio = Dio(
  BaseOptions(
    baseUrl: 'API　URL', // 使用するAPIのURLを記述してください
    contentType: 'application/json',
  ),
);

Future<void> initPlatformState() async {
  await BackgroundLocator.initialize();
  print('Locator service started');
}

@pragma('vm:entry-point')
class LocationCallbackHandler {
  static const String isolateName = "LocatorIsolate";

  @pragma('vm:entry-point')
  static Future<void> _initCallback(Map<dynamic, dynamic> params) async {
    print('initCallback');
  }

  @pragma('vm:entry-point')
  static Future<void> _disposeCallback() async {
    print('disposeCallback');
  }

  @pragma('vm:entry-point')
  static Future<void> _callback(LocationDto locationDto) async {
    final SendPort? send = IsolateNameServer.lookupPortByName(isolateName);
    if (send != null) {
      print('Sending location');
      send.send(locationDto.toJson());
    } else {
      print('SendPort not found');
    }
    // await dio.post('/location', data: {
    //   'latitude': locationDto.latitude,
    //   'longitude': locationDto.longitude
    // });
  }

  static void startLocationService() {
    BackgroundLocator.registerLocationUpdate(_callback,
        initCallback: _initCallback,
        disposeCallback: _disposeCallback,
        autoStop: false,
        iosSettings: IOSSettings(
            accuracy: s.LocationAccuracy.NAVIGATION, distanceFilter: 0),
        androidSettings: AndroidSettings(
          accuracy: s.LocationAccuracy.NAVIGATION,
          interval: 5,
          distanceFilter: 0,
        ));
  }
}

class RequestLocationPermission {
  static Future<void> request(Location location) async {
    // 位置情報サービスが有効か確認
    bool serviceEnabled = await location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await location.requestService();
      if (!serviceEnabled) {
        return;
      }
    }

    // 位置情報の権限状態を確認
    var permissionStatus = await Permission.location.status;
    print('位置情報の権限状態: $permissionStatus');
    
    // 権限が拒否されている場合
    if (permissionStatus.isDenied) {
      // 権限をリクエスト
      permissionStatus = await Permission.location.request();
      
      // 権限が拒否された場合、設定画面を開く
      if (permissionStatus.isPermanentlyDenied) {
       await openAppSettings();
      }
    }

    // バックグラウンドでの位置情報アクセス許可を確認
    var backgroundPermissionStatus = await Permission.locationAlways.status;
    print('バックグラウンドでの位置情報アクセス許可: $backgroundPermissionStatus');
    if (backgroundPermissionStatus.isDenied) {
      backgroundPermissionStatus = await Permission.locationAlways.request();
      
      // 常時許可が拒否された場合、設定画面を開く
      if (backgroundPermissionStatus.isPermanentlyDenied) {
       await openAppSettings();
      }
    }
  }
}