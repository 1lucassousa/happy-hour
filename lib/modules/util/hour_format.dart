import 'package:intl/intl.dart';

class HourUtil {
  static DateFormat outputFormat = DateFormat("yyyy-MM-dd HH:mm:ss");
  static DateFormat inputFormat = DateFormat("dd/MM/yyyy HH:mm:ss");

  static format(String date) {
    return inputFormat.format(outputFormat.parse(date)).toString();
  }

  static addingMilliseconds(String date) {
    DateTime dateTime = DateTime.now();
    return date +
        '.' +
        dateTime.millisecond.toString() +
        dateTime.microsecond.toString();
  }
}
