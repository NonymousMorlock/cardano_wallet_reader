import 'package:cardano_wallet_reader/core/errors/failure.dart';
import 'package:cardano_wallet_reader/src/wallet/data/models/wallet_model.dart';
import 'package:cardano_wallet_reader/src/wallet/domain/entities/wallet.dart';
import 'package:cardano_wallet_reader/src/wallet/domain/repos/wallet_repo.dart';
import 'package:cardano_wallet_reader/src/wallet/domain/usecases/get_wallet.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'wallet_repo.mock.dart';

void main() {
  late WalletRepo repo;
  late GetWallet usecase;

  setUp(() {
    repo = MockWalletRepo();
    usecase = GetWallet(repo);
  });

  final tWallet = WalletModel.empty();

  test('should return [Wallet] from [WalletRepo]', () async {
    when(() => repo.getWallet(any())).thenAnswer((_) async => Right(tWallet));

    final result = await usecase('walletAddress');

    expect(result, equals(Right<Failure, Wallet>(tWallet)));
    verify(() => repo.getWallet('walletAddress')).called(1);
    verifyNoMoreInteractions(repo);
  });
}
