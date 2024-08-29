import 'package:cardano_wallet_reader/core/utils/core_utils.dart';
import 'package:flutter/material.dart';

class CopyIcon extends StatefulWidget {
  const CopyIcon({required this.payload, this.iconSize, super.key});

  final String payload;

  final double? iconSize;

  @override
  State<CopyIcon> createState() => _CopyIconState();
}

class _CopyIconState extends State<CopyIcon> {
  bool isCopying = false;

  @override
  Widget build(BuildContext context) {
    if (isCopying) {
      return const CircularProgressIndicator.adaptive();
    }
    return IconButton(
      icon: const Icon(Icons.copy),
      iconSize: widget.iconSize,
      onPressed: () async {
        setState(() {
          isCopying = true;
        });
        await CoreUtils.copyToClipboard(context, text: widget.payload);
        setState(() {
          isCopying = false;
        });
      },
    );
  }
}
