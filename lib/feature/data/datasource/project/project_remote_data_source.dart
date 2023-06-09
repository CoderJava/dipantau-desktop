import 'package:dio/dio.dart';
import 'package:dipantau_desktop_client/config/base_url_config.dart';
import 'package:dipantau_desktop_client/config/flavor_config.dart';
import 'package:dipantau_desktop_client/feature/data/model/project/project_response.dart';

abstract class ProjectRemoteDataSource {
  /// Panggil endpoint [host]/project/user/:id
  /// path parameter
  /// id - nilai ID user
  ///
  /// Throws [DioError] untuk semua error kode
  late String pathGetProject;

  Future<ProjectResponse> getProject(String userId);
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
      throw DioError(requestOptions: RequestOptions(path: pathGetProject));
    }
  }
}
