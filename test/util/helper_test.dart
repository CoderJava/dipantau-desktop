import 'package:dipantau_desktop_client/core/util/helper.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late Helper helper;

  setUp(() {
    helper = Helper();
  });

  test(
    'pastikan fungsi checkValidationEmail bisa mengecek apakah email-nya valid atau tidak',
    () async {
      // act
      final result = helper.checkValidationEmail('yudisetiawan@nusa.net.id');
      final result2 = helper.checkValidationEmail('eva.yosefin@surya-nusantara.com');
      final result3 = helper.checkValidationEmail('eva-yosefin.pablo@surya-nusantara.com');

      // assert
      expect(result, true);
      expect(result2, true);
      expect(result3, true);
    },
  );
}
