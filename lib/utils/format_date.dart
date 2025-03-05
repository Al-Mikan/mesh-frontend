import 'package:intl/intl.dart';

String formatDateTime(String dateTime) {
  final dateTimeObj = DateTime.parse(dateTime).toLocal();
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
