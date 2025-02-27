import 'dart:ui' as ui;
import 'dart:typed_data';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class CustomUserPin {
  static final Random _random = Random();

  static Future<BitmapDescriptor> createCustomMarker(String name) async {
    final ui.PictureRecorder recorder = ui.PictureRecorder();
    final Canvas canvas = Canvas(recorder);
    const double size = 40;

    // ランダムな色を生成
    final Color randomColor = Color.fromARGB(
      255,
      _random.nextInt(256),
      _random.nextInt(256),
      _random.nextInt(256),
    );

    final Paint circlePaint = Paint()..color = Colors.white; // 🔹 内側の白い丸
    final Paint borderPaint =
        Paint()
          ..color = randomColor
          ..style = PaintingStyle.fill;

    canvas.drawCircle(const Offset(size / 2, size / 2), size / 2, borderPaint);
    canvas.drawCircle(
      const Offset(size / 2, size / 2),
      size / 2.5,
      circlePaint,
    );

    final TextPainter textPainter = TextPainter(
      text: TextSpan(
        text: name.length > 3 ? name.substring(0, 3) : name, // 3文字まで表示
        style: const TextStyle(
          fontSize: 14,
          color: Colors.black,
          fontWeight: FontWeight.bold,
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

    // 🔹 画像を生成して `BitmapDescriptor` に変換
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
}
