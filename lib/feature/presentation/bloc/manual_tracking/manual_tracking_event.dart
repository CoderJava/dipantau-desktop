part of 'manual_tracking_bloc.dart';

abstract class ManualTrackingEvent {}

class CreateManualTrackingEvent extends ManualTrackingEvent {
  final ManualCreateTrackBody body;

  CreateManualTrackingEvent({
    required this.body,
  });

  @override
  String toString() {
    return 'CreateManualTrackingEvent{body: $body}';
  }
}
