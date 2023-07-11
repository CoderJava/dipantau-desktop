import 'dart:convert';

import 'package:dipantau_desktop_client/feature/data/model/kv_setting/kv_setting_response.dart';
import 'package:dipantau_desktop_client/feature/presentation/bloc/setting/setting_bloc.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../fixture/fixture_reader.dart';

void main() {
  group('FailureSettingState', () {
    final tState = FailureSettingState(errorMessage: 'testErrorMessage');

    test(
      'pastikan output dari fungsi toString',
      () async {
        // assert
        expect(
          tState.toString(),
          'FailureSettingState{errorMessage: ${tState.errorMessage}}',
        );
      },
    );
  });

  group('FailureSnackBarSettingState', () {
    final tState = FailureSnackBarSettingState(errorMessage: 'testErrorMessage');

    test(
      'pastikan output dari fungsi toString',
      () async {
        // assert
        expect(
          tState.toString(),
          'FailureSnackBarSettingState{errorMessage: ${tState.errorMessage}}',
        );
      },
    );
  });

  group('SuccessLoadKvSettingState', () {
    final tState = SuccessLoadKvSettingState(
      response: KvSettingResponse.fromJson(
        json.decode(
          fixture('kv_setting_response.json'),
        ),
      ),
    );

    test(
      'pastikan output dari fungsi toString',
      () async {
        // assert
        expect(
          tState.toString(),
          'SuccessLoadKvSettingState{response: ${tState.response}}',
        );
      },
    );
  });
}
