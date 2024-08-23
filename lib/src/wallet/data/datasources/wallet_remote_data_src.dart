import 'package:cardano_wallet_reader/core/enums/order.dart';
import 'package:cardano_wallet_reader/src/wallet/data/models/transaction_model.dart';
import 'package:cardano_wallet_reader/src/wallet/data/models/wallet_model.dart';
import 'package:http/http.dart' as http;

abstract interface class WalletRemoteDataSrc {
  Future<List<TransactionModel>> getTransactions({
    required String walletAddress,
    SortOrder? order,
    int? limit,
    int? page,
  });

  Future<WalletModel> getWallet(String walletAddress);
}

class WalletRemoteDataSrcImpl implements WalletRemoteDataSrc {
  const WalletRemoteDataSrcImpl(this._client);

  final http.Client _client;

  @override
  Future<List<TransactionModel>> getTransactions({
    required String walletAddress,
    SortOrder? order,
    int? limit,
    int? page,
  }) async {
    // TODO: implement getTransactions
    throw UnimplementedError();
  }

  @override
  Future<WalletModel> getWallet(String walletAddress) async {
    // TODO: implement getWallet
    throw UnimplementedError();
  }
}
