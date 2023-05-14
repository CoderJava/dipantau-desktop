part of 'home_bloc.dart';

abstract class HomeState extends Equatable {
  const HomeState();

  @override
  List<Object?> get props => [];
}

class InitialHomeState extends HomeState {}

class LoadingHomeState extends HomeState {}

class FailureHomeState extends HomeState {
  final String errorMessage;

  FailureHomeState({required this.errorMessage});

  @override
  List<Object?> get props => [
    errorMessage,
  ];

  @override
  String toString() {
    return 'FailureHomeState{errorMessage: $errorMessage}';
  }
}

class SuccessPrepareDataHomeState extends HomeState {
  final UserProfileResponse? user;

  SuccessPrepareDataHomeState({required this.user});

  @override
  List<Object?> get props => [
    user,
  ];

  @override
  String toString() {
    return 'SuccessPrepareDataHomeState{user: $user}';
  }
}

class SuccessLoadDataProjectHomeState extends HomeState {
  final ProjectResponseBak project;

  SuccessLoadDataProjectHomeState({required this.project});

  @override
  List<Object?> get props => [
    project,
  ];

  @override
  String toString() {
    return 'SuccessLoadDataProjectHomeState{project: $project}';
  }
}