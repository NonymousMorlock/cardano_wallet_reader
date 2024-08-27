import 'dart:io';

import 'package:cardano_wallet_reader/app/app.dart';
import 'package:cardano_wallet_reader/bootstrap.dart';
import 'package:device_preview/device_preview.dart';

void main() {
  bootstrap(
    () => DevicePreview(
      enabled: Platform.isWindows || Platform.isLinux || Platform.isMacOS,
      builder: (_) => const App(),
    ),
  );
}
