import 'dart:convert';

import 'package:dipantau_desktop_client/feature/data/model/screenshot_refresh/screenshot_refresh_body.dart';
import 'package:dipantau_desktop_client/feature/presentation/bloc/report_screenshot/report_screenshot_bloc.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../fixture/fixture_reader.dart';

void main() {
  group('LoadReportScreenshotEvent', () {
    final tEvent = LoadReportScreenshotEvent(
      userId: 'testUserId',
      date: 'testDate',
    );

    test(
      'pastikan output dari fungsi toString',
      () async {
        // assert
        expect(
          tEvent.toString(),
          'LoadReportScreenshotEvent{userId: ${tEvent.userId}, date: ${tEvent.date}}',
        );
      },
    );
  });

  group('LoadDetailScreenshotReportScreenshotEvent', () {
    final body = ScreenshotRefreshBody.fromJson(
      json.decode(
        fixture('screenshot_refresh_body.json'),
      ),
    );
    final tEvent = LoadDetailScreenshotReportScreenshotEvent(body: body);

    test(
      'pastikan output dari fungsi toString',
      () async {
        // assert
        expect(
          tEvent.toString(),
          'LoadDetailScreenshotReportScreenshotEvent{body: ${tEvent.body}}',
        );
      },
    );
  });
}
