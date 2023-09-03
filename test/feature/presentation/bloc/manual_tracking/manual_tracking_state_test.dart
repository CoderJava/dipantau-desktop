import 'package:dipantau_desktop_client/feature/presentation/bloc/manual_tracking/manual_tracking_bloc.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('FailureManualTrackingState', () {
    final state = FailureManualTrackingState(errorMessage: 'errorMessage');

    test(
      'pastikan output dari fungsi toString',
      () async {
        // assert
        expect(
          state.toString(),
          'FailureManualTrackingState{errorMessage: ${state.errorMessage}}',
        );
      },
    );
  });

  group('FailureCenterManualTrackingState', () {
    final state = FailureCenterManualTrackingState(errorMessage: 'errorMessage');

    test(
      'pastikan output dari fungsi toString',
      () async {
        // assert
        expect(
          state.toString(),
          'FailureCenterManualTrackingState{errorMessage: ${state.errorMessage}}',
        );
      },
    );
  });
}
