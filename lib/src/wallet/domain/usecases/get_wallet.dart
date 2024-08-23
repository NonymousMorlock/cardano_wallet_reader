import 'package:cardano_wallet_reader/core/usecases/usecases.dart';
import 'package:cardano_wallet_reader/core/utils/typedefs.dart';
import 'package:cardano_wallet_reader/src/wallet/domain/entities/wallet.dart';
import 'package:cardano_wallet_reader/src/wallet/domain/repos/wallet_repo.dart';

class GetWallet extends UsecaseWithParams<Wallet, String> {
  const GetWallet(this._repo);

  final WalletRepo _repo;

  @override
  ResultFuture<Wallet> call(String params) => _repo.getWallet(params);
}
