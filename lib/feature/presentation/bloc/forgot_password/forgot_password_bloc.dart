import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:dipantau_desktop_client/core/util/helper.dart';
import 'package:dipantau_desktop_client/feature/data/model/forgot_password/forgot_password_body.dart';
import 'package:dipantau_desktop_client/feature/domain/usecase/forgot_password/forgot_password.dart';

part 'forgot_password_event.dart';

part 'forgot_password_state.dart';

class ForgotPasswordBloc extends Bloc<ForgotPasswordEvent, ForgotPasswordState> {
  final Helper helper;
  final ForgotPassword forgotPassword;

  ForgotPasswordBloc({
    required this.helper,
    required this.forgotPassword,
  }) : super(InitialForgotPasswordState()) {
    on<SubmitForgotPasswordEvent>(_onSubmitForgotPasswordEvent);
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
}
