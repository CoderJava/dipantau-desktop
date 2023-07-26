part of 'cron_tracking_bloc.dart';

abstract class CronTrackingEvent {}

class RunCronTrackingEvent extends CronTrackingEvent {
  final BulkCreateTrackDataBody? bodyData;
  final BulkCreateTrackImageBody? bodyImage;

  RunCronTrackingEvent({
    required this.bodyData,
    required this.bodyImage,
  });

  @override
  String toString() {
    return 'RunCronTrackingEvent{bodyData: $bodyData, bodyImage: $bodyImage}';
  }
}