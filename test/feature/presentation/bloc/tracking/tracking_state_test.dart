import 'package:dipantau_desktop_client/feature/presentation/bloc/tracking/tracking_bloc.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('FailureTrackingState', () {
    final tState = FailureTrackingState(errorMessage: 'testErrorMessage');

    test(
      'pastikan output dari fungsi toString',
      () async {
        // assert
        expect(
          tState.toString(),
          'FailureTrackingState{errorMessage: ${tState.errorMessage}}',
        );
      },
    );
  });
}