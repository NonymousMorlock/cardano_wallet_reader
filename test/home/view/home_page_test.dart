import 'package:bloc_test/bloc_test.dart';
import 'package:cardano_wallet_reader/src/home/presentation/views/home_view.dart';
import 'package:cardano_wallet_reader/src/wallet/presentation/wallet_views.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../helpers/helpers.dart';

class MockWalletCubit extends MockCubit<WalletState> implements WalletCubit {}

void main() {
  group('HomeView', () {
    late WalletCubit walletCubit;

    setUp(() {
      walletCubit = MockWalletCubit();
      when(() => walletCubit.state).thenReturn(const WalletInitial());
    });

    testWidgets('renders HomeView', (tester) async {
      await tester.pumpApp(
        BlocProvider.value(
          value: walletCubit,
          child: const HomeView(),
        ),
      );
      expect(find.byType(HomeView), findsOneWidget);
    });

    testWidgets('renders [TextField]', (tester) async {
      await tester.pumpApp(
        BlocProvider.value(
          value: walletCubit,
          child: const HomeView(),
        ),
      );
      expect(find.byType(TextField), findsOneWidget);
    });
  });
}
