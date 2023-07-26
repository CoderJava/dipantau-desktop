import 'package:dipantau_desktop_client/feature/presentation/bloc/sync_manual/sync_manual_bloc.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('FailureSyncManualState', () {
    final tState = FailureSyncManualState(errorMessage: 'testErrorMessage');

    test(
      'pastikan output dari fungsi toString',
      () async {
        // assert
        expect(
          tState.toString(),
          'FailureSyncManualState{errorMessage: ${tState.errorMessage}}',
        );
      },
    );
  });
}