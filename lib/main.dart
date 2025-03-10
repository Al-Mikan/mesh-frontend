import 'dart:async';

import 'package:app_links/app_links.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mesh_frontend/all_gathered_page.dart';
import 'package:mesh_frontend/home_page.dart';
import 'package:mesh_frontend/invited_page.dart';
import 'package:mesh_frontend/utils/notification_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final notificationService = NotificationService();
  await notificationService.init();
  await notificationService.requestIOSPermissions(); // iOS用の通知権限リクエスト
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  StreamSubscription<Uri>? _linkSubscription;
  final navigatorKey = GlobalKey<NavigatorState>();
  bool _isDeepLinkHandled = false;

  @override
  void initState() {
    super.initState();
    initDeepLinks();
  }

  @override
  void dispose() {
    _linkSubscription?.cancel();

    super.dispose();
  }

  Future<void> initDeepLinks() async {
    _linkSubscription = AppLinks().uriLinkStream.listen((uri) {
      //deep linkの処理
      debugPrint('onDeepLink: $uri');
      if (!_isDeepLinkHandled) {
        handleDeepLink(uri);
        _isDeepLinkHandled = true;
        Future.delayed(const Duration(seconds: 1), () {
          _isDeepLinkHandled = false;
        });
      }
    });
  }

  void handleDeepLink(Uri uri) {
    if (uri.scheme == 'mesh' && uri.host == 'invite') {
      final String groupId = uri.pathSegments.last;
      SharedPreferences.getInstance().then((prefs) {
        final String? savedGroupId = prefs.getString('groupId');
        if (savedGroupId == null) {
          navigatorKey.currentState?.pushAndRemoveUntil(
            MaterialPageRoute(
              builder: (context) => InvitedPage(groupId: groupId),
            ),
            (Route<dynamic> route) => false,
          );
        } else {
          // 既に別のグループに参加している場合、ダイアログを表示
          showCupertinoDialog(
            context: navigatorKey.currentContext!,
            builder: (BuildContext context) {
              return CupertinoAlertDialog(
                title: const Text('別のグループに参加中'),
                content: const Text('新しいグループに参加するには、一度退出してください。'),
                actions: <Widget>[
                  CupertinoDialogAction(
                    child: const Text('OK'),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              );
            },
          );
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '待ち合わせアプリ',
      theme: ThemeData(primarySwatch: Colors.orange, useMaterial3: false),
      home: const HomePage(),
      navigatorKey: navigatorKey,
    );
  }
}
