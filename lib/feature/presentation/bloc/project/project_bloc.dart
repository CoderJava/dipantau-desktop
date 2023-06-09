import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:dipantau_desktop_client/core/error/failure.dart';
import 'package:dipantau_desktop_client/core/util/shared_preferences_manager.dart';
import 'package:dipantau_desktop_client/feature/data/model/project/project_response.dart';
import 'package:dipantau_desktop_client/feature/domain/usecase/get_project/get_project.dart';
import 'package:equatable/equatable.dart';

part 'project_event.dart';

part 'project_state.dart';

class ProjectBloc extends Bloc<ProjectEvent, ProjectState> {
  final SharedPreferencesManager sharedPreferencesManager;
  final GetProject getProject;

  ProjectBloc({
    required this.sharedPreferencesManager,
    required this.getProject,
  }) : super(InitialProjectState()) {
    on<LoadDataProjectEvent>(_onLoadDataProjectEvent, transformer: restartable());
  }

  FutureOr<void> _onLoadDataProjectEvent(
    LoadDataProjectEvent event,
    Emitter<ProjectState> emit,
  ) async {
    emit(LoadingProjectState());
    final userId = sharedPreferencesManager.getString(SharedPreferencesManager.keyUserId);
    if (userId == null || userId == '-1') {
      emit(FailureProjectState(errorMessage: 'invalid_user_id'));
      return;
    }

    final result = await getProject(
      ParamsGetProject(
        userId: userId,
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
          return FailureProjectState(errorMessage: errorMessage);
        },
        (response) => SuccessLoadDataProjectState(project: response),
      ),
    );
  }
}
