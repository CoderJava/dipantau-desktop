import 'dart:convert';

import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:dipantau_desktop_client/core/error/failure.dart';
import 'package:dipantau_desktop_client/core/usecase/usecase.dart';
import 'package:dipantau_desktop_client/feature/data/model/user_profile/user_profile_response.dart';
import 'package:dipantau_desktop_client/feature/presentation/bloc/user_profile/user_profile_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../../../fixture/fixture_reader.dart';
import '../../../../helper/mock_helper.mocks.dart';

void main() {
  late UserProfileBloc bloc;
  late MockHelper mockHelper;
  late MockGetProfile mockGetProfile;

  setUp(() {
    mockHelper = MockHelper();
    mockGetProfile = MockGetProfile();
    bloc = UserProfileBloc(
      helper: mockHelper,
      getProfile: mockGetProfile,
    );
  });

  const errorMessage = 'testErrorMessage';

  test(
    'pastikan output dari initialState',
    () async {
      // assert
      expect(
        bloc.state,
        isA<InitialUserProfileState>(),
      );
    },
  );

  group('load data user profile', () {
    final tEvent = LoadDataUserProfileEvent();
    final tParams = NoParams();
    final tResponse = UserProfileResponse.fromJson(
      json.decode(
        fixture('user_profile_super_admin_response.json'),
      ),
    );

    blocTest(
      'pastikan emit [LoadingCenterUserProfileState, SuccessLoadDataUserProfileState] ketika terima event '
      'LoadDataUserProfileEvent dengan proses berhasil',
      build: () {
        when(mockGetProfile(any)).thenAnswer((_) async => Right(tResponse));
        return bloc;
      },
      act: (UserProfileBloc bloc) {
        return bloc.add(tEvent);
      },
      expect: () => [
        isA<LoadingCenterUserProfileState>(),
        isA<SuccessLoadDataUserProfileState>(),
      ],
      verify: (_) {
        verify(mockGetProfile(tParams));
      },
    );

    blocTest(
      'pastikan emit [LoadingCenterUserProfileState, FailureUserProfileState] ketika terima event '
      'LoadDataUserProfileEvent dengan proses gagal dari endpoint',
      build: () {
        when(mockGetProfile(any)).thenAnswer((_) async => Left(ServerFailure(errorMessage)));
        return bloc;
      },
      act: (UserProfileBloc bloc) {
        return bloc.add(tEvent);
      },
      expect: () => [
        isA<LoadingCenterUserProfileState>(),
        isA<FailureUserProfileState>(),
      ],
      verify: (_) {
        verify(mockGetProfile(tParams));
      },
    );

    blocTest(
      'pastikan emit [LoadingCenterUserProfileState, FailureUserProfileState] ketika terima event '
      'LoadDataUserProfileEvent dengan kondisi internet tidak terhubung',
      build: () {
        when(mockGetProfile(any)).thenAnswer((_) async => Left(ConnectionFailure()));
        return bloc;
      },
      act: (UserProfileBloc bloc) {
        return bloc.add(tEvent);
      },
      expect: () => [
        isA<LoadingCenterUserProfileState>(),
        isA<FailureUserProfileState>(),
      ],
      verify: (_) {
        verify(mockGetProfile(tParams));
      },
    );

    blocTest(
      'pastikan emit [LoadingCenterUserProfileState, FailureUserProfileState] ketika terima event '
      'LoadDataUserProfileEvent dengan proses gagal parsing respon JSON dari endpoint',
      build: () {
        when(mockGetProfile(any)).thenAnswer((_) async => Left(ParsingFailure(errorMessage)));
        return bloc;
      },
      act: (UserProfileBloc bloc) {
        return bloc.add(tEvent);
      },
      expect: () => [
        isA<LoadingCenterUserProfileState>(),
        isA<FailureUserProfileState>(),
      ],
      verify: (_) {
        verify(mockGetProfile(tParams));
      },
    );
  });
}
