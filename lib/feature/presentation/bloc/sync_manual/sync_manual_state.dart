part of 'sync_manual_bloc.dart';

abstract class SyncManualState {}

class InitialSyncManualState extends SyncManualState {}

class LoadingSyncManualState extends SyncManualState {}

class FailureSyncManualState extends SyncManualState {
  final String errorMessage;

  FailureSyncManualState({required this.errorMessage});

  @override
  String toString() {
    return 'FailureSyncManualState{errorMessage: $errorMessage}';
  }
}

class SuccessRunSyncManualState extends SyncManualState {}
