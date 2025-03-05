import 'package:flutter/material.dart';

class ArrivalConfirmationCard extends StatelessWidget {
  final VoidCallback onArrived;

  const ArrivalConfirmationCard({super.key, required this.onArrived});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      margin: const EdgeInsets.all(0),
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(32)),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // アイコンとタイトル
            const SizedBox(height: 8),
            const Text(
              "待ち合わせ場所付近です",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            // 説明文
            const Text(
              "到着したら、メンバーに知らせましょう",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 15, color: Colors.black54),
            ),

            const SizedBox(height: 8),

            // 到着ボタン
            SizedBox(
              width: double.infinity, // ボタンを画面幅いっぱいに
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange, // ボタンの色
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(24),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 12),
                ),
                onPressed: onArrived,
                icon: const Icon(
                  Icons.check_circle_outline,
                  size: 24,
                  color: Colors.white,
                ),
                label: const Text(
                  "到着しました",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
