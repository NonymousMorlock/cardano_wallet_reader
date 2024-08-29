import 'package:cardano_wallet_reader/core/services/injection_container.dart';
import 'package:cardano_wallet_reader/l10n/l10n.dart';
import 'package:cardano_wallet_reader/src/home/presentation/views/home_view.dart';
import 'package:cardano_wallet_reader/src/wallet/presentation/wallet_views.dart';
import 'package:device_preview/device_preview.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.dark(useMaterial3: true).copyWith(
        scaffoldBackgroundColor: const Color(0xFF131313),
        colorScheme: const ColorScheme.dark(
          primary: Colors.white,
          surface: Color(0xFF262626),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF262626),
          ),
        ),
        cardColor: const Color(0xFF262626),
        dialogBackgroundColor: const Color(0xFF262626),
      ),
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      locale: DevicePreview.locale(context),
      builder: DevicePreview.appBuilder,
      home: BlocProvider(
        create: (_) => sl<WalletCubit>(),
        child: const HomeView(),
      ),
    );
  }
}
