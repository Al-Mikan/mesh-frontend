import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

enum AppNotificationType {
  walkingStart,
  bicyclingStart,
  drivingStart,
  meeting,
}

class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  factory NotificationService() {
    return _instance;
  }

  NotificationService._internal();

  Future<void> init() async {
    // タイムゾーンの初期化
    tz.initializeTimeZones();

    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    final DarwinInitializationSettings initializationSettingsIOS =
        DarwinInitializationSettings(
      requestSoundPermission: true,
      requestBadgePermission: true,
      requestAlertPermission: true,
    );

    final InitializationSettings initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsIOS,
    );

    await flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: _onDidReceiveNotificationResponse,
    );
  }

  Future<void> create(AppNotificationType type, DateTime scheduledTime) async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
      'your_channel_id',
      'your_channel_name',
      importance: Importance.max,
      priority: Priority.high,
    );

    const DarwinNotificationDetails iOSPlatformChannelSpecifics =
        DarwinNotificationDetails(
      sound: 'default',
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    const NotificationDetails platformChannelSpecifics = NotificationDetails(
      android: androidPlatformChannelSpecifics,
      iOS: iOSPlatformChannelSpecifics,
    );

    final String title;
    final String body;
    switch (type) {
      case AppNotificationType.walkingStart:
        title = '出発の準備は整いましたか?';
        body = '今から徒歩で出発すると、集合時刻に間に合います！';
        break;
      case AppNotificationType.bicyclingStart:
        title = '出発の準備は整いましたか?';
        body = '今から自転車で出発すると、集合時刻に間に合います！';
        break;
      case AppNotificationType.drivingStart:
        title = '出発の準備は整いましたか?';
        body = '今から車で出発すると、集合時刻に間に合います！';
        break;
      case AppNotificationType.meeting:
        title = '到着していますか?';
        body = '集合時刻になりました！';
        break;
    }

    // 既存の通知を削除
    await deleteAll();

    await flutterLocalNotificationsPlugin.zonedSchedule(
      type.index, // 通知IDとしてenumのindexを使用
      title, // タイトル
      body, // 本文
      tz.TZDateTime.from(scheduledTime, tz.local),
      platformChannelSpecifics,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      payload: 'payload', // 必要に応じてペイロードを設定
    );
  }

  Future<void> deleteAll() async {
    await flutterLocalNotificationsPlugin.cancelAll();
  }

  void _onDidReceiveNotificationResponse(NotificationResponse notificationResponse) {
    // 通知がタップされたときの処理
    debugPrint('Notification tapped');
  }

  Future<void> requestIOSPermissions() async {
  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
          IOSFlutterLocalNotificationsPlugin>()
      ?.requestPermissions(
        alert: true,
        badge: true,
        sound: true,
      );
  }
}