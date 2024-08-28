import 'dart:convert';

import 'package:cardano_wallet_reader/core/errors/exception.dart';
import 'package:cardano_wallet_reader/core/services/cache_helper.dart';
import 'package:cardano_wallet_reader/core/utils/constants/network_constants.dart';
import 'package:cardano_wallet_reader/core/utils/typedefs.dart';
import 'package:cardano_wallet_reader/src/wallet/data/datasources/wallet_remote_data_src.dart';
import 'package:cardano_wallet_reader/src/wallet/data/models/transaction_model.dart';
import 'package:cardano_wallet_reader/src/wallet/data/models/wallet_model.dart';
import 'package:cardano_wallet_reader/src/wallet/domain/entities/output_amount.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:mocktail/mocktail.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../fixtures/fixture_reader.dart';

class MockHttpClient extends Mock implements http.Client {}

class MockSharedPreferences extends Mock implements SharedPreferences {}

void main() {
  late http.Client client;
  late WalletRemoteDataSrcImpl remoteDataSrcImpl;
  late SharedPreferences prefs;

  setUp(() {
    client = MockHttpClient();
    prefs = MockSharedPreferences();

    remoteDataSrcImpl = WalletRemoteDataSrcImpl(client);

    when(() => prefs.getInt(any())).thenReturn(null);
    when(() => prefs.setInt(any(), any())).thenAnswer((_) async => true);

    CacheHelper.instance.init(prefs);

    registerFallbackValue(Uri());
    registerFallbackValue(<String, String>{});
  });

  group('getTransactions', () {
    group('success', () {
      final transactionFixture = fixture('transaction.json');
      setUp(() {
        final transactionsJson = [
          {
            'tx_hash': 'c34c232d6574d35a92f3bdcc6159b6d0b04f98de9f31'
                '1db629f8973ac66dec10',
            'tx_index': 9,
            'block_height': 8223596,
            'block_time': 1672766667,
          },
        ];

        final tTransactionsResponse = http.Response(
          jsonEncode(transactionsJson),
          200,
        );

        final tTransactionResponse = http.Response(
          transactionFixture,
          200,
        );
        when(
          () => client.get(any(), headers: any(named: 'headers')),
        ).thenAnswer((invocation) async {
          final url = invocation.positionalArguments[0] as Uri;
          final pathSegments = url.pathSegments;
          if (pathSegments.contains('transactions') &&
              pathSegments.contains('addresses')) {
            return tTransactionsResponse;
          } else if (pathSegments.contains('assets')) {
            return http.Response(fixture('asset.json'), 200);
          } else if (pathSegments.contains('genesis')) {
            return http.Response(fixture('genesis.json'), 200);
          } else if (pathSegments.contains('utxos')) {
            return http.Response(fixture('utxos.json'), 200);
          } else {
            return tTransactionResponse;
          }
        });
      });
      test(
        'should return a [List<Transaction>>] when status code is 200',
        () async {
          // flow requires we make 1st get request to
          // https://cardano-mainnet.blockfrost.io/api/v0/addresses
          // /addr1qy6qvd3szupa7ayqf6zw7cd0ple7w3yg5f3xh5gkkc4q9zmc9ty742qnc
          // mffaesxqarvqjmxmy36d9aht2duhmhvekgq52e2en/transactions?count=1
          // &order=desc
          // it gives us the tx_hash, we extract only the tx_hash and make a
          // 2nd get request to
          // https://cardano-mainnet.blockfrost.io/api/v0/txs/tx_hash
          // we get the transaction details, so we are basically looping
          // through the first request and run the 2nd request for each tx_hash
          // so we want to stub both requests dynamically because the url might
          // not always contain the same query parameters, we can use the
          // `invocation` to detect when the request url is made directly to
          // /transactions vs when it's made to /txs/tx_hash

          final result = await remoteDataSrcImpl.getTransactions(
            walletAddress: 'walletAddress',
          );

          final transactionFixture =
              jsonDecode(fixture('transaction.json')) as DataMap;

          expect(result, isA<List<TransactionModel>>());
          expect(result.length, 1);
          expect(result.first.hash, transactionFixture['hash']);

          verify(
            () => client.get(
              Uri.parse(
                '${NetworkConstants.baseUrl}/addresses/'
                'walletAddress/transactions',
              ),
              headers: any(named: 'headers'),
            ),
          ).called(1);

          verify(
            () => client.get(
              Uri.parse(
                '${NetworkConstants.baseUrl}/txs/'
                'c34c232d6574d35a92f3bdcc6159b6d0b04f98de9f31'
                '1db629f8973ac66dec10',
              ),
              headers: any(named: 'headers'),
            ),
          ).called(1);

          verify(
            () => client.get(
              Uri.parse('${NetworkConstants.baseUrl}/genesis'),
              headers: any(named: 'headers'),
            ),
          ).called(1);
        },
      );
      test(
        "should attempt fetching the unit name when any [OutputAmount]'s "
        'unit is not "lovelace"',
        () async {
          final result = await remoteDataSrcImpl.getTransactions(
            walletAddress: 'walletAddress',
          );

          expect(
            result.expand((transaction) => transaction.outputAmount).every(
              (outputAmount) {
                if (outputAmount.unit != 'lovelace') {
                  return outputAmount.unitName!.toLowerCase() == 'nutcoin';
                }
                return true;
              },
            ),
            true,
          );
          final faultingOutputAmount = result
              .expand((transaction) => transaction.outputAmount)
              .firstWhere(
                (outputAmount) => outputAmount.unit != 'lovelace',
                // I'm 100% sure that there is a unit that is not 'lovelace'
                orElse: () => const OutputAmount(
                  unit: 'lovelace',
                  quantity: 0,
                ),
              );
          verify(
            () => client.get(
              Uri.parse(
                '${NetworkConstants.baseUrl}/assets'
                '/${faultingOutputAmount.unit}',
              ),
              headers: any(named: 'headers'),
            ),
            // I know it's three because of the fixtures.
          ).called(3);
        },
      );

      test(
        'should attempt fetching utxos for each transaction',
        () async {
          final result = await remoteDataSrcImpl.getTransactions(
            walletAddress: 'walletAddress',
          );

          expect(
            result.expand((transaction) => transaction.inputs).isNotEmpty,
            true,
          );

          verify(
            () => client.get(
              Uri.parse(
                '${NetworkConstants.baseUrl}/txs/${result.first.hash}/utxos',
              ),
              headers: any(named: 'headers'),
            ),
          ).called(1);
        },
      );
    });
    group('failure', () {
      test(
        'should throw [ServerException] when the status code is not 200',
        () async {
          final tTransactionsResponse = http.Response(
            jsonEncode({
              'status_code': 400,
              'error': 'Bad Request',
              'message': 'Backend did not understand your request.',
            }),
            400,
          );

          when(
            () => client.get(any(), headers: any(named: 'headers')),
          ).thenAnswer((_) async => tTransactionsResponse);

          expect(
            () => remoteDataSrcImpl.getTransactions(
              walletAddress: 'walletAddress',
            ),
            throwsA(isA<ServerException>()),
          );
        },
      );

      test(
        'should return [List<Transaction>] when the status code is 200 for'
        ' all requests except the request to "/assets"',
        () async {
          // so when transactions have been processed, but we are trying to
          // process the outputAmounts, we make a request to /assets, if the
          // status code is not 200, we should just continue with others and
          // return the transactions we have with the failed outputAmounts
          // left unchanged

          final transactionsJson = [
            {
              'tx_hash': 'c34c232d657'
                  '4d35a92f3bdcc6159b6d0b04f98de9f311db629f8973ac66dec10',
              'tx_index': 9,
              'block_height': 8223596,
              'block_time': 1672766667,
            },
          ];

          final tTransactionsResponse = http.Response(
            jsonEncode(transactionsJson),
            200,
          );

          final tTransactionResponse = http.Response(
            fixture('transaction.json'),
            200,
          );

          final tAssetResponse = http.Response(
            jsonEncode({
              'status_code': 400,
              'error': 'Bad Request',
              'message': 'Backend did not understand your request.',
            }),
            400,
          );

          when(
            () => client.get(any(), headers: any(named: 'headers')),
          ).thenAnswer((invocation) async {
            final url = invocation.positionalArguments[0] as Uri;
            final pathSegments = url.pathSegments;
            if (pathSegments.contains('transactions') &&
                pathSegments.contains('addresses')) {
              return tTransactionsResponse;
            } else if (pathSegments.contains('assets')) {
              return tAssetResponse;
            } else if (pathSegments.contains('genesis')) {
              return http.Response(fixture('genesis.json'), 200);
            } else if (pathSegments.contains('utxos')) {
              return http.Response(fixture('utxos.json'), 200);
            } else {
              return tTransactionResponse;
            }
          });

          final result = await remoteDataSrcImpl.getTransactions(
            walletAddress: 'walletAddress',
          );

          expect(result, isA<List<TransactionModel>>());
          expect(result.length, 1);
          // expect that it contains a transaction.outputAmount where one
          // outputAmount has a unitName of null
          expect(
            result.expand((transaction) => transaction.outputAmount).any(
                  (outputAmount) =>
                      outputAmount.unitName == null ||
                      outputAmount.unitName!.isEmpty,
                ),
            true,
          );
          verify(
            () => client.get(any(), headers: any(named: 'headers')),
          ).called(7);
          verifyNoMoreInteractions(client);
        },
      );
    });
  });

  group('getWallet', () {
    const tWalletAddress = 'walletAddress';

    test(
      'should return a "complete" [Wallet] when status code is 200',
      () async {
        final addressFixture = {
          'address': tWalletAddress,
          'amount': [
            {'unit': 'lovelace', 'quantity': '42000000'},
            {
              'unit': 'b0d07d45fe9514f80213f4020e5a612'
                  '41458be626841cde717cb38a76e7574636f696e',
              'quantity': '12',
            }
          ],
          'stake_address':
              'stake1ux3g2c9dx2nhhehyrezyxpkstartcqmu9hk63qgfkccw5rqttygt7',
          'type': 'shelley',
          'script': false,
        };
        final addressDetailsJson = jsonEncode(addressFixture);

        when(
          () => client.get(any(), headers: any(named: 'headers')),
        ).thenAnswer((invocation) async {
          final uri = invocation.positionalArguments.first as Uri;
          final pathSegments = uri.pathSegments;
          if (pathSegments.contains('addresses')) {
            return http.Response(addressDetailsJson, 200);
          } else if (pathSegments.contains('genesis')) {
            return http.Response(fixture('genesis.json'), 200);
          }
          return http.Response(fixture('wallet.json'), 200);
        });

        final result = await remoteDataSrcImpl.getWallet(tWalletAddress);
        expect(
          result,
          equals(WalletModel.fixture().copyWith(address: tWalletAddress)),
        );

        verify(
          () => client.get(
            Uri.parse('${NetworkConstants.baseUrl}/addresses/$tWalletAddress'),
            headers: any(named: 'headers'),
          ),
        ).called(1);
        final stakeAddress = addressFixture['stake_address'];
        verify(
          () => client.get(
            Uri.parse('${NetworkConstants.baseUrl}/accounts/$stakeAddress'),
            headers: any(named: 'headers'),
          ),
        ).called(1);

        verify(
          () => client.get(
            Uri.parse('${NetworkConstants.baseUrl}/genesis'),
            headers: any(named: 'headers'),
          ),
        ).called(1);

        verifyNoMoreInteractions(client);
      },
    );

    test(
      'should throw a [ServerException] when status code is not 200',
      () {
        when(
          () => client.get(any(), headers: any(named: 'headers')),
        ).thenAnswer(
          (_) async => http.Response(
            jsonEncode({
              'status_code': 400,
              'error': 'Bad Request',
              'message': 'Backend did not understand your request.',
            }),
            400,
          ),
        );

        expect(
          () => remoteDataSrcImpl.getWallet(tWalletAddress),
          throwsA(isA<ServerException>()),
        );

        verify(() => client.get(any(), headers: any(named: 'headers')))
            .called(1);
        verifyNoMoreInteractions(client);
      },
    );
  });
}
