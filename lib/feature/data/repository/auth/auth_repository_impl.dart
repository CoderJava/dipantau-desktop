import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:dipantau_desktop_client/core/error/failure.dart';
import 'package:dipantau_desktop_client/core/network/network_info.dart';
import 'package:dipantau_desktop_client/feature/data/datasource/auth/auth_remote_data_source.dart';
import 'package:dipantau_desktop_client/feature/data/model/forgot_password/forgot_password_body.dart';
import 'package:dipantau_desktop_client/feature/data/model/general/general_response.dart';
import 'package:dipantau_desktop_client/feature/data/model/login/login_body.dart';
import 'package:dipantau_desktop_client/feature/data/model/login/login_response.dart';
import 'package:dipantau_desktop_client/feature/data/model/refresh_token/refresh_token_body.dart';
import 'package:dipantau_desktop_client/feature/data/model/sign_up/sign_up_body.dart';
import 'package:dipantau_desktop_client/feature/data/model/sign_up/sign_up_response.dart';
import 'package:dipantau_desktop_client/feature/domain/repository/auth/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;
  final NetworkInfo networkInfo;

  AuthRepositoryImpl({
    required this.remoteDataSource,
    required this.networkInfo,
  });

  String getErrorMessageFromEndpoint(dynamic dynamicErrorMessage, String httpErrorMessage, int? statusCode) {
    if (dynamicErrorMessage is Map && dynamicErrorMessage.containsKey('message')) {
      return '$statusCode ${dynamicErrorMessage['message']}';
    } else if (dynamicErrorMessage is String) {
      return httpErrorMessage;
    } else {
      return httpErrorMessage;
    }
  }

  @override
  Future<Either<Failure, LoginResponse>> login(LoginBody body) async {
    final isConnected = await networkInfo.isConnected;
    if (isConnected) {
      try {
        final response = await remoteDataSource.login(body);
        return Right(response);
      } on DioException catch (error) {
        final message = error.message ?? error.toString();
        if (error.response == null) {
          return Left(ServerFailure(message));
        }
        final errorMessage = getErrorMessageFromEndpoint(
          error.response?.data,
          message,
          error.response?.statusCode,
        );
        return Left(ServerFailure(errorMessage));
      } on TypeError catch (error) {
        final errorMessage = error.toString();
        return Left(ParsingFailure(errorMessage));
      }
    } else {
      return Left(ConnectionFailure());
    }
  }

  @override
  Future<Either<Failure, SignUpResponse>> signUp(SignUpBody body) async {
    final isConnected = await networkInfo.isConnected;
    if (isConnected) {
      try {
        final response = await remoteDataSource.signUp(body);
        return Right(response);
      } on DioException catch (error) {
        final message = error.message ?? error.toString();
        if (error.response == null) {
          return Left(ServerFailure(message));
        }
        final errorMessage = getErrorMessageFromEndpoint(
          error.response?.data,
          message,
          error.response?.statusCode,
        );
        return Left(ServerFailure(errorMessage));
      } on TypeError catch (error) {
        final errorMessage = error.toString();
        return Left(ParsingFailure(errorMessage));
      }
    } else {
      return Left(ConnectionFailure());
    }
  }

  @override
  Future<Either<Failure, LoginResponse>> refreshToken(RefreshTokenBody body) async {
    final isConnected = await networkInfo.isConnected;
    if (isConnected) {
      try {
        final response = await remoteDataSource.refreshToken(body);
        return Right(response);
      } on DioException catch (error) {
        final message = error.message ?? error.toString();
        if (error.response == null) {
          return Left(ServerFailure(message));
        }
        final errorMessage = getErrorMessageFromEndpoint(
          error.response?.data,
          message,
          error.response?.statusCode,
        );
        return Left(ServerFailure(errorMessage));
      } on TypeError catch (error) {
        final errorMessage = error.toString();
        return Left(ParsingFailure(errorMessage));
      }
    } else {
      return Left(ConnectionFailure());
    }
  }

  @override
  Future<({Failure? failure, GeneralResponse? response})> forgotPassword(ForgotPasswordBody body) async {
    Failure? failure;
    GeneralResponse? response;
    final isConnected = await networkInfo.isConnected;
    if (isConnected) {
      try {
        response = await remoteDataSource.forgotPassword(body);
      } on DioException catch (error) {
        final message = error.message ?? error.toString();
        if (error.response == null) {
          failure = ServerFailure(message);
        } else {
          final errorMessage = getErrorMessageFromEndpoint(
            error.response?.data,
            message,
            error.response?.statusCode,
          );
          failure = ServerFailure(errorMessage);
        }
      } on TypeError catch (error) {
        final errorMessage = error.toString();
        failure = ParsingFailure(errorMessage);
      }
    } else {
      failure = ConnectionFailure();
    }
    return (failure: failure, response: response);
  }
}
