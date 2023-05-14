import 'dart:convert';

import 'package:dipantau_desktop_client/feature/data/model/project/project_response_bak.dart';
import 'package:dipantau_desktop_client/feature/presentation/bloc/project/project_bloc.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../fixture/fixture_reader.dart';

void main() {
  group('FailureProjectState', () {
    final tState = FailureProjectState(errorMessage: 'testErrorMessage');

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
          'FailureProjectState{errorMessage: ${tState.errorMessage}}',
        );
      },
    );
  });

  group('SuccessLoadDataProjectState', () {
    final tState = SuccessLoadDataProjectState(
      project: ProjectResponseBak.fromJson(
        json.decode(
          fixture('project_response.json'),
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
          'SuccessLoadDataProjectState{project: ${tState.project}}',
        );
      },
    );
  });
}
