import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:dipantau_desktop_client/core/util/helper.dart';
import 'package:dipantau_desktop_client/feature/data/model/track_user/track_user_response.dart';
import 'package:dipantau_desktop_client/feature/domain/usecase/get_track_user/get_track_user.dart';

part 'report_screenshot_event.dart';

part 'report_screenshot_state.dart';

class ReportScreenshotBloc extends Bloc<ReportScreenshotEvent, ReportScreenshotState> {
  final Helper helper;
  final GetTrackUser getTrackUser;

  ReportScreenshotBloc({
    required this.helper,
    required this.getTrackUser,
  }) : super(InitialReportScreenshotState()) {
    on<LoadReportScreenshotEvent>(_onLoadReportScreenshotEvent);
  }

  FutureOr<void> _onLoadReportScreenshotEvent(
    LoadReportScreenshotEvent event,
    Emitter<ReportScreenshotState> emit,
  ) async {
    emit(LoadingCenterReportScreenshotState());
    final (:response, :failure) = await getTrackUser(
      ParamsGetTrackUser(
        userId: event.userId,
        date: event.date,
      ),
    );
    if (response != null) {
      emit(SuccessLoadReportScreenshotState(response: response));
      return;
    }

    final errorMessage = helper.getErrorMessageFromFailure(failure);
    emit(FailureReportScreenshotState(errorMessage: errorMessage));
  }
}
