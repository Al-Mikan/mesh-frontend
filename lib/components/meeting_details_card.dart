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
    return Card(
      elevation: 10, // ✅ カードに少し影をつける
      margin: EdgeInsets.symmetric(horizontal: 0, vertical: 12),
      shadowColor: Colors.grey.withOpacity(0.5),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildDetailRow(Icons.location_on, '場所', location),
            const SizedBox(height: 10),
            _buildDetailRow(Icons.access_time, '時間', time),
            const SizedBox(height: 10),
            _buildDetailRow(Icons.person, '作成者', userName),
          ],
        ),
      ),
    );
  }

  // ✅ 情報を表示するウィジェット
  Widget _buildDetailRow(IconData icon, String title, String value) {
    return Row(
      children: [
        Icon(icon),
        const SizedBox(width: 5),
        Expanded(
          child: Text(
            '$title：$value',
            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
          ),
        ),
      ],
    );
  }
}
