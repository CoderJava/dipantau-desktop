import 'package:dio/dio.dart';
import 'package:dipantau_desktop_client/config/flavor_config.dart';
import 'package:dipantau_desktop_client/feature/data/model/general/general_response.dart';

abstract class GeneralRemoteDataSource {
  /// Panggil endpoint [host]/api/ping
  ///
  /// Throws [DioException] untuk semua error kode
  late String pathPing;

  Future<GeneralResponse> ping();
}

class GeneralRemoteDataSourceImpl implements GeneralRemoteDataSource {
  final Dio dio;

  GeneralRemoteDataSourceImpl({
    required this.dio,
  });

  final baseUrl = FlavorConfig.instance.values.baseUrl;

  @override
  String pathPing = '';

  @override
  Future<GeneralResponse> ping() async {
    pathPing = '$baseUrl/api/ping';
    final response = await dio.get(pathPing);
    if (response.statusCode.toString().startsWith('2')) {
      return GeneralResponse.fromJson(response.data);
    } else {
      throw DioException(requestOptions: RequestOptions(path: pathPing));
    }
  }
}
