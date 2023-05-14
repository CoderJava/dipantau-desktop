import 'dart:convert';

import 'package:dipantau_desktop_client/feature/data/model/project/project_response_bak.dart';
import 'package:dipantau_desktop_client/feature/data/model/user_profile/user_profile_response.dart';
import 'package:dipantau_desktop_client/feature/presentation/bloc/home/home_bloc.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../fixture/fixture_reader.dart';

void main() {
  group('FailureHomeState', () {
    final tState = FailureHomeState(errorMessage: 'testErrorMessage');

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
          'FailureHomeState{errorMessage: ${tState.errorMessage}}',
        );
      },
    );
  });

  group('SuccessPrepareDataHomeState', () {
    final tUser = UserProfileResponse.fromJson(
      json.decode(
        fixture('user_profile_super_admin_response.json'),
      ),
    );
    final tState = SuccessPrepareDataHomeState(user: tUser);

    test(
      'pastikan output dari nilai props',
      () async {
        // assert
        expect(
          tState.props,
          [
            tState.user,
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
          'SuccessPrepareDataHomeState{user: ${tState.user}}',
        );
      },
    );
  });

  group('SuccessLoadDataProjectHomeState', () {
    final tResponse = ProjectResponseBak.fromJson(
      json.decode(
        fixture('project_response.json'),
      ),
    );
    final tState = SuccessLoadDataProjectHomeState(project: tResponse);

    test(
      'pastikan output dari nilai props',
      () async {
        // assert
        expect(
          tState.props,
          [
            tState.project,
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
          'SuccessLoadDataProjectHomeState{project: ${tState.project}}',
        );
      },
    );
  });
}
