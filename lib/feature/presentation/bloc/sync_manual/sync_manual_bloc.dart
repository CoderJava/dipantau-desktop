import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:dipantau_desktop_client/core/util/helper.dart';
import 'package:dipantau_desktop_client/feature/data/model/create_track/bulk_create_track_data_body.dart';
import 'package:dipantau_desktop_client/feature/domain/usecase/bulk_create_track_data/bulk_create_track_data.dart';

part 'sync_manual_event.dart';

part 'sync_manual_state.dart';

class SyncManualBloc extends Bloc<SyncManualEvent, SyncManualState> {
  final Helper helper;
  final BulkCreateTrackData bulkCreateTrackData;

  SyncManualBloc({
    required this.helper,
    required this.bulkCreateTrackData,
  }) : super(InitialSyncManualState()) {
    on<RunSyncManualEvent>(_onRunSyncManualEvent, transformer: restartable());
  }

  FutureOr<void> _onRunSyncManualEvent(
    RunSyncManualEvent event,
    Emitter<SyncManualState> emit,
  ) async {
    emit(LoadingSyncManualState());
    await Future.delayed(const Duration(milliseconds: 2500));
    final (:response, :failure) = await bulkCreateTrackData(
      ParamsBulkCreateTrackData(
        body: event.body,
      ),
    );
    if (response != null) {
      emit(SuccessRunSyncManualState());
      return;
    }

    final errorMessage = helper.getErrorMessageFromFailure(failure);
    emit(FailureSyncManualState(errorMessage: errorMessage));
  }
}
