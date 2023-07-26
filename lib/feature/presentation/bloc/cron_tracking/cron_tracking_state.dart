part of 'cron_tracking_bloc.dart';

abstract class CronTrackingState {}

class InitialCronTrackingState extends CronTrackingState {}

class LoadingCronTrackingState extends CronTrackingState {}

class FailureCronTrackingState extends CronTrackingState {
  final String errorMessage;

  FailureCronTrackingState({
    required this.errorMessage,
  });

  @override
  String toString() {
    return 'FailureCronTrackingState{errorMessage: $errorMessage}';
  }
}

class SuccessRunCronTrackingState extends CronTrackingState {
  final List<int> ids;
  final List<String> files;

  SuccessRunCronTrackingState({
    required this.ids,
    required this.files,
  });

  @override
  String toString() {
    return 'SuccessRunCronTrackingState{ids: $ids, files: $files}';
  }
}
