import 'package:intl/intl.dart';

class Rupiah {
  static String format(num number) {
    final formatter =
        NumberFormat.simpleCurrency(locale: 'id_ID', decimalDigits: 0);
    return formatter.format(number);
  }
}
