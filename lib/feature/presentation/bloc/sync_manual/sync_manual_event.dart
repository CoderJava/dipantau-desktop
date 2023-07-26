part of 'sync_manual_bloc.dart';

abstract class SyncManualEvent {}

class RunSyncManualEvent extends SyncManualEvent {
  final BulkCreateTrackDataBody body;

  RunSyncManualEvent({required this.body});

  @override
  String toString() {
    return 'RunSyncManualEvent{body: $body}';
  }
}