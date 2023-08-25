import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:dipantau_desktop_client/core/util/helper.dart';
import 'package:dipantau_desktop_client/feature/data/model/reset_password/reset_password_body.dart';
import 'package:dipantau_desktop_client/feature/domain/usecase/reset_password/reset_password.dart';

part 'reset_password_event.dart';

part 'reset_password_state.dart';

class ResetPasswordBloc extends Bloc<ResetPasswordEvent, ResetPasswordState> {
  final Helper helper;
  final ResetPassword resetPassword;

  ResetPasswordBloc({
    required this.helper,
    required this.resetPassword,
  }) : super(InitialResetPasswordState()) {
    on<SubmitResetPasswordEvent>(_onSubmitResetPasswordEvent);
  }

  FutureOr<void> _onSubmitResetPasswordEvent(
    SubmitResetPasswordEvent event,
    Emitter<ResetPasswordState> emit,
  ) async {
    emit(LoadingResetPasswordState());
    final result = await resetPassword(
      ParamsResetPassword(
        body: event.body,
      ),
    );
    final response = result.response;
    final failure = result.failure;
    if (response != null) {
      emit(SuccessResetPasswordState());
      return;
    }

    final errorMessage = helper.getErrorMessageFromFailure(failure);
    emit(FailureResetPasswordState(errorMessage: errorMessage));
  }
}
