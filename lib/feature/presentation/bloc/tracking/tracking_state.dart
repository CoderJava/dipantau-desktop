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

class SuccessCronTrackingState extends TrackingState {
  final List<int> ids;
  final List<String> files;

  SuccessCronTrackingState({
    required this.ids,
    required this.files,
  });

  @override
  String toString() {
    return 'SuccessCronTrackingState{ids: $ids, files: $files}';
  }
}
