import 'package:dartz/dartz.dart';
import 'package:dipantau_desktop_client/core/error/failure.dart';
import 'package:dipantau_desktop_client/feature/data/model/project/project_response.dart';

abstract class GeneralRepository {
  Future<Either<Failure, ProjectResponse>> getProject(String email);
}