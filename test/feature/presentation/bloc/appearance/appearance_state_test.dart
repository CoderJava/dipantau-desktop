import 'package:dipantau_desktop_client/feature/presentation/bloc/appearance/appearance_bloc.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('UpdateAppearanceState', () {
    final tState = UpdatedAppearanceState(isDarkMode: true);

    test(
      'pastikan output dari fungsi toString',
      () async {
        // assert
        expect(
          tState.toString(),
            'UpdatedAppearanceState{isDarkMode: ${tState.isDarkMode}}',
        );
      },
    );
  });
}