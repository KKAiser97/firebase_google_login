class Validators {
  static isValidEmail(String email) {
    final regExp = RegExp(
        r'^[a-zA-Z0-9.!#$%&’*+/=?^_`{|}~-]+@[a-zA-Z0-9-]+(?:\.[a-zA-Z0-9-]+)*$');
    return regExp.hasMatch(email);
  }

  static isValidPassword(String password) => password.length >= 3;
}
