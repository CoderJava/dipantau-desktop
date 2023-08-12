import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:dipantau_desktop_client/core/error/failure.dart';
import 'package:dipantau_desktop_client/feature/data/model/track_user_lite/track_user_lite_response.dart';
import 'package:dipantau_desktop_client/feature/domain/usecase/get_track_user_lite/get_track_user_lite.dart';
import 'package:equatable/equatable.dart';

part 'home_event.dart';

part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final GetTrackUserLite getTrackUserLite;

  HomeBloc({
    required this.getTrackUserLite,
  }) : super(InitialHomeState()) {
    on<LoadDataHomeEvent>(_onLoadDataHomeEvent);
  }

  FutureOr<void> _onLoadDataHomeEvent(LoadDataHomeEvent event, Emitter<HomeState> emit) async {
    emit(LoadingHomeState());
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
