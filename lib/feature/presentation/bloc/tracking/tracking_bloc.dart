import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:dipantau_desktop_client/core/error/failure.dart';
import 'package:dipantau_desktop_client/feature/data/model/create_track/create_track_body.dart';
import 'package:dipantau_desktop_client/feature/domain/usecase/create_track/create_track.dart';

part 'tracking_event.dart';

part 'tracking_state.dart';

class TrackingBloc extends Bloc<TrackingEvent, TrackingState> {
  final CreateTrack createTrack;

  TrackingBloc({
    required this.createTrack,
  }) : super(InitialTrackingState()) {
    on<CreateTimeTrackingEvent>(_onCreateTimeTrackingEvent);
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
      emit(SuccessCreateTimeTrackingState());
      return;
    }

    var errorMessage = ConstantErrorMessage().failureUnknown;
    switch (failure) {
      case ServerFailure():
        errorMessage = failure.errorMessage;
        break;
      case ConnectionFailure():
        errorMessage = failure.errorMessage;
        break;
      case ParsingFailure():
        errorMessage = failure.errorMessage;
        break;
      default:
        /* Nothing to do in here */
    }
    emit(FailureTrackingState(errorMessage: errorMessage));
  }
}
