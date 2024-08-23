import 'package:cardano_wallet_reader/core/errors/exception.dart';
import 'package:cardano_wallet_reader/core/errors/failure.dart';
import 'package:cardano_wallet_reader/src/wallet/data/datasources/wallet_remote_data_src.dart';
import 'package:cardano_wallet_reader/src/wallet/data/models/transaction_model.dart';
import 'package:cardano_wallet_reader/src/wallet/data/models/wallet_model.dart';
import 'package:cardano_wallet_reader/src/wallet/data/repos/wallet_repo_impl.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockWalletRemoteDataSrc extends Mock implements WalletRemoteDataSrc {}

void main() {
  late WalletRemoteDataSrc remoteDataSrc;
  late WalletRepoImpl repoImpl;

  setUp(() {
    remoteDataSrc = MockWalletRemoteDataSrc();
    repoImpl = WalletRepoImpl(remoteDataSrc);
  });

  const tServerException = ServerException(
    message: 'Unknown Server Error',
    statusCode: '500',
  );

  group('getTransaction', () {
    test(
      'should return [Right<List<Transaction>>] when call to remote source '
      'is successful',
      () async {
        final tResult = [TransactionModel.empty()];
        when(
          () => remoteDataSrc.getTransactions(
            walletAddress: any(named: 'walletAddress'),
          ),
        ).thenAnswer((_) async => tResult);

        final result = await repoImpl.getTransactions(
          walletAddress: 'walletAddress',
        );

        expect(result, equals(Right<Failure, List<TransactionModel>>(tResult)));
        verify(
          () => remoteDataSrc.getTransactions(walletAddress: 'walletAddress'),
        ).called(1);
      },
    );

    test(
      'should return [Left<ServerFailure>] when call to remote source '
      'is unsuccessful',
      () async {
        when(
          () => remoteDataSrc.getTransactions(
            walletAddress: any(named: 'walletAddress'),
          ),
        ).thenThrow(tServerException);

        final result = await repoImpl.getTransactions(
          walletAddress: 'walletAddress',
        );

        expect(
          result,
          equals(
            Left<Failure, List<TransactionModel>>(
              ServerFailure.fromServerException(tServerException),
            ),
          ),
        );

        verify(
          () => remoteDataSrc.getTransactions(walletAddress: 'walletAddress'),
        ).called(1);

        verifyNoMoreInteractions(remoteDataSrc);
      },
    );
  });

  group('getWallet', () {
    test(
      'should return a [Right<Wallet>] when call to remote source '
      'is successful',
      () async {
        final tResult = WalletModel.empty();
        when(() => remoteDataSrc.getWallet(any())).thenAnswer(
          (_) async => tResult,
        );

        final result = await repoImpl.getWallet('walletAddress');

        expect(result, equals(Right<Failure, WalletModel>(tResult)));
        verify(() => remoteDataSrc.getWallet('walletAddress')).called(1);
        verifyNoMoreInteractions(remoteDataSrc);
      },
    );

    test(
      'should return a [Left<ServerFailure>] when call to remote source '
      'is unsuccessful',
      () async {
        when(() => remoteDataSrc.getWallet(any())).thenThrow(tServerException);

        final result = await repoImpl.getWallet('walletAddress');

        expect(
          result,
          equals(
            Left<Failure, WalletModel>(
              ServerFailure.fromServerException(tServerException),
            ),
          ),
        );

        verify(() => remoteDataSrc.getWallet(any())).called(1);
        verifyNoMoreInteractions(remoteDataSrc);
      },
    );
  });
}
