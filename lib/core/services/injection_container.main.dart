part of 'injection_container.dart';

final sl = GetIt.instance;

Future<void> init() async {
  await _initMemory();
  await _initWallet();
}

Future<void> _initWallet() async {
  sl
    ..registerFactory<WalletCubit>(
      () => WalletCubit(getWallet: sl(), getTransactions: sl()),
    )
    ..registerLazySingleton(() => GetWallet(sl()))
    ..registerLazySingleton(() => GetTransactions(sl()))
    ..registerLazySingleton<WalletRepo>(() => WalletRepoImpl(sl()))
    ..registerLazySingleton<WalletRemoteDataSrc>(
      () => WalletRemoteDataSrcImpl(sl()),
    )
    ..registerLazySingleton<http.Client>(http.Client.new);
}

Future<void> _initMemory() async {
  final prefs = await SharedPreferences.getInstance();
  sl.registerLazySingleton(() => prefs);
}
