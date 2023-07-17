part of 'tracking_bloc.dart';

abstract class TrackingEvent {
  const TrackingEvent();
}

class CreateTimeTrackingEvent extends TrackingEvent {
  final CreateTrackBody body;
  final int trackEntityId;

  CreateTimeTrackingEvent({
    required this.body,
    required this.trackEntityId,
  });

  @override
  String toString() {
    return 'CreateTimeTrackingEvent{body: $body, trackEntityId: $trackEntityId}';
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

class CronTrackingEvent extends TrackingEvent {
  final BulkCreateTrackDataBody? bodyData;
  final BulkCreateTrackImageBody? bodyImage;

  CronTrackingEvent({
    required this.bodyData,
    required this.bodyImage,
  });

  @override
  String toString() {
    return 'CronTrackingEvent{bodyData: $bodyData, bodyImage: $bodyImage}';
  }
}
