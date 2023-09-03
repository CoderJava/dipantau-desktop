part of 'manual_tracking_bloc.dart';

abstract class ManualTrackingState {}

class InitialManualTrackingState extends ManualTrackingState {}

class LoadingManualTrackingState extends ManualTrackingState {}

class FailureManualTrackingState extends ManualTrackingState {
  final String errorMessage;

  FailureManualTrackingState({required this.errorMessage});

  @override
  String toString() {
    return 'FailureManualTrackingState{errorMessage: $errorMessage}';
  }
}

class FailureCenterManualTrackingState extends ManualTrackingState {
  final String errorMessage;

  FailureCenterManualTrackingState({required this.errorMessage});

  @override
  String toString() {
    return 'FailureCenterManualTrackingState{errorMessage: $errorMessage}';
  }
}

class SuccessCreateManualTrackingState extends ManualTrackingState {}

class SuccessLoadDataProjectTaskManualTrackingState extends ManualTrackingState {
  final ProjectTaskResponse response;

  SuccessLoadDataProjectTaskManualTrackingState({
    required this.response,
  });

  @override
  String toString() {
    return 'SuccessLoadDataProjectTaskManualTrackingState{response: $response}';
  }
}
