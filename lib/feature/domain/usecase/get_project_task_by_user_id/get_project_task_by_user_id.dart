import 'package:dipantau_desktop_client/core/error/failure.dart';
import 'package:dipantau_desktop_client/core/usecase/usecase.dart';
import 'package:dipantau_desktop_client/feature/data/model/project_task/project_task_response.dart';
import 'package:dipantau_desktop_client/feature/domain/repository/project/project_repository.dart';
import 'package:equatable/equatable.dart';

class GetProjectTaskByUserId implements UseCaseRecords<ProjectTaskResponse?, ParamsGetProjectTaskByUserId> {
  final ProjectRepository repository;

  GetProjectTaskByUserId({required this.repository});

  @override
  Future<({Failure? failure, ProjectTaskResponse? response})> call(ParamsGetProjectTaskByUserId params) async {
    return repository.getProjectTaskByUserId(params.userId);
  }
}

class ParamsGetProjectTaskByUserId extends Equatable {
  final String userId;

  ParamsGetProjectTaskByUserId({required this.userId});

  @override
  List<Object?> get props => [
        userId,
      ];

  @override
  String toString() {
    return 'ParamsGetProjectTaskByUserId{userId: $userId}';
  }
}
