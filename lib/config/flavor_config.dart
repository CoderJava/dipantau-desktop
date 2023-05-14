class FlavorValues {
  String baseUrl;
  String baseUrlAuth;
  String baseUrlUser;
  String baseUrlTrack;
  String baseUrlProject;

  FlavorValues({
    required this.baseUrl,
    required this.baseUrlAuth,
    required this.baseUrlUser,
    required this.baseUrlTrack,
    required this.baseUrlProject,
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
