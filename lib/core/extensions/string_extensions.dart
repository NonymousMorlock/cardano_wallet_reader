extension StringExtensions on String {
  /// Shortens the address by replacing the middle part with ellipsis.
  /// b0d07d45fe9514f80213f4020e5a61241458be626841cde717cb38a76e7574636f696e
  /// becomes b0d0...696e
  String get shortenEllipsis {
    if (length < 12) return this;
    return '${substring(0, 6)}...${substring(length - 4)}';
  }
}
