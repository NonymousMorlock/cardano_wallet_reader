import 'package:intl/intl.dart';

extension DateTimeExtensions on DateTime {
  String get yyyyMMddHHmmss => DateFormat('yyyy-MM-dd HH:mm:ss').format(this);
}
