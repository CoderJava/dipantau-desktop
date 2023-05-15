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

class SuccessLoadDataTrackingState extends TrackingState {
  final TrackUserLiteResponse trackUserLite;

  SuccessLoadDataTrackingState({required this.trackUserLite});

  @override
  String toString() {
    return 'SuccessLoadDataTrackingState{trackUserLite: $trackUserLite}';
  }
}