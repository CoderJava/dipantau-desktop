part of 'tracking_bloc.dart';

abstract class TrackingState {
  const TrackingState();
}

class InitialTrackingState extends TrackingState {}

class LoadingTrackingState extends TrackingState {}

class FailureTrackingState extends TrackingState {
  final String errorMessage;

  FailureTrackingState({required this.errorMessage});

  @override
  String toString() {
    return 'FailureTrackingState{errorMessage: $errorMessage}';
  }
}

class SuccessCreateTimeTrackingState extends TrackingState {}