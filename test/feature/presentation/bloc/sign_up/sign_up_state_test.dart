import 'dart:convert';

import 'package:dipantau_desktop_client/feature/data/model/sign_up/sign_up_response.dart';
import 'package:dipantau_desktop_client/feature/presentation/bloc/sign_up/sign_up_bloc.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../fixture/fixture_reader.dart';

void main() {
  group('FailureSignUpState', () {
    final tState = FailureSignUpState(errorMessage: 'testErrorMessage');

    test(
      'pastikan output dari nilai props',
      () async {
        // assert
        expect(
          tState.props,
          [
            tState.errorMessage,
          ],
        );
      },
    );

    test(
      'pastikan output dari fungsi toString',
      () async {
        // assert
        expect(
          tState.toString(),
          'FailureSignUpState{errorMessage: ${tState.errorMessage}}',
        );
      },
    );
  });

  group('SuccessSubmitSignUpState', () {
    final tState = SuccessSubmitSignUpState(
      response: SignUpResponse.fromJson(
        json.decode(
          fixture('sign_up_response.json'),
        ),
      ),
    );

    test(
      'pastikan output dari nilai props',
      () async {
        // assert
        expect(
          tState.props,
          [
            tState.response,
          ],
        );
      },
    );

    test(
      'pastikan output dari fungsi toString',
      () async {
        // assert
        expect(
          tState.toString(),
          'SuccessSubmitSignUpState{response: ${tState.response}}',
        );
      },
    );
  });
}
