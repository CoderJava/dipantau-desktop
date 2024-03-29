import 'package:dio/dio.dart';
import 'package:dipantau_desktop_client/config/flavor_config.dart';
import 'package:dipantau_desktop_client/core/util/enum/user_role.dart';
import 'package:dipantau_desktop_client/feature/data/model/forgot_password/forgot_password_body.dart';
import 'package:dipantau_desktop_client/feature/data/model/general/general_response.dart';
import 'package:dipantau_desktop_client/feature/data/model/login/login_body.dart';
import 'package:dipantau_desktop_client/feature/data/model/login/login_response.dart';
import 'package:dipantau_desktop_client/feature/data/model/refresh_token/refresh_token_body.dart';
import 'package:dipantau_desktop_client/feature/data/model/reset_password/reset_password_body.dart';
import 'package:dipantau_desktop_client/feature/data/model/sign_up/sign_up_body.dart';
import 'package:dipantau_desktop_client/feature/data/model/sign_up/sign_up_response.dart';
import 'package:dipantau_desktop_client/feature/data/model/verify_forgot_password/verify_forgot_password_body.dart';

abstract class AuthRemoteDataSource {
  /// Panggil endpoint [host]/auth/login
  ///
  /// Throws [DioException] untuk semua error kode
  late String pathLogin;

  Future<LoginResponse> login(LoginBody body);

  /// Panggil endpoint [host]/auth/signup
  ///
  /// Throws [DioException] untuk semua error kode
  late String pathSignUp;

  Future<SignUpResponse> signUp(SignUpBody body);

  /// Panggil endpoint [host]/auth/refresh
  ///
  /// Throws [DioException] untuk semua error kode
  late String pathRefreshToken;

  Future<LoginResponse> refreshToken(RefreshTokenBody body);

  /// Panggil endpoint [host]/auth/forgot-password
  late String pathForgotPassword;

  Future<GeneralResponse> forgotPassword(ForgotPasswordBody body);

  /// Panggil endpoint [host]/auth/forgot-password/verify
  late String pathVerifyForgotPassword;

  Future<GeneralResponse> verifyForgotPassword(VerifyForgotPasswordBody body);

  /// Panggil endpoint [host]/auth/reset-password
  late String pathResetPassword;

  Future<GeneralResponse> resetPassword(ResetPasswordBody body);
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
      throw DioException(requestOptions: RequestOptions(path: pathLogin));
    }
  }

  @override
  String pathSignUp = '';

  @override
  Future<SignUpResponse> signUp(SignUpBody body) async {
    pathSignUp = '$baseUrl/signup';
    var data = body.toJson();
    String strUserRole;
    switch (body.userRole) {
      case UserRole.superAdmin:
        strUserRole = 'super_admin';
        break;
      case UserRole.admin:
        strUserRole = 'admin';
        break;
      case UserRole.employee:
        strUserRole = 'employee';
        break;
    }
    data['user_role'] = strUserRole;
    final response = await dio.post(
      pathSignUp,
      data: data,
    );
    if (response.statusCode.toString().startsWith('2')) {
      return SignUpResponse.fromJson(response.data);
    } else {
      throw DioException(requestOptions: RequestOptions(path: pathSignUp));
    }
  }

  @override
  String pathRefreshToken = '';

  @override
  Future<LoginResponse> refreshToken(RefreshTokenBody body) async {
    pathRefreshToken = '$baseUrl/refresh';
    final response = await dio.post(
      pathRefreshToken,
      data: body.toJson(),
    );
    if (response.statusCode.toString().startsWith('2')) {
      return LoginResponse.fromJson(response.data);
    } else {
      throw DioException(requestOptions: RequestOptions(path: pathRefreshToken));
    }
  }

  @override
  String pathForgotPassword = '';

  @override
  Future<GeneralResponse> forgotPassword(ForgotPasswordBody body) async {
    pathForgotPassword = '$baseUrl/forgot-password';
    final response = await dio.post(
      pathForgotPassword,
      data: body.toJson(),
    );
    if (response.statusCode.toString().startsWith('2')) {
      return GeneralResponse.fromJson(response.data);
    } else {
      throw DioException(requestOptions: RequestOptions(path: pathForgotPassword));
    }
  }

  @override
  String pathVerifyForgotPassword = '';

  @override
  Future<GeneralResponse> verifyForgotPassword(VerifyForgotPasswordBody body) async {
    pathVerifyForgotPassword = '$baseUrl/forgot-password/verify';
    final response = await dio.post(
      pathVerifyForgotPassword,
      data: body.toJson(),
    );
    if (response.statusCode.toString().startsWith('2')) {
      return GeneralResponse.fromJson(response.data);
    } else {
      throw DioException(requestOptions: RequestOptions(path: pathVerifyForgotPassword));
    }
  }

  @override
  String pathResetPassword = '';

  @override
  Future<GeneralResponse> resetPassword(ResetPasswordBody body) async {
    pathResetPassword = '$baseUrl/reset-password';
    final response = await dio.post(
      pathResetPassword,
      data: body.toJson(),
    );
    if (response.statusCode.toString().startsWith('2')) {
      return GeneralResponse.fromJson(response.data);
    } else {
      throw DioException(requestOptions: RequestOptions(path: pathResetPassword));
    }
  }
}
