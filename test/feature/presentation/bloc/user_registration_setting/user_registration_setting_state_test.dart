import 'dart:convert';

import 'package:dipantau_desktop_client/feature/data/model/kv_setting/kv_setting_response.dart';
import 'package:dipantau_desktop_client/feature/data/model/user_sign_up_waiting/user_sign_up_waiting_response.dart';
import 'package:dipantau_desktop_client/feature/presentation/bloc/user_registration_setting/user_registration_setting_bloc.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../fixture/fixture_reader.dart';

void main() {
  group('FailureUserRegistrationSettingState', () {
    final state = FailureUserRegistrationSettingState(errorMessage: 'testErrorMessage');

    test(
      'pastikan output dari fungsi toString',
      () async {
        // assert
        expect(
          state.toString(),
          'FailureUserRegistrationSettingState{errorMessage: ${state.errorMessage}}',
        );
      },
    );
  });

  group('SuccessPrepareDataUserRegistrationSettingState', () {
    final kvSettingResponse = KvSettingResponse.fromJson(
      json.decode(
        fixture('kv_setting_response.json'),
      ),
    );
    final userSignUpWaitingResponse = UserSignUpWaitingResponse.fromJson(
      json.decode(
        fixture('user_sign_up_waiting_response.json'),
      ),
    );
    final state = SuccessPrepareDataUserRegistrationSettingState(
      kvSettingResponse: kvSettingResponse,
      userSignUpWaitingResponse: userSignUpWaitingResponse,
    );

    test(
      'pastikan output dari fungsi toString',
      () async {
        // assert
        expect(
          state.toString(),
          'SuccessPrepareDataUserRegistrationSettingState{kvSettingResponse: ${state.kvSettingResponse}, '
          'userSignUpWaitingResponse: ${state.userSignUpWaitingResponse}}',
        );
      },
    );
  });
}
