import 'package:dartz/dartz.dart';
import 'package:dipantau_desktop_client/core/error/failure.dart';
import 'package:dipantau_desktop_client/feature/data/model/project/project_response.dart';
import 'package:dipantau_desktop_client/feature/data/model/project_task/project_task_response.dart';

abstract class ProjectRepository {
  Future<Either<Failure, ProjectResponse>> getProject(String userId);

  Future<({Failure? failure, ProjectTaskResponse? response})> getProjectTaskByUserId(String userId);
}