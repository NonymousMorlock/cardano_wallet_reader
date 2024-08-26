import 'package:cardano_wallet_reader/core/enums/order.dart';
import 'package:cardano_wallet_reader/core/usecases/usecases.dart';
import 'package:cardano_wallet_reader/core/utils/typedefs.dart';
import 'package:cardano_wallet_reader/src/wallet/domain/entities/transaction.dart';
import 'package:cardano_wallet_reader/src/wallet/domain/repos/wallet_repo.dart';
import 'package:equatable/equatable.dart';

class GetTransactions
    extends UsecaseWithParams<List<Transaction>, GetTransactionsParams> {
  const GetTransactions(this._repo);

  final WalletRepo _repo;

  @override
  ResultFuture<List<Transaction>> call(GetTransactionsParams params) =>
      _repo.getTransactions(
        walletAddress: params.walletAddress,
        order: params.order,
        limit: params.limit,
        page: params.page,
      );
}

class GetTransactionsParams extends Equatable {
  const GetTransactionsParams({
    required this.walletAddress,
    this.order,
    this.limit,
    this.page,
  });

  const GetTransactionsParams.empty() : this(walletAddress: 'Test String');

  final String walletAddress;
  final SortOrder? order;
  final int? limit;
  final int? page;

  @override
  List<dynamic> get props => [walletAddress, order, limit, page];
}
