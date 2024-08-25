import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

abstract class CoreUtils {
  static void showSnackBar(
    BuildContext context, {
    required String message,
    Color? colour,
    Color? textColour,
  }) {
    ScaffoldMessenger.of(context)
      ..removeCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(
            message,
            style: GoogleFonts.roboto(
              color: textColour ?? Colors.white,
              fontSize: 16,
            ),
          ),
          backgroundColor: colour ?? Colors.red,
          behavior: SnackBarBehavior.floating,
        ),
      );
  }

  static Future<void> copyToClipboard(
    BuildContext context, {
    required String text,
  }) async {
    await Clipboard.setData(ClipboardData(text: text));
    if (context.mounted) {
      showSnackBar(
        context,
        message: 'Copied to clipboard',
        colour: Colors.green,
      );
    }
  }
}
