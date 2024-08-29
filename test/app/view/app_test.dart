import 'package:bloc_test/bloc_test.dart';
import 'package:cardano_wallet_reader/app/app.dart';
import 'package:cardano_wallet_reader/src/home/presentation/views/home_view.dart';
import 'package:cardano_wallet_reader/src/wallet/data/datasources/wallet_remote_data_src.dart';
import 'package:cardano_wallet_reader/src/wallet/domain/repos/wallet_repo.dart';
import 'package:cardano_wallet_reader/src/wallet/domain/usecases/get_transactions.dart';
import 'package:cardano_wallet_reader/src/wallet/domain/usecases/get_wallet.dart';
import 'package:cardano_wallet_reader/src/wallet/presentation/wallet_views.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:mocktail/mocktail.dart';

class MockWalletCubit extends MockCubit<WalletState> implements WalletCubit {}

class MockGetWallet extends Mock implements GetWallet {}

class MockGetTransactions extends Mock implements GetTransactions {}

class MockWalletRepo extends Mock implements WalletRepo {}

class MockWalletRemoteDataSrc extends Mock implements WalletRemoteDataSrc {}

void main() {
  group('App', () {
    setUp(() {
      final cubit = MockWalletCubit();
      GetIt.instance
        ..registerLazySingleton<WalletCubit>(() => cubit)
        ..registerLazySingleton<GetWallet>(MockGetWallet.new)
        ..registerLazySingleton<GetTransactions>(MockGetTransactions.new)
        ..registerLazySingleton<WalletRepo>(MockWalletRepo.new)
        ..registerLazySingleton<WalletRemoteDataSrc>(
          MockWalletRemoteDataSrc.new,
        );

      when(() => cubit.state).thenReturn(const WalletInitial());
    });
    testWidgets('renders HomeView', (tester) async {
      await tester.pumpWidget(const App());
      expect(find.byType(HomeView), findsOneWidget);
    });
  });
}
