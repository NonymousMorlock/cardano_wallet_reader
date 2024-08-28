import 'package:bloc_test/bloc_test.dart';
import 'package:cardano_wallet_reader/core/errors/failure.dart';
import 'package:cardano_wallet_reader/src/wallet/data/models/transaction_model.dart';
import 'package:cardano_wallet_reader/src/wallet/data/models/wallet_model.dart';
import 'package:cardano_wallet_reader/src/wallet/domain/usecases/get_transactions.dart';
import 'package:cardano_wallet_reader/src/wallet/domain/usecases/get_wallet.dart';
import 'package:cardano_wallet_reader/src/wallet/presentation/wallet_views.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockGetWallet extends Mock implements GetWallet {}

class MockGetTransactions extends Mock implements GetTransactions {}

void main() {
  late GetWallet getWallet;
  late GetTransactions getTransactions;
  late WalletCubit cubit;

  setUp(() {
    getWallet = MockGetWallet();
    getTransactions = MockGetTransactions();
    cubit = WalletCubit(
      getWallet: getWallet,
      getTransactions: getTransactions,
    );
  });

  const tFailure = ServerFailure(
    message: 'An unexpected response was received from the backend',
    statusCode: '500 Internal Server Error',
  );

  test('initial state is [WalletInitial]', () {
    expect(cubit.state, isA<WalletInitial>());
  });

  group('getWallet', () {
    final tWallet = WalletModel.empty();

    blocTest<WalletCubit, WalletState>(
      'should emit [WalletLoading, WalletLoaded] when fetching data is '
      'successful',
      build: () {
        when(() => getWallet(any())).thenAnswer((_) async => Right(tWallet));
        return cubit;
      },
      act: (cubit) => cubit.getWallet('walletAddress'),
      expect: () => [
        const WalletLoading(),
        WalletLoaded(tWallet),
      ],
      verify: (_) => [
        verify(() => getWallet('walletAddress')).called(1),
        verifyNoMoreInteractions(getWallet),
      ],
    );

    blocTest<WalletCubit, WalletState>(
      'should emit [WalletLoading, WalletError] when fetching data is '
      'unsuccessful',
      build: () {
        when(() => getWallet(any())).thenAnswer(
          (_) async => const Left(tFailure),
        );
        return cubit;
      },
      act: (cubit) => cubit.getWallet('walletAddress'),
      expect: () => [
        const WalletLoading(),
        WalletError(tFailure.errorMessage),
      ],
      verify: (_) => [
        verify(() => getWallet('walletAddress')).called(1),
        verifyNoMoreInteractions(getWallet),
      ],
    );
  });

  group('getTransactions', () {
    setUp(() {
      registerFallbackValue(const GetTransactionsParams.empty());
    });
    final tTransactions = <TransactionModel>[];

    blocTest<WalletCubit, WalletState>(
      'should emit [WalletLoading, WalletTransactionsLoaded] when fetching '
      'data is successful',
      build: () {
        when(() => getTransactions(any())).thenAnswer(
          (_) async => Right(tTransactions),
        );
        return cubit;
      },
      act: (cubit) => cubit.getTransactions(walletAddress: 'walletAddress'),
      expect: () => [
        const WalletLoading(),
        WalletTransactionsLoaded(tTransactions),
      ],
      verify: (_) => [
        verify(() => getTransactions(any())).called(1),
        verifyNoMoreInteractions(getTransactions),
      ],
    );

    blocTest<WalletCubit, WalletState>(
      'should emit [WalletLoading, WalletError] when fetching data is '
      'unsuccessful',
      build: () {
        when(() => getTransactions(any())).thenAnswer(
          (_) async => const Left(tFailure),
        );
        return cubit;
      },
      act: (cubit) => cubit.getTransactions(walletAddress: 'walletAddress'),
      expect: () => [
        const WalletLoading(),
        WalletError(tFailure.errorMessage),
      ],
      verify: (_) => [
        verify(() => getTransactions(any())).called(1),
        verifyNoMoreInteractions(getTransactions),
      ],
    );
  });
}
