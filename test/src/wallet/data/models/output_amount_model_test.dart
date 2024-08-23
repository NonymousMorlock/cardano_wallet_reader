import 'dart:convert';

import 'package:cardano_wallet_reader/core/utils/typedefs.dart';
import 'package:cardano_wallet_reader/src/wallet/data/models/output_amount_model.dart';
import 'package:cardano_wallet_reader/src/wallet/domain/entities/output_amount.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../fixtures/fixture_reader.dart';

void main() {
  const tOutputAmountModel = OutputAmountModel.fixture();

  group('OutputAmountModel', () {
    test('should be a subclass of [OutputAmount] entity', () {
      expect(tOutputAmountModel, isA<OutputAmount>());
    });

    group('fromMap', () {
      test(
          'should return a valid [OutputAmountModel] when the JSON is not null',
          () {
        final map = jsonDecode(fixture('output_amount.json')) as DataMap;
        final result = OutputAmountModel.fromMap(map);
        expect(result, tOutputAmountModel);
      });
    });

    group('toMap', () {
      test('should return a Dart map containing the proper data', () {
        final map = jsonDecode(fixture('output_amount.json')) as DataMap;
        final tModel = OutputAmountModel.fromMap(map);
        final result = tModel.toMap();
        expect(result, map);
      });
    });

    group('copyWith', () {
      test('should return a new [OutputAmountModel] with the same values', () {
        final result = tOutputAmountModel.copyWith(unit: '');
        expect(result.unit, equals(''));
      });
    });
  });
}
