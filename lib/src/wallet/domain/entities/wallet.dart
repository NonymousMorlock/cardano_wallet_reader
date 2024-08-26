import 'package:equatable/equatable.dart';

class Wallet extends Equatable {
  const Wallet({
    required this.address,
    required this.stakeAddress,
    required this.active,
    required this.controlledAmount,
    required this.rewardsSum,
    required this.withdrawalsSum,
    required this.reservesSum,
    required this.treasurySum,
    required this.withdrawableAmount,
    this.activeEpoch,
    this.poolId,
  });

  Wallet.empty()
      : address = 'Test String',
        stakeAddress = 'Test String',
        active = true,
        activeEpoch = DateTime.now(),
        controlledAmount = 1,
        rewardsSum = 1,
        withdrawalsSum = 1,
        reservesSum = 1,
        treasurySum = 1,
        withdrawableAmount = 1,
        poolId = 'Test String';

  final String address;
  final String stakeAddress;
  final bool active;

  /// The account has been participating in staking since this epoch
  final DateTime? activeEpoch;
  final double controlledAmount;
  final double rewardsSum;
  final double withdrawalsSum;
  final double reservesSum;
  final double treasurySum;
  final double withdrawableAmount;
  final String? poolId;

  @override
  List<Object?> get props => [
        address,
        stakeAddress,
        active,
        activeEpoch,
        controlledAmount,
        rewardsSum,
        withdrawalsSum,
        reservesSum,
        treasurySum,
        withdrawableAmount,
        poolId,
      ];
}
