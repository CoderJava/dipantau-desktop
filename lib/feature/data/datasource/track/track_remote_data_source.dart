import 'package:dio/dio.dart';
import 'package:dipantau_desktop_client/config/base_url_config.dart';
import 'package:dipantau_desktop_client/config/flavor_config.dart';
import 'package:dipantau_desktop_client/feature/data/model/create_track/bulk_create_track_data_body.dart';
import 'package:dipantau_desktop_client/feature/data/model/create_track/bulk_create_track_image_body.dart';
import 'package:dipantau_desktop_client/feature/data/model/create_track/create_track_body.dart';
import 'package:dipantau_desktop_client/feature/data/model/general/general_response.dart';
import 'package:dipantau_desktop_client/feature/data/model/track_user/track_user_response.dart';
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

  /// Panggil endpoint [host]/track/bulk/data
  ///
  /// Throws [DioException] untuk semua error kode
  late String pathBulkCreateTrackData;

  Future<GeneralResponse> bulkCreateTrackData(BulkCreateTrackDataBody body);

  /// Panggil endpoint [host]/track/bulk/image
  ///
  /// Throws [DioException] untuk semua error kode
  late String pathBulkCreateTrackImage;

  Future<GeneralResponse> bulkCreateTrackImage(BulkCreateTrackImageBody body);

  /// Panggil endpoint [host]/track/user
  ///
  /// Throws [DioException] untuk semua error kode
  late String pathGetTrackUser;

  Future<TrackUserResponse> getTrackUser(String userId, String date);

  /// Panggil endpoint [host]/track/:id
  ///
  /// Throws [DioException] untuk semua error kode
  late String pathDeleteTrack;

  Future<GeneralResponse> deleteTrackUser(int trackId);
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

  @override
  String pathBulkCreateTrackData = '';

  @override
  Future<GeneralResponse> bulkCreateTrackData(BulkCreateTrackDataBody body) async {
    pathBulkCreateTrackData = '$baseUrl/bulk/data';
    final response = await dio.post(
      pathBulkCreateTrackData,
      data: body.toJson(),
      options: Options(
        headers: {
          baseUrlConfig.requiredToken: true,
        },
      ),
    );
    if (response.statusCode.toString().startsWith('2')) {
      return GeneralResponse.fromJson(response.data);
    } else {
      throw DioException(requestOptions: RequestOptions(path: pathBulkCreateTrackData));
    }
  }

  @override
  String pathBulkCreateTrackImage = '';

  @override
  Future<GeneralResponse> bulkCreateTrackImage(BulkCreateTrackImageBody body) async {
    final listMultipartFiles = <MultipartFile>[];
    for (final itemFile in body.files) {
      final file = await MultipartFile.fromFile(itemFile);
      listMultipartFiles.add(file);
    }
    final formDataMap = <String, dynamic>{
      'files[]': listMultipartFiles,
    };
    final formData = FormData.fromMap(formDataMap);
    pathBulkCreateTrackImage = '$baseUrl/bulk/image';
    final response = await dio.post(
      pathBulkCreateTrackImage,
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
      throw DioException(requestOptions: RequestOptions(path: pathBulkCreateTrackImage));
    }
  }

  @override
  String pathGetTrackUser = '';

  @override
  Future<TrackUserResponse> getTrackUser(String userId, String date) async {
    pathGetTrackUser = '$baseUrl/user';
    final response = await dio.get(
      pathGetTrackUser,
      queryParameters: {
        'user_id': userId,
        'date': date,
      },
      options: Options(
        headers: {
          baseUrlConfig.requiredToken: true,
        },
      ),
    );
    if (response.statusCode.toString().startsWith('2')) {
      return TrackUserResponse.fromJson(response.data);
    } else {
      throw DioException(requestOptions: RequestOptions(path: pathGetTrackUser));
    }
  }

  @override
  String pathDeleteTrack = '';

  @override
  Future<GeneralResponse> deleteTrackUser(int trackId) async {
    pathDeleteTrack = '$baseUrl/$trackId';
    final response = await dio.delete(
      pathDeleteTrack,
      options: Options(
        headers: {
          baseUrlConfig.requiredToken: true,
        },
      ),
    );
    if (response.statusCode.toString().startsWith('2')) {
      return GeneralResponse.fromJson(response.data);
    } else {
      throw DioException(requestOptions: RequestOptions(path: pathDeleteTrack));
    }
  }
}
