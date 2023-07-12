import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:dipantau_desktop_client/core/usecase/usecase.dart';
import 'package:dipantau_desktop_client/core/util/helper.dart';
import 'package:dipantau_desktop_client/feature/data/model/user_profile/user_profile_response.dart';
import 'package:dipantau_desktop_client/feature/domain/usecase/get_profile/get_profile.dart';

part 'user_profile_event.dart';

part 'user_profile_state.dart';

class UserProfileBloc extends Bloc<UserProfileEvent, UserProfileState> {
  final Helper helper;
  final GetProfile getProfile;

  UserProfileBloc({
    required this.helper,
    required this.getProfile,
  }) : super(InitialUserProfileState()) {
    on<LoadDataUserProfileEvent>(_onLoadDataUserProfileEvent);
  }

  FutureOr<void> _onLoadDataUserProfileEvent(
    LoadDataUserProfileEvent event,
    Emitter<UserProfileState> emit,
  ) async {
    emit(LoadingCenterUserProfileState());
    final result = await getProfile(NoParams());
    emit(
      result.fold(
        (failure) {
          final errorMessage = helper.getErrorMessageFromFailure(failure);
          return FailureUserProfileState(errorMessage: errorMessage);
        },
        (response) => SuccessLoadDataUserProfileState(response: response),
      ),
    );
  }
}
