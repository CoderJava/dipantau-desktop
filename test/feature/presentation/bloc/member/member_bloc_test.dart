import 'dart:convert';

import 'package:bloc_test/bloc_test.dart';
import 'package:dipantau_desktop_client/core/error/failure.dart';
import 'package:dipantau_desktop_client/core/usecase/usecase.dart';
import 'package:dipantau_desktop_client/feature/data/model/user_profile/list_user_profile_response.dart';
import 'package:dipantau_desktop_client/feature/presentation/bloc/member/member_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../../../fixture/fixture_reader.dart';
import '../../../../helper/mock_helper.mocks.dart';

void main() {
  late MemberBloc bloc;
  late MockGetAllMember mockGetAllMember;
  late MockHelper mockHelper;

  setUp(() {
    mockGetAllMember = MockGetAllMember();
    mockHelper = MockHelper();
    bloc = MemberBloc(
      getAllMember: mockGetAllMember,
      helper: mockHelper,
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
}
