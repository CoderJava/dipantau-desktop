import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:dipantau_desktop_client/core/error/failure.dart';
import 'package:dipantau_desktop_client/feature/data/model/sign_up/sign_up_body.dart';
import 'package:dipantau_desktop_client/feature/data/model/sign_up/sign_up_response.dart';
import 'package:dipantau_desktop_client/feature/domain/usecase/sign_up/sign_up.dart';
import 'package:equatable/equatable.dart';

part 'sign_up_event.dart';

part 'sign_up_state.dart';

class SignUpBloc extends Bloc<SignUpEvent, SignUpState> {
  final SignUp signUp;

  SignUpBloc({
    required this.signUp,
  }) : super(InitialSignUpState()) {
    on<SubmitSignUpEvent>(_onSubmitSignUpEvent);
  }

  FutureOr<void> _onSubmitSignUpEvent(
    SubmitSignUpEvent event,
    Emitter<SignUpState> emit,
  ) async {
    emit(LoadingSignUpState());
    final result = await signUp(
      SignUpParams(
        body: event.body,
      ),
    );
    emit(
      result.fold(
        (failure) {
          var errorMessage = '';
          if (failure is ServerFailure) {
            errorMessage = failure.errorMessage;
          } else if (failure is ConnectionFailure) {
            errorMessage = failure.errorMessage;
          } else if (failure is ParsingFailure) {
            errorMessage = ConstantErrorMessage().parsingError;
          }
          return FailureSignUpState(errorMessage: errorMessage);
        },
        (response) => SuccessSubmitSignUpState(response: response),
      ),
    );
  }
}
