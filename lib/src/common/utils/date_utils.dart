import 'package:intl/intl.dart';

final _timeFormat = DateFormat('HH:mm:ss');
final _dateFormat = DateFormat('yyyy-MM-dd');
final _dateTimeFormat = DateFormat('yyyy-MM-dd HH:mm:ss');

extension DateTimeX on DateTime {
  static DateTime? parseTime(String? time) {
    if (time == null) {
      return null;
    }
    return _timeFormat.parse(time);
  }

  String formatTime() {
    return _timeFormat.format(this);
  }

  String formatDate() {
    return _dateFormat.format(this);
  }

  String formatDateTime() {
    return _dateTimeFormat.format(this);
  }
}
