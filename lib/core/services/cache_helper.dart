import 'package:shared_preferences/shared_preferences.dart';

class CacheHelper {
  CacheHelper._internal();

  static final CacheHelper instance = CacheHelper._internal();

  static const _genesisTimeKey = 'slot-0-unix-time';
  static const _slotDurationKey = 'slot-duration';

  late SharedPreferences _prefs;

  bool _initialized = false;
  int _genesisTime = 0;

  int _slotDuration = 1;

  /// Unix time of the genesis block.
  int get genesisTime => _genesisTime;

  /// Slot duration in seconds.
  ///
  /// Default value is 1 second.
  int get slotDuration => _slotDuration;

  bool _isGenesisTimeCached = false;
  bool _isSlotDurationCached = false;

  bool get isGenesisTimeCached => _isGenesisTimeCached;

  bool get isSlotDurationCached => _isSlotDurationCached;

  void init(SharedPreferences prefs) {
    if (_initialized) return;
    _prefs = prefs;
    final genesisTime = _prefs.getInt(_genesisTimeKey);
    if (genesisTime != null) {
      _genesisTime = genesisTime;
      _isGenesisTimeCached = true;
    }
    final slotDuration = _prefs.getInt(_slotDurationKey);
    if (slotDuration != null) {
      _slotDuration = slotDuration;
      _isSlotDurationCached = true;
    }
    _initialized = true;
  }

  Future<void> cacheGenesisTime(int unixTime) async {
    await _prefs.setInt(_genesisTimeKey, unixTime);
    _genesisTime = unixTime;
  }

  Future<void> cacheSlotDuration(int slotDuration) async {
    await _prefs.setInt(_slotDurationKey, slotDuration);
    _slotDuration = slotDuration;
  }
}
