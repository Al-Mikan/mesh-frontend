import 'dart:ui' as ui;
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class CustomUserPin {
  static Future<BitmapDescriptor> createCustomMarker(String userName) async {
    final ui.PictureRecorder recorder = ui.PictureRecorder();
    final Canvas canvas = Canvas(recorder);
    const double size = 40;

    // **ユーザーごとに固定の色を決める**
    final Color userColor = _getUserColor(userName);

    final Paint circlePaint = Paint()..color = userColor;
    final Paint borderPaint =
        Paint()
          ..color = Colors.white
          ..style = PaintingStyle.stroke
          ..strokeWidth = 2;

    // **外枠を描画**
    canvas.drawCircle(const Offset(size / 2, size / 2), size / 2, borderPaint);
    // **中央の丸を描画（ユーザー固有の色）**
    canvas.drawCircle(
      const Offset(size / 2, size / 2),
      size / 2.5,
      circlePaint,
    );

    // **ユーザー名の冒頭3文字を取得**
    String displayText =
        userName.isNotEmpty
            ? userName.substring(0, userName.length < 3 ? userName.length : 3)
            : "？";

    // **ユーザー名を描画**
    final TextPainter textPainter = TextPainter(
      text: TextSpan(
        text: displayText,
        style: const TextStyle(
          fontSize: 14, // 少し小さめに調整
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
      textDirection: TextDirection.ltr,
      textAlign: TextAlign.center,
    );

    textPainter.layout();
    textPainter.paint(
      canvas,
      Offset((size - textPainter.width) / 2, (size - textPainter.height) / 2),
    );

    final ui.Image img = await recorder.endRecording().toImage(
      size.toInt(),
      size.toInt(),
    );
    final ByteData? byteData = await img.toByteData(
      format: ui.ImageByteFormat.png,
    );
    final Uint8List bytes = byteData!.buffer.asUint8List();

    return BitmapDescriptor.bytes(bytes);
  }

  /// **ユーザー名から固定の色を生成**
  static Color _getUserColor(String userName) {
    List<Color> colors = Colors.primaries;
    int hash = userName.codeUnits.fold(0, (prev, code) => prev + code);
    return colors[hash % colors.length];
  }
}
