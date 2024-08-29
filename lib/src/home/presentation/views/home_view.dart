import 'package:cardano_wallet_reader/core/utils/core_utils.dart';
import 'package:cardano_wallet_reader/src/wallet/presentation/wallet_views.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  final TextEditingController _controller = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<WalletCubit, WalletState>(
      listener: (context, state) {
        if (state case WalletError(:final message)) {
          CoreUtils.showSnackBar(context, message: message);
        } else if (state case WalletLoaded(:final wallet)) {
          Navigator.of(context).push(
            MaterialPageRoute<void>(
              builder: (_) {
                return WalletPage(wallet);
              },
            ),
          );
        }
      },
      builder: (context, state) {
        return Scaffold(
          // field to collect wallet address, and a button to 'Get Wallet'
          body: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(16).copyWith(top: 32),
              child: Center(
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      TextFormField(
                        controller: _controller,
                        maxLines: 5,
                        minLines: 1,
                        decoration: InputDecoration(
                          labelText: 'Wallet Address',
                          labelStyle: const TextStyle(
                            color: Colors.grey,
                          ),
                          filled: true,
                          border: const OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                            borderSide: BorderSide(
                              color: Color(0xFF313131),
                              width: 2,
                            ),
                          ),
                          enabledBorder: const OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                            borderSide: BorderSide(
                              color: Color(0xFF313131),
                              width: 2,
                            ),
                          ),
                          suffixIcon: ListenableBuilder(
                            listenable: _controller,
                            child: IconButton(
                              onPressed: _controller.clear,
                              icon: const Icon(Icons.clear),
                            ),
                            builder: (_, child) {
                              if (_controller.text.isEmpty) {
                                return const SizedBox.shrink();
                              } else {
                                return child!;
                              }
                            },
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter a wallet address';
                          }
                          return null;
                        },
                      ),
                      const Gap(16),
                      AnimatedSwitcher(
                        duration: const Duration(milliseconds: 300),
                        child: switch (state) {
                          WalletLoading() =>
                            const CircularProgressIndicator.adaptive(),
                          _ => ElevatedButton(
                              onPressed: () {
                                if (_formKey.currentState!.validate()) {
                                  context.read<WalletCubit>().getWallet(
                                        _controller.text.trim(),
                                      );
                                }
                              },
                              child: const Text('Get Wallet'),
                            ),
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
