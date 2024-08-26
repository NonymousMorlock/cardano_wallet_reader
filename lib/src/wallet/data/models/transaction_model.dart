import 'package:cardano_wallet_reader/core/utils/constants/app_constants.dart';
import 'package:cardano_wallet_reader/core/utils/typedefs.dart';
import 'package:cardano_wallet_reader/src/wallet/data/models/output_amount_model.dart';
import 'package:cardano_wallet_reader/src/wallet/domain/entities/output_amount.dart';
import 'package:cardano_wallet_reader/src/wallet/domain/entities/transaction.dart';

class TransactionModel extends Transaction {
  const TransactionModel({
    required super.hash,
    required super.block,
    required super.blockHeight,
    required super.blockTime,
    required super.slot,
    required super.index,
    required super.outputAmount,
    required super.fees,
    required super.deposit,
    required super.size,
    required super.utxoCount,
    required super.withdrawalCount,
    required super.mirCertCount,
    required super.delegationCount,
    required super.stakeCertCount,
    required super.poolUpdateCount,
    required super.poolRetireCount,
    required super.assetMintOrBurnCount,
    required super.redeemerCount,
    required super.validContract,
    super.invalidBefore,
    super.invalidHereafter,
  });

  TransactionModel.empty()
      : this(
          hash: 'Test String',
          block: 'Test String',
          blockHeight: 1,
          blockTime: DateTime.now(),
          slot: 1,
          index: 1,
          outputAmount: <OutputAmountModel>[],
          fees: 1,
          deposit: 1,
          size: 1,
          invalidBefore: DateTime.now(),
          invalidHereafter: DateTime.now(),
          utxoCount: 1,
          withdrawalCount: 1,
          mirCertCount: 1,
          delegationCount: 1,
          stakeCertCount: 1,
          poolUpdateCount: 1,
          poolRetireCount: 1,
          assetMintOrBurnCount: 1,
          redeemerCount: 1,
          validContract: true,
        );

  TransactionModel.fixture()
      : this(
          hash: '1e043f100dce12d107f679685acd2fc0610e10f72a92d412794c9773'
              'd11d8477',
          block: '356b7d7dbb696ccd12775c016941057a9dc70898d87a63fc752271b'
              'b46856940',
          blockHeight: 123456,
          blockTime: DateTime.fromMillisecondsSinceEpoch(
            1635505891 * 1000,
            isUtc: true,
          ),
          slot: 42000000,
          index: 1,
          outputAmount: <OutputAmountModel>[
            OutputAmountModel.fromMap(const {
              'unit': 'lovelace',
              'quantity': '42000000',
            }),
            OutputAmountModel.fromMap(const {
              'unit': 'b0d07d45fe9514f80213f4020e5a61241458be626841cde717'
                  'cb38a76e7574636f696e',
              'quantity': '12',
            }),
          ],
          fees: 182485 / AppConstants.lovelaceFactor,
          deposit: 0,
          size: 433,
          invalidBefore: null,
          invalidHereafter: DateTime.fromMillisecondsSinceEpoch(13885913),
          utxoCount: 4,
          withdrawalCount: 0,
          mirCertCount: 0,
          delegationCount: 0,
          stakeCertCount: 0,
          poolUpdateCount: 0,
          poolRetireCount: 0,
          assetMintOrBurnCount: 0,
          redeemerCount: 0,
          validContract: true,
        );

  TransactionModel.fromMap(DataMap map)
      : this(
          hash: map['hash'] as String,
          block: map['block'] as String,
          blockHeight: (map['block_height'] as num).toInt(),
          blockTime: DateTime.fromMillisecondsSinceEpoch(
            (map['block_time'] as num).toInt() * 1000,
            isUtc: true,
          ),
          slot: map['slot'] as int,
          index: map['index'] as int,
          outputAmount: List<DataMap>.from(map['output_amount'] as List)
              .map(OutputAmountModel.fromMap)
              .toList(),
          fees:
              double.parse(map['fees'] as String) / AppConstants.lovelaceFactor,
          deposit: double.parse(map['deposit'] as String) /
              AppConstants.lovelaceFactor,
          size: (map['size'] as num).toInt(),
          invalidBefore: (map['invalid_before']) == null
              ? null
              : DateTime.fromMillisecondsSinceEpoch(
                  int.parse(map['invalid_before'] as String),
                ),
          invalidHereafter: (map['invalid_hereafter']) == null
              ? null
              : DateTime.fromMillisecondsSinceEpoch(
                  int.parse(map['invalid_hereafter'] as String),
                ),
          utxoCount: (map['utxo_count'] as num).toInt(),
          withdrawalCount: (map['withdrawal_count'] as num).toInt(),
          mirCertCount: (map['mir_cert_count'] as num).toInt(),
          delegationCount: (map['delegation_count'] as num).toInt(),
          stakeCertCount: (map['stake_cert_count'] as num).toInt(),
          poolUpdateCount: (map['pool_update_count'] as num).toInt(),
          poolRetireCount: (map['pool_retire_count'] as num).toInt(),
          assetMintOrBurnCount:
              (map['asset_mint_or_burn_count'] as num).toInt(),
          redeemerCount: (map['redeemer_count'] as num).toInt(),
          validContract: map['valid_contract'] as bool,
        );

  TransactionModel copyWith({
    String? hash,
    String? block,
    int? blockHeight,
    DateTime? blockTime,
    int? slot,
    int? index,
    List<OutputAmount>? outputAmount,
    double? fees,
    double? deposit,
    int? size,
    DateTime? invalidBefore,
    DateTime? invalidHereafter,
    int? utxoCount,
    int? withdrawalCount,
    int? mirCertCount,
    int? delegationCount,
    int? stakeCertCount,
    int? poolUpdateCount,
    int? poolRetireCount,
    int? assetMintOrBurnCount,
    int? redeemerCount,
    bool? validContract,
  }) {
    return TransactionModel(
      hash: hash ?? this.hash,
      block: block ?? this.block,
      blockHeight: blockHeight ?? this.blockHeight,
      blockTime: blockTime ?? this.blockTime,
      slot: slot ?? this.slot,
      index: index ?? this.index,
      outputAmount: outputAmount ?? this.outputAmount,
      fees: fees ?? this.fees,
      deposit: deposit ?? this.deposit,
      size: size ?? this.size,
      invalidBefore: invalidBefore ?? this.invalidBefore,
      invalidHereafter: invalidHereafter ?? this.invalidHereafter,
      utxoCount: utxoCount ?? this.utxoCount,
      withdrawalCount: withdrawalCount ?? this.withdrawalCount,
      mirCertCount: mirCertCount ?? this.mirCertCount,
      delegationCount: delegationCount ?? this.delegationCount,
      stakeCertCount: stakeCertCount ?? this.stakeCertCount,
      poolUpdateCount: poolUpdateCount ?? this.poolUpdateCount,
      poolRetireCount: poolRetireCount ?? this.poolRetireCount,
      assetMintOrBurnCount: assetMintOrBurnCount ?? this.assetMintOrBurnCount,
      redeemerCount: redeemerCount ?? this.redeemerCount,
      validContract: validContract ?? this.validContract,
    );
  }

  DataMap toMap() {
    final fees = this.fees * AppConstants.lovelaceFactor;
    final deposit = this.deposit * AppConstants.lovelaceFactor;
    return <String, dynamic>{
      'hash': hash,
      'block': block,
      'block_height': blockHeight,
      'block_time': blockTime.millisecondsSinceEpoch ~/ 1000,
      'slot': slot,
      'index': index,
      'output_amount':
          outputAmount.map((e) => (e as OutputAmountModel).toMap()).toList(),
      'fees': (fees % 1 == 0 ? fees.toInt() : fees).toString(),
      'deposit': (deposit % 1 == 0 ? deposit.toInt() : deposit).toString(),
      'size': size,
      'invalid_before': invalidBefore?.millisecondsSinceEpoch.toString(),
      'invalid_hereafter': invalidHereafter?.millisecondsSinceEpoch.toString(),
      'utxo_count': utxoCount,
      'withdrawal_count': withdrawalCount,
      'mir_cert_count': mirCertCount,
      'delegation_count': delegationCount,
      'stake_cert_count': stakeCertCount,
      'pool_update_count': poolUpdateCount,
      'pool_retire_count': poolRetireCount,
      'asset_mint_or_burn_count': assetMintOrBurnCount,
      'redeemer_count': redeemerCount,
      'valid_contract': validContract,
    };
  }
}
