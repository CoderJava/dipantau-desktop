class PasswordValidator {
  /// Cek panjang kata sandinya
  bool hasMinLength(String password, int minLength) {
    return password.length >= minLength;
  }

  /// Cek kata sandinya harus mengandung karakter lower case
  bool hasMinLowerCaseChar(String password, int count) {
    final pattern = '^(.*?[a-z]){$count,}';
    return password.contains(RegExp(pattern));
  }

  /// Cek kata sandinya harus mengandung karakter upper case
  bool hasMinUpperCaseChar(String password, int count) {
    final pattern = '^(.*?[A-Z]){$count,}';
    return password.contains(RegExp(pattern));
  }

  /// Cek kata sandinya harus mengandung karakter angka
  bool hasMinNumericChar(String password, int count) {
    final pattern = '^(.*?[0-9]){$count,}';
    return password.contains(RegExp(pattern));
  }

  /// Cek kata sandinya harus mengandung karakter khusus atau simbol
  bool hasMinSpecialChar(String password, int count) {
    // ignore: prefer_interpolation_to_compose_strings
    final pattern = r"^(.*?[$&+,\:;/=?@#|'<>.^*()_%!-]){" + count.toString() + ",}";
    return password.contains(RegExp(pattern));
  }
}
