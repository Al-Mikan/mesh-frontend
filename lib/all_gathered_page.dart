import 'dart:math';

import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';
import 'package:haptic_feedback/haptic_feedback.dart';
import 'package:mesh_frontend/home_page.dart';
import 'package:mesh_frontend/components/button.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AllGatheredPage extends StatefulWidget {
  const AllGatheredPage({super.key});

  @override
  State<AllGatheredPage> createState() => _AllGatheredPageState();
}

class _AllGatheredPageState extends State<AllGatheredPage> {
  final _controller = ConfettiController(duration: const Duration(seconds: 1));

  @override
  void initState() {
    super.initState();
    Haptics.vibrate(HapticsType.success);
    _controller.play();
  }

  Future<void> _handleOkButton(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('groupId');

    if (context.mounted) {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const HomePage()),
        (Route<dynamic> route) => false, // すべての前の画面を削除
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ConfettiWidget(
                      confettiController: _controller,
                      emissionFrequency: 0,
                      blastDirection: -pi/4,
                      numberOfParticles: 30,
                      
                    ),
                    ConfettiWidget(
                      confettiController: _controller,
                      emissionFrequency: 0,
                      numberOfParticles: 30,
                      blastDirection: -pi*3/4,
                    ),
                  ],
                ),
                const Icon(
                  Icons.celebration,
                  size: 80,
                  color: Colors.orangeAccent,
                ),
                const SizedBox(height: 20),
                const Text(
                  "全員集合",
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 15),
                const Text(
                  "全員揃いました！\n楽しい時間を過ごしましょう",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 18, color: Colors.black),
                ),
                const SizedBox(height: 20),
                const Text(
                  "位置情報は自動的に解除されます。",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 16, color: Colors.black45),
                ),
              ],
            ),
          ),

          // 🔹 OKボタンを下に配置（画面の高さに応じて調整）
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 80, left: 20, right: 20),
              child: OriginalButton(
                text: "OK",
                onPressed: () => _handleOkButton(context),
                fill: true,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
