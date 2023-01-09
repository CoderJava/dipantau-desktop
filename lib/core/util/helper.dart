class Helper {
  bool checkValidationEmail(String email) {
    var isEmailValid = RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9!#$%&'*+-/=?^_`{|}~]+\.[a-zA-Z]+").hasMatch(email);
    return isEmailValid;
  }
}