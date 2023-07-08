part of 'report_screenshot_bloc.dart';

abstract class ReportScreenshotState {}

class InitialReportScreenshotState extends ReportScreenshotState {}

class LoadingCenterReportScreenshotState extends ReportScreenshotState {}

class FailureReportScreenshotState extends ReportScreenshotState {
  final String errorMessage;

  FailureReportScreenshotState({required this.errorMessage});

  @override
  String toString() {
    return 'FailureReportScreenshotState{errorMessage: $errorMessage}';
  }
}

class SuccessLoadReportScreenshotState extends ReportScreenshotState {
  final TrackUserResponse response;

  SuccessLoadReportScreenshotState({
    required this.response,
  });

  @override
  String toString() {
    return 'SuccessLoadReportScreenshotState{response: $response}';
  }
}
