import 'package:dartz/dartz.dart';
import 'package:dipantau_desktop_client/core/error/failure.dart';
import 'package:dipantau_desktop_client/core/usecase/usecase.dart';
import 'package:dipantau_desktop_client/feature/data/model/project/project_response.dart';
import 'package:dipantau_desktop_client/feature/domain/repository/project/project_repository.dart';
import 'package:equatable/equatable.dart';

class GetProject implements UseCase<ProjectResponse, ParamsGetProject> {
  final ProjectRepository repository;

  GetProject({required this.repository});

  @override
  Future<Either<Failure, ProjectResponse>> call(ParamsGetProject params) {
    return repository.getProject(params.userId);
  }
}

class ParamsGetProject extends Equatable {
  final String userId;

  ParamsGetProject({required this.userId});

  @override
  List<Object?> get props => [
    userId,
  ];

  @override
  String toString() {
    return 'ParamsGetProject{userId: $userId}';
  }
}