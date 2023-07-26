import 'package:dipantau_desktop_client/feature/presentation/bloc/cron_tracking/cron_tracking_bloc.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('FailureCronTrackingState', () {
    final tState = FailureCronTrackingState(
      errorMessage: 'testErrorMessage',
    );

    test(
      'pastikan output dari fungsi toString',
      () async {
        // assert
        expect(
          tState.toString(),
          'FailureCronTrackingState{errorMessage: ${tState.errorMessage}}',
        );
      },
    );
  });

  group('SuccessRunCronTrackingState', () {
    final tState = SuccessRunCronTrackingState(
      ids: [],
      files: [],
    );

    test(
      'pastikan output dari fungsi toString',
      () async {
        // assert
        expect(
          tState.toString(),
          'SuccessRunCronTrackingState{ids: ${tState.ids}, files: ${tState.files}}',
        );
      },
    );
  });
}
