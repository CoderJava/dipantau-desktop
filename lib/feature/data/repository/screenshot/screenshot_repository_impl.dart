import 'package:dio/dio.dart';
import 'package:dipantau_desktop_client/core/error/failure.dart';
import 'package:dipantau_desktop_client/core/network/network_info.dart';
import 'package:dipantau_desktop_client/feature/data/datasource/screenshot/screenshot_remote_data_source.dart';
import 'package:dipantau_desktop_client/feature/data/model/screenshot_refresh/screenshot_refresh_body.dart';
import 'package:dipantau_desktop_client/feature/data/model/screenshot_refresh/screenshot_refresh_response.dart';
import 'package:dipantau_desktop_client/feature/domain/repository/screenshot/screenshot_repository.dart';

class ScreenshotRepositoryImpl implements ScreenshotRepository {
  final ScreenshotRemoteDataSource remoteDataSource;
  final NetworkInfo networkInfo;

  ScreenshotRepositoryImpl({
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
  Future<({Failure? failure, ScreenshotRefreshResponse? response})> refreshScreenshot(
    ScreenshotRefreshBody body,
  ) async {
    Failure? failure;
    ScreenshotRefreshResponse? response;
    final isConnected = await networkInfo.isConnected;
    if (isConnected) {
      try {
        response = await remoteDataSource.refreshScreenshot(body);
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
