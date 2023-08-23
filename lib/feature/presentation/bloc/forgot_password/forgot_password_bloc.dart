import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:dipantau_desktop_client/core/util/helper.dart';
import 'package:dipantau_desktop_client/feature/data/model/forgot_password/forgot_password_body.dart';
import 'package:dipantau_desktop_client/feature/data/model/verify_forgot_password/verify_forgot_password_body.dart';
import 'package:dipantau_desktop_client/feature/domain/usecase/forgot_password/forgot_password.dart';
import 'package:dipantau_desktop_client/feature/domain/usecase/verify_forgot_password/verify_forgot_password.dart';

part 'forgot_password_event.dart';

part 'forgot_password_state.dart';

class ForgotPasswordBloc extends Bloc<ForgotPasswordEvent, ForgotPasswordState> {
  final Helper helper;
  final ForgotPassword forgotPassword;
  final VerifyForgotPassword verifyForgotPassword;

  ForgotPasswordBloc({
    required this.helper,
    required this.forgotPassword,
    required this.verifyForgotPassword,
  }) : super(InitialForgotPasswordState()) {
    on<SubmitForgotPasswordEvent>(_onSubmitForgotPasswordEvent);

    on<SubmitVerifyForgotPasswordEvent>(_onSubmitVerifyForgotPasswordEvent);
  }

  FutureOr<void> _onSubmitForgotPasswordEvent(
    SubmitForgotPasswordEvent event,
    Emitter<ForgotPasswordState> emit,
  ) async {
    emit(LoadingForgotPasswordState());
    final result = await forgotPassword(
      ParamsForgotPassword(
        body: event.body,
      ),
    );
    final response = result.response;
    final failure = result.failure;
    if (response != null) {
      emit(
        SuccessForgotPasswordState(
          email: event.body.email,
        ),
      );
      return;
    }

    final errorMessage = helper.getErrorMessageFromFailure(failure);
    emit(FailureForgotPasswordState(errorMessage: errorMessage));
  }

  FutureOr<void> _onSubmitVerifyForgotPasswordEvent(
    SubmitVerifyForgotPasswordEvent event,
    Emitter<ForgotPasswordState> emit,
  ) async {
    emit(LoadingForgotPasswordState());
    final result = await verifyForgotPassword(
      ParamsVerifyForgotPassword(
        body: event.body,
      ),
    );
    final response = result.response;
    final failure = result.failure;
    if (response != null) {
      emit(
        SuccessVerifyForgotPasswordState(
          code: event.body.code,
        ),
      );
      return;
    }

    final errorMessage = helper.getErrorMessageFromFailure(failure);
    emit(FailureForgotPasswordState(errorMessage: errorMessage));
  }
}
