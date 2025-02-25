import 'dart:ui' as ui;
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class CustomGoalPin {
  static Future<BitmapDescriptor> createGoalMarker() async {
    final ui.PictureRecorder recorder = ui.PictureRecorder();
    final Canvas canvas = Canvas(recorder);
    const double size = 100;

    final Paint circlePaint = Paint()..color = Colors.red;
    final Paint borderPaint =
        Paint()
          ..color = Colors.white
          ..style = PaintingStyle.fill;

    // 丸い枠の背景を描画
    canvas.drawCircle(const Offset(size / 2, size / 2), size / 2, borderPaint);
    canvas.drawCircle(
      const Offset(size / 2, size / 2),
      size / 2.5,
      circlePaint,
    );

    // 旗のアイコンを描画
    final TextPainter iconPainter = TextPainter(
      text: TextSpan(
        text: String.fromCharCode(Icons.flag.codePoint), // Flutter のアイコンを取得
        style: TextStyle(
          fontSize: 50,
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

    return BitmapDescriptor.fromBytes(bytes);
  }
}
