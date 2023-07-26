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