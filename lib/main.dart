import 'dart:async';

import 'package:app_links/app_links.dart';
import 'package:flutter/material.dart';
import 'package:mesh_frontend/home_page.dart';
import 'package:mesh_frontend/invited_page.dart';
import 'package:shared_preferences/shared_preferences.dart';


void main() async {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  StreamSubscription<Uri>? _linkSubscription;
  final navigatorKey = GlobalKey<NavigatorState>();
  bool _isDeepLinkInitialized = false;
  
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
      handleDeepLink(uri);
    });
  }

  void handleDeepLink(Uri uri) {
    if (uri.scheme == 'mesh' && uri.host == 'invite') {
      final String? groupId = uri.pathSegments.last;
      if (groupId != null) {
        SharedPreferences.getInstance().then((prefs) {
          final String? savedGroupId = prefs.getString('groupId');
          if (savedGroupId == null) {
            navigatorKey.currentState?.pushAndRemoveUntil(
              MaterialPageRoute(
                builder: (context) => InvitedPage(groupId: groupId),
              ),
              (Route<dynamic> route) => false,
            );
          }
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '待ち合わせアプリ',
      theme: ThemeData(primarySwatch: Colors.blue, useMaterial3: false),
      home: const HomePage(),
      navigatorKey: navigatorKey,
    );
  }
}