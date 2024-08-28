import 'package:cardano_wallet_reader/core/services/cache_helper.dart';

extension IntExtensions on int {
  DateTime get slotToDateTime {
    final genesisTime = DateTime.fromMillisecondsSinceEpoch(
      CacheHelper.instance.genesisTime * 1000,
      isUtc: true,
    );

    return genesisTime.add(
      Duration(seconds: this * CacheHelper.instance.slotDuration),
    );
  }
}
