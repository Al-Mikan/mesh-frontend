import 'package:intl/intl.dart';

String formatDateTime(String dateTime) {
  final dateTimeObj = DateTime.parse(dateTime);
  return DateFormat('yyyy/MM/dd HH:mm').format(dateTimeObj);
}
