import 'package:cardano_wallet_reader/core/common/widgets/copy_icon.dart';
import 'package:cardano_wallet_reader/core/extensions/double_extensions.dart';
import 'package:cardano_wallet_reader/core/extensions/string_extensions.dart';
import 'package:cardano_wallet_reader/core/utils/core_utils.dart';
import 'package:cardano_wallet_reader/src/wallet/domain/entities/wallet.dart';
import 'package:cardano_wallet_reader/src/wallet/presentation/sections/transactions_section.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';

class WalletView extends StatefulWidget {
  const WalletView(this.wallet, {super.key});

  final Wallet wallet;

  @override
  State<WalletView> createState() => _WalletViewState();
}

class _WalletViewState extends State<WalletView> {
  ValueNotifier<bool> copyingNotifier = ValueNotifier(false);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Wallet Details'),
        backgroundColor: Colors.transparent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GestureDetector(
                  onTap: () async {
                    copyingNotifier.value = true;
                    await CoreUtils.copyToClipboard(
                      context,
                      text: widget.wallet.address,
                    );
                    copyingNotifier.value = false;
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 5,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFF212121),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.account_balance_wallet,
                          color: Color(0xFF767676),
                          size: 16,
                        ),
                        const Gap(10),
                        Text(
                          widget.wallet.address.shortenEllipsis,
                          style: GoogleFonts.roboto(
                            fontWeight: FontWeight.bold,
                            color: const Color(0xFF767676),
                          ),
                        ),
                        const Gap(8),
                        ValueListenableBuilder(
                          valueListenable: copyingNotifier,
                          builder: (_, isCopying, __) {
                            if (isCopying) {
                              return const CircularProgressIndicator.adaptive();
                            }
                            return const Icon(Icons.copy, size: 16);
                          },
                        ),
                      ],
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 15,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFF212121),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: const Color(0xFF767676),
                      width: .5,
                    ),
                  ),
                  child: Row(
                    children: [
                      Text(
                        widget.wallet.active ? 'Active' : 'Inactive',
                        style: GoogleFonts.roboto(),
                      ),
                      const Gap(8),
                      if (widget.wallet.active)
                        const Icon(
                          Icons.circle,
                          size: 8,
                          color: Color(0xFF11d144),
                        )
                      else
                        const Icon(
                          Icons.circle,
                          size: 8,
                          color: Colors.red,
                        )
                            .animate(
                              onComplete: (controller) => controller.loop(),
                            )
                            .fadeIn(
                              duration: const Duration(milliseconds: 900),
                            )
                            .then()
                            .fadeOut(
                              duration: const Duration(milliseconds: 900),
                            ),
                    ],
                  ),
                ),
              ],
            ),
            const Gap(16),
            Expanded(
              child: ListView(
                children: [
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      gradient: const LinearGradient(
                        colors: [Color(0xFF1b1b1b), Color(0xFF313131)],
                      ),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Total Balance',
                          style: GoogleFonts.roboto(fontSize: 12),
                        ),
                        const Gap(5),
                        RichText(
                          text: TextSpan(
                            text: widget.wallet.controlledAmount.walletFormat,
                            style: GoogleFonts.roboto(
                              fontWeight: FontWeight.bold,
                              fontSize: 24,
                            ),
                            children: [
                              TextSpan(
                                text: ' ADA',
                                style: GoogleFonts.roboto(
                                  fontWeight: FontWeight.normal,
                                  fontSize: 16,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const Gap(16),
                        DecoratedBox(
                          decoration: BoxDecoration(
                            // color: const Color(0xFF212121),

                            borderRadius: BorderRadius.circular(8),
                            gradient: const LinearGradient(
                              colors: [Color(0xFF313131), Color(0xFF3F3F3F)],
                            ),
                            // BoxShadow(
                            //color: Colors.black.withOpacity(0.2),
                            //blurRadius: 5,
                            //spreadRadius: 1,
                            //),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.2),
                                blurRadius: 5,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: ListTile(
                            title: Text(
                              'Stake Address',
                              style: GoogleFonts.roboto(
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                              ),
                            ),
                            subtitle: Text(
                              widget.wallet.stakeAddress,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            trailing: CopyIcon(
                              payload: widget.wallet.stakeAddress,
                            ),
                          ),
                        ),
                        const Gap(8),
                      ],
                    ),
                  ),
                  const Gap(16),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      gradient: const LinearGradient(
                        colors: [Color(0xFF1b1b1b), Color(0xFF313131)],
                      ),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Rewards',
                          style: GoogleFonts.roboto(fontSize: 12),
                        ),
                        const Gap(5),
                        RichText(
                          text: TextSpan(
                            text: widget.wallet.rewardsSum.toString(),
                            style: GoogleFonts.roboto(
                              fontWeight: FontWeight.bold,
                              fontSize: 24,
                            ),
                            children: [
                              TextSpan(
                                text: ' ADA',
                                style: GoogleFonts.roboto(
                                  fontWeight: FontWeight.normal,
                                  fontSize: 16,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const Gap(16),
                        Text(
                          'Withdrawals',
                          style: GoogleFonts.roboto(fontSize: 12),
                        ),
                        const Gap(5),
                        RichText(
                          text: TextSpan(
                            text: widget.wallet.withdrawalsSum.toString(),
                            style: GoogleFonts.roboto(
                              fontWeight: FontWeight.bold,
                              fontSize: 24,
                            ),
                            children: [
                              TextSpan(
                                text: ' ADA',
                                style: GoogleFonts.roboto(
                                  fontWeight: FontWeight.normal,
                                  fontSize: 16,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const Gap(16),
                        Text(
                          'Reserves',
                          style: GoogleFonts.roboto(fontSize: 12),
                        ),
                        const Gap(5),
                        RichText(
                          text: TextSpan(
                            text: widget.wallet.reservesSum.toString(),
                            style: GoogleFonts.roboto(
                              fontWeight: FontWeight.bold,
                              fontSize: 24,
                            ),
                            children: [
                              TextSpan(
                                text: ' ADA',
                                style: GoogleFonts.roboto(
                                  fontWeight: FontWeight.normal,
                                  fontSize: 16,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const Gap(16),
                        Text(
                          'Treasury',
                          style: GoogleFonts.roboto(fontSize: 12),
                        ),
                        const Gap(5),
                        RichText(
                          text: TextSpan(
                            text: widget.wallet.treasurySum.toString(),
                            style: GoogleFonts.roboto(
                              fontWeight: FontWeight.bold,
                              fontSize: 24,
                            ),
                            children: [
                              TextSpan(
                                text: ' ADA',
                                style: GoogleFonts.roboto(
                                  fontWeight: FontWeight.normal,
                                  fontSize: 16,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const Gap(16),
                        Text(
                          'Withdrawable Amount',
                          style: GoogleFonts.roboto(fontSize: 12),
                        ),
                        const Gap(5),
                        RichText(
                          text: TextSpan(
                            text: widget.wallet.withdrawableAmount.toString(),
                            style: GoogleFonts.roboto(
                              fontWeight: FontWeight.bold,
                              fontSize: 24,
                            ),
                            children: [
                              TextSpan(
                                text: ' ADA',
                                style: GoogleFonts.roboto(
                                  fontWeight: FontWeight.normal,
                                  fontSize: 16,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const Gap(16),
                      ],
                    ),
                  ),
                  TransactionsSection(
                    walletAddress: widget.wallet.address,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
