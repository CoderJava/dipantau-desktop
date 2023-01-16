import 'package:dipantau_desktop_client/core/usecase/usecase.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test(
    'pastikan output dari nilai props',
    () async {
      // assert
      expect(
        NoParams().props,
        [],
      );
    },
  );
}
