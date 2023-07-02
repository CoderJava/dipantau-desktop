part of 'tracking_bloc.dart';

abstract class TrackingEvent {
  const TrackingEvent();
}

class CreateTimeTrackingEvent extends TrackingEvent {
  final CreateTrackBody body;

  CreateTimeTrackingEvent({required this.body});

  @override
  String toString() {
    return 'CreateTimeTrackingEvent{body: $body}';
  }
}

class SyncManualTrackingEvent extends TrackingEvent {
  final BulkCreateTrackDataBody body;

  SyncManualTrackingEvent({required this.body});

  @override
  String toString() {
    return 'SyncManualTrackingEvent{body: $body}';
  }
}