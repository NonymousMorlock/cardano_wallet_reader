import 'package:cardano_wallet_reader/core/utils/typedefs.dart';
import 'package:cardano_wallet_reader/src/wallet/data/models/output_amount_model.dart';
import 'package:cardano_wallet_reader/src/wallet/domain/entities/output_amount.dart';
import 'package:cardano_wallet_reader/src/wallet/domain/entities/utxo.dart';

class UtxoModel extends Utxo {
  const UtxoModel({
    required super.address,
    required super.amount,
    required super.outputIndex,
    required super.collateral,
    super.dataHash,
    super.inlineDatum,
    super.reference,
    super.referenceScriptHash,
    super.txHash,
  });

  UtxoModel.empty()
      : this(
          address: 'Test String',
          amount: [],
          txHash: null,
          outputIndex: 1,
          dataHash: null,
          inlineDatum: 'Test String',
          referenceScriptHash: null,
          collateral: true,
          reference: null,
        );

  UtxoModel.fixture()
      : this(
          address: 'addr1q9ld26v2lv8wvrxxmvg90pn8n8n5k6tdst06q2s85'
              '6rwmvnueldzuuqmnsye359fqrk8hwvenjnqultn7djtrlft7jnq7dy7wv',
          amount: [
            OutputAmountModel.fromMap(
              const {'unit': 'lovelace', 'quantity': '42000000'},
            ),
            OutputAmountModel.fromMap(
              const {
                'unit': 'b0d07d45fe9514f80213f4020e5a61'
                    '241458be626841cde717cb38a76e7574636f696e',
                'quantity': '12',
              },
            ),
          ],
          txHash: '1a0570af966fb355a7160e4f82d5a80b8681b7955f5d'
              '44bec0dce628516157f0',
          outputIndex: 0,
          dataHash: '9e478573ab81ea7a8e31891ce0648b81229f4'
              '08d596a3483e6f4f9b92d3cf710',
          inlineDatum: '19a6aa',
          referenceScriptHash: '13a3efd825703a352a8f71f4e275'
              '8d08c28c564e8dfcce9f77776ad1',
          collateral: false,
          reference: false,
        );

  UtxoModel.fromMap(DataMap map)
      : this(
          address: map['address'] as String,
          amount: List<DataMap>.from(map['amount'] as List)
              .map(OutputAmountModel.fromMap)
              .toList(),
          txHash: map['tx_hash'] as String?,
          outputIndex: (map['output_index'] as num).toInt(),
          dataHash: map['data_hash'] as String?,
          inlineDatum: map['inline_datum'] as String?,
          referenceScriptHash: map['reference_script_hash'] as String?,
          collateral: map['collateral'] as bool,
          reference: map['reference'] as bool?,
        );

  UtxoModel copyWith({
    String? address,
    List<OutputAmount>? amount,
    String? txHash,
    int? outputIndex,
    String? dataHash,
    String? inlineDatum,
    String? referenceScriptHash,
    bool? collateral,
    bool? reference,
  }) {
    return UtxoModel(
      address: address ?? this.address,
      amount: amount ?? this.amount,
      txHash: txHash ?? this.txHash,
      outputIndex: outputIndex ?? this.outputIndex,
      dataHash: dataHash ?? this.dataHash,
      inlineDatum: inlineDatum ?? this.inlineDatum,
      referenceScriptHash: referenceScriptHash ?? this.referenceScriptHash,
      collateral: collateral ?? this.collateral,
      reference: reference ?? this.reference,
    );
  }

  DataMap toMap() {
    return <String, dynamic>{
      'address': address,
      'amount': amount.map((e) => (e as OutputAmountModel).toMap()).toList(),
      if (txHash != null) 'tx_hash': txHash,
      'output_index': outputIndex,
      'data_hash': dataHash,
      'inline_datum': inlineDatum,
      'reference_script_hash': referenceScriptHash,
      'collateral': collateral,
      if (reference != null) 'reference': reference,
    };
  }
}
