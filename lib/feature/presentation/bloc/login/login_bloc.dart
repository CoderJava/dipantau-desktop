import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:dipantau_desktop_client/core/error/failure.dart';
import 'package:dipantau_desktop_client/core/util/shared_preferences_manager.dart';
import 'package:dipantau_desktop_client/feature/data/model/login/login_body.dart';
import 'package:dipantau_desktop_client/feature/domain/usecase/login/login.dart';
import 'package:equatable/equatable.dart';

part 'login_event.dart';

part 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final Login login;
  final SharedPreferencesManager sharedPreferencesManager;

  LoginBloc({
    required this.login,
    required this.sharedPreferencesManager,
  }) : super(InitialLoginState()) {
    on<SubmitLoginEvent>(_onSubmitLoginEvent);
  }

  FutureOr<void> _onSubmitLoginEvent(SubmitLoginEvent event, Emitter<LoginState> emit) async {
    emit(LoadingLoginState());
    final result = await login(
      LoginParams(
        body: event.body,
      ),
    );
    emit(
      await result.fold(
        (failure) {
          var errorMessage = '';
          if (failure is ServerFailure) {
            errorMessage = failure.errorMessage;
          } else if (failure is ConnectionFailure) {
            errorMessage = failure.errorMessage;
          } else if (failure is ParsingFailure) {
            errorMessage = failure.defaultErrorMessage;
          }
          return FailureLoginState(errorMessage: errorMessage);
        },
        (response) async {
          await sharedPreferencesManager.putString(SharedPreferencesManager.keyEmail, event.body.username);
          await sharedPreferencesManager.putBool(SharedPreferencesManager.keyIsLogin, true);
          await sharedPreferencesManager.putString(
            SharedPreferencesManager.keyAccessToken,
            response.accessToken ?? '',
          );
          await sharedPreferencesManager.putString(
            SharedPreferencesManager.keyRefreshToken,
            response.refreshToken ?? '',
          );
          await sharedPreferencesManager.putString(
            SharedPreferencesManager.keyUserRole,
            response.role?.name ?? '',
          );
          return SuccessSubmitLoginState();
        },
      ),
    );
  }
}
