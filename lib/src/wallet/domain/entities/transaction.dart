import 'package:cardano_wallet_reader/src/wallet/domain/entities/output_amount.dart';
import 'package:equatable/equatable.dart';

class Transaction extends Equatable {
  const Transaction({
    required this.hash,
    required this.block,
    required this.blockHeight,
    required this.blockTime,
    required this.slot,
    required this.index,
    required this.outputAmount,
    required this.fees,
    required this.deposit,
    required this.size,
    required this.utxoCount,
    required this.withdrawalCount,
    required this.mirCertCount,
    required this.delegationCount,
    required this.stakeCertCount,
    required this.poolUpdateCount,
    required this.poolRetireCount,
    required this.assetMintOrBurnCount,
    required this.redeemerCount,
    required this.validContract,
    this.invalidBefore,
    this.invalidHereafter,
  });

  Transaction.empty()
      : hash = 'Test String',
        block = 'Test String',
        blockHeight = 1,
        blockTime = DateTime.now(),
        slot = 1,
        index = 1,
        outputAmount = [],
        fees = 1,
        deposit = 1,
        size = 1,
        invalidBefore = DateTime.now(),
        invalidHereafter = DateTime.now(),
        utxoCount = 1,
        withdrawalCount = 1,
        mirCertCount = 1,
        delegationCount = 1,
        stakeCertCount = 1,
        poolUpdateCount = 1,
        poolRetireCount = 1,
        assetMintOrBurnCount = 1,
        redeemerCount = 1,
        validContract = true;

  final String hash;
  final String block;
  final int blockHeight;
  final DateTime blockTime;
  final int slot;
  final int index;
  final List<OutputAmount> outputAmount;
  final double fees;
  final double deposit;
  final int size;
  final DateTime? invalidBefore;
  final DateTime? invalidHereafter;
  final int utxoCount;
  final int withdrawalCount;
  final int mirCertCount;
  final int delegationCount;
  final int stakeCertCount;
  final int poolUpdateCount;
  final int poolRetireCount;
  final int assetMintOrBurnCount;
  final int redeemerCount;
  final bool validContract;

  @override
  List<Object?> get props => [
        hash,
        block,
        blockHeight,
        blockTime,
        slot,
        index,
        outputAmount,
        fees,
        deposit,
        size,
        invalidBefore,
        invalidHereafter,
        utxoCount,
        withdrawalCount,
        mirCertCount,
        delegationCount,
        stakeCertCount,
        poolUpdateCount,
        poolRetireCount,
        assetMintOrBurnCount,
        redeemerCount,
        validContract,
      ];
}
