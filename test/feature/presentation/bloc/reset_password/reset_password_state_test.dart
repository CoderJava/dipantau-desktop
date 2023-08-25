import 'package:dipantau_desktop_client/feature/presentation/bloc/reset_password/reset_password_bloc.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('FailureResetPasswordState', () {
    final state = FailureResetPasswordState(
      errorMessage: 'testErrorMessage',
    );

    test(
      'pastikan output dari fungsi toString',
      () async {
        // assert
        expect(
          state.toString(),
          'FailureResetPasswordState{errorMessage: ${state.errorMessage}}',
        );
      },
    );
  });
}
