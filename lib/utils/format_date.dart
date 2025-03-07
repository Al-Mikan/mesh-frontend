import 'package:intl/intl.dart';

String formatDateTime(dynamic dateTime) {
  final dateTimeObj = dateTime is String ? DateTime.parse(dateTime).toLocal() : dateTime.toLocal();
  final now = DateTime.now();
  final today = DateTime(now.year, now.month, now.day);
  final yesterday = today.subtract(const Duration(days: 1));
  final tomorrow = today.add(const Duration(days: 1));

  final date = DateTime(dateTimeObj.year, dateTimeObj.month, dateTimeObj.day);

  String dateText;
  if (date == today) {
    dateText = '今日';
  } else if (date == yesterday) {
    dateText = '昨日';
  } else if (date == tomorrow) {
    dateText = '明日';
  } else {
    dateText = DateFormat('MM/dd').format(dateTimeObj);
  }

  return '$dateText ${DateFormat('HH:mm').format(dateTimeObj)}';
}

String formatDuration(Duration duration) {
  final hours = duration.inHours;
  final minutes = duration.inMinutes.remainder(60);

  if (hours > 0 && minutes == 0) {
    return '$hours時間前から';
  } else if (hours > 0 && minutes > 0) {
    return '$hours時間$minutes分前から';
  } else {
    return '$minutes分前から';
  }
}
