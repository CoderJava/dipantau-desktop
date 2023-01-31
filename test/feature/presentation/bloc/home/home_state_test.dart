import 'dart:convert';

import 'package:dipantau_desktop_client/feature/data/model/project/project_response.dart';
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

  group('SuccessLoadDataProjectHomeState', () {
    final tResponse = ProjectResponse.fromJson(
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
