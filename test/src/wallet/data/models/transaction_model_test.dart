import 'dart:convert';

import 'package:cardano_wallet_reader/core/utils/typedefs.dart';
import 'package:cardano_wallet_reader/src/wallet/data/models/transaction_model.dart';
import 'package:cardano_wallet_reader/src/wallet/domain/entities/transaction.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../fixtures/fixture_reader.dart';

void main() {
  final tTransactionModel = TransactionModel.fixture();

  group('TransactionModel', () {
    test('should be a subclass of [Transaction] entity', () {
      expect(tTransactionModel, isA<Transaction>());
    });

    group('fromMap', () {
      test('should return a valid [TransactionModel] when the JSON is not null',
          () {
        final map = jsonDecode(fixture('transaction.json')) as DataMap;
        final result = TransactionModel.fromMap(map);
        expect(result, tTransactionModel);
      });
    });

    group('toMap', () {
      test('should return a Dart map containing the proper data', () {
        final map = jsonDecode(fixture('transaction.json')) as DataMap;
        final tModel = TransactionModel.fromMap(map);
        final result = tModel.toMap();
        expect(result, map);
      });
    });

    group('copyWith', () {
      test('should return a new [TransactionModel] with the same values', () {
        final result = tTransactionModel.copyWith(hash: '');
        expect(result.hash, equals(''));
      });
    });
  });
}
