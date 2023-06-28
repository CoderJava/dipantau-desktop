import 'package:dio/dio.dart';
import 'package:dipantau_desktop_client/config/base_url_config.dart';
import 'package:dipantau_desktop_client/config/flavor_config.dart';
import 'package:dipantau_desktop_client/feature/data/model/create_track/create_track_body.dart';
import 'package:dipantau_desktop_client/feature/data/model/general/general_response.dart';
import 'package:dipantau_desktop_client/feature/data/model/track_user_lite/track_user_lite_response.dart';

abstract class TrackRemoteDataSource {
  /// Panggil endpoint [host]/track/user/lite
  ///
  /// Throws [DioException] untuk semua error kode
  late String pathGetTrackUserLite;

  Future<TrackUserLiteResponse> getTrackUserLite(String date, String projectId);

  /// Panggil endpoint [host]/track
  ///
  /// Throws [DioException] untuk semua error kode
  late String pathCreateTrack;

  Future<GeneralResponse> createTrack(CreateTrackBody body);
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
      throw DioException(requestOptions: RequestOptions(path: pathGetTrackUserLite));
    }
  }

  @override
  String pathCreateTrack = '';

  @override
  Future<GeneralResponse> createTrack(CreateTrackBody body) async {
    final formDataMap = <String, dynamic>{
      'task_id': body.taskId,
      'start_date': body.startDate,
      'finish_date': body.finishDate,
      'activity': body.activity,
      'duration': body.duration,
    };
    final listMultipartFiles = <MultipartFile>[];
    for (final itemFile in body.files) {
      final file = await MultipartFile.fromFile(itemFile);
      listMultipartFiles.add(file);
    }
    formDataMap['files[]'] = listMultipartFiles;
    final formData = FormData.fromMap(formDataMap);

    pathCreateTrack = baseUrl;
    final response = await dio.post(
      pathCreateTrack,
      data: formData,
      options: Options(
        headers: {
          baseUrlConfig.requiredToken: true,
        },
      ),
    );
    if (response.statusCode.toString().startsWith('2')) {
      return GeneralResponse.fromJson(response.data);
    } else {
      throw DioException(requestOptions: RequestOptions(path: pathCreateTrack));
    }
  }
}
