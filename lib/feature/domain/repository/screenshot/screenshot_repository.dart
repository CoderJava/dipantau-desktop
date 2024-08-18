import 'package:dipantau_desktop_client/core/error/failure.dart';
import 'package:dipantau_desktop_client/feature/data/model/screenshot_refresh/screenshot_refresh_body.dart';
import 'package:dipantau_desktop_client/feature/data/model/screenshot_refresh/screenshot_refresh_response.dart';

abstract class ScreenshotRepository {
  Future<({Failure? failure, ScreenshotRefreshResponse? response})> refreshScreenshot(ScreenshotRefreshBody body);
}