import 'package:cardano_wallet_reader/core/enums/order.dart';
import 'package:cardano_wallet_reader/core/errors/exception.dart';
import 'package:cardano_wallet_reader/core/errors/failure.dart';
import 'package:cardano_wallet_reader/core/utils/typedefs.dart';
import 'package:cardano_wallet_reader/src/wallet/data/datasources/wallet_remote_data_src.dart';
import 'package:cardano_wallet_reader/src/wallet/domain/entities/transaction.dart';
import 'package:cardano_wallet_reader/src/wallet/domain/entities/wallet.dart';
import 'package:cardano_wallet_reader/src/wallet/domain/repos/wallet_repo.dart';
import 'package:dartz/dartz.dart';

class WalletRepoImpl implements WalletRepo {
  const WalletRepoImpl(this._remoteDataSrc);

  final WalletRemoteDataSrc _remoteDataSrc;

  @override
  ResultFuture<List<Transaction>> getTransactions({
    required String walletAddress,
    SortOrder? order,
    int? limit,
    int? page,
  }) async {
    try {
      final result = await _remoteDataSrc.getTransactions(
        walletAddress: walletAddress,
        order: order,
        limit: limit,
        page: page,
      );

      return Right(result);
    } on ServerException catch (e) {
      return Left(ServerFailure.fromServerException(e));
    }
  }

  @override
  ResultFuture<Wallet> getWallet(String walletAddress) async {
    try {
      final result = await _remoteDataSrc.getWallet(walletAddress);
      return Right(result);
    } on ServerException catch (e) {
      return Left(ServerFailure.fromServerException(e));
    }
  }
}
