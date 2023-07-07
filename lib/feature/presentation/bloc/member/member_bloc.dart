import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:dipantau_desktop_client/core/usecase/usecase.dart';
import 'package:dipantau_desktop_client/core/util/helper.dart';
import 'package:dipantau_desktop_client/feature/data/model/update_user/update_user_body.dart';
import 'package:dipantau_desktop_client/feature/data/model/user_profile/list_user_profile_response.dart';
import 'package:dipantau_desktop_client/feature/domain/usecase/get_all_member/get_all_member.dart';
import 'package:dipantau_desktop_client/feature/domain/usecase/update_user/update_user.dart';

part 'member_event.dart';

part 'member_state.dart';

class MemberBloc extends Bloc<MemberEvent, MemberState> {
  final GetAllMember getAllMember;
  final Helper helper;
  final UpdateUser updateUser;

  MemberBloc({
    required this.getAllMember,
    required this.helper,
    required this.updateUser,
  }) : super(InitialMemberState()) {
    on<LoadListMemberEvent>(_onLoadListMemberEvent);

    on<EditMemberEvent>(_onEditMemberEvent);
  }

  FutureOr<void> _onLoadListMemberEvent(
    LoadListMemberEvent event,
    Emitter<MemberState> emit,
  ) async {
    emit(LoadingCenterMemberState());
    final (:response, :failure) = await getAllMember(NoParams());
    if (response != null) {
      emit(SuccessLoadListMemberState(response: response));
      return;
    }

    final errorMessage = helper.getErrorMessageFromFailure(failure);
    emit(FailureMemberState(errorMessage: errorMessage));
  }

  FutureOr<void> _onEditMemberEvent(
    EditMemberEvent event,
    Emitter<MemberState> emit,
  ) async {
    emit(LoadingCenterOverlayMemberState());
    final (:response, :failure) = await updateUser(
      ParamsUpdateUser(
        body: event.body,
        id: event.id,
      ),
    );
    if (response != null) {
      emit(SuccessEditMemberState());
      return;
    }

    final errorMessage = helper.getErrorMessageFromFailure(failure);
    emit(FailureMemberState(errorMessage: errorMessage));
  }
}
