import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:dipantau_desktop_client/core/error/failure.dart';
import 'package:dipantau_desktop_client/core/network/network_info.dart';
import 'package:dipantau_desktop_client/feature/data/datasource/general/general_remote_data_source.dart';
import 'package:dipantau_desktop_client/feature/data/model/general/general_response.dart';
import 'package:dipantau_desktop_client/feature/data/model/project/project_response_bak.dart';
import 'package:dipantau_desktop_client/feature/data/model/tracking_data/tracking_data_body.dart';
import 'package:dipantau_desktop_client/feature/domain/repository/general/general_repository.dart';

class GeneralRepositoryImpl implements GeneralRepository {
  final GeneralRemoteDataSource generalRemoteDataSource;
  final NetworkInfo networkInfo;

  GeneralRepositoryImpl({
    required this.generalRemoteDataSource,
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
  Future<Either<Failure, ProjectResponseBak>> getProject(String email) async {
    final isConnected = await networkInfo.isConnected;
    if (isConnected) {
      try {
        final response = await generalRemoteDataSource.getProject(email);
        return Right(response);
      } on DioError catch (error) {
        if (error.response == null) {
          return Left(ServerFailure(error.message));
        }
        final errorMessage = getErrorMessageFromEndpoint(
          error.response?.data,
          error.message,
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
  Future<Either<Failure, GeneralResponse>> createTrackingData(TrackingDataBody body) async {
    final isConnected = await networkInfo.isConnected;
    if (isConnected) {
      try {
        final response = await generalRemoteDataSource.createTrackingData(body);
        return Right(response);
      } on DioError catch (error) {
        if (error.response == null) {
          return Left(ServerFailure(error.message));
        }
        final errorMessage = getErrorMessageFromEndpoint(
          error.response?.data,
          error.message,
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
