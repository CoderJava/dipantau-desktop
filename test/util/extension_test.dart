import 'package:dipantau_desktop_client/core/util/enum/appearance_mode.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test(
    'pastikan output dari extension fromString yang di appearance_mode bisa mengembalikan enum AppearanceMode',
    () async {
      // arrange
      final light = AppearanceMode.light.name;
      final dark = AppearanceMode.dark.name;
      final system = AppearanceMode.system.name;

      // act
      final resultLight = light.fromString;
      final resultDark = dark.fromString;
      final resultSystem = system.fromString;

      // assert
      expect(resultLight, AppearanceMode.light);
      expect(resultDark, AppearanceMode.dark);
      expect(resultSystem, AppearanceMode.system);
    },
  );
}