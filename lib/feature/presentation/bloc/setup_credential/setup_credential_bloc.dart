import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:dipantau_desktop_client/core/usecase/usecase.dart';
import 'package:dipantau_desktop_client/core/util/helper.dart';
import 'package:dipantau_desktop_client/feature/domain/usecase/ping/ping.dart';

part 'setup_credential_event.dart';
part 'setup_credential_state.dart';

class SetupCredentialBloc extends Bloc<SetupCredentialEvent, SetupCredentialState> {
  final Helper helper;
  final Ping ping;

  SetupCredentialBloc({
    required this.helper,
    required this.ping,
  }) : super(InitialSetupCredentialState()) {
    on<PingSetupCredentialEvent>(_onPingSetupCredentialEvent);
  }

  FutureOr<void> _onPingSetupCredentialEvent(
    PingSetupCredentialEvent event,
    Emitter<SetupCredentialState> emit,
  ) async {
    emit(LoadingSetupCredentialState());
    final result = await ping(NoParams());
    final response = result.response;
    final failure = result.failure;
    if (response != null) {
      emit(SuccessPingSetupCredentialState());
      return;
    }

    final errorMessage = helper.getErrorMessageFromFailure(failure);
    emit(FailureSetupCredentialState(errorMessage: errorMessage));
  }
}
