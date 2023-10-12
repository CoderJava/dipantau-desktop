enum SignUpMethod {
  manual,
  auto,
}

extension SignUpMethodExtension on SignUpMethod {
  String toValue() {
    switch (this) {
      case SignUpMethod.manual:
        return 'manual_approval';
      case SignUpMethod.auto:
        return 'auto_approval';
      default:
        return '';
    }
  }

  static SignUpMethod? parseString(String value) {
    if (value.contains('manual')) {
      return SignUpMethod.manual;
    } else if (value.contains('auto')) {
      return SignUpMethod.auto;
    }
    return null;
  }
}
