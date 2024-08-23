import 'package:cardano_wallet_reader/core/enums/order.dart';
import 'package:cardano_wallet_reader/core/utils/typedefs.dart';
import 'package:cardano_wallet_reader/src/wallet/domain/entities/transaction.dart';
import 'package:cardano_wallet_reader/src/wallet/domain/entities/wallet.dart';

abstract interface class WalletRepo {
  ResultFuture<List<Transaction>> getTransactions({
    required String walletAddress,
    SortOrder? order,
    int? limit,
    int? page,
  });

  ResultFuture<Wallet> getWallet(String walletAddress);
}
