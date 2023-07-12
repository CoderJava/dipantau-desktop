import 'dart:convert';

import 'package:dipantau_desktop_client/feature/data/model/user_profile/user_profile_response.dart';
import 'package:dipantau_desktop_client/feature/presentation/bloc/user_profile/user_profile_bloc.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../fixture/fixture_reader.dart';

void main() {
  group('FailureUserProfileState', () {
    final tState = FailureUserProfileState(errorMessage: 'testErrorMessage');

    test(
      'pastikan output dari fungsi toString',
      () async {
        // assert
        expect(
          tState.toString(),
          'FailureUserProfileState{errorMessage: ${tState.errorMessage}}',
        );
      },
    );
  });

  group('FailureSnackBarUserProfileState', () {
    final tState = FailureSnackBarUserProfileState(errorMessage: 'testErrorMessage');

    test(
      'pastikan output dari fungsi toString',
      () async {
        // assert
        expect(
          tState.toString(),
          'FailureSnackBarUserProfileState{errorMessage: ${tState.errorMessage}}',
        );
      },
    );
  });

  group('SuccessLoadDataUserProfileState', () {
    final tState = SuccessLoadDataUserProfileState(
      response: UserProfileResponse.fromJson(
        json.decode(
          fixture('user_profile_super_admin_response.json'),
        ),
      ),
    );

    test(
      'pastikan output dari fungsi toString',
      () async {
        // assert
        expect(
          tState.toString(),
          'SuccessLoadDataUserProfileState{response: ${tState.response}}',
        );
      },
    );
  });
}
