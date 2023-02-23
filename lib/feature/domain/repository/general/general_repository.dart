import 'package:dartz/dartz.dart';
import 'package:dipantau_desktop_client/core/error/failure.dart';
import 'package:dipantau_desktop_client/feature/data/model/general/general_response.dart';
import 'package:dipantau_desktop_client/feature/data/model/project/project_response.dart';
import 'package:dipantau_desktop_client/feature/data/model/tracking_data/tracking_data_body.dart';

abstract class GeneralRepository {
  Future<Either<Failure, ProjectResponse>> getProject(String email);

  Future<Either<Failure, GeneralResponse>> createTrackingData(TrackingDataBody body);
}