import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:dipantau_desktop_client/core/error/failure.dart';
import 'package:dipantau_desktop_client/core/network/network_info.dart';
import 'package:dipantau_desktop_client/feature/data/datasource/user/user_remote_data_source.dart';
import 'package:dipantau_desktop_client/feature/data/model/user_profile/list_user_profile_response.dart';
import 'package:dipantau_desktop_client/feature/data/model/user_profile/user_profile_response.dart';
import 'package:dipantau_desktop_client/feature/domain/repository/user/user_repository.dart';

class UserRepositoryImpl implements UserRepository {
  final UserRemoteDataSource remoteDataSource;
  final NetworkInfo networkInfo;

  UserRepositoryImpl({
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
  Future<Either<Failure, UserProfileResponse>> getProfile() async {
    final isConnected = await networkInfo.isConnected;
    if (isConnected) {
      try {
        final response = await remoteDataSource.getProfile();
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
  Future<Either<Failure, ListUserProfileResponse>> getAllMembers() async {
    final isConnected = await networkInfo.isConnected;
    if (isConnected) {
      try {
        final response = await remoteDataSource.getAllMembers();
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
}