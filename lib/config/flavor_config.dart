class FlavorValues {
  String baseUrl;
  String baseUrlAuth;

  FlavorValues({
    required this.baseUrl,
    required this.baseUrlAuth,
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
