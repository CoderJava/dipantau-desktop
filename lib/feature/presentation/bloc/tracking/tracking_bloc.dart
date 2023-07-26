import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:dipantau_desktop_client/core/util/helper.dart';
import 'package:dipantau_desktop_client/feature/data/model/create_track/create_track_body.dart';
import 'package:dipantau_desktop_client/feature/domain/usecase/create_track/create_track.dart';

part 'tracking_event.dart';

part 'tracking_state.dart';

class TrackingBloc extends Bloc<TrackingEvent, TrackingState> {
  final CreateTrack createTrack;
  final Helper helper;

  TrackingBloc({
    required this.createTrack,
    required this.helper,
  }) : super(InitialTrackingState()) {
    on<CreateTimeTrackingEvent>(_onCreateTimeTrackingEvent, transformer: sequential());
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
      emit(
        SuccessCreateTimeTrackingState(
          files: event.body.files,
          trackEntityId: event.trackEntityId,
        ),
      );
      return;
    }

    final errorMessage = helper.getErrorMessageFromFailure(failure);
    emit(FailureTrackingState(errorMessage: errorMessage));
  }
}
