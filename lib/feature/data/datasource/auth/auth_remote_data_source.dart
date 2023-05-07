import 'package:dio/dio.dart';
import 'package:dipantau_desktop_client/config/flavor_config.dart';
import 'package:dipantau_desktop_client/feature/data/model/login/login_body.dart';
import 'package:dipantau_desktop_client/feature/data/model/login/login_response.dart';
import 'package:dipantau_desktop_client/feature/data/model/sign_up/sign_up_body.dart';
import 'package:dipantau_desktop_client/feature/data/model/sign_up/sign_up_response.dart';

abstract class AuthRemoteDataSource {
  /// Panggil endpoint [host]/auth/login
  ///
  /// Throws [DioError] untuk semua error kode
  late String pathLogin;

  Future<LoginResponse> login(LoginBody body);

  /// Panggil endpoint [host]/auth/signup
  ///
  /// Throws [DioError] untuk semua error kode
  late String pathSignUp;

  Future<SignUpResponse> signUp(SignUpBody body);
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

  @override
  String pathSignUp = '';

  @override
  Future<SignUpResponse> signUp(SignUpBody body) async {
    pathSignUp = '$baseUrl/signup';
    final response = await dio.post(
      pathSignUp,
      data: body.toJson(),
    );
    if (response.statusCode.toString().startsWith('2')) {
      return SignUpResponse.fromJson(response.data);
    } else {
      throw DioError(requestOptions: RequestOptions(path: pathSignUp));
    }
  }
}
