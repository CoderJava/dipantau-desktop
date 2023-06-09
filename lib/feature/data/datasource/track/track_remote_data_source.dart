import 'package:dio/dio.dart';
import 'package:dipantau_desktop_client/config/base_url_config.dart';
import 'package:dipantau_desktop_client/config/flavor_config.dart';
import 'package:dipantau_desktop_client/feature/data/model/track_user_lite/track_user_lite_response.dart';

abstract class TrackRemoteDataSource {
  /// Panggil endpoint [host]/track/user/lite
  ///
  /// Throws [DioError] untuk semua error kode
  late String pathGetTrackUserLite;

  Future<TrackUserLiteResponse> getTrackUserLite(String date, String projectId);
}

class TrackRemoteDataSourceImpl implements TrackRemoteDataSource {
  final Dio dio;

  TrackRemoteDataSourceImpl({
    required this.dio,
  });

  final baseUrl = FlavorConfig.instance.values.baseUrlTrack;
  final baseUrlConfig = BaseUrlConfig();

  @override
  String pathGetTrackUserLite = '';

  @override
  Future<TrackUserLiteResponse> getTrackUserLite(String date, String projectId) async {
    pathGetTrackUserLite = '$baseUrl/user/lite';
    final response = await dio.get(
      pathGetTrackUserLite,
      queryParameters: {
        'date': date,
        'project_id': projectId,
      },
      options: Options(
        headers: {
          baseUrlConfig.requiredToken: true,
        },
      ),
    );
    if (response.statusCode.toString().startsWith('2')) {
      return TrackUserLiteResponse.fromJson(response.data);
    } else {
      throw DioError(requestOptions: RequestOptions(path: pathGetTrackUserLite));
    }
  }
}
