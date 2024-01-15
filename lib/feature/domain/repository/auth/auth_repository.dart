import 'package:dartz/dartz.dart';
import 'package:dipantau_desktop_client/core/error/failure.dart';
import 'package:dipantau_desktop_client/feature/data/model/forgot_password/forgot_password_body.dart';
import 'package:dipantau_desktop_client/feature/data/model/general/general_response.dart';
import 'package:dipantau_desktop_client/feature/data/model/login/login_body.dart';
import 'package:dipantau_desktop_client/feature/data/model/login/login_response.dart';
import 'package:dipantau_desktop_client/feature/data/model/refresh_token/refresh_token_body.dart';
import 'package:dipantau_desktop_client/feature/data/model/reset_password/reset_password_body.dart';
import 'package:dipantau_desktop_client/feature/data/model/sign_up/sign_up_body.dart';
import 'package:dipantau_desktop_client/feature/data/model/sign_up/sign_up_response.dart';
import 'package:dipantau_desktop_client/feature/data/model/sign_up_by_user/sign_up_by_user_body.dart';
import 'package:dipantau_desktop_client/feature/data/model/verify_forgot_password/verify_forgot_password_body.dart';

abstract class AuthRepository {
  Future<Either<Failure, LoginResponse>> login(LoginBody body);

  Future<Either<Failure, SignUpResponse>> signUp(SignUpBody body);

  Future<Either<Failure, LoginResponse>> refreshToken(RefreshTokenBody body);

  Future<({Failure? failure, GeneralResponse? response})> forgotPassword(ForgotPasswordBody body);

  Future<({Failure? failure, GeneralResponse? response})> verifyForgotPassword(VerifyForgotPasswordBody body);

  Future<({Failure? failure, GeneralResponse? response})> resetPassword(ResetPasswordBody body);

  Future<({Failure? failure, GeneralResponse? response})> signUpByUser(SignUpByUserBody body);
}
