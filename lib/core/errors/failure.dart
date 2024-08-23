import 'package:cardano_wallet_reader/core/errors/exception.dart';
import 'package:equatable/equatable.dart';

sealed class Failure extends Equatable {
  const Failure({required this.message, required this.statusCode});

  final String message;
  final String statusCode;

  String get errorMessage => '$statusCode Error: $message';

  @override
  List<Object> get props => [message, statusCode];
}

class ServerFailure extends Failure {
  const ServerFailure({required super.message, required super.statusCode});

  ServerFailure.fromServerException(ServerException e)
      : this(message: e.message, statusCode: e.statusCode);
}
