import 'package:dio/dio.dart';
import 'package:dipantau_desktop_client/config/flavor_config.dart';
import 'package:dipantau_desktop_client/feature/data/model/login/login_body.dart';
import 'package:dipantau_desktop_client/feature/data/model/login/login_response.dart';

abstract class AuthRemoteDataSource {
  /// Panggil endpoint [host]/auth/login
  ///
  /// Throws [DioError] untuk semua error kode
  late String pathLogin;

  Future<LoginResponse> login(LoginBody body);
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final Dio dio;

  AuthRemoteDataSourceImpl({
    required this.dio,
  });

  final baseUrl = FlavorConfig.instance.values.baseUrlAuth;

  @override
  String pathLogin = '';

  @override
  Future<LoginResponse> login(LoginBody body) async {
    pathLogin = '$baseUrl/login';
    final response = await dio.post(
      pathLogin,
      data: body.toJson(),
    );
    if (response.statusCode.toString().startsWith('2')) {
      return LoginResponse.fromJson(response.data);
    } else {
      throw DioError(requestOptions: RequestOptions(path: pathLogin));
    }
  }
}
