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
