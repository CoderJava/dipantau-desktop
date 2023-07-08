import 'package:dipantau_desktop_client/feature/presentation/bloc/report_screenshot/report_screenshot_bloc.dart';
import 'package:flutter_test/flutter_test.dart';

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
}
