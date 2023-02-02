import 'package:dipantau_desktop_client/feature/data/model/tracking_time/tracking_time.dart';
import 'package:intl/intl.dart';

class Helper {
  bool checkValidationEmail(String email) {
    final isEmailValid =
        RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9!#$%&'*+-/=?^_`{|}~]+\.[a-zA-Z]+")
            .hasMatch(email);
    return isEmailValid;
  }

  double get getDefaultPaddingLayout => 24.0;

  double get getDefaultWindowSize => 500.0;

  DateFormat setDateFormat(String pattern, {String? languageCode}) {
    if (languageCode != null) {
      return DateFormat(pattern, languageCode);
    }
    return DateFormat(pattern, 'en');
  }

  TrackingTime convertSecondToTrackingTime(int durationInSecond) {
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
    return TrackingTime(
      hour: hour,
      minute: minute,
      second: second,
    );
  }
}
