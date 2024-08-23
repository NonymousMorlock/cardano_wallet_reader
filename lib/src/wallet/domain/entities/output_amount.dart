import 'package:equatable/equatable.dart';

class OutputAmount extends Equatable {
  const OutputAmount({
    required this.unit,
    required this.quantity,
    this.unitName = 'ADA',
  });
  const OutputAmount.empty()
      : unit = 'Test String',
        unitName = 'Test String',
        quantity = 1;

  final String unit;
  final String? unitName;
  final double quantity;

  @override
  List<Object?> get props => [
        unit,
        quantity,
        unitName,
      ];
}
