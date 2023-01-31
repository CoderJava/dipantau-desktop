import 'package:dartz/dartz.dart';
import 'package:dipantau_desktop_client/core/error/failure.dart';
import 'package:dipantau_desktop_client/core/usecase/usecase.dart';
import 'package:dipantau_desktop_client/feature/data/model/project/project_response.dart';
import 'package:dipantau_desktop_client/feature/domain/repository/general/general_repository.dart';
import 'package:equatable/equatable.dart';

class GetProject implements UseCase<ProjectResponse, ParamsGetProject> {
  final GeneralRepository generalRepository;

  GetProject({required this.generalRepository});

  @override
  Future<Either<Failure, ProjectResponse>> call(ParamsGetProject params) {
    return generalRepository.getProject(params.email);
  }
}

class ParamsGetProject extends Equatable {
  final String email;

  ParamsGetProject({required this.email});

  @override
  List<Object?> get props => [
    email,
  ];

  @override
  String toString() {
    return 'ParamsGetProject{email: $email}';
  }
}