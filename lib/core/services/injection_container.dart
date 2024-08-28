import 'package:cardano_wallet_reader/src/wallet/data/datasources/wallet_remote_data_src.dart';
import 'package:cardano_wallet_reader/src/wallet/data/repos/wallet_repo_impl.dart';
import 'package:cardano_wallet_reader/src/wallet/domain/repos/wallet_repo.dart';
import 'package:cardano_wallet_reader/src/wallet/domain/usecases/get_transactions.dart';
import 'package:cardano_wallet_reader/src/wallet/domain/usecases/get_wallet.dart';
import 'package:cardano_wallet_reader/src/wallet/presentation/wallet_views.dart';
import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

part 'injection_container.main.dart';
