import 'package:cardano_wallet_reader/core/errors/failure.dart';
import 'package:cardano_wallet_reader/src/wallet/data/models/transaction_model.dart';
import 'package:cardano_wallet_reader/src/wallet/domain/entities/transaction.dart';
import 'package:cardano_wallet_reader/src/wallet/domain/repos/wallet_repo.dart';
import 'package:cardano_wallet_reader/src/wallet/domain/usecases/get_transactions.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'wallet_repo.mock.dart';

void main() {
  late WalletRepo repo;
  late GetTransactions usecase;

  setUp(() {
    repo = MockWalletRepo();
    usecase = GetTransactions(repo);
  });

  final tTransactions = [TransactionModel.empty()];

  test('should return [List<Transaction>] from [WalletRepo]', () async {
    when(
      () => repo.getTransactions(walletAddress: any(named: 'walletAddress')),
    ).thenAnswer((_) async => Right(tTransactions));

    final result = await usecase(
      const GetTransactionsParams(walletAddress: 'walletAddress'),
    );

    expect(result, equals(Right<Failure, List<Transaction>>(tTransactions)));
    verify(
      () => repo.getTransactions(walletAddress: 'walletAddress'),
    ).called(1);
    verifyNoMoreInteractions(repo);
  });
}
