import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesManager {
  static late SharedPreferences _sharedPreferences;

  static const keyFullName = 'full_name';
  static const keyEmail = 'email';
  static const keyIsLogin = 'is_Login';
  static const keyAccessToken = 'access_token';
  static const keyRefreshToken = 'refresh_token';
  static const keyUserRole = 'user_role';
  static const keyUserId = 'user_id';
  static const keySelectedProjectId = 'selected_project_id';
  static const keySelectedProjectName = 'selected_project_name';
  static const keyDomainApi = 'domain_api';
  static const keyIsEnableScreenshotNotification = 'is_enable_screenshot_notification';
  static const keyAppearanceMode = 'appearance_mode';

  SharedPreferencesManager();

  factory SharedPreferencesManager.getInstance(SharedPreferences sharedPreferences) {
    _sharedPreferences = sharedPreferences;
    return SharedPreferencesManager();
  }

  Future<bool> putBool(String key, bool value) => _sharedPreferences.setBool(key, value);

  bool? getBool(String key, {bool defaultValue = false}) =>
      _sharedPreferences.containsKey(key) ? _sharedPreferences.getBool(key) : defaultValue;

  Future<bool> putDouble(String key, double value) => _sharedPreferences.setDouble(key, value);

  double? getDouble(String key, {double defaultValue = 0.0}) =>
      _sharedPreferences.containsKey(key) ? _sharedPreferences.getDouble(key) : defaultValue;

  Future<bool> putInt(String key, int value) => _sharedPreferences.setInt(key, value);

  int? getInt(String key, {int defaultValue = 0}) =>
      _sharedPreferences.containsKey(key) ? _sharedPreferences.getInt(key) : defaultValue;

  Future<bool> putString(String key, String value) => _sharedPreferences.setString(key, value);

  String? getString(String key, {String defaultValue = ''}) =>
      _sharedPreferences.containsKey(key) ? _sharedPreferences.getString(key) : defaultValue;

  Future<bool> putStringList(String key, List<String> value) => _sharedPreferences.setStringList(key, value);

  List<String>? getStringList(String key) =>
      _sharedPreferences.containsKey(key) ? _sharedPreferences.getStringList(key) : null;

  bool isKeyExists(String key) => _sharedPreferences.containsKey(key);

  Future<bool> clearKey(String key) => _sharedPreferences.remove(key);

  Future<bool> clearAll() => _sharedPreferences.clear();
}
