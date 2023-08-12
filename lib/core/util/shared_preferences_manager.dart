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
  static const keyBaseFilePathScreenshot = 'base_file_path_screenshot';
  static const keyIsLaunchAtStartup = 'is_launch_at_startup';
  static const keyIsAlwaysOnTop = 'is_always_on_top';
  static const keyIsEnableReminderTrack = 'is_enable_reminder_track';
  static const keyStartTimeReminderTrack = 'start_time_reminder_track';
  static const keyFinishTimeReminderTrack = 'finish_time_reminder_track';
  static const keyDayReminderTrack = 'day_reminder_track';
  static const keyIntervalReminderTrack = 'interval_reminder_track';
  static const keyIsEnableSoundScreenshotNotification = 'is_enable_sound_screenshot_notification';
  static const keySelectedTaskName = 'selected_task_name';
  static const keySelectedTaskId = 'selected_task_id';
  static const keyIsAutoStartTask = 'is_auto_start_task';
  static const keySleepTime = 'sleep_time';

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
