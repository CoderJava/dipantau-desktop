import 'package:dartz/dartz.dart';
import 'package:dipantau_desktop_client/core/error/failure.dart';
import 'package:dipantau_desktop_client/feature/data/model/login/login_body.dart';
import 'package:dipantau_desktop_client/feature/data/model/login/login_response.dart';
import 'package:dipantau_desktop_client/feature/data/model/refresh_token/refresh_token_body.dart';
import 'package:dipantau_desktop_client/feature/data/model/sign_up/sign_up_body.dart';
import 'package:dipantau_desktop_client/feature/data/model/sign_up/sign_up_response.dart';

abstract class AuthRepository {
  Future<Either<Failure, LoginResponse>> login(LoginBody body);

  Future<Either<Failure, SignUpResponse>> signUp(SignUpBody body);

  Future<Either<Failure, LoginResponse>> refreshToken(RefreshTokenBody body);
}
