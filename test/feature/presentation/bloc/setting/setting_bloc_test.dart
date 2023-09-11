import 'dart:convert';

import 'package:bloc_test/bloc_test.dart';
import 'package:dipantau_desktop_client/core/error/failure.dart';
import 'package:dipantau_desktop_client/core/usecase/usecase.dart';
import 'package:dipantau_desktop_client/feature/data/model/all_user_setting/all_user_setting_response.dart';
import 'package:dipantau_desktop_client/feature/data/model/kv_setting/kv_setting_body.dart';
import 'package:dipantau_desktop_client/feature/data/model/kv_setting/kv_setting_response.dart';
import 'package:dipantau_desktop_client/feature/data/model/user_setting/user_setting_body.dart';
import 'package:dipantau_desktop_client/feature/data/model/user_setting/user_setting_response.dart';
import 'package:dipantau_desktop_client/feature/domain/usecase/set_kv_setting/set_kv_setting.dart';
import 'package:dipantau_desktop_client/feature/domain/usecase/update_user_setting/update_user_setting.dart';
import 'package:dipantau_desktop_client/feature/presentation/bloc/setting/setting_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../../../fixture/fixture_reader.dart';
import '../../../../helper/mock_helper.mocks.dart';

void main() {
  late SettingBloc bloc;
  late MockHelper mockHelper;
  late MockGetKvSetting mockGetKvSetting;
  late MockSetKvSetting mockSetKvSetting;
  late MockGetUserSetting mockGetUserSetting;
  late MockGetAllUserSetting mockGetAllUserSetting;
  late MockUpdateUserSetting mockUpdateUserSetting;

  setUp(() {
    mockHelper = MockHelper();
    mockGetKvSetting = MockGetKvSetting();
    mockSetKvSetting = MockSetKvSetting();
    mockGetUserSetting = MockGetUserSetting();
    mockGetAllUserSetting = MockGetAllUserSetting();
    mockUpdateUserSetting = MockUpdateUserSetting();
    bloc = SettingBloc(
      helper: mockHelper,
      getKvSetting: mockGetKvSetting,
      setKvSetting: mockSetKvSetting,
      getUserSetting: mockGetUserSetting,
      getAllUserSetting: mockGetAllUserSetting,
      updateUserSetting: mockUpdateUserSetting,
    );
  });

  test(
    'pastikan nilai dari initialState',
    () async {
      // assert
      expect(
        bloc.state,
        isA<InitialSettingState>(),
      );
    },
  );

  const tErrorMessage = 'testErrorMessage';

  group('get kv setting', () {
    final tEvent = LoadKvSettingEvent();
    final tParams = NoParams();
    final tResponse = KvSettingResponse.fromJson(
      json.decode(
        fixture('kv_setting_response.json'),
      ),
    );

    blocTest(
      'pastikan emit [LoadingCenterSettingState, SuccessLoadKvSettingState] ketika terima event '
      'LoadKvSettingEvent dengan proses berhasil',
      build: () {
        final result = (failure: null, response: tResponse);
        when(mockGetKvSetting(any)).thenAnswer((_) async => result);
        return bloc;
      },
      act: (SettingBloc bloc) {
        return bloc.add(tEvent);
      },
      expect: () => [
        isA<LoadingCenterSettingState>(),
        isA<SuccessLoadKvSettingState>(),
      ],
      verify: (_) {
        verify(mockGetKvSetting(tParams));
      },
    );

    blocTest(
      'pastikan emit [LoadingCenterSettingState, FailureSettingState] ketika terima event '
      'LoadKvSettingEvent dengan proses gagal dari endpoint',
      build: () {
        final result = (failure: ServerFailure(tErrorMessage), response: null);
        when(mockGetKvSetting(any)).thenAnswer((_) async => result);
        return bloc;
      },
      act: (SettingBloc bloc) {
        return bloc.add(tEvent);
      },
      expect: () => [
        isA<LoadingCenterSettingState>(),
        isA<FailureSettingState>(),
      ],
      verify: (_) {
        verify(mockGetKvSetting(tParams));
      },
    );

    blocTest(
      'pastikan emit [LoadingCenterSettingState, FailureSettingState] ketika terima event '
      'LoadKvSettingEvent dengan kondisi internet tidak terhubung',
      build: () {
        final result = (failure: ConnectionFailure(), response: null);
        when(mockGetKvSetting(any)).thenAnswer((_) async => result);
        return bloc;
      },
      act: (SettingBloc bloc) {
        return bloc.add(tEvent);
      },
      expect: () => [
        isA<LoadingCenterSettingState>(),
        isA<FailureSettingState>(),
      ],
      verify: (_) {
        verify(mockGetKvSetting(tParams));
      },
    );

    blocTest(
      'pastikan emit [LoadingCenterSettingState, FailureSettingState] ketika terima event '
      'LoadKvSettingEvent dengan proses gagal parsing respon dari endpoint',
      build: () {
        final result = (failure: ParsingFailure(tErrorMessage), response: null);
        when(mockGetKvSetting(any)).thenAnswer((_) async => result);
        return bloc;
      },
      act: (SettingBloc bloc) {
        return bloc.add(tEvent);
      },
      expect: () => [
        isA<LoadingCenterSettingState>(),
        isA<FailureSettingState>(),
      ],
      verify: (_) {
        verify(mockGetKvSetting(tParams));
      },
    );
  });

  group('set kv setting', () {
    final tBody = KvSettingBody.fromJson(
      json.decode(
        fixture('kv_setting_body.json'),
      ),
    );
    final tEvent = UpdateKvSettingEvent(
      body: tBody,
    );
    final tParams = ParamsSetKvSetting(
      body: tBody,
    );
    const tResponse = true;

    blocTest(
      'pastikan emit [LoadingButtonSettingState, SuccessUpdateKvSettingState] ketika terima event '
      'UpdateKvSettingEvent dengan proses berhasil',
      build: () {
        const result = (failure: null, response: tResponse);
        when(mockSetKvSetting(any)).thenAnswer((_) async => result);
        return bloc;
      },
      act: (SettingBloc bloc) {
        return bloc.add(tEvent);
      },
      expect: () => [
        isA<LoadingButtonSettingState>(),
        isA<SuccessUpdateKvSettingState>(),
      ],
      verify: (_) {
        verify(mockSetKvSetting(tParams));
      },
    );

    blocTest(
      'pastikan emit [LoadingButtonSettingState, FailureSnackBarSettingState] ketika terima event '
      'UpdateKvSettingEvent dengan proses gagal dari endpoint',
      build: () {
        final result = (failure: ServerFailure(tErrorMessage), response: null);
        when(mockSetKvSetting(any)).thenAnswer((_) async => result);
        return bloc;
      },
      act: (SettingBloc bloc) {
        return bloc.add(tEvent);
      },
      expect: () => [
        isA<LoadingButtonSettingState>(),
        isA<FailureSnackBarSettingState>(),
      ],
      verify: (_) {
        verify(mockSetKvSetting(tParams));
      },
    );

    blocTest(
      'pastikan emit [LoadingButtonSettingState, FailureSnackBarSettingState] ketika terima event '
      'UpdateKvSettingEvent dengan kondisi internet tidak terhubung',
      build: () {
        final result = (failure: ConnectionFailure(), response: null);
        when(mockSetKvSetting(any)).thenAnswer((_) async => result);
        return bloc;
      },
      act: (SettingBloc bloc) {
        return bloc.add(tEvent);
      },
      expect: () => [
        isA<LoadingButtonSettingState>(),
        isA<FailureSnackBarSettingState>(),
      ],
      verify: (_) {
        verify(mockSetKvSetting(tParams));
      },
    );

    blocTest(
      'pastikan emit [LoadingButtonSettingState, FailureSnackBarSettingState] ketika terima event '
      'UpdateKvSettingEvent dengan proses gagal parsing respon dari endpoint',
      build: () {
        final result = (failure: ParsingFailure(tErrorMessage), response: null);
        when(mockSetKvSetting(any)).thenAnswer((_) async => result);
        return bloc;
      },
      act: (SettingBloc bloc) {
        return bloc.add(tEvent);
      },
      expect: () => [
        isA<LoadingButtonSettingState>(),
        isA<FailureSnackBarSettingState>(),
      ],
      verify: (_) {
        verify(mockSetKvSetting(tParams));
      },
    );
  });

  group('load user setting', () {
    final tEvent = LoadUserSettingEvent();
    final tParams = NoParams();
    final tResponse = UserSettingResponse.fromJson(
      json.decode(
        fixture('user_setting_response.json'),
      ),
    );

    blocTest(
      'pastikan emit [LoadingCenterSettingState, SuccessLoadUserSettingState] ketika terima event '
      'LoadUserSettingEvent dengan proses berhasil',
      build: () {
        final result = (failure: null, response: tResponse);
        when(mockGetUserSetting(any)).thenAnswer((_) async => result);
        return bloc;
      },
      act: (SettingBloc bloc) {
        return bloc.add(tEvent);
      },
      expect: () => [
        isA<LoadingCenterSettingState>(),
        isA<SuccessLoadUserSettingState>(),
      ],
      verify: (_) {
        verify(mockGetUserSetting(tParams));
      },
    );

    blocTest(
      'pastikan emit [LoadingCenterSettingState, FailureSettingState] ketika terima event '
      'LoadUserSettingEvent dengan proses gagal dari endpoint',
      build: () {
        final result = (failure: ServerFailure(tErrorMessage), response: null);
        when(mockGetUserSetting(any)).thenAnswer((_) async => result);
        return bloc;
      },
      act: (SettingBloc bloc) {
        return bloc.add(tEvent);
      },
      expect: () => [
        isA<LoadingCenterSettingState>(),
        isA<FailureSettingState>(),
      ],
      verify: (_) {
        verify(mockGetUserSetting(tParams));
      },
    );

    blocTest(
      'pastikan emit [LoadingCenterSettingState, FailureSettingState] ketika terima event '
      'LoadUserSettingEvent dengan kondisi internet tidak terhubung',
      build: () {
        final result = (failure: ConnectionFailure(), response: null);
        when(mockGetUserSetting(any)).thenAnswer((_) async => result);
        return bloc;
      },
      act: (SettingBloc bloc) {
        return bloc.add(tEvent);
      },
      expect: () => [
        isA<LoadingCenterSettingState>(),
        isA<FailureSettingState>(),
      ],
      verify: (_) {
        verify(mockGetUserSetting(tParams));
      },
    );

    blocTest(
      'pastikan emit [LoadingCenterSettingState, FailureSettingState] ketika terima event '
      'LoadUserSettingEvent dengan proses gagal parsing respon dari endpoint',
      build: () {
        final result = (failure: ParsingFailure(tErrorMessage), response: null);
        when(mockGetUserSetting(any)).thenAnswer((_) async => result);
        return bloc;
      },
      act: (SettingBloc bloc) {
        return bloc.add(tEvent);
      },
      expect: () => [
        isA<LoadingCenterSettingState>(),
        isA<FailureSettingState>(),
      ],
      verify: (_) {
        verify(mockGetUserSetting(tParams));
      },
    );
  });

  group('load all user setting', () {
    final tEvent = LoadAllUserSettingEvent();
    final tParams = NoParams();
    final tResponse = AllUserSettingResponse.fromJson(
      json.decode(
        fixture('all_user_setting_response.json'),
      ),
    );

    blocTest(
      'pastikan emit [LoadingCenterSettingState, SuccessLoadAllUserSettingState] ketika terima event '
      'LoadAllUserSettingEvent dengan proses berhasil',
      build: () {
        final result = (failure: null, response: tResponse);
        when(mockGetAllUserSetting(any)).thenAnswer((_) async => result);
        return bloc;
      },
      act: (SettingBloc bloc) {
        return bloc.add(tEvent);
      },
      expect: () => [
        isA<LoadingCenterSettingState>(),
        isA<SuccessLoadAllUserSettingState>(),
      ],
      verify: (_) {
        verify(mockGetAllUserSetting(tParams));
      },
    );

    blocTest(
      'pastikan emit [LoadingCenterSettingState, FailureSettingState] ketika terima event '
      'LoadAllUserSettingEvent dengan proses gagal dari endpoint',
      build: () {
        final result = (failure: ServerFailure(tErrorMessage), response: null);
        when(mockGetAllUserSetting(any)).thenAnswer((_) async => result);
        return bloc;
      },
      act: (SettingBloc bloc) {
        return bloc.add(tEvent);
      },
      expect: () => [
        isA<LoadingCenterSettingState>(),
        isA<FailureSettingState>(),
      ],
      verify: (_) {
        verify(mockGetAllUserSetting(tParams));
      },
    );

    blocTest(
      'pastikan emit [LoadingCenterSettingState, FailureSettingState] ketika terima event '
      'LoadAllUserSettingEvent dengan kondisi internet tidak terhubung',
      build: () {
        final result = (failure: ConnectionFailure(), response: null);
        when(mockGetAllUserSetting(any)).thenAnswer((_) async => result);
        return bloc;
      },
      act: (SettingBloc bloc) {
        return bloc.add(tEvent);
      },
      expect: () => [
        isA<LoadingCenterSettingState>(),
        isA<FailureSettingState>(),
      ],
      verify: (_) {
        verify(mockGetAllUserSetting(tParams));
      },
    );

    blocTest(
      'pastikan emit [LoadingCenterSettingState, FailureSettingState] ketika terima event '
      'LoadAllUserSettingEvent dengan proses gagal parsing respon dari endpoint',
      build: () {
        final result = (failure: ParsingFailure(tErrorMessage), response: null);
        when(mockGetAllUserSetting(any)).thenAnswer((_) async => result);
        return bloc;
      },
      act: (SettingBloc bloc) {
        return bloc.add(tEvent);
      },
      expect: () => [
        isA<LoadingCenterSettingState>(),
        isA<FailureSettingState>(),
      ],
      verify: (_) {
        verify(mockGetAllUserSetting(tParams));
      },
    );
  });

  group('update user setting', () {
    final tBody = UserSettingBody.fromJson(
      json.decode(
        fixture('user_setting_body.json'),
      ),
    );
    final tEvent = UpdateUserSettingEvent(
      body: tBody,
    );
    final tParams = ParamsUpdateUserSetting(
      body: tBody,
    );
    const tResponse = true;

    blocTest(
      'pastikan emit [LoadingButtonSettingState, SuccessUpdateUserSettingState] ketika terima event '
      'UpdateUserSettingEvent dengan proses berhasil',
      build: () {
        const result = (failure: null, response: tResponse);
        when(mockUpdateUserSetting(any)).thenAnswer((_) async => result);
        return bloc;
      },
      act: (SettingBloc bloc) {
        return bloc.add(tEvent);
      },
      expect: () => [
        isA<LoadingButtonSettingState>(),
        isA<SuccessUpdateUserSettingState>(),
      ],
      verify: (_) {
        verify(mockUpdateUserSetting(tParams));
      },
    );

    blocTest(
      'pastikan emit [LoadingButtonSettingState, FailureSnackBarSettingState] ketika terima event '
      'UpdateUserSettingEvent dengan proses gagal dari endpoint',
      build: () {
        final result = (failure: ServerFailure(tErrorMessage), response: null);
        when(mockUpdateUserSetting(any)).thenAnswer((_) async => result);
        return bloc;
      },
      act: (SettingBloc bloc) {
        return bloc.add(tEvent);
      },
      expect: () => [
        isA<LoadingButtonSettingState>(),
        isA<FailureSnackBarSettingState>(),
      ],
      verify: (_) {
        verify(mockUpdateUserSetting(tParams));
      },
    );

    blocTest(
      'pastikan emit [LoadingButtonSettingState, FailureSnackBarSettingState] ketika terima event '
      'UpdateUserSettingEvent dengan kondisi internet tidak terhubung',
      build: () {
        final result = (failure: ConnectionFailure(), response: null);
        when(mockUpdateUserSetting(any)).thenAnswer((_) async => result);
        return bloc;
      },
      act: (SettingBloc bloc) {
        return bloc.add(tEvent);
      },
      expect: () => [
        isA<LoadingButtonSettingState>(),
        isA<FailureSnackBarSettingState>(),
      ],
      verify: (_) {
        verify(mockUpdateUserSetting(tParams));
      },
    );

    blocTest(
      'pastikan emit [LoadingButtonSettingState, FailureSnackBarSettingState] ketika terima event '
      'UpdateUserSettingEvent dengan proses gagal parsing respon dari endpoint',
      build: () {
        final result = (failure: ParsingFailure(tErrorMessage), response: null);
        when(mockUpdateUserSetting(any)).thenAnswer((_) async => result);
        return bloc;
      },
      act: (SettingBloc bloc) {
        return bloc.add(tEvent);
      },
      expect: () => [
        isA<LoadingButtonSettingState>(),
        isA<FailureSnackBarSettingState>(),
      ],
      verify: (_) {
        verify(mockUpdateUserSetting(tParams));
      },
    );
  });
}
