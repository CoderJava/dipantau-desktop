class FlavorValues {
  String baseUrl;

  FlavorValues({
    required this.baseUrl,
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
