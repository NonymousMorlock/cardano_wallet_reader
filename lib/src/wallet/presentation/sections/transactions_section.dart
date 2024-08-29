import 'package:cardano_wallet_reader/core/utils/core_utils.dart';
import 'package:cardano_wallet_reader/src/wallet/data/models/transaction_model.dart';
import 'package:cardano_wallet_reader/src/wallet/presentation/wallet_views.dart';
import 'package:cardano_wallet_reader/src/wallet/presentation/widgets/transaction_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';

class TransactionsSection extends StatefulWidget {
  const TransactionsSection({required this.walletAddress, super.key});

  final String walletAddress;

  @override
  State<TransactionsSection> createState() => _TransactionsSectionState();
}

class _TransactionsSectionState extends State<TransactionsSection> {
  Future<void> getTransactions() {
    return context.read<WalletCubit>().getTransactions(
          walletAddress: widget.walletAddress,
        );
  }

  @override
  void initState() {
    super.initState();
    getTransactions();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<WalletCubit, WalletState>(
      listener: (context, state) {
        if (state case WalletError(:final message)) {
          CoreUtils.showSnackBar(context, message: message);
        }
      },
      builder: (_, state) {
        if (state is WalletLoading) {
          return const Center(child: CircularProgressIndicator.adaptive());
        } else if (state case WalletTransactionsLoaded(:final transactions)) {
          if (transactions.isEmpty) {
            return Center(
              child: Text(
                'No transactions found',
                style: GoogleFonts.roboto(
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                ),
              ),
            );
          }
          final previewTransactions = transactions.take(5).toList()
            ..add(TransactionModel.fixture())
            ..add(TransactionModel.fixture())
            ..sort(
              (a, b) => b.blockTime.compareTo(a.blockTime),
            );
          return Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Gap(30),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Transaction History',
                    style: GoogleFonts.roboto(
                      fontSize: 20,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const Gap(10),
                  const Icon(Icons.history, size: 24),
                ],
              ),
              const Gap(10),
              ListView.builder(
                physics: const NeverScrollableScrollPhysics(),
                itemCount: previewTransactions.length,
                shrinkWrap: true,
                itemBuilder: (_, index) {
                  final transaction = previewTransactions[index];
                  final isFirst = index == 0;
                  final isLast = index == previewTransactions.length - 1;
                  return TransactionTile(
                    key: ValueKey(transaction.hash),
                    transaction,
                    isFirst: isFirst,
                    isLast: isLast,
                  );
                },
              ),
            ],
          );
        } else if (state is WalletError) {
          // show retry button
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'An error occurred',
                  style: GoogleFonts.roboto(
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const Gap(10),
                ElevatedButton(
                  onPressed: getTransactions,
                  child: const Text('Retry'),
                ),
              ],
            ),
          );
        }
        return const SizedBox.shrink();
      },
    );
  }
}
