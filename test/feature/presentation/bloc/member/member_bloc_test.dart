import 'dart:convert';

import 'package:bloc_test/bloc_test.dart';
import 'package:dipantau_desktop_client/core/error/failure.dart';
import 'package:dipantau_desktop_client/core/usecase/usecase.dart';
import 'package:dipantau_desktop_client/feature/data/model/update_user/update_user_body.dart';
import 'package:dipantau_desktop_client/feature/data/model/user_profile/list_user_profile_response.dart';
import 'package:dipantau_desktop_client/feature/domain/usecase/update_user/update_user.dart';
import 'package:dipantau_desktop_client/feature/presentation/bloc/member/member_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../../../fixture/fixture_reader.dart';
import '../../../../helper/mock_helper.mocks.dart';

void main() {
  late MemberBloc bloc;
  late MockGetAllMember mockGetAllMember;
  late MockHelper mockHelper;
  late MockUpdateUser mockUpdateUser;

  setUp(() {
    mockGetAllMember = MockGetAllMember();
    mockHelper = MockHelper();
    mockUpdateUser = MockUpdateUser();
    bloc = MemberBloc(
      getAllMember: mockGetAllMember,
      helper: mockHelper,
      updateUser: mockUpdateUser,
    );
  });

  const tErrorMessage = 'testErrorMessage';

  test(
    'pastikan output dari initialState',
    () async {
      // assert
      expect(
        bloc.state,
        isA<InitialMemberState>(),
      );
    },
  );

  group('load list member', () {
    final tEvent = LoadListMemberEvent();
    final tParams = NoParams();
    final tResponse = ListUserProfileResponse.fromJson(
      json.decode(
        fixture('list_user_profile_response.json'),
      ),
    );

    blocTest(
      'pastikan emit [LoadingCenterMemberState, SuccessLoadListMemberState] ketika terima event '
      'LoadListMemberEvent dengan proses berhasil',
      build: () {
        final result = (failure: null, response: tResponse);
        when(mockGetAllMember(any)).thenAnswer((_) async => result);
        return bloc;
      },
      act: (MemberBloc bloc) {
        return bloc.add(tEvent);
      },
      expect: () => [
        isA<LoadingCenterMemberState>(),
        isA<SuccessLoadListMemberState>(),
      ],
      verify: (_) {
        verify(mockGetAllMember(tParams));
      },
    );

    blocTest(
      'pastikan emit [LoadingCenterMemberState, FailureMemberState] ketika terima event '
      'LoadListMemberEvent dengan proses gagal dari endpoint',
      build: () {
        final result = (failure: ServerFailure(tErrorMessage), response: null);
        when(mockGetAllMember(any)).thenAnswer((_) async => result);
        return bloc;
      },
      act: (MemberBloc bloc) {
        return bloc.add(tEvent);
      },
      expect: () => [
        isA<LoadingCenterMemberState>(),
        isA<FailureMemberState>(),
      ],
      verify: (_) {
        verify(mockGetAllMember(tParams));
      },
    );

    blocTest(
      'pastikan emit [LoadingCenterMemberState, FailureMemberState] ketika terima event '
      'LoadListMemberEvent dengan kondisi internet tidak terhubung',
      build: () {
        final result = (failure: ConnectionFailure(), response: null);
        when(mockGetAllMember(any)).thenAnswer((_) async => result);
        return bloc;
      },
      act: (MemberBloc bloc) {
        return bloc.add(tEvent);
      },
      expect: () => [
        isA<LoadingCenterMemberState>(),
        isA<FailureMemberState>(),
      ],
      verify: (_) {
        verify(mockGetAllMember(tParams));
      },
    );

    blocTest(
      'pastikan emit [LoadingCenterMemberState, FailureMemberState] ketika terima event '
      'LoadListMemberEvent dengan proses gagal parsing respon dari endpoint',
      build: () {
        final result = (failure: ParsingFailure(tErrorMessage), response: null);
        when(mockGetAllMember(any)).thenAnswer((_) async => result);
        return bloc;
      },
      act: (MemberBloc bloc) {
        return bloc.add(tEvent);
      },
      expect: () => [
        isA<LoadingCenterMemberState>(),
        isA<FailureMemberState>(),
      ],
      verify: (_) {
        verify(mockGetAllMember(tParams));
      },
    );
  });

  group('edit member', () {
    const tId = 1;
    final tBody = UpdateUserBody.fromJson(
      json.decode(
        fixture('update_user_body.json'),
      ),
    );
    final tEvent = EditMemberEvent(
      body: tBody,
      id: tId,
    );
    final tParams = ParamsUpdateUser(
      body: tBody,
      id: tId,
    );
    const tResponse = true;

    blocTest(
      'pastikan emit [LoadingCenterOverlayMemberState, SuccessEditMemberState] ketika terima event '
      'EditMemberEvent dengan proses berhasil',
      build: () {
        const result = (failure: null, response: tResponse);
        when(mockUpdateUser(any)).thenAnswer((_) async => result);
        return bloc;
      },
      act: (MemberBloc bloc) {
        return bloc.add(tEvent);
      },
      expect: () => [
        isA<LoadingCenterOverlayMemberState>(),
        isA<SuccessEditMemberState>(),
      ],
      verify: (_) {
        verify(mockUpdateUser(tParams));
      },
    );

    blocTest(
      'pastikan emit [LoadingCenterOverlayMemberState, FailureMemberState] ketika terima event '
      'EditMemberEvent dengan proses gagal dari endpoint',
      build: () {
        final result = (failure: ServerFailure(tErrorMessage), response: null);
        when(mockUpdateUser(any)).thenAnswer((_) async => result);
        return bloc;
      },
      act: (MemberBloc bloc) {
        return bloc.add(tEvent);
      },
      expect: () => [
        isA<LoadingCenterOverlayMemberState>(),
        isA<FailureMemberState>(),
      ],
      verify: (_) {
        verify(mockUpdateUser(tParams));
      },
    );

    blocTest(
      'pastikan emit [LoadingCenterOverlayMemberState, FailureMemberState] ketika terima event '
      'EditMemberEvent dengan kondisi internet tidak terhubung',
      build: () {
        final result = (failure: ConnectionFailure(), response: null);
        when(mockUpdateUser(any)).thenAnswer((_) async => result);
        return bloc;
      },
      act: (MemberBloc bloc) {
        return bloc.add(tEvent);
      },
      expect: () => [
        isA<LoadingCenterOverlayMemberState>(),
        isA<FailureMemberState>(),
      ],
      verify: (_) {
        verify(mockUpdateUser(tParams));
      },
    );

    blocTest(
      'pastikan emit [LoadingCenterOverlayMemberState, FailureMemberState] ketika terima event '
      'EditMemberEvent dengan proses gagal parsing respon dari endpoint',
      build: () {
        final result = (failure: ParsingFailure(tErrorMessage), response: null);
        when(mockUpdateUser(any)).thenAnswer((_) async => result);
        return bloc;
      },
      act: (MemberBloc bloc) {
        return bloc.add(tEvent);
      },
      expect: () => [
        isA<LoadingCenterOverlayMemberState>(),
        isA<FailureMemberState>(),
      ],
      verify: (_) {
        verify(mockUpdateUser(tParams));
      },
    );
  });
}
