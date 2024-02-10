import 'dart:convert';

import 'package:bloc_test/bloc_test.dart';
import 'package:dipantau_desktop_client/core/error/failure.dart';
import 'package:dipantau_desktop_client/core/usecase/usecase.dart';
import 'package:dipantau_desktop_client/feature/data/model/kv_setting/kv_setting_response.dart';
import 'package:dipantau_desktop_client/feature/data/model/user_sign_up_waiting/user_sign_up_waiting_response.dart';
import 'package:dipantau_desktop_client/feature/presentation/bloc/user_registration_setting/user_registration_setting_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../../../fixture/fixture_reader.dart';
import '../../../../helper/mock_helper.mocks.dart';

void main() {
  late UserRegistrationSettingBloc bloc;
  late MockHelper mockHelper;
  late MockGetKvSetting mockGetKvSetting;
  late MockGetUserSignUpWaiting mockGetUserSignUpWaiting;

  setUp(() {
    mockHelper = MockHelper();
    mockGetKvSetting = MockGetKvSetting();
    mockGetUserSignUpWaiting = MockGetUserSignUpWaiting();
    bloc = UserRegistrationSettingBloc(
      helper: mockHelper,
      getKvSetting: mockGetKvSetting,
      getUserSignUpWaiting: mockGetUserSignUpWaiting,
    );
  });

  test(
    'pastikan nilai dari initial state',
    () async {
      // assert
      expect(
        bloc.state,
        isA<InitialUserRegistrationSettingState>(),
      );
    },
  );

  group('prepare data user registration', () {
    final event = PrepareDataUserRegistrationSettingEvent();
    final noParams = NoParams();
    final kvSettingResponse = KvSettingResponse.fromJson(
      json.decode(
        fixture('kv_setting_response.json'),
      ),
    );
    final userSignUpWaitingResponse = UserSignUpWaitingResponse.fromJson(
      json.decode(
        fixture('user_sign_up_waiting_response.json'),
      ),
    );

    blocTest(
      'pastikan emit [LoadingCenterUserRegistrationSettingState, SuccessPrepareDataUserRegistrationSettingState] ketika terima event '
      'PrepareDataUserRegistrationSettingEvent dengan proses berhasil',
      build: () {
        final resultKvSetting = (failure: null, response: kvSettingResponse);
        final resultUserSignUpWaiting = (failure: null, response: userSignUpWaitingResponse);
        when(mockGetKvSetting(any)).thenAnswer((_) async => resultKvSetting);
        when(mockGetUserSignUpWaiting(any)).thenAnswer((_) async => resultUserSignUpWaiting);
        return bloc;
      },
      act: (UserRegistrationSettingBloc bloc) {
        return bloc.add(event);
      },
      expect: () => [
        isA<LoadingCenterUserRegistrationSettingState>(),
        isA<SuccessPrepareDataUserRegistrationSettingState>(),
      ],
      verify: (_) {
        verify(mockGetKvSetting(noParams));
        verify(mockGetUserSignUpWaiting(noParams));
      },
    );

    blocTest(
      'pastikan emit [LoadingCenterUserRegistrationSettingState, FailureUserRegistrationSettingState] ketika terima event '
      'PrepareDataUserRegistrationSettingEvent dengan proses gagal dari endpoint getKvSetting',
      build: () {
        final result = (failure: ServerFailure('testErrorMessage'), response: null);
        when(mockGetKvSetting(any)).thenAnswer((_) async => result);
        return bloc;
      },
      act: (UserRegistrationSettingBloc bloc) {
        return bloc.add(event);
      },
      expect: () => [
        isA<LoadingCenterUserRegistrationSettingState>(),
        isA<FailureUserRegistrationSettingState>(),
      ],
      verify: (_) {
        verify(mockGetKvSetting(noParams));
      },
    );

    blocTest(
      'pastikan emit [LoadingCenterUserRegistrationSettingState, FailureUserRegistrationSettingState] ketika terima event '
      'PrepareDataUserRegistrationSettingEvent dengan kondisi internet tidak terhubung ketika hit endpoint getKvSetting',
      build: () {
        final result = (failure: ConnectionFailure(), response: null);
        when(mockGetKvSetting(any)).thenAnswer((_) async => result);
        return bloc;
      },
      act: (UserRegistrationSettingBloc bloc) {
        return bloc.add(event);
      },
      expect: () => [
        isA<LoadingCenterUserRegistrationSettingState>(),
        isA<FailureUserRegistrationSettingState>(),
      ],
      verify: (_) {
        verify(mockGetKvSetting(noParams));
      },
    );

    blocTest(
      'pastikan emit [LoadingCenterUserRegistrationSettingState, FailureUserRegistrationSettingState] ketika terima event '
      'PrepareDataUserRegistrationSettingEvent dengan proses gagal parsing respon JSON dari endpoint getKvSetting',
      build: () {
        final result = (failure: ParsingFailure('testErrorMessage'), response: null);
        when(mockGetKvSetting(any)).thenAnswer((_) async => result);
        return bloc;
      },
      act: (UserRegistrationSettingBloc bloc) {
        return bloc.add(event);
      },
      expect: () => [
        isA<LoadingCenterUserRegistrationSettingState>(),
        isA<FailureUserRegistrationSettingState>(),
      ],
      verify: (_) {
        verify(mockGetKvSetting(noParams));
      },
    );

    blocTest(
      'pastikan emit [LoadingCenterUserRegistrationSettingState, FailureUserRegistrationSettingState] ketika terima event '
      'PrepareDataUserRegistrationSettingEvent dengan proses gagal dari endpoint getUserSignUpWaiting',
      build: () {
        final resultKvSetting = (failure: null, response: kvSettingResponse);
        final resultUserSignUpWaiting = (failure: ServerFailure('testErrorMessage'), response: null);
        when(mockGetKvSetting(any)).thenAnswer((_) async => resultKvSetting);
        when(mockGetUserSignUpWaiting(any)).thenAnswer((_) async => resultUserSignUpWaiting);
        return bloc;
      },
      act: (UserRegistrationSettingBloc bloc) {
        return bloc.add(event);
      },
      expect: () => [
        isA<LoadingCenterUserRegistrationSettingState>(),
        isA<FailureUserRegistrationSettingState>(),
      ],
      verify: (_) {
        verify(mockGetKvSetting(noParams));
        verify(mockGetUserSignUpWaiting(noParams));
      },
    );

    blocTest(
      'pastikan emit [LoadingCenterUserRegistrationSettingState, FailureUserRegistrationSettingState] ketika terima event '
      'PrepareDataUserRegistrationSettingEvent dengan kondisi internet tidak terhubung ketika hit endpoint getUserSignUpWaiting',
      build: () {
        final resultKvSetting = (failure: null, response: kvSettingResponse);
        final resultUserSignUpWaiting = (failure: ConnectionFailure(), response: null);
        when(mockGetKvSetting(any)).thenAnswer((_) async => resultKvSetting);
        when(mockGetUserSignUpWaiting(any)).thenAnswer((_) async => resultUserSignUpWaiting);
        return bloc;
      },
      act: (UserRegistrationSettingBloc bloc) {
        return bloc.add(event);
      },
      expect: () => [
        isA<LoadingCenterUserRegistrationSettingState>(),
        isA<FailureUserRegistrationSettingState>(),
      ],
      verify: (_) {
        verify(mockGetKvSetting(noParams));
        verify(mockGetUserSignUpWaiting(noParams));
      },
    );

    blocTest(
      'pastikan emit [LoadingCenterUserRegistrationSettingState, FailureUserRegistrationSettingState] ketika terima event '
      'PrepareDataUserRegistrationSettingEvent dengan proses gagal parsing respon JSON dari endpoint getUserSignUpWaiting',
      build: () {
        final resultKvSetting = (failure: null, response: kvSettingResponse);
        final resultUserSignUpWaiting = (failure: ParsingFailure('testErrorMessage'), response: null);
        when(mockGetKvSetting(any)).thenAnswer((_) async => resultKvSetting);
        when(mockGetUserSignUpWaiting(any)).thenAnswer((_) async => resultUserSignUpWaiting);
        return bloc;
      },
      act: (UserRegistrationSettingBloc bloc) {
        return bloc.add(event);
      },
      expect: () => [
        isA<LoadingCenterUserRegistrationSettingState>(),
        isA<FailureUserRegistrationSettingState>(),
      ],
      verify: (_) {
        verify(mockGetKvSetting(noParams));
        verify(mockGetUserSignUpWaiting(noParams));
      },
    );
  });
}
