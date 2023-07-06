import 'package:dipantau_desktop_client/core/util/password_validator.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final passwordValidator = PasswordValidator();

  test(
    'pastikan password validator berfungsi dengan baik',
    () async {
      // arrange
      const password = 'Nusanet123!';

      // act
      final minLengthResult = passwordValidator.hasMinLength(password, 8);
      final minLowerCaseResult = passwordValidator.hasMinLowerCaseChar(password, 1);
      final minUpperCaseResult = passwordValidator.hasMinUpperCaseChar(password, 1);
      final minNumericCharResult = passwordValidator.hasMinNumericChar(password, 1);
      final minSpecialCharResult = passwordValidator.hasMinSpecialChar(password, 1);

      // assert
      expect(minLengthResult, true);
      expect(minLowerCaseResult, true);
      expect(minUpperCaseResult, true);
      expect(minNumericCharResult, true);
      expect(minSpecialCharResult, true);
    },
  );
}