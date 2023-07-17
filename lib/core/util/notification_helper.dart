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
    localNotification?.show(
      DateTime.now().millisecond,
      'app_name'.tr(),
      'screenshot_taken'.tr(),
      const NotificationDetails(
        macOS: DarwinNotificationDetails(
          presentAlert: true,
          presentSound: true,
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
}
