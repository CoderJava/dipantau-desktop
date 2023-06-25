import 'package:dipantau_desktop_client/feature/presentation/bloc/appearance/appearance_bloc.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('UpdateAppearanceEvent', () {
    final tEvent = UpdateAppearanceEvent(isDarkMode: true);

    test(
      'pastikan output dari fungsi toString',
      () async {
        // assert
        expect(
          tEvent.toString(),
          'UpdateAppearanceEvent{isDarkMode: ${tEvent.isDarkMode}}',
        );
      },
    );
  });
}