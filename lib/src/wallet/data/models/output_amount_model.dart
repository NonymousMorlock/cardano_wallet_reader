import 'package:cardano_wallet_reader/core/utils/constants/app_constants.dart';
import 'package:cardano_wallet_reader/core/utils/typedefs.dart';
import 'package:cardano_wallet_reader/src/wallet/domain/entities/output_amount.dart';

class OutputAmountModel extends OutputAmount {
  const OutputAmountModel({
    required super.unit,
    required super.quantity,
    super.unitName = 'ADA',
  });

  const OutputAmountModel.empty()
      : this(
          unit: 'Test String',
          unitName: 'Test String',
          quantity: 1,
        );

  /// Fixed output amount for testing purposes
  const OutputAmountModel.fixture()
      : this(
          unit: 'lovelace',
          unitName: 'ADA',
          // actual json value is 42000000, but due to the lovelace factor,
          // it will be 42
          quantity: 42,
        );

  OutputAmountModel.fromMap(DataMap map)
      : this(
          unit: map['unit'] as String,
          unitName: map['unit'] == 'lovelace' ? 'ADA' : '',
          quantity: double.parse(map['quantity'] as String) /
              (map['unit'] == 'lovelace' ? AppConstants.lovelaceFactor : 1),
        );

  OutputAmountModel copyWith({
    String? unit,
    String? unitName,
    double? quantity,
  }) {
    return OutputAmountModel(
      unit: unit ?? this.unit,
      unitName: unitName ?? this.unitName,
      quantity: quantity ?? this.quantity,
    );
  }

  DataMap toMap() {
    final quantity = unit == 'lovelace'
        ? this.quantity * AppConstants.lovelaceFactor
        : this.quantity;
    return <String, dynamic>{
      'unit': unit,
      // if it has decimal places but it's 0, it will be converted to an integer
      'quantity': (quantity % 1 == 0 ? quantity.toInt() : quantity).toString(),
    };
  }
}
