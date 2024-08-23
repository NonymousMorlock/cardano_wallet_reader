import 'package:cardano_wallet_reader/counter/counter.dart';
import 'package:cardano_wallet_reader/l10n/l10n.dart';
import 'package:device_preview/device_preview.dart';
import 'package:flutter/material.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        appBarTheme: AppBarTheme(
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        ),
        useMaterial3: true,
      ),
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      locale: DevicePreview.locale(context),
      builder: DevicePreview.appBuilder,
      home: const CounterPage(),
    );
  }
}