import 'package:dipantau_desktop_client/feature/presentation/bloc/setup_credential/setup_credential_bloc.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('PingSetupCredentialEvent', () {
    final event = PingSetupCredentialEvent(baseUrl: 'https://example.com');

    test(
      'pastikan output dari fungsi toString',
      () async {
        // assert
        expect(
          event.toString(),
          'PingSetupCredentialEvent{baseUrl: ${event.baseUrl}}',
        );
      },
    );
  });
}
