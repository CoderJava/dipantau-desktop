part of 'project_bloc.dart';

abstract class ProjectState extends Equatable {
  const ProjectState();

  @override
  List<Object?> get props => [];
}

class InitialProjectState extends ProjectState {}

class LoadingProjectState extends ProjectState {}

class FailureProjectState extends ProjectState {
  final String errorMessage;

  FailureProjectState({required this.errorMessage});

  @override
  List<Object?> get props => [
    errorMessage,
  ];

  @override
  String toString() {
    return 'FailureProjectState{errorMessage: $errorMessage}';
  }
}

class SuccessLoadDataProjectState extends ProjectState {
  final ProjectResponse project;

  SuccessLoadDataProjectState({required this.project});

  @override
  List<Object?> get props => [
    project,
  ];

  @override
  String toString() {
    return 'SuccessLoadDataProjectState{project: $project}';
  }
}