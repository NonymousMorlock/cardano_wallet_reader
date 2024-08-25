extension DoubleExtensions on double {
  String get walletFormat {
    final stripped = this % 1 == 0 ? toInt() : this;
    return stripped.toString().replaceAllMapped(
          RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
          (match) => '${match[1]},',
        );
  }
}
