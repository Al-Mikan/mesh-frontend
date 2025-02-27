import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mesh_frontend/map_share_page.dart';
import 'package:mesh_frontend/components/button.dart';
import 'package:mesh_frontend/components/meeting_details_card.dart'; // ✅ 新しいコンポーネントをインポート

class ShareLinkPage extends StatelessWidget {
  final String shareUrl;
  final String groupId;
  final String location;
  final String time;
  final String userName;

  const ShareLinkPage({
    super.key,
    required this.shareUrl,
    required this.groupId,
    required this.location,
    required this.time,
    required this.userName,
  });

  void _copyToClipboard(BuildContext context) {
    Clipboard.setData(ClipboardData(text: shareUrl));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('リンクをコピーしました！'),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _navigateToMap(BuildContext context) {
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (context) => MapSharePage(groupId: groupId)),
      (Route<dynamic> route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // 📌 メインコンテンツ
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                const Text(
                  '待ち合わせが作成されました！',
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 10),
                const Text('🎉', style: TextStyle(fontSize: 40)),
                const SizedBox(height: 20),

                // ✅ 待ち合わせの詳細情報（新コンポーネント）
                MeetingDetailsCard(
                  location: location,
                  time: time,
                  userName: userName,
                ),

                const SizedBox(height: 20),

                // ✅ URL 表示 & コピー機能（シンプルデザイン）
                // Row(
                //   mainAxisAlignment: MainAxisAlignment.center,
                //   children: [
                //     Expanded(
                //       child: Text(
                //         shareUrl,
                //         style: const TextStyle(
                //           fontSize: 16,
                //           fontWeight: FontWeight.w500,
                //           color: Colors.blue,
                //         ),
                //         overflow: TextOverflow.ellipsis,
                //         textAlign: TextAlign.center,
                //       ),
                //     ),
                //     const SizedBox(width: 10),
                //     GestureDetector(
                //       onTap: () => _copyToClipboard(context),
                //       child: Icon(
                //         Icons.copy,
                //         color: Colors.blue.shade700,
                //         size: 22,
                //       ),
                //     ),
                //   ],
                // ),
              ],
            ),
          ),

          // 📌 「次へ」ボタンの配置
          Positioned(
            bottom: 80, // 🔹 画面下から少し上に配置
            left: 20,
            right: 20,
            child: OriginalButton(
              text: 'リンクをコピーして次へ',
              onPressed: () {
                _copyToClipboard(context);
                _navigateToMap(context);
              },
            ),
          ),
        ],
      ),
    );
  }
}
