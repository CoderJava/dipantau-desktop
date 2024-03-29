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

class SuccessCreateTimeTrackingState extends TrackingState {
  final List<String> files;
  final int trackEntityId;

  SuccessCreateTimeTrackingState({
    required this.files,
    required this.trackEntityId,
  });

  @override
  String toString() {
    return 'SuccessCreateTimeTrackingState{files: $files, trackEntityId: $trackEntityId}';
  }
}

class SuccessDeleteTrackUserTrackingState extends TrackingState {
  final int trackId;

  SuccessDeleteTrackUserTrackingState({required this.trackId});

  @override
  String toString() {
    return 'SuccessDeleteTrackUserTrackingState{trackId: $trackId}';
  }
}
