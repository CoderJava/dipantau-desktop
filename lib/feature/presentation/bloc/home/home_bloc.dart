import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:dipantau_desktop_client/core/error/failure.dart';
import 'package:dipantau_desktop_client/core/util/shared_preferences_manager.dart';
import 'package:dipantau_desktop_client/feature/data/model/project/project_response.dart';
import 'package:dipantau_desktop_client/feature/domain/usecase/get_project/get_project.dart';
import 'package:equatable/equatable.dart';

part 'home_event.dart';

part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final SharedPreferencesManager sharedPreferencesManager;
  final GetProject getProject;

  HomeBloc({
    required this.sharedPreferencesManager,
    required this.getProject,
  }) : super(InitialHomeState()) {
    on<LoadDataProjectHomeEvent>(_onLoadDataProjectHomeEvent, transformer: restartable());
  }

  FutureOr<void> _onLoadDataProjectHomeEvent(LoadDataProjectHomeEvent event, Emitter<HomeState> emit) async {
    emit(LoadingHomeState());
    final email = sharedPreferencesManager.getString(SharedPreferencesManager.keyEmail);
    if (email == null || email.isEmpty) {
      emit(FailureHomeState(errorMessage: 'Error: Invalid email. Please relogin to fix it.'));
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
          return FailureHomeState(errorMessage: errorMessage);
        },
        (response) => SuccessLoadDataProjectHomeState(project: response),
      ),
    );
  }
}
