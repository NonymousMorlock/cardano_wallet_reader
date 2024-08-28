part of 'wallet_cubit.dart';

sealed class WalletState extends Equatable {
  const WalletState();

  @override
  List<Object> get props => [];
}

final class WalletInitial extends WalletState {
  const WalletInitial();
}

final class WalletLoading extends WalletState {
  const WalletLoading();
}

final class WalletLoaded extends WalletState {
  const WalletLoaded(this.wallet);

  final Wallet wallet;

  @override
  List<Object> get props => [wallet];
}

final class WalletTransactionsLoaded extends WalletState {
  const WalletTransactionsLoaded(this.transactions);

  final List<Transaction> transactions;

  @override
  List<Object> get props => transactions;
}

final class WalletError extends WalletState {
  const WalletError(this.message);

  final String message;

  @override
  List<Object> get props => [message];
}
