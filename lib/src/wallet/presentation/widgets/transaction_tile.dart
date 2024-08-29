import 'package:cardano_wallet_reader/core/extensions/date_time_extensions.dart';
import 'package:cardano_wallet_reader/core/extensions/double_extensions.dart';
import 'package:cardano_wallet_reader/core/extensions/string_extensions.dart';
import 'package:cardano_wallet_reader/core/utils/core_utils.dart';
import 'package:cardano_wallet_reader/src/wallet/domain/entities/output_amount.dart';
import 'package:cardano_wallet_reader/src/wallet/domain/entities/transaction.dart';
import 'package:cardano_wallet_reader/src/wallet/presentation/views/nerd_stats.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class TransactionTile extends StatefulWidget {
  const TransactionTile(
    this.transaction, {
    required this.isFirst,
    required this.isLast,
    super.key,
  });

  final Transaction transaction;
  final bool isFirst;
  final bool isLast;

  @override
  State<TransactionTile> createState() => _TransactionTileState();
}

class _TransactionTileState extends State<TransactionTile> {
  late bool transactionIsPositive;
  late String quantity;
  final otherTokens = <OutputAmount>[];

  @override
  void initState() {
    super.initState();
    transactionIsPositive = widget.transaction.isPositive;
    // the quantity will be from transaction.outputAmount and we find all
    // where outputAmount.unit is lovelace and sum their quantities then
    // assign the rest to a separate list
    var quantity = 0.0;
    for (final outputAmount in widget.transaction.outputAmount) {
      if (outputAmount.unit == 'lovelace') {
        quantity += outputAmount.quantity;
      } else {
        otherTokens.add(outputAmount);
      }
    }
    this.quantity = quantity.walletFormat;
  }

  @override
  Widget build(BuildContext context) {
    final outputAmount = widget.transaction.outputAmount.first;
    return ClipRRect(
      borderRadius: widget.isFirst
          ? const BorderRadius.vertical(top: Radius.circular(10))
          : widget.isLast
              ? const BorderRadius.vertical(bottom: Radius.circular(10))
              : BorderRadius.zero,
      child: ColoredBox(
        color: const Color(0xFF212121),
        child: ExpansionTile(
          showTrailingIcon: false,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    outputAmount.unitName ?? outputAmount.unit.shortenEllipsis,
                    maxLines: 1,
                    style: GoogleFonts.roboto(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Text(
                    widget.transaction.blockTime.yyyyMMddHHmmss,
                    style: GoogleFonts.roboto(
                      fontSize: 12,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
              Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    '${transactionIsPositive ? '+' : '-'} $quantity',
                    style: GoogleFonts.roboto(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: transactionIsPositive
                          ? Theme.of(context).colorScheme.secondary
                          : Colors.red,
                    ),
                  ),
                  Text(
                    widget.transaction.validContract ? 'Completed' : 'Pending',
                    style: GoogleFonts.roboto(
                      fontSize: 12,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            ],
          ),
          children: [
            ListTile(
              title: Text(
                'Block Height: ${widget.transaction.blockHeight}',
                style: GoogleFonts.roboto(
                  fontSize: 14,
                ),
              ),
            ),
            ListTile(
              title: Text(
                'Slot: ${widget.transaction.slot}',
                style: GoogleFonts.roboto(
                  fontSize: 14,
                ),
              ),
            ),
            ListTile(
              title: Text(
                'Fees: ${widget.transaction.fees}',
                style: GoogleFonts.roboto(
                  fontSize: 14,
                ),
              ),
            ),
            if (otherTokens.isNotEmpty) ...[
              const Divider(indent: 10, endIndent: 10),
              Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: const EdgeInsets.only(left: 16),
                  child: Text(
                    'Sub-Transactions',
                    textAlign: TextAlign.start,
                    style: GoogleFonts.roboto(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
              ...otherTokens.map(
                (outputAmount) {
                  final unitName = outputAmount.unitName;
                  final hasUnitName = unitName != null && unitName.isNotEmpty;

                  final quantity = outputAmount.quantity.walletFormat;
                  return ListTile(
                    title: Text(
                      hasUnitName ? unitName : 'Unit Hash',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.roboto(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    subtitle: !hasUnitName
                        ? Text(
                            outputAmount.unit,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: GoogleFonts.roboto(
                              fontSize: 12,
                              color: Colors.grey,
                            ),
                          )
                        : null,
                    trailing: Text(
                      '${transactionIsPositive ? '+' : '-'} $quantity',
                      style: GoogleFonts.roboto(
                        fontSize: 14,
                        color: transactionIsPositive
                            ? Theme.of(context).colorScheme.secondary
                            : Colors.red,
                      ),
                    ),
                    onLongPress: hasUnitName
                        ? null
                        : () {
                            CoreUtils.copyToClipboard(
                              context,
                              text: outputAmount.unit,
                            );
                          },
                  );
                },
              ),
              const Divider(indent: 10, endIndent: 10),
            ],
            Align(
              alignment: Alignment.centerLeft,
              child: TextButton.icon(
                onPressed: () {
                  showModalBottomSheet<void>(
                    context: context,
                    showDragHandle: true,
                    builder: (context) {
                      return NerdStats(transaction: widget.transaction);
                    },
                  );
                },
                icon: const Icon(Icons.info),
                label: Text(
                  'Stats for nerds',
                  style: GoogleFonts.roboto(
                    fontSize: 14,
                    color: Theme.of(context).colorScheme.secondary,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
