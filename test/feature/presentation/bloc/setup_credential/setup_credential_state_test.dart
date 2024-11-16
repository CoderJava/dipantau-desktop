import 'package:dipantau_desktop_client/feature/presentation/bloc/setup_credential/setup_credential_bloc.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('FailureSetupCredentialState', () {
    final state = FailureSetupCredentialState(errorMessage: 'errorMessage');

    test(
      'pastikan output dari fungsi toString',
      () async {
        // assert
        expect(
          state.toString(),
          'FailureSetupCredentialState{errorMessage: ${state.errorMessage}}',
        );
      },
    );
  });
}
