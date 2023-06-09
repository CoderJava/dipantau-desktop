import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:dipantau_desktop_client/core/error/failure.dart';
import 'package:dipantau_desktop_client/core/usecase/usecase.dart';
import 'package:dipantau_desktop_client/core/util/shared_preferences_manager.dart';
import 'package:dipantau_desktop_client/feature/data/model/login/login_body.dart';
import 'package:dipantau_desktop_client/feature/data/model/login/login_response.dart';
import 'package:dipantau_desktop_client/feature/data/model/user_profile/user_profile_response.dart';
import 'package:dipantau_desktop_client/feature/domain/usecase/get_profile/get_profile.dart';
import 'package:dipantau_desktop_client/feature/domain/usecase/login/login.dart';
import 'package:equatable/equatable.dart';

part 'login_event.dart';

part 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final Login login;
  final SharedPreferencesManager sharedPreferencesManager;
  final GetProfile getProfile;

  LoginBloc({
    required this.login,
    required this.sharedPreferencesManager,
    required this.getProfile,
  }) : super(InitialLoginState()) {
    on<SubmitLoginEvent>(_onSubmitLoginEvent);
  }

  FutureOr<void> _onSubmitLoginEvent(SubmitLoginEvent event, Emitter<LoginState> emit) async {
    emit(LoadingLoginState());
    final resultLogin = await login(
      LoginParams(
        body: event.body,
      ),
    );
    final resultFoldLogin = resultLogin.fold(
      (failure) => failure,
      (response) => response,
    );
    var errorMessage = '';
    if (resultFoldLogin is ServerFailure) {
      errorMessage = resultFoldLogin.errorMessage;
    } else if (resultFoldLogin is ConnectionFailure) {
      errorMessage = resultFoldLogin.errorMessage;
    } else if (resultFoldLogin is ParsingFailure) {
      errorMessage = resultFoldLogin.defaultErrorMessage;
    }
    if (errorMessage.isNotEmpty) {
      emit(FailureLoginState(errorMessage: errorMessage));
      return;
    }
    final loginResponse = resultFoldLogin as LoginResponse;
    await sharedPreferencesManager.putString(
      SharedPreferencesManager.keyAccessToken,
      loginResponse.accessToken ?? '',
    );
    await sharedPreferencesManager.putString(
      SharedPreferencesManager.keyRefreshToken,
      loginResponse.refreshToken ?? '',
    );

    final resultProfileLite = await getProfile(NoParams());
    final resultFoldProfileLite = resultProfileLite.fold(
      (failure) => failure,
      (response) => response,
    );
    if (resultFoldProfileLite is ServerFailure) {
      errorMessage = resultFoldProfileLite.errorMessage;
    } else if (resultFoldProfileLite is ConnectionFailure) {
      errorMessage = resultFoldProfileLite.errorMessage;
    } else if (resultFoldProfileLite is ParsingFailure) {
      errorMessage = resultFoldProfileLite.defaultErrorMessage;
    }
    if (errorMessage.isNotEmpty) {
      await sharedPreferencesManager.clearAll();
      emit(FailureLoginState(errorMessage: errorMessage));
      return;
    }
    final userProfileResponse = resultFoldProfileLite as UserProfileResponse;

    await sharedPreferencesManager.putString(
      SharedPreferencesManager.keyEmail,
      event.body.username,
    );
    await sharedPreferencesManager.putString(
      SharedPreferencesManager.keyUserId,
      (userProfileResponse.id ?? -1).toString(),
    );
    await sharedPreferencesManager.putString(
      SharedPreferencesManager.keyFullName,
      userProfileResponse.name ?? '',
    );
    await sharedPreferencesManager.putString(
      SharedPreferencesManager.keyUserRole,
      userProfileResponse.role?.name ?? '',
    );
    await sharedPreferencesManager.putBool(
      SharedPreferencesManager.keyIsLogin,
      true,
    );
    emit(SuccessSubmitLoginState());
  }
}
