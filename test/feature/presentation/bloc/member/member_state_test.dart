import 'dart:convert';

import 'package:dipantau_desktop_client/feature/data/model/user_profile/list_user_profile_response.dart';
import 'package:dipantau_desktop_client/feature/presentation/bloc/member/member_bloc.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../fixture/fixture_reader.dart';

void main() {
  group('FailureMemberState', () {
    final tState = FailureMemberState(errorMessage: 'testErrorMessage');

    test(
      'pastikan output dari fungsi toString',
      () async {
        // assert
        expect(
          tState.toString(),
          'FailureMemberState{errorMessage: ${tState.errorMessage}}',
        );
      },
    );
  });

  group('SuccessLoadListMemberState', () {
    final tResponse = ListUserProfileResponse.fromJson(
      json.decode(
        fixture('list_user_profile_response.json'),
      ),
    );
    final tState = SuccessLoadListMemberState(response: tResponse);

    test(
      'pastikan output dari fungsi toString',
      () async {
        // assert
        expect(
          tState.toString(),
          'SuccessLoadListMemberState{response: ${tState.response}}',
        );
      },
    );
  });
}
