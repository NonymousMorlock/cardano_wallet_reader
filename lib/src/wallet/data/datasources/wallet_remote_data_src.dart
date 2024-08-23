import 'package:cardano_wallet_reader/core/enums/order.dart';
import 'package:cardano_wallet_reader/src/wallet/data/models/transaction_model.dart';
import 'package:cardano_wallet_reader/src/wallet/data/models/wallet_model.dart';

abstract interface class WalletRemoteDataSrc {
  Future<List<TransactionModel>> getTransactions({
    required String walletAddress,
    SortOrder? order,
    int? limit,
    int? page,
  });

  Future<WalletModel> getWallet(String walletAddress);
}
