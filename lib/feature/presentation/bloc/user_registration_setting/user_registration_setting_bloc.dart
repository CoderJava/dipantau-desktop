import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:dipantau_desktop_client/core/usecase/usecase.dart';
import 'package:dipantau_desktop_client/core/util/helper.dart';
import 'package:dipantau_desktop_client/feature/data/model/kv_setting/kv_setting_response.dart';
import 'package:dipantau_desktop_client/feature/data/model/user_sign_up_waiting/user_sign_up_waiting_response.dart';
import 'package:dipantau_desktop_client/feature/domain/usecase/get_kv_setting/get_kv_setting.dart';
import 'package:dipantau_desktop_client/feature/domain/usecase/get_user_sign_up_waiting/get_user_sign_up_waiting.dart';

part 'user_registration_setting_event.dart';

part 'user_registration_setting_state.dart';

class UserRegistrationSettingBloc extends Bloc<UserRegistrationSettingEvent, UserRegistrationSettingState> {
  final Helper helper;
  final GetKvSetting getKvSetting;
  final GetUserSignUpWaiting getUserSignUpWaiting;

  UserRegistrationSettingBloc({
    required this.helper,
    required this.getKvSetting,
    required this.getUserSignUpWaiting,
  }) : super(InitialUserRegistrationSettingState()) {
    on<PrepareDataUserRegistrationSettingEvent>(
      _onPrepareDataUserRegistrationSettingEvent,
      transformer: restartable(),
    );
  }

  FutureOr<void> _onPrepareDataUserRegistrationSettingEvent(
    PrepareDataUserRegistrationSettingEvent event,
    Emitter<UserRegistrationSettingState> emit,
  ) async {
    late KvSettingResponse kvSettingResponse;
    late UserSignUpWaitingResponse userSignUpWaitingResponse;
    final noParams = NoParams();
    emit(LoadingCenterUserRegistrationSettingState());
    final resultKvSetting = await getKvSetting(noParams);
    if (resultKvSetting.response != null) {
      kvSettingResponse = resultKvSetting.response!;
    } else {
      final errorMessage = helper.getErrorMessageFromFailure(resultKvSetting.failure);
      emit(FailureUserRegistrationSettingState(errorMessage: errorMessage));
      return;
    }

    final resultUserSignUpWaiting = await getUserSignUpWaiting(noParams);
    if (resultUserSignUpWaiting.response != null) {
      userSignUpWaitingResponse = resultUserSignUpWaiting.response!;
    } else {
      final errorMessage = helper.getErrorMessageFromFailure(resultUserSignUpWaiting.failure);
      emit(FailureUserRegistrationSettingState(errorMessage: errorMessage));
      return;
    }

    emit(
      SuccessPrepareDataUserRegistrationSettingState(
        kvSettingResponse: kvSettingResponse,
        userSignUpWaitingResponse: userSignUpWaitingResponse,
      ),
    );
  }
}
