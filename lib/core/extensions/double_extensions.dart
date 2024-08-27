import 'package:intl/intl.dart';

extension DoubleExtensions on double {
  String get walletFormat {
    final stripped = this % 1 == 0 ? toInt() : this;
    return NumberFormat(
      '###,###.##',
      'en_US',
    ).format(stripped);
  }
}
