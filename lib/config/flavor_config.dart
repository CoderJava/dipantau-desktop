class FlavorValues {
  String baseUrl;
  String baseUrlAuth;
  String baseUrlUser;

  FlavorValues({
    required this.baseUrl,
    required this.baseUrlAuth,
    required this.baseUrlUser,
  });
}

class FlavorConfig {
  final FlavorValues values;

  static late FlavorConfig _instance;

  factory FlavorConfig({
    required FlavorValues values,
  }) {
    _instance = FlavorConfig._internal(
      values,
    );
    return _instance;
  }

  FlavorConfig._internal(this.values);

  static FlavorConfig get instance => _instance;
}
