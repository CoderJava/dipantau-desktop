import 'package:dipantau_desktop_client/core/util/enum/global_variable.dart';
import 'package:dipantau_desktop_client/core/util/shared_preferences_manager.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationHelper {
  static FlutterLocalNotificationsPlugin? localNotification;

  NotificationHelper() {
    localNotification ??= FlutterLocalNotificationsPlugin();
  }

  void requestPermissionNotification() {
    localNotification
        ?.resolvePlatformSpecificImplementation<MacOSFlutterLocalNotificationsPlugin>()
        ?.requestPermissions(
          sound: true,
          alert: true,
        );
  }

  void showScreenshotTakenNotification() {
    final presentSound = sharedPreferencesManager.getBool(
          SharedPreferencesManager.keyIsEnableSoundScreenshotNotification,
          defaultValue: true,
        ) ??
        true;
    localNotification?.show(
      DateTime.now().millisecond,
      'app_name'.tr(),
      'screenshot_taken'.tr(),
      NotificationDetails(
        macOS: DarwinNotificationDetails(
          presentAlert: true,
          presentSound: presentSound,
        ),
      ),
    );
  }

  void showReminderNotTrackNotification() {
    localNotification?.show(
      DateTime.now().millisecond,
      'app_name'.tr(),
      'reminder_not_tracking_time'.tr(),
      const NotificationDetails(
        macOS: DarwinNotificationDetails(
          presentAlert: true,
          presentSound: true,
          sound: 'hasta_la_vista.aiff',
        ),
      ),
    );
  }

  void showPermissionScreenRecordingIssuedNotification() {
    localNotification?.show(
      DateTime.now().millisecond,
      'app_name'.tr(),
      'screen_recording_issued'.tr(),
      const NotificationDetails(
        macOS: DarwinNotificationDetails(
          presentAlert: true,
          presentSound: true,
        ),
      ),
    );
  }
}
