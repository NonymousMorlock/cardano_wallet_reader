import 'package:cardano_wallet_reader/src/wallet/domain/entities/output_amount.dart';
import 'package:equatable/equatable.dart';

/// Unspent transaction output (UTXO).
class Utxo extends Equatable {
  /// Unspent transaction output (UTXO).
  const Utxo({
    required this.address,
    required this.amount,
    required this.outputIndex,
    required this.collateral,
    this.dataHash,
    this.inlineDatum,
    this.reference,
    this.referenceScriptHash,
    this.txHash,
  });

  Utxo.empty()
      : address = 'Test String',
        amount = [],
        txHash = null,
        outputIndex = 1,
        dataHash = null,
        inlineDatum = 'Test String',
        referenceScriptHash = null,
        collateral = true,
        reference = null;

  final String address;
  final List<OutputAmount> amount;
  final String? txHash;
  final int outputIndex;
  final String? dataHash;
  final String? inlineDatum;
  final String? referenceScriptHash;
  final bool collateral;
  final bool? reference;

  bool get isOutput => reference == null;

  bool get isInput => !isOutput;

  @override
  List<dynamic> get props => [
        address,
        txHash,
        outputIndex,
        dataHash,
        inlineDatum,
        referenceScriptHash,
        collateral,
        reference,
      ];
}
