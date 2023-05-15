import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:dipantau_desktop_client/core/error/failure.dart';
import 'package:dipantau_desktop_client/feature/data/model/track_user_lite/track_user_lite_response.dart';
import 'package:dipantau_desktop_client/feature/data/model/tracking_data/tracking_data_body.dart';
import 'package:dipantau_desktop_client/feature/domain/usecase/create_tracking_data/create_tracking_data.dart';
import 'package:dipantau_desktop_client/feature/domain/usecase/get_track_user_lite/get_track_user_lite.dart';

part 'tracking_event.dart';

part 'tracking_state.dart';

class TrackingBloc extends Bloc<TrackingEvent, TrackingState> {
  final CreateTrackingData createTrackingData;
  final GetTrackUserLite getTrackUserLite;

  TrackingBloc({
    required this.createTrackingData,
    required this.getTrackUserLite,
  }) : super(InitialTrackingState()) {
    on<CreateTimeTrackingEvent>(_onCreateTimeTrackingEvent);

    on<LoadDataTrackingEvent>(_onLoadDataTrackingEvent, transformer: restartable());
  }

  FutureOr<void> _onCreateTimeTrackingEvent(
    CreateTimeTrackingEvent event,
    Emitter<TrackingState> emit,
  ) async {
    emit(LoadingTrackingState());
    final result = await createTrackingData(
      ParamsCreateTrackingData(
        body: event.body,
      ),
    );
    emit(
      result.fold(
        (failure) {
          var errorMessage = ConstantErrorMessage().failureUnknown;
          if (failure is ServerFailure) {
            errorMessage = failure.errorMessage;
          } else if (failure is ConnectionFailure) {
            errorMessage = failure.errorMessage;
          } else if (failure is ParsingFailure) {
            errorMessage = failure.errorMessage;
          }
          return FailureTrackingState(errorMessage: errorMessage);
        },
        (response) => SuccessCreateTimeTrackingState(),
      ),
    );
  }

  FutureOr<void> _onLoadDataTrackingEvent(
    LoadDataTrackingEvent event,
    Emitter<TrackingState> emit,
  ) async {
    emit(LoadingTrackingState());
    final result = await getTrackUserLite(
      ParamsGetTrackUserLite(
        date: event.date,
        projectId: event.projectId,
      ),
    );
    emit(
      result.fold(
        (failure) {
          var errorMessage = ConstantErrorMessage().failureUnknown;
          if (failure is ServerFailure) {
            errorMessage = failure.errorMessage;
          } else if (failure is ConnectionFailure) {
            errorMessage = failure.errorMessage;
          } else if (failure is ParsingFailure) {
            errorMessage = failure.errorMessage;
          }
          return FailureTrackingState(errorMessage: errorMessage);
        },
        (response) => SuccessLoadDataTrackingState(trackUserLite: response),
      ),
    );
  }
}
