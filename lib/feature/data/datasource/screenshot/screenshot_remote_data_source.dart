import 'package:dio/dio.dart';
import 'package:dipantau_desktop_client/config/base_url_config.dart';
import 'package:dipantau_desktop_client/config/flavor_config.dart';
import 'package:dipantau_desktop_client/feature/data/model/screenshot_refresh/screenshot_refresh_body.dart';
import 'package:dipantau_desktop_client/feature/data/model/screenshot_refresh/screenshot_refresh_response.dart';

abstract class ScreenshotRemoteDataSource {
  /// Panggil endpoint [host]/screenshot/refresh
  late String pathRefreshScreenshot;

  Future<ScreenshotRefreshResponse> refreshScreenshot(ScreenshotRefreshBody body);
}

class ScreenshotRemoteDataSourceImpl implements ScreenshotRemoteDataSource {
  final Dio dio;

  ScreenshotRemoteDataSourceImpl({
    required this.dio,
  });

  final baseUrl = FlavorConfig.instance.values.baseUrlScreenshot;
  final baseUrlConfig = BaseUrlConfig();

  @override
  String pathRefreshScreenshot = '';

  @override
  Future<ScreenshotRefreshResponse> refreshScreenshot(ScreenshotRefreshBody body) async {
    pathRefreshScreenshot = '$baseUrl/refresh';
    final response = await dio.post(
      pathRefreshScreenshot,
      data: body.toJson(),
      options: Options(
        headers: {
          baseUrlConfig.requiredToken: true,
        },
      ),
    );
    if (response.statusCode.toString().startsWith('2')) {
      return ScreenshotRefreshResponse.fromJson(response.data);
    } else {
      throw DioException(requestOptions: RequestOptions(path: pathRefreshScreenshot));
    }
  }
}
