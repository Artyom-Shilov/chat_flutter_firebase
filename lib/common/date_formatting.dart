import 'package:intl/intl.dart';

class DateFormatter {

  DateFormatter._();

  static final DateFormatter _instance = DateFormatter._();
  static DateFormatter get I => _instance;

  String formatDate(int millisecondsSinceEpoch) {
    return DateFormat('yy/MM/dd H:mm')
        .format(DateTime.fromMillisecondsSinceEpoch(millisecondsSinceEpoch));
  }
}