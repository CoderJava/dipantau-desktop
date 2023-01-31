import 'package:dipantau_desktop_client/feature/presentation/bloc/home/home_bloc.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('LoadDataProjectHomeEvent', () {
    final tEvent = LoadDataProjectHomeEvent();

    test(
      'pastikan output dari nilai props',
      () async {
        // assert
        expect(
          tEvent.props,
          [],
        );
      },
    );

    test(
      'pastikan output dari fungsi toString',
      () async {
        // assert
        expect(
          tEvent.toString(),
          'LoadDataProjectHomeEvent()',
        );
      },
    );
  });
}