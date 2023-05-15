part of 'tracking_bloc.dart';

abstract class TrackingEvent {
  const TrackingEvent();
}

class CreateTimeTrackingEvent extends TrackingEvent {
  final TrackingDataBody body;

  CreateTimeTrackingEvent({required this.body});

  @override
  String toString() {
    return 'CreateTimeTrackingEvent{body: $body}';
  }
}

class LoadDataTrackingEvent extends TrackingEvent {
  final String date;
  final String projectId;

  LoadDataTrackingEvent({
    required this.date,
    required this.projectId,
  });

  @override
  String toString() {
    return 'LoadDataTrackingEvent{date: $date, projectId: $projectId}';
  }
}
