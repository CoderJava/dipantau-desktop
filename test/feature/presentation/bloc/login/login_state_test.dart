import 'package:dipantau_desktop_client/feature/presentation/bloc/login/login_bloc.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('FailureLoginState', () {
    final tState = FailureLoginState(errorMessage: 'testErrorMessage');

    test(
      'pastikan output dari nilai props',
      () async {
        // assert
        expect(
          tState.props,
          [
            tState.errorMessage,
          ]
        );
      },
    );

    test(
      'pastikan output dari fungsi toString',
      () async {
        // assert
        expect(
          tState.toString(),
          'FailureLoginState{errorMessage: ${tState.errorMessage}}',
        );
      },
    );
  });
}