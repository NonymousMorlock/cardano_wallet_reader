import 'package:cardano_wallet_reader/core/enums/order.dart';
import 'package:cardano_wallet_reader/core/utils/typedefs.dart';
import 'package:cardano_wallet_reader/src/wallet/data/datasources/wallet_remote_data_src.dart';
import 'package:cardano_wallet_reader/src/wallet/domain/entities/transaction.dart';
import 'package:cardano_wallet_reader/src/wallet/domain/entities/wallet.dart';
import 'package:cardano_wallet_reader/src/wallet/domain/repos/wallet_repo.dart';

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
    // TODO: implement getTransactions
    throw UnimplementedError();
  }

  @override
  ResultFuture<Wallet> getWallet(String walletAddress) async {
    // TODO: implement getWallet
    throw UnimplementedError();
  }
}
