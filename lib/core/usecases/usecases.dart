// ignore_for_file: one_member_abstracts

import 'package:cardano_wallet_reader/core/utils/typedefs.dart';

abstract class UsecaseWithParams<ReturnType, Params> {
  const UsecaseWithParams();

  ResultFuture<ReturnType> call(Params params);
}

abstract class UsecaseWithoutParams<ReturnType> {
  const UsecaseWithoutParams();

  ResultFuture<ReturnType> call();
}
