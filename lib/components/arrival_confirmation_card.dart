import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

class ArrivalConfirmationCard extends StatelessWidget {
  final VoidCallback onArrived;

  const ArrivalConfirmationCard({super.key, required this.onArrived});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      elevation: 6, // カードの影を強めに
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // アイコンとタイトル
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.location_on, color: Colors.redAccent, size: 28),
                const SizedBox(width: 8),
                const Text(
                  "待ち合わせ場所付近です！",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 12),

            // 説明文
            const Text(
              "到着しましたか？ ボタンを押して通知しましょう。",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 15, color: Colors.black54),
            ),

            const SizedBox(height: 16),

            // 到着ボタン
            SizedBox(
              width: double.infinity, // ボタンを画面幅いっぱいに
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green, // ボタンの色
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
                onPressed: onArrived,
                icon: const Icon(Icons.check_circle_outline, size: 24),
                label: const Text(
                  "到着しました",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
