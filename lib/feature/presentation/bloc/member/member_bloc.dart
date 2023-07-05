import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:dipantau_desktop_client/core/usecase/usecase.dart';
import 'package:dipantau_desktop_client/core/util/helper.dart';
import 'package:dipantau_desktop_client/feature/data/model/user_profile/list_user_profile_response.dart';
import 'package:dipantau_desktop_client/feature/domain/usecase/get_all_member/get_all_member.dart';

part 'member_event.dart';

part 'member_state.dart';

class MemberBloc extends Bloc<MemberEvent, MemberState> {
  final GetAllMember getAllMember;
  final Helper helper;

  MemberBloc({
    required this.getAllMember,
    required this.helper,
  }) : super(InitialMemberState()) {
    on<LoadListMemberEvent>(_onLoadListMemberEvent);
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
}
