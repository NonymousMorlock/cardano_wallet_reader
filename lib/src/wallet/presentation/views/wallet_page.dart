import 'package:cardano_wallet_reader/core/services/injection_container.dart';
import 'package:cardano_wallet_reader/src/wallet/domain/entities/wallet.dart';
import 'package:cardano_wallet_reader/src/wallet/presentation/wallet_views.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class WalletPage extends StatelessWidget {
  const WalletPage(this.wallet, {super.key});

  final Wallet wallet;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<WalletCubit>(),
      child: WalletView(wallet),
    );
  }
}
