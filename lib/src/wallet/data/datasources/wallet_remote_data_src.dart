import 'dart:convert';

import 'package:cardano_wallet_reader/core/enums/order.dart';
import 'package:cardano_wallet_reader/core/errors/exception.dart';
import 'package:cardano_wallet_reader/core/services/cache_helper.dart';
import 'package:cardano_wallet_reader/core/utils/constants/network_constants.dart';
import 'package:cardano_wallet_reader/core/utils/typedefs.dart';
import 'package:cardano_wallet_reader/src/wallet/data/models/output_amount_model.dart';
import 'package:cardano_wallet_reader/src/wallet/data/models/transaction_model.dart';
import 'package:cardano_wallet_reader/src/wallet/data/models/utxo_model.dart';
import 'package:cardano_wallet_reader/src/wallet/data/models/wallet_model.dart';
import 'package:cardano_wallet_reader/src/wallet/domain/entities/output_amount.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

abstract interface class WalletRemoteDataSrc {
  Future<List<TransactionModel>> getTransactions({
    required String walletAddress,
    SortOrder? order,
    int? limit,
    int? page,
  });

  Future<WalletModel> getWallet(String walletAddress);
}

class WalletRemoteDataSrcImpl implements WalletRemoteDataSrc {
  const WalletRemoteDataSrcImpl(this._client);

  final http.Client _client;

  @override
  Future<List<TransactionModel>> getTransactions({
    required String walletAddress,
    SortOrder? order,
    int? limit,
    int? page,
  }) async {
    try {
      await _fetchGenesis();

      final uri = Uri.https(
        NetworkConstants.authority,
        '${NetworkConstants.apiEndpoint}/addresses/$walletAddress/transactions',
        order == null && limit == null && page == null
            ? null
            : {
                if (order != null) 'order': order.value,
                if (limit != null) 'count': limit.toString(),
                if (page != null) 'page': page.toString(),
              },
      );

      final transactionsResponse = await _client.get(
        uri,
        headers: {
          'Content-Type': 'application/json',
          'project_id': NetworkConstants.apiKey,
        },
      );

      if (transactionsResponse.statusCode != 200) {
        final errorMap = jsonDecode(transactionsResponse.body) as DataMap;
        final errorCodeText = errorMap['error'] as String;
        throw ServerException(
          message: errorMap['message'] as String,
          statusCode: '${transactionsResponse.statusCode} $errorCodeText',
        );
      }

      final rawTransactions = List<DataMap>.from(
        jsonDecode(transactionsResponse.body) as List,
      );

      final transactionFutures = rawTransactions.map((transaction) async {
        final transactionResponse = await _client.get(
          Uri.https(
            NetworkConstants.authority,
            '${NetworkConstants.apiEndpoint}/txs/${transaction['tx_hash']}',
          ),
          headers: {
            'Content-Type': 'application/json',
            'project_id': NetworkConstants.apiKey,
          },
        );

        if (transactionResponse.statusCode != 200) {
          final errorMap = jsonDecode(transactionResponse.body) as DataMap;
          final errorCodeText = errorMap['error'] as String;
          throw ServerException(
            message: errorMap['message'] as String,
            statusCode: '${transactionResponse.statusCode} $errorCodeText',
          );
        }

        final transactionMap = jsonDecode(transactionResponse.body) as DataMap;
        return TransactionModel.fromMap(transactionMap).copyWith(
          walletAddress: walletAddress,
        );
      }).toList();

      final transactions = await Future.wait(transactionFutures);

      final processedTransactionFutures = transactions.map((transaction) async {
        final processedOutputs = await Future.wait(
          transaction.outputAmount.map(_processOutputAmount),
        );

        return transaction.copyWith(outputAmount: processedOutputs);
      }).toList();

      final transactionsWithOutputAmounts =
          await Future.wait(processedTransactionFutures);

      final transactionsWithUtxosFutures =
          transactionsWithOutputAmounts.map((transaction) async {
        final inputsResponse = await _client.get(
          Uri.https(
            NetworkConstants.authority,
            '${NetworkConstants.apiEndpoint}/txs/${transaction.hash}/utxos',
          ),
          headers: {
            'Content-Type': 'application/json',
            'project_id': NetworkConstants.apiKey,
          },
        );

        if (inputsResponse.statusCode != 200) {
          final errorMap = jsonDecode(inputsResponse.body) as DataMap;
          final errorCodeText = errorMap['error'] as String;
          throw ServerException(
            message: errorMap['message'] as String,
            statusCode: '${inputsResponse.statusCode} $errorCodeText',
          );
        }

        final inputsMap = jsonDecode(inputsResponse.body) as DataMap;
        final inputs = List<DataMap>.from(inputsMap['inputs'] as List)
            .map(UtxoModel.fromMap)
            .toList();
        final outputs = List<DataMap>.from(inputsMap['outputs'] as List)
            .map(UtxoModel.fromMap)
            .toList();

        final processedInputs = await Future.wait(
          inputs.map((input) async {
            final processedOutputAmounts = await Future.wait(
              input.amount.map(_processOutputAmount).toList(),
            );

            return input.copyWith(amount: processedOutputAmounts);
          }).toList(),
        );

        final processedOutputs = await Future.wait(
          outputs.map((output) async {
            final processedOutputAmounts = await Future.wait(
              output.amount.map(_processOutputAmount).toList(),
            );

            return output.copyWith(amount: processedOutputAmounts);
          }).toList(),
        );

        return transaction.copyWith(
          inputs: processedInputs,
          outputs: processedOutputs,
        );
      }).toList();

      return Future.wait(transactionsWithUtxosFutures);
    } on ServerException catch (e, s) {
      debugPrint('Error Occurred: $e');
      debugPrintStack(stackTrace: s);
      rethrow;
    } catch (e, s) {
      debugPrint('Error Occurred: $e');
      debugPrintStack(stackTrace: s);
      throw const ServerException(
        message: 'An error occurred while fetching transactions',
        statusCode: '500 Internal Server Error',
      );
    }
  }

  @override
  Future<WalletModel> getWallet(String walletAddress) async {
    try {
      await _fetchGenesis();
      final addressUri = Uri.https(
        NetworkConstants.authority,
        '${NetworkConstants.apiEndpoint}/addresses/$walletAddress',
      );

      final addressResponse = await _client.get(
        addressUri,
        headers: {
          'Content-Type': 'application/json',
          'project_id': NetworkConstants.apiKey,
        },
      );

      final addressMap = jsonDecode(addressResponse.body) as DataMap;

      if (addressResponse.statusCode != 200) {
        final errorCodeText = addressMap['error'] as String;
        throw ServerException(
          message: addressMap['message'] as String,
          statusCode: '${addressResponse.statusCode} $errorCodeText',
        );
      }

      if (addressMap['stake_address'] == null) {
        throw const ServerException(
          message: 'Invalid wallet address',
          statusCode: '422 Unprocessable Entity',
        );
      }

      final stakeAddress = addressMap['stake_address'] as String;

      final accountUri = Uri.https(
        NetworkConstants.authority,
        '${NetworkConstants.apiEndpoint}/accounts/$stakeAddress',
      );

      final accountResponse = await _client.get(
        accountUri,
        headers: {
          'Content-Type': 'application/json',
          'project_id': NetworkConstants.apiKey,
        },
      );

      final accountMap = jsonDecode(accountResponse.body) as DataMap;

      if (accountResponse.statusCode != 200) {
        final errorCodeText = accountMap['error'] as String;
        throw ServerException(
          message: accountMap['message'] as String,
          statusCode: '${accountResponse.statusCode} $errorCodeText',
        );
      }
      return WalletModel.fromMap(accountMap).copyWith(address: walletAddress);
    } on ServerException catch (e, s) {
      debugPrint('Error Occurred: $e');
      debugPrintStack(stackTrace: s);
      rethrow;
    } catch (e, s) {
      debugPrint('Error Occurred: $e');
      debugPrintStack(stackTrace: s);
      throw const ServerException(
        message: 'An error occurred while fetching wallet',
        statusCode: '500 Internal Server Error',
      );
    }
  }

  Future<void> _fetchGenesis() async {
    final cacheHelper = CacheHelper.instance;
    if (!cacheHelper.isGenesisTimeCached || !cacheHelper.isSlotDurationCached) {
      final genesisUri = Uri.https(
        NetworkConstants.authority,
        '${NetworkConstants.apiEndpoint}/genesis',
      );

      final genesisResponse = await _client.get(
        genesisUri,
        headers: {
          'Content-Type': 'application/json',
          'project_id': NetworkConstants.apiKey,
        },
      );

      final genesisMap = jsonDecode(genesisResponse.body) as DataMap;

      if (genesisResponse.statusCode != 200) {
        final errorCodeText = genesisMap['error'] as String;
        throw ServerException(
          message: genesisMap['message'] as String,
          statusCode: '${genesisResponse.statusCode} $errorCodeText',
        );
      }

      final cacheFuture = Future.wait([
        cacheHelper.cacheGenesisTime(
          genesisMap['system_start'] as int,
        ),
        cacheHelper.cacheSlotDuration(
          genesisMap['slot_length'] as int,
        ),
      ]);

      await cacheFuture;
    }
  }

  Future<OutputAmountModel> _processOutputAmount(
    OutputAmount outputAmount,
  ) async {
    outputAmount as OutputAmountModel;
    if (outputAmount.unit != 'lovelace') {
      final assetResponse = await _client.get(
        Uri.https(
          NetworkConstants.authority,
          '${NetworkConstants.apiEndpoint}/assets/${outputAmount.unit}',
        ),
        headers: {
          'Content-Type': 'application/json',
          'project_id': NetworkConstants.apiKey,
        },
      );

      if (assetResponse.statusCode != 200) {
        return outputAmount;
      }

      final assetMap = jsonDecode(assetResponse.body) as DataMap;
      return outputAmount.copyWith(
        unitName: (assetMap['metadata'] as DataMap)['name'] as String,
      );
    } else {
      return outputAmount;
    }
  }
}
