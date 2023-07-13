import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:dipantau_desktop_client/core/usecase/usecase.dart';
import 'package:dipantau_desktop_client/core/util/helper.dart';
import 'package:dipantau_desktop_client/feature/data/model/update_user/update_user_body.dart';
import 'package:dipantau_desktop_client/feature/data/model/user_profile/user_profile_response.dart';
import 'package:dipantau_desktop_client/feature/domain/usecase/get_profile/get_profile.dart';
import 'package:dipantau_desktop_client/feature/domain/usecase/update_user/update_user.dart';

part 'user_profile_event.dart';

part 'user_profile_state.dart';

class UserProfileBloc extends Bloc<UserProfileEvent, UserProfileState> {
  final Helper helper;
  final GetProfile getProfile;
  final UpdateUser updateUser;

  UserProfileBloc({
    required this.helper,
    required this.getProfile,
    required this.updateUser,
  }) : super(InitialUserProfileState()) {
    on<LoadDataUserProfileEvent>(_onLoadDataUserProfileEvent);

    on<UpdateDataUserProfileEvent>(_onUpdateDataUserProfileEvent);
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

  FutureOr<void> _onUpdateDataUserProfileEvent(
    UpdateDataUserProfileEvent event,
    Emitter<UserProfileState> emit,
  ) async {
    final body = event.body;
    emit(LoadingButtonUserProfileState());
    final (:response, :failure) = await updateUser(
      ParamsUpdateUser(
        body: body,
        id: event.id,
      ),
    );
    if (response != null) {
      emit(SuccessUpdateDataUserProfileState(body: body));
      return;
    }

    final errorMessage = helper.getErrorMessageFromFailure(failure);
    emit(FailureSnackBarUserProfileState(errorMessage: errorMessage));
  }
}
