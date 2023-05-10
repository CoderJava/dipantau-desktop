import 'package:dipantau_desktop_client/feature/presentation/bloc/home/home_bloc.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('PrepareDataHomeEvent', () {
    final tEvent = PrepareDataHomeEvent();

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
  });

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
  });
}