import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:dipantau_desktop_client/core/usecase/usecase.dart';
import 'package:dipantau_desktop_client/core/util/helper.dart';
import 'package:dipantau_desktop_client/feature/data/model/all_user_setting/all_user_setting_response.dart';
import 'package:dipantau_desktop_client/feature/data/model/kv_setting/kv_setting_body.dart';
import 'package:dipantau_desktop_client/feature/data/model/kv_setting/kv_setting_response.dart';
import 'package:dipantau_desktop_client/feature/data/model/user_setting/user_setting_body.dart';
import 'package:dipantau_desktop_client/feature/data/model/user_setting/user_setting_response.dart';
import 'package:dipantau_desktop_client/feature/domain/usecase/get_all_user_setting/get_all_user_setting.dart';
import 'package:dipantau_desktop_client/feature/domain/usecase/get_kv_setting/get_kv_setting.dart';
import 'package:dipantau_desktop_client/feature/domain/usecase/get_user_setting/get_user_setting.dart';
import 'package:dipantau_desktop_client/feature/domain/usecase/set_kv_setting/set_kv_setting.dart';
import 'package:dipantau_desktop_client/feature/domain/usecase/update_user_setting/update_user_setting.dart';

part 'setting_event.dart';

part 'setting_state.dart';

class SettingBloc extends Bloc<SettingEvent, SettingState> {
  final Helper helper;
  final GetKvSetting getKvSetting;
  final SetKvSetting setKvSetting;
  final GetUserSetting getUserSetting;
  final GetAllUserSetting getAllUserSetting;
  final UpdateUserSetting updateUserSetting;

  SettingBloc({
    required this.helper,
    required this.getKvSetting,
    required this.setKvSetting,
    required this.getUserSetting,
    required this.getAllUserSetting,
    required this.updateUserSetting,
  }) : super(InitialSettingState()) {
    on<LoadKvSettingEvent>(_onLoadKvSettingEvent);

    on<UpdateKvSettingEvent>(_onUpdateKvSettingEvent);

    on<LoadUserSettingEvent>(_onLoadUserSettingEvent);

    on<LoadAllUserSettingEvent>(_onLoadAllUserSettingEvent);

    on<UpdateUserSettingEvent>(_onUpdateUserSettingEvent);
  }

  FutureOr<void> _onLoadKvSettingEvent(
    LoadKvSettingEvent event,
    Emitter<SettingState> emit,
  ) async {
    emit(LoadingCenterSettingState());
    final (:response, :failure) = await getKvSetting(NoParams());
    if (response != null) {
      emit(SuccessLoadKvSettingState(response: response));
      return;
    }

    final errorMessage = helper.getErrorMessageFromFailure(failure);
    emit(FailureSettingState(errorMessage: errorMessage));
  }

  FutureOr<void> _onUpdateKvSettingEvent(UpdateKvSettingEvent event, Emitter<SettingState> emit) async {
    emit(LoadingButtonSettingState());
    final (:response, :failure) = await setKvSetting(
      ParamsSetKvSetting(
        body: event.body,
      ),
    );
    if (response != null) {
      emit(SuccessUpdateKvSettingState());
      return;
    }

    final errorMessage = helper.getErrorMessageFromFailure(failure);
    emit(FailureSnackBarSettingState(errorMessage: errorMessage));
  }

  FutureOr<void> _onLoadUserSettingEvent(LoadUserSettingEvent event, Emitter<SettingState> emit) async {
    emit(LoadingCenterSettingState());
    final (:response, :failure) = await getUserSetting(NoParams());
    if (response != null) {
      emit(SuccessLoadUserSettingState(response: response));
      return;
    }

    final errorMessage = helper.getErrorMessageFromFailure(failure);
    emit(FailureSettingState(errorMessage: errorMessage));
  }

  FutureOr<void> _onLoadAllUserSettingEvent(LoadAllUserSettingEvent event, Emitter<SettingState> emit) async {
    emit(LoadingCenterSettingState());
    final (:response, :failure) = await getAllUserSetting(NoParams());
    if (response != null) {
      emit(SuccessLoadAllUserSettingState(response: response));
      return;
    }

    final errorMessage = helper.getErrorMessageFromFailure(failure);
    emit(FailureSettingState(errorMessage: errorMessage));
  }

  FutureOr<void> _onUpdateUserSettingEvent(UpdateUserSettingEvent event, Emitter<SettingState> emit) async {
    emit(LoadingButtonSettingState());
    final (:response, :failure) = await updateUserSetting(
      ParamsUpdateUserSetting(
        body: event.body,
      ),
    );
    if (response != null) {
      emit(SuccessUpdateUserSettingState());
      return;
    }

    final errorMessage = helper.getErrorMessageFromFailure(failure);
    emit(FailureSnackBarSettingState(errorMessage: errorMessage));
  }
}
