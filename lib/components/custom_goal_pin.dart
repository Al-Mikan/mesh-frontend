import 'dart:ui' as ui;
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class CustomGoalPin {
  static Future<BitmapDescriptor> createGoalMarker() async {
    final ui.PictureRecorder recorder = ui.PictureRecorder();
    final Canvas canvas = Canvas(recorder);
    const double size = 46;

    final Rect rect = Rect.fromCircle(
      center: const Offset(size / 2, size / 2),
      radius: size / 2,
    );

    // 🔹 グラデーションを作成
    final Paint gradientPaint =
        Paint()
          ..shader = ui.Gradient.linear(rect.topCenter, rect.bottomCenter, [
            const Color(0xFFF86594), // ピンク
            const Color(0xFFFCC373), // オレンジ
          ]);

    final Paint borderPaint =
        Paint()
          ..color = const ui.Color.fromARGB(255, 255, 255, 255)
          ..style = PaintingStyle.fill;

    canvas.drawCircle(const Offset(size / 2, size / 2), size / 2, borderPaint);
    canvas.drawCircle(
      const Offset(size / 2, size / 2),
      size / 2.5,
      gradientPaint,
    );

    final TextPainter iconPainter = TextPainter(
      text: TextSpan(
        text: String.fromCharCode(Icons.flag.codePoint), // 旗アイコン
        style: TextStyle(
          fontSize: 24,
          fontFamily: Icons.flag.fontFamily,
          color: Colors.white, // 旗の色
        ),
      ),
      textDirection: TextDirection.ltr,
      textAlign: TextAlign.center,
    );

    iconPainter.layout();
    iconPainter.paint(
      canvas,
      Offset((size - iconPainter.width) / 2, (size - iconPainter.height) / 2),
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
}
