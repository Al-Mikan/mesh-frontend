import 'package:flutter/material.dart';
import 'package:mesh_frontend/home_page.dart';
import 'package:mesh_frontend/components/button.dart'; // ✅ 追加
import 'package:shared_preferences/shared_preferences.dart'; // ✅ 追加

class AllGatheredPage extends StatelessWidget {
  const AllGatheredPage({super.key});

  Future<void> _handleOkButton(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('groupId');

    if (context.mounted) {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const HomePage()),
        (Route<dynamic> route) => false, // すべての前の画面を削除
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              "全員集合！",
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            const Text(
              "全員揃いました！楽しい時間を過ごしましょう 🎉",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 20),
            // 🔽 位置情報の解除についての文言を追加
            const Text(
              "位置情報は自動的に解除されます。",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
            const SizedBox(height: 30),
            // ✅ `OriginalButton` を使用
            OriginalButton(
              text: "OK",
              onPressed: () => _handleOkButton(context), // ✅ `OK` 押下時の処理
              fill: true, // 背景色あり
            ),
          ],
        ),
      ),
    );
  }
}
