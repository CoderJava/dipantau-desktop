import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:dipantau_desktop_client/core/util/helper.dart';
import 'package:dipantau_desktop_client/feature/data/model/manual_create_track/manual_create_track_body.dart';
import 'package:dipantau_desktop_client/feature/data/model/project_task/project_task_response.dart';
import 'package:dipantau_desktop_client/feature/domain/usecase/create_manual_track/create_manual_track.dart';
import 'package:dipantau_desktop_client/feature/domain/usecase/get_project_task_by_user_id/get_project_task_by_user_id.dart';

part 'manual_tracking_event.dart';

part 'manual_tracking_state.dart';

class ManualTrackingBloc extends Bloc<ManualTrackingEvent, ManualTrackingState> {
  final Helper helper;
  final CreateManualTrack createManualTrack;
  final GetProjectTaskByUserId getProjectTaskByUserId;

  ManualTrackingBloc({
    required this.helper,
    required this.createManualTrack,
    required this.getProjectTaskByUserId,
  }) : super(InitialManualTrackingState()) {
    on<CreateManualTrackingEvent>(_onCreateManualTrackingEvent);

    on<LoadDataProjectTaskManualTrackingEvent>(_onLoadDataProjectTaskManualTrackingEvent);
  }

  FutureOr<void> _onCreateManualTrackingEvent(
    CreateManualTrackingEvent event,
    Emitter<ManualTrackingState> emit,
  ) async {
    emit(LoadingManualTrackingState());
    final result = await createManualTrack(
      ParamsCreateManualTrack(
        body: event.body,
      ),
    );
    final response = result.response;
    final failure = result.failure;
    if (response != null) {
      emit(SuccessCreateManualTrackingState());
      return;
    }

    final errorMessage = helper.getErrorMessageFromFailure(failure);
    emit(FailureManualTrackingState(errorMessage: errorMessage));
  }

  FutureOr<void> _onLoadDataProjectTaskManualTrackingEvent(
    LoadDataProjectTaskManualTrackingEvent event,
    Emitter<ManualTrackingState> emit,
  ) async {
    emit(LoadingManualTrackingState());
    final result = await getProjectTaskByUserId(
      ParamsGetProjectTaskByUserId(
        userId: event.userId,
      ),
    );
    final response = result.response;
    final failure = result.failure;
    if (response != null) {
      emit(SuccessLoadDataProjectTaskManualTrackingState(response: response));
      return;
    }

    final errorMessage = helper.getErrorMessageFromFailure(failure);
    emit(FailureCenterManualTrackingState(errorMessage: errorMessage));
  }
}
