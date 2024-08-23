import 'dart:convert';

import 'package:cardano_wallet_reader/core/utils/typedefs.dart';
import 'package:cardano_wallet_reader/src/wallet/data/models/wallet_model.dart';
import 'package:cardano_wallet_reader/src/wallet/domain/entities/wallet.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../fixtures/fixture_reader.dart';

void main() {
  final tWalletModel = WalletModel.fixture();

  group('WalletModel', () {
    test('should be a subclass of [Wallet] entity', () {
      expect(tWalletModel, isA<Wallet>());
    });

    group('fromMap', () {
      test('should return a valid [WalletModel] when the JSON is not null', () {
        final map = jsonDecode(fixture('wallet.json')) as DataMap;
        final result = WalletModel.fromMap(map);
        expect(result, tWalletModel);
      });
    });

    group('toMap', () {
      test('should return a Dart map containing the proper data', () {
        final map = jsonDecode(fixture('wallet.json')) as DataMap;
        final result = tWalletModel.toMap();
        expect(result, map);
      });
    });

    group('copyWith', () {
      test('should return a new [WalletModel] with the same values', () {
        final result = tWalletModel.copyWith(stakeAddress: '');
        expect(result.stakeAddress, equals(''));
      });
    });
  });
}
