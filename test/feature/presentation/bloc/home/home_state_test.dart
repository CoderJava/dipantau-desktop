import 'dart:convert';

import 'package:dipantau_desktop_client/feature/data/model/track_user_lite/track_user_lite_response.dart';
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

  group('SuccessLoadDataHomeState', () {
    final tResponse = TrackUserLiteResponse.fromJson(
      json.decode(
        fixture('track_user_lite_response.json'),
      ),
    );
    final tState = SuccessLoadDataHomeState(
      trackUserLiteResponse: tResponse,
      isAutoStart: false,
    );

    test(
      'pastikan output dari nilai props',
      () async {
        // assert
        expect(
          tState.props,
          [
            tState.trackUserLiteResponse,
            tState.isAutoStart,
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
          'SuccessLoadDataHomeState{trackUserLiteResponse: ${tState.trackUserLiteResponse}, '
          'isAutoStart: ${tState.isAutoStart}}',
        );
      },
    );
  });
}
