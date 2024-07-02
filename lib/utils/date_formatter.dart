import 'package:intl/intl.dart';

class DateFormatter {
  static DateFormat dateFormat = DateFormat('dd MMM yyyy');
  static DateFormat dateFormatTime = DateFormat('jm');
  static DateFormat dateFormatter = DateFormat('dd-MM-yyyy h:mm a');
  static DateFormat dayFormat = DateFormat('dd-MM-yyyy, EEEE');
  static DateFormat dateFormatWithDay = DateFormat('dd MMM yyyy, h:mm a');
}
