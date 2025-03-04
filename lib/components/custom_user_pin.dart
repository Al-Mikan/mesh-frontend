import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:widget_to_marker/widget_to_marker.dart';

/// カスタムマーカーを生成するクラス
class CustomUserPin {
  static Future<BitmapDescriptor> createCustomMarker(
    String userName,
    String iconID,
    String shortMessage,
  ) async {
    return await _PinWidget(
      userName: userName,
      iconPath: 'assets/images/user_icons/$iconID.jpg',
      shortMessage: shortMessage,
    ).toBitmapDescriptor();
  }
}

class _PinWidget extends StatelessWidget {
  const _PinWidget({
    Key? key,
    required this.userName,
    required this.iconPath,
    required this.shortMessage,
  }) : super(key: key);

  final String userName;
  final String iconPath;
  final String shortMessage;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 200,
      height: 90,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // 白い枠線
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              border: Border.all(color: Colors.white, width: 3),
              shape: BoxShape.circle,
            ),
          ),
          // アイコン画像
          ClipOval(
            child: Image.asset(
              iconPath,
              width: 36,
              height: 36,
              fit: BoxFit.cover,
            ),
          ),
          Transform.translate(
            offset: const Offset(0, 30),
            child: Text(
              userName,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
          ),
          if (shortMessage.isNotEmpty)
            Transform.translate(
              offset: const Offset(0, -30),
              child: Card(
                elevation: 0,
                color: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                  side: BorderSide(color: Colors.grey, width: 0.5),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 2,
                  ),
                  child: Text(
                    shortMessage,
                    style: const TextStyle(fontSize: 12, color: Colors.black),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
