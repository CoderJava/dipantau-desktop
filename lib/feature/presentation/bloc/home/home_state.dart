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

class SuccessLoadDataHomeState extends HomeState {
  final TrackUserLiteResponse trackUserLiteResponse;

  SuccessLoadDataHomeState({
    required this.trackUserLiteResponse,
  });

  @override
  List<Object?> get props => [
    trackUserLiteResponse,
  ];

  @override
  String toString() {
    return 'SuccessLoadDataHomeState{trackUserLiteResponse: $trackUserLiteResponse}';
  }
}
