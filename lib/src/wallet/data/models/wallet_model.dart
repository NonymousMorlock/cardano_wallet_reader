import 'package:cardano_wallet_reader/core/utils/constants/app_constants.dart';
import 'package:cardano_wallet_reader/core/utils/typedefs.dart';
import 'package:cardano_wallet_reader/src/wallet/domain/entities/wallet.dart';

/// A Cardano Wallet Model
class WalletModel extends Wallet {
  const WalletModel({
    required super.address,
    required super.stakeAddress,
    required super.active,
    required super.activeEpoch,
    required super.controlledAmount,
    required super.rewardsSum,
    required super.withdrawalsSum,
    required super.reservesSum,
    required super.treasurySum,
    required super.withdrawableAmount,
    required super.poolId,
  });

  WalletModel.empty()
      : this(
          address: 'Test String',
          stakeAddress: 'Test String',
          active: true,
          activeEpoch: DateTime.now(),
          controlledAmount: 1,
          rewardsSum: 1,
          withdrawalsSum: 1,
          reservesSum: 1,
          treasurySum: 1,
          withdrawableAmount: 1,
          poolId: 'Test String',
        );

  /// Fixed wallet for testing purposes
  WalletModel.fixture()
      : this(
          address: '',
          stakeAddress:
              'stake1ux3g2c9dx2nhhehyrezyxpkstartcqmu9hk63qgfkccw5rqttygt7',
          active: true,
          activeEpoch: DateTime.fromMillisecondsSinceEpoch(412),
          controlledAmount:
              double.parse('619154618165') / AppConstants.lovelaceFactor,
          rewardsSum:
              double.parse('319154618165') / AppConstants.lovelaceFactor,
          withdrawalsSum:
              double.parse('12125369253') / AppConstants.lovelaceFactor,
          reservesSum:
              double.parse('319154618165') / AppConstants.lovelaceFactor,
          treasurySum: double.parse('12000000') / AppConstants.lovelaceFactor,
          withdrawableAmount:
              double.parse('319154618165') / AppConstants.lovelaceFactor,
          poolId: 'pool1pu5jlj4q9w9jlxeu370a3c9myx47md5j5m2str0naunn2q3lkdy',
        );

  WalletModel.fromMap(DataMap map)
      : this(
          address: '',
          stakeAddress: map['stake_address'] as String,
          active: map['active'] as bool,
          activeEpoch: DateTime.fromMillisecondsSinceEpoch(
            (map['active_epoch'] as num).toInt(),
          ),
          controlledAmount: int.parse(map['controlled_amount'] as String) /
              AppConstants.lovelaceFactor,
          rewardsSum: int.parse(map['rewards_sum'] as String) /
              AppConstants.lovelaceFactor,
          withdrawalsSum: int.parse(map['withdrawals_sum'] as String) /
              AppConstants.lovelaceFactor,
          reservesSum: int.parse(map['reserves_sum'] as String) /
              AppConstants.lovelaceFactor,
          treasurySum: int.parse(map['treasury_sum'] as String) /
              AppConstants.lovelaceFactor,
          withdrawableAmount: int.parse(map['withdrawable_amount'] as String) /
              AppConstants.lovelaceFactor,
          poolId: map['pool_id'] as String,
        );

  WalletModel copyWith({
    String? address,
    String? stakeAddress,
    bool? active,
    DateTime? activeEpoch,
    double? controlledAmount,
    double? rewardsSum,
    double? withdrawalsSum,
    double? reservesSum,
    double? treasurySum,
    double? withdrawableAmount,
    String? poolId,
  }) {
    return WalletModel(
      address: address ?? this.address,
      stakeAddress: stakeAddress ?? this.stakeAddress,
      active: active ?? this.active,
      activeEpoch: activeEpoch ?? this.activeEpoch,
      controlledAmount: controlledAmount ?? this.controlledAmount,
      rewardsSum: rewardsSum ?? this.rewardsSum,
      withdrawalsSum: withdrawalsSum ?? this.withdrawalsSum,
      reservesSum: reservesSum ?? this.reservesSum,
      treasurySum: treasurySum ?? this.treasurySum,
      withdrawableAmount: withdrawableAmount ?? this.withdrawableAmount,
      poolId: poolId ?? this.poolId,
    );
  }

  DataMap toMap() {
    final controlledAmount =
        this.controlledAmount * AppConstants.lovelaceFactor;
    final rewardsSum = this.rewardsSum * AppConstants.lovelaceFactor;
    final withdrawalsSum = this.withdrawalsSum * AppConstants.lovelaceFactor;
    final reservesSum = this.reservesSum * AppConstants.lovelaceFactor;
    final treasurySum = this.treasurySum * AppConstants.lovelaceFactor;
    final withdrawableAmount =
        this.withdrawableAmount * AppConstants.lovelaceFactor;

    return {
      'stake_address': stakeAddress,
      'active': active,
      'active_epoch': activeEpoch.millisecondsSinceEpoch,
      'controlled_amount': (controlledAmount % 1 == 0
              ? controlledAmount.toInt()
              : controlledAmount)
          .toString(),
      'rewards_sum':
          (rewardsSum % 1 == 0 ? rewardsSum.toInt() : rewardsSum).toString(),
      'withdrawals_sum':
          (withdrawalsSum % 1 == 0 ? withdrawalsSum.toInt() : withdrawalsSum)
              .toString(),
      'reserves_sum':
          (reservesSum % 1 == 0 ? reservesSum.toInt() : reservesSum).toString(),
      'treasury_sum':
          (treasurySum % 1 == 0 ? treasurySum.toInt() : treasurySum).toString(),
      'withdrawable_amount': (withdrawableAmount % 1 == 0
              ? withdrawableAmount.toInt()
              : withdrawableAmount)
          .toString(),
      'pool_id': poolId,
    };
  }
}
