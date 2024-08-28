import 'package:bloc/bloc.dart';
import 'package:cardano_wallet_reader/core/enums/order.dart';
import 'package:cardano_wallet_reader/src/wallet/domain/entities/transaction.dart';
import 'package:cardano_wallet_reader/src/wallet/domain/entities/wallet.dart';
import 'package:cardano_wallet_reader/src/wallet/domain/usecases/get_transactions.dart';
import 'package:cardano_wallet_reader/src/wallet/domain/usecases/get_wallet.dart';
import 'package:equatable/equatable.dart';

part 'wallet_state.dart';

class WalletCubit extends Cubit<WalletState> {
  WalletCubit({
    required GetWallet getWallet,
    required GetTransactions getTransactions,
  })  : _getWallet = getWallet,
        _getTransactions = getTransactions,
        super(const WalletInitial());

  final GetWallet _getWallet;
  final GetTransactions _getTransactions;

  Future<void> getWallet(String walletAddress) async {
    emit(const WalletLoading());
    final result = await _getWallet(walletAddress);

    result.fold(
      (failure) => emit(WalletError(failure.errorMessage)),
      (wallet) => emit(WalletLoaded(wallet)),
    );
  }

  Future<void> getTransactions({
    required String walletAddress,
    SortOrder? order,
    int? limit,
    int? page,
  }) async {
    emit(const WalletLoading());
    final result = await _getTransactions(
      GetTransactionsParams(
        walletAddress: walletAddress,
        order: order,
        limit: limit,
        page: page,
      ),
    );

    result.fold(
      (failure) => emit(WalletError(failure.errorMessage)),
      (transactions) => emit(WalletTransactionsLoaded(transactions)),
    );
  }
}
