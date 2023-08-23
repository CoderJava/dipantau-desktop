import 'package:dipantau_desktop_client/feature/presentation/bloc/forgot_password/forgot_password_bloc.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('FailureForgotPasswordState', () {
    final state = FailureForgotPasswordState(errorMessage: 'testErrorMessage');

    test(
      'pastikan output dari fungsi toString',
      () async {
        // assert
        expect(
          state.toString(),
          'FailureForgotPasswordState{errorMessage: ${state.errorMessage}}',
        );
      },
    );
  });

  group('SuccessForgotPasswordState', () {
    final state = SuccessForgotPasswordState(email: 'testEmail');

    test(
      'pastikan output dari fungsi toString',
      () async {
        // assert
        expect(
          state.toString(),
          'SuccessForgotPasswordState{email: ${state.email}}',
        );
      },
    );
  });
}
