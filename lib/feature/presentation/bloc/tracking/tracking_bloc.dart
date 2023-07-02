import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:dipantau_desktop_client/core/util/helper.dart';
import 'package:dipantau_desktop_client/feature/data/model/create_track/bulk_create_track_data_body.dart';
import 'package:dipantau_desktop_client/feature/data/model/create_track/create_track_body.dart';
import 'package:dipantau_desktop_client/feature/domain/usecase/bulk_create_track_data/bulk_create_track_data.dart';
import 'package:dipantau_desktop_client/feature/domain/usecase/create_track/create_track.dart';

part 'tracking_event.dart';

part 'tracking_state.dart';

class TrackingBloc extends Bloc<TrackingEvent, TrackingState> {
  final CreateTrack createTrack;
  final BulkCreateTrackData bulkCreateTrackData;
  final Helper helper;

  TrackingBloc({
    required this.createTrack,
    required this.bulkCreateTrackData,
    required this.helper,
  }) : super(InitialTrackingState()) {
    on<CreateTimeTrackingEvent>(_onCreateTimeTrackingEvent);

    on<SyncManualTrackingEvent>(_onSyncManualTrackingEvent);
  }

  FutureOr<void> _onCreateTimeTrackingEvent(
    CreateTimeTrackingEvent event,
    Emitter<TrackingState> emit,
  ) async {
    emit(LoadingTrackingState());
    final result = await createTrack(ParamsCreateTrack(body: event.body));
    final response = result.response;
    final failure = result.failure;
    if (response != null) {
      emit(SuccessCreateTimeTrackingState(files: event.body.files));
      return;
    }

    final errorMessage = helper.getErrorMessageFromFailure(failure);
    emit(FailureTrackingState(errorMessage: errorMessage));
  }

  FutureOr<void> _onSyncManualTrackingEvent(
    SyncManualTrackingEvent event,
    Emitter<TrackingState> emit,
  ) async {
    emit(LoadingTrackingState());
    await Future.delayed(const Duration(seconds: 2));
    final (:response, :failure) = await bulkCreateTrackData(ParamsBulkCreateTrackData(body: event.body));
    if (response != null) {
      emit(SuccessSyncManualTrackingState());
      return;
    }

    final errorMessage = helper.getErrorMessageFromFailure(failure);
    emit(FailureTrackingState(errorMessage: errorMessage));
  }
}
