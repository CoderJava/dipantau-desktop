import 'package:dipantau_desktop_client/feature/presentation/bloc/project/project_bloc.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('LoadDataProjectEvent', () {
    final tEvent = LoadDataProjectEvent();

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