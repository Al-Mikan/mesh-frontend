import 'package:flutter/material.dart';

class OriginalButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final bool fill;

  const OriginalButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.fill = true,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 40),
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          elevation: 0,
          padding: const EdgeInsets.symmetric(vertical: 20),
          backgroundColor: fill ? const Color(0xFF332731) : Colors.transparent,
          side: BorderSide(
            color: const Color(0xFF332731),
            width: 2, // ✅ ボーダーの太さ
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(100),
          ),
        ),
        child: Text(
          text,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.bold,
            color: fill ? Colors.white : const Color(0xFF332731),
          ),
        ),
      ),
    );
  }
}
