import 'package:dio/dio.dart';
import 'package:dipantau_desktop_client/config/base_url_config.dart';
import 'package:dipantau_desktop_client/config/flavor_config.dart';
import 'package:dipantau_desktop_client/feature/data/model/project/project_response.dart';
import 'package:dipantau_desktop_client/feature/data/model/project_task/project_task_response.dart';

abstract class ProjectRemoteDataSource {
  /// Panggil endpoint [host]/project/user/:id
  /// path parameter
  /// id - nilai ID user
  ///
  /// Throws [DioException] untuk semua error kode
  late String pathGetProject;

  Future<ProjectResponse> getProject(String userId);

  /// Panggil endpoint [host]/project/user/:id/detail
  /// path parameter
  /// id - nilai ID user
  ///
  /// Throws [DioException] untuk semua error kode
  late String pathGetProjectTaskByUserId;

  Future<ProjectTaskResponse> getProjectTaskByUserId(String userId);
}

class ProjectRemoteDataSourceImpl implements ProjectRemoteDataSource {
  final Dio dio;

  ProjectRemoteDataSourceImpl({
    required this.dio,
  });

  final baseUrl = FlavorConfig.instance.values.baseUrlProject;
  final baseUrlConfig = BaseUrlConfig();

  @override
  String pathGetProject = '';

  @override
  Future<ProjectResponse> getProject(String userId) async {
    pathGetProject = '$baseUrl/user/$userId';
    final response = await dio.get(
      pathGetProject,
      options: Options(
        headers: {
          baseUrlConfig.requiredToken: true,
        },
      ),
    );
    if (response.statusCode.toString().startsWith('2')) {
      return ProjectResponse.fromJson(response.data);
    } else {
      throw DioException(requestOptions: RequestOptions(path: pathGetProject));
    }
  }

  @override
  String pathGetProjectTaskByUserId = '';

  @override
  Future<ProjectTaskResponse> getProjectTaskByUserId(String userId) async {
    pathGetProjectTaskByUserId = '$baseUrl/user/$userId/detail';
    final response = await dio.get(
      pathGetProjectTaskByUserId,
      options: Options(
        headers: {
          baseUrlConfig.requiredToken: true,
        },
      ),
    );
    if (response.statusCode.toString().startsWith('2')) {
      return ProjectTaskResponse.fromJson(response.data);
    } else {
      throw DioException(requestOptions: RequestOptions(path: pathGetProjectTaskByUserId));
    }
  }
}
