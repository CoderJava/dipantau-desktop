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

class SuccessCreateManualTrackingState extends ManualTrackingState {}