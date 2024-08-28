import 'dart:convert';

import 'package:cardano_wallet_reader/core/utils/typedefs.dart';
import 'package:cardano_wallet_reader/src/wallet/data/models/utxo_model.dart';
import 'package:cardano_wallet_reader/src/wallet/domain/entities/utxo.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../fixtures/fixture_reader.dart';

void main() {
  final tUtxoModel = UtxoModel.fixture();

  group('UtxoModel', () {
    test('should be a subclass of [Utxo] entity', () async {
      expect(tUtxoModel, isA<Utxo>());
    });

    group('fromMap', () {
      test('should return a valid [UtxoModel] when the JSON is not null',
          () async {
        final map = jsonDecode(fixture('utxo.json')) as DataMap;
        final result = UtxoModel.fromMap(map);
        expect(result, tUtxoModel);
      });
    });

    group('toMap', () {
      test('should return a Dart map containing the proper data', () async {
        final map = jsonDecode(fixture('utxo.json')) as DataMap;
        final result = tUtxoModel.toMap();
        expect(result, map);
      });
    });

    group('copyWith', () {
      test('should return a new [UtxoModel] with the same values', () async {
        final result = tUtxoModel.copyWith(address: '');
        expect(result.address, equals(''));
      });
    });
  });
}
