enum SortOrder {
  asc,
  desc;

  String get value {
    switch (this) {
      case SortOrder.asc:
        return 'asc';
      case SortOrder.desc:
        return 'desc';
    }
  }
}
