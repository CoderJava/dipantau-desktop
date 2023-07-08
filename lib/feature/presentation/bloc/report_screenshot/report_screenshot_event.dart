part of 'report_screenshot_bloc.dart';

abstract class ReportScreenshotEvent {}

class LoadReportScreenshotEvent extends ReportScreenshotEvent {
  final String userId;
  final String date;

  LoadReportScreenshotEvent({
    required this.userId,
    required this.date,
  });

  @override
  String toString() {
    return 'LoadReportScreenshotEvent{userId: $userId, date: $date}';
  }
}
