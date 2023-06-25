import 'package:dipantau_desktop_client/config/flavor_config.dart';
import 'package:dipantau_desktop_client/core/util/enum/appearance_mode.dart';
import 'package:dipantau_desktop_client/core/util/shared_preferences_manager.dart';
import 'package:intl/intl.dart';

class Helper {
  final SharedPreferencesManager sharedPreferencesManager;

  Helper({required this.sharedPreferencesManager});

  bool checkValidationEmail(String email) {
    final isValid = RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9!#$%&'*+-/=?^_`{|}~]+\.[a-zA-Z]+")
        .hasMatch(email);
    return isValid;
  }

  double get getDefaultPaddingLayout => 16.0;

  double get getDefaultWindowSize => 500.0;

  DateFormat setDateFormat(String pattern, {String? languageCode}) {
    if (languageCode != null) {
      return DateFormat(pattern, languageCode);
    }
    return DateFormat(pattern, 'en');
  }

  ({int hour, int minute, int second}) convertSecondToHms(int durationInSecond) {
    var hour = 0;
    var minute = 0;
    var second = 0;
    if (durationInSecond >= 3600) {
      hour = durationInSecond ~/ 3600;
      second = durationInSecond % 3600;
      if (second >= 60) {
        minute = second ~/ 60;
        second = second % 60;
      }
    } else if (durationInSecond >= 60) {
      minute = durationInSecond ~/ 60;
      second = durationInSecond % 60;
    } else {
      second = durationInSecond;
    }
    return (
      hour: hour,
      minute: minute,
      second: second,
    );
  }

  String convertTrackingTimeToString(int durationInSecond) {
    final (:hour, :minute, :second) = convertSecondToHms(durationInSecond);
    final strHour = hour < 10 ? '0$hour' : hour.toString();
    final strMinute = minute < 10 ? '0$minute' : minute.toString();
    final strSecond = second < 10 ? '0$second' : second.toString();
    final format = '$strHour:$strMinute:$strSecond';
    return format;
  }

  void setDomainApiToFlavor(String domainApi) {
    FlavorConfig(
      values: FlavorValues(
        baseUrl: domainApi,
        baseUrlAuth: '$domainApi/auth',
        baseUrlUser: '$domainApi/user',
        baseUrlTrack: '$domainApi/track',
        baseUrlProject: '$domainApi/project',
      ),
    );
  }

  Future<void> setLogout() async {
    final domainApi = sharedPreferencesManager.getString(SharedPreferencesManager.keyDomainApi) ?? '';
    final appearanceMode =
        sharedPreferencesManager.getString(SharedPreferencesManager.keyAppearanceMode) ?? AppearanceMode.light.name;
    sharedPreferencesManager.clearAll();
    if (domainApi.isNotEmpty) {
      sharedPreferencesManager.putString(SharedPreferencesManager.keyDomainApi, domainApi);
    }
    if (appearanceMode.isNotEmpty) {
      sharedPreferencesManager.putString(SharedPreferencesManager.keyAppearanceMode, appearanceMode);
    }
  }
}
