import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:dipantau_desktop_client/core/usecase/usecase.dart';
import 'package:dipantau_desktop_client/core/util/helper.dart';
import 'package:dipantau_desktop_client/feature/data/model/kv_setting/kv_setting_body.dart';
import 'package:dipantau_desktop_client/feature/data/model/kv_setting/kv_setting_response.dart';
import 'package:dipantau_desktop_client/feature/domain/usecase/get_kv_setting/get_kv_setting.dart';
import 'package:dipantau_desktop_client/feature/domain/usecase/set_kv_setting/set_kv_setting.dart';

part 'setting_event.dart';

part 'setting_state.dart';

class SettingBloc extends Bloc<SettingEvent, SettingState> {
  final Helper helper;
  final GetKvSetting getKvSetting;
  final SetKvSetting setKvSetting;

  SettingBloc({
    required this.helper,
    required this.getKvSetting,
    required this.setKvSetting,
  }) : super(InitialSettingState()) {
    on<LoadKvSettingEvent>(_onLoadKvSettingEvent);

    on<UpdateKvSettingEvent>(_onUpdateKvSettingEvent);
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
}
