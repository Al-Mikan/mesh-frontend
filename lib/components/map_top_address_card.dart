
import 'dart:ui';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class TopAddressCard extends StatelessWidget {
  const TopAddressCard({
    super.key, 
    required this.address,
    required this.lat,
    required this.lon,
  });

  final String address;
  final double lat;
  final double lon;

  // 地図アプリを開く
  void _openMap() async {
    final Uri googleMapsUri = Uri.parse(
      "https://www.google.com/maps/search/?api=1&query=$lat,$lon",
    );
    final Uri appleMapsUri = Uri.parse("maps://?q=$lat,$lon");

    if (await canLaunchUrl(googleMapsUri)) {
      await launchUrl(googleMapsUri);
    } else if (await canLaunchUrl(appleMapsUri)) {
      await launchUrl(appleMapsUri);
    } else {
      debugPrint("地図アプリを開けませんでした");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 60,
      left: 12,
      right: 12,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(32),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.7),
              borderRadius: BorderRadius.circular(32),
              border: Border.all(
                color: Colors.grey.withOpacity(0.3),
                width: 1.0,
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // 旗アイコン
                  ShaderMask(
                    shaderCallback: (Rect bounds) {
                      return ui.Gradient.linear(
                        bounds.topCenter,
                        bounds.bottomCenter,
                        [
                          const Color(0xFFF86594), // ピンク
                          const Color(0xFFFCC373), // オレンジ
                        ],
                      );
                    },
                    child: const Icon(
                      Icons.flag,
                      size: 24,
                      color: Colors.white, // 白をベースにグラデーションを適用
                    ),
                  ),
                  const SizedBox(width: 6),

                  // 住所
                  Expanded(
                    child: Text(
                      address, // 住所を表示
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),

                  // 「地図アプリを開く」ボタン（iOS スタイルの外部リンクアイコン）
                  GestureDetector(
                    onTap: _openMap,
                    child: const Padding(
                      padding: EdgeInsets.only(left: 6),
                      child: Icon(
                        Icons.open_in_new, // 🔹 iOS風の外部リンクアイコン
                        size: 20,
                        color: Colors.blueGrey,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}