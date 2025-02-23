import 'package:flutter/material.dart';
import 'package:mesh_frontend/home_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MapSharePage extends StatelessWidget {
  final String groupId;

  const MapSharePage({super.key, required this.groupId});

  void onTapExit(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('groupId');
    if (context.mounted) {
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => const HomePage()),
        (Route<dynamic> route) => false,  // すべての前のルートを削除
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('地図共有画面'),
        automaticallyImplyLeading: false, // 戻るボタンを非表示
      ),
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
      ),
    );
  }
}
