import 'package:cardano_wallet_reader/core/common/widgets/copy_icon.dart';
import 'package:cardano_wallet_reader/core/extensions/date_time_extensions.dart';
import 'package:cardano_wallet_reader/core/extensions/int_extensions.dart';
import 'package:cardano_wallet_reader/src/wallet/domain/entities/transaction.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class NerdStats extends StatelessWidget {
  const NerdStats({required this.transaction, super.key});

  final Transaction transaction;

  @override
  Widget build(BuildContext context) {
    final style = GoogleFonts.roboto(fontSize: 14);

    final invalidHereAfter =
        transaction.invalidHereafter?.slotToDateTime.yyyyMMddHHmmss;

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          ListTile(
            title: Text(
              'Block: ${transaction.block}',
              style: style,
            ),
            trailing: CopyIcon(payload: transaction.block),
          ),
          ListTile(
            title: Text(
              'Deposit: ${transaction.deposit}',
              style: style,
            ),
          ),
          ListTile(
            title: Text(
              'Size: ${transaction.size}',
              style: style,
            ),
          ),
          ListTile(
            title: Text(
              'Invalid Before: '
              '${transaction.invalidBefore?.slotToDateTime}',
              style: style,
            ),
          ),
          ListTile(
            title: Text(
              'Invalid Hereafter: '
              '$invalidHereAfter',
              style: style,
            ),
          ),
          ListTile(
            title: Text(
              'Withdrawal Count: ${transaction.withdrawalCount}',
              style: style,
            ),
          ),
          ListTile(
            title: Text(
              'Mir Cert Count: ${transaction.mirCertCount}',
              style: style,
            ),
          ),
          ListTile(
            title: Text(
              'Delegation Count: ${transaction.delegationCount}',
              style: style,
            ),
          ),
          ListTile(
            title: Text(
              'Stake Cert Count: ${transaction.stakeCertCount}',
              style: style,
            ),
          ),
          ListTile(
            title: Text(
              'Pool Update Count: ${transaction.poolUpdateCount}',
              style: style,
            ),
          ),
          ListTile(
            title: Text(
              'Pool Retire Count: ${transaction.poolRetireCount}',
              style: style,
            ),
          ),
          ListTile(
            title: Text(
              'Asset Mint Or Burn Count: '
              '${transaction.assetMintOrBurnCount}',
              style: style,
            ),
          ),
          ListTile(
            title: Text(
              'Redeemer Count: ${transaction.redeemerCount}',
              style: style,
            ),
          ),
        ],
      ),
    );
  }
}
