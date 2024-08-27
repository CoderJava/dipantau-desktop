import 'dart:convert';

import 'package:dipantau_desktop_client/feature/data/model/screenshot_refresh/screenshot_refresh_response.dart';
import 'package:dipantau_desktop_client/feature/data/model/track_user/track_user_response.dart';
import 'package:dipantau_desktop_client/feature/presentation/bloc/report_screenshot/report_screenshot_bloc.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../fixture/fixture_reader.dart';

void main() {
  group('FailureReportScreenshotState', () {
    final tState = FailureReportScreenshotState(errorMessage: 'testErrorMessage');

    test(
      'pastikan output dari fungsi toString',
      () async {
        // assert
        expect(
          tState.toString(),
          'FailureReportScreenshotState{errorMessage: ${tState.errorMessage}}',
        );
      },
    );
  });

  group('SuccessLoadReportScreenshotState', () {
    final tState = SuccessLoadReportScreenshotState(
      response: TrackUserResponse.fromJson(
        json.decode(
          fixture('track_user_response.json'),
        ),
      ),
    );

    test(
      'pastikan output dari fungsi toString',
      () async {
        // assert
        expect(
          tState.toString(),
          'SuccessLoadReportScreenshotState{response: ${tState.response}}',
        );
      },
    );
  });

  group('SuccessLoadDetailScreenshotReportScreenshotState', () {
    final response = ScreenshotRefreshResponse.fromJson(
      json.decode(
        fixture('screenshot_refresh_response.json'),
      ),
    );
    final tState = SuccessLoadDetailScreenshotReportScreenshotState(response: response);

    test(
      'pastikan output dari fungsi toString',
      () async {
        // assert
        expect(
          tState.toString(),
          'SuccessLoadDetailScreenshotReportScreenshotState{response: ${tState.response}}',
        );
      },
    );
  });
}
