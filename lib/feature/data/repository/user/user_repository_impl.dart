import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:dipantau_desktop_client/core/error/failure.dart';
import 'package:dipantau_desktop_client/core/network/network_info.dart';
import 'package:dipantau_desktop_client/feature/data/datasource/user/user_remote_data_source.dart';
import 'package:dipantau_desktop_client/feature/data/model/general/general_response.dart';
import 'package:dipantau_desktop_client/feature/data/model/update_user/update_user_body.dart';
import 'package:dipantau_desktop_client/feature/data/model/user_profile/list_user_profile_response.dart';
import 'package:dipantau_desktop_client/feature/data/model/user_profile/user_profile_response.dart';
import 'package:dipantau_desktop_client/feature/data/model/user_sign_up_approval/user_sign_up_approval_body.dart';
import 'package:dipantau_desktop_client/feature/data/model/user_sign_up_waiting/user_sign_up_waiting_response.dart';
import 'package:dipantau_desktop_client/feature/domain/repository/user/user_repository.dart';
import 'package:dipantau_desktop_client/feature/domain/usecase/user_version/user_version_body.dart';

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
  Future<({Failure? failure, ListUserProfileResponse? response})> getAllMembers() async {
    Failure? failure;
    ListUserProfileResponse? response;
    final isConnected = await networkInfo.isConnected;
    if (isConnected) {
      try {
        response = await remoteDataSource.getAllMembers();
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

  @override
  Future<({Failure? failure, bool? response})> updateUser(UpdateUserBody body, int id) async {
    Failure? failure;
    bool? response;
    final isConnected = await networkInfo.isConnected;
    if (isConnected) {
      try {
        response = await remoteDataSource.updateUser(body, id);
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

  @override
  Future<({Failure? failure, bool? response})> sendAppVersion(UserVersionBody body) async {
    Failure? failure;
    bool? response;
    final isConnected = await networkInfo.isConnected;
    if (isConnected) {
      try {
        response = await remoteDataSource.sendAppVersion(body);
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

  @override
  Future<({Failure? failure, UserSignUpWaitingResponse? response})> getUserSignUpWaiting() async {
    Failure? failure;
    UserSignUpWaitingResponse? response;
    final isConnected = await networkInfo.isConnected;
    if (isConnected) {
      try {
        response = await remoteDataSource.getUserSignUpWaiting();
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

  @override
  Future<({Failure? failure, GeneralResponse? response})> userSignUpApproval(UserSignUpApprovalBody body) async {
    Failure? failure;
    GeneralResponse? response;
    final isConnected = await networkInfo.isConnected;
    if (isConnected) {
      try {
        response = await remoteDataSource.userSignUpApproval(body);
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
