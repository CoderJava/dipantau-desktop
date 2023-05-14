import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:dipantau_desktop_client/core/error/failure.dart';
import 'package:dipantau_desktop_client/core/util/shared_preferences_manager.dart';
import 'package:dipantau_desktop_client/feature/data/model/project/project_response_bak.dart';
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
    final email = sharedPreferencesManager.getString(SharedPreferencesManager.keyEmail);
    if (email == null || email.isEmpty) {
      emit(FailureProjectState(errorMessage: 'Error: Invalid email. Please relogin to fix it.'));
      return;
    }
    final result = await getProject(ParamsGetProject(email: email));
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
          return FailureProjectState(errorMessage: errorMessage);
        },
        (response) => SuccessLoadDataProjectState(project: response),
      ),
    );
  }
}
