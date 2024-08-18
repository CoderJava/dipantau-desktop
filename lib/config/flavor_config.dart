class FlavorValues {
  String baseUrl;
  String baseUrlAuth;
  String baseUrlUser;
  String baseUrlTrack;
  String baseUrlProject;
  String baseUrlSetting;
  String baseUrlScreenshot;

  FlavorValues({
    required this.baseUrl,
    required this.baseUrlAuth,
    required this.baseUrlUser,
    required this.baseUrlTrack,
    required this.baseUrlProject,
    required this.baseUrlSetting,
    required this.baseUrlScreenshot,
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
