import 'package:dipantau_desktop_client/feature/presentation/bloc/cron_tracking/cron_tracking_bloc.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('RunCronTrackingEvent', () {
    final tEvent = RunCronTrackingEvent(
      bodyData: null,
      bodyImage: null,
    );

    test(
      'pastikan output dari fungsi toString',
      () async {
        // assert
        expect(
          tEvent.toString(),
          'RunCronTrackingEvent{bodyData: ${tEvent.bodyData}, bodyImage: ${tEvent.bodyImage}}',
        );
      },
    );
  });
}
