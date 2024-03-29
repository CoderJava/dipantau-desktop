import 'package:dio/dio.dart';
import 'package:dipantau_desktop_client/core/error/failure.dart';
import 'package:dipantau_desktop_client/core/network/network_info.dart';
import 'package:dipantau_desktop_client/feature/data/datasource/setting/setting_remote_data_source.dart';
import 'package:dipantau_desktop_client/feature/data/model/all_user_setting/all_user_setting_response.dart';
import 'package:dipantau_desktop_client/feature/data/model/kv_setting/kv_setting_body.dart';
import 'package:dipantau_desktop_client/feature/data/model/kv_setting/kv_setting_response.dart';
import 'package:dipantau_desktop_client/feature/data/model/user_setting/user_setting_body.dart';
import 'package:dipantau_desktop_client/feature/data/model/user_setting/user_setting_response.dart';
import 'package:dipantau_desktop_client/feature/domain/repository/setting/setting_repository.dart';

class SettingRepositoryImpl implements SettingRepository {
  final SettingRemoteDataSource remoteDataSource;
  final NetworkInfo networkInfo;

  SettingRepositoryImpl({
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
  Future<({Failure? failure, KvSettingResponse? response})> getKvSetting() async {
    Failure? failure;
    KvSettingResponse? response;
    final isConnected = await networkInfo.isConnected;
    if (isConnected) {
      try {
        response = await remoteDataSource.getKvSetting();
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
  Future<({Failure? failure, bool? response})> setKvSetting(KvSettingBody body) async {
    Failure? failure;
    bool? response;
    final isConnected = await networkInfo.isConnected;
    if (isConnected) {
      try {
        response = await remoteDataSource.setKvSetting(body);
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
  Future<({Failure? failure, AllUserSettingResponse? response})> getAllUserSetting() async {
    Failure? failure;
    AllUserSettingResponse? response;
    final isConnected = await networkInfo.isConnected;
    if (isConnected) {
      try {
        response = await remoteDataSource.getAllUserSetting();
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
  Future<({Failure? failure, UserSettingResponse? response})> getUserSetting() async {
    Failure? failure;
    UserSettingResponse? response;
    final isConnected = await networkInfo.isConnected;
    if (isConnected) {
      try {
        response = await remoteDataSource.getUserSetting();
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
  Future<({Failure? failure, bool? response})> updateUserSetting(UserSettingBody body) async {
    Failure? failure;
    bool? response;
    final isConnected = await networkInfo.isConnected;
    if (isConnected) {
      try {
        response = await remoteDataSource.updateUserSetting(body);
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
