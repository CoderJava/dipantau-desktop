import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:dipantau_desktop_client/core/error/failure.dart';
import 'package:dipantau_desktop_client/feature/data/model/track_user_lite/track_user_lite_response.dart';
import 'package:dipantau_desktop_client/feature/domain/usecase/get_track_user_lite/get_track_user_lite.dart';
import 'package:dipantau_desktop_client/feature/domain/usecase/send_app_version/send_app_version.dart';
import 'package:dipantau_desktop_client/feature/domain/usecase/user_version/user_version_body.dart';
import 'package:equatable/equatable.dart';

part 'home_event.dart';

part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final GetTrackUserLite getTrackUserLite;
  final SendAppVersion sendAppVersion;

  HomeBloc({
    required this.getTrackUserLite,
    required this.sendAppVersion,
  }) : super(InitialHomeState()) {
    on<LoadDataHomeEvent>(_onLoadDataHomeEvent);
  }

  FutureOr<void> _onLoadDataHomeEvent(LoadDataHomeEvent event, Emitter<HomeState> emit) async {
    emit(LoadingHomeState());

    final userVersionBody = event.userVersionBody;
    if (userVersionBody != null) {
      await sendAppVersion(
        ParamsSendAppVersion(
          body: UserVersionBody(
            code: userVersionBody.code,
            name: userVersionBody.name,
            userId: userVersionBody.userId,
          ),
        ),
      );
    }

    final result = await getTrackUserLite(
      ParamsGetTrackUserLite(
        date: event.date,
        projectId: event.projectId,
      ),
    );
    emit(
      result.fold(
        (failure) {
          var errorMessage = '';
          if (failure is ServerFailure) {
            errorMessage = failure.errorMessage;
          } else if (failure is ConnectionFailure) {
            errorMessage = failure.errorMessage;
          } else if (failure is ParsingFailure) {
            errorMessage = failure.defaultErrorMessage;
          }
          return FailureHomeState(errorMessage: errorMessage);
        },
        (response) => SuccessLoadDataHomeState(
          trackUserLiteResponse: response,
          isAutoStart: event.isAutoStart,
        ),
      ),
    );
  }
}
