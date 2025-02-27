import 'package:flutter/material.dart';

class MeetingDetailsCard extends StatelessWidget {
  final String location;
  final String time;
  final String userName;

  const MeetingDetailsCard({
    super.key,
    required this.location,
    required this.time,
    required this.userName,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white, // 背景色
        borderRadius: BorderRadius.circular(16), // 角丸
        border: Border.all(color: Colors.grey.shade300, width: 0.8), // ごく薄い枠線
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3), // 軽めの影
            blurRadius: 6,
            spreadRadius: 1,
            offset: Offset(0, 3),
          ),
        ],
      ),
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildDetailRow(
            Icons.location_on,
            '場所',
            location,
            const Color(0xFFF86594),
          ),
          const SizedBox(height: 12),
          _buildDetailRow(
            Icons.access_time,
            '時間',
            time,
            const Color(0xFFFCC373),
          ),
          const SizedBox(height: 12),
          _buildDetailRow(Icons.person, '作成者', userName, Colors.black87),
        ],
      ),
    );
  }

  /// **詳細情報のレイアウト**
  Widget _buildDetailRow(
    IconData icon,
    String title,
    String value,
    Color iconColor,
  ) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Icon(icon, size: 24, color: iconColor), // 🎨 カスタム色
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey.shade700,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
