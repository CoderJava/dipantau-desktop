import 'dart:convert';

import 'package:bloc_test/bloc_test.dart';
import 'package:dipantau_desktop_client/core/error/failure.dart';
import 'package:dipantau_desktop_client/core/usecase/usecase.dart';
import 'package:dipantau_desktop_client/feature/data/model/kv_setting/kv_setting_body.dart';
import 'package:dipantau_desktop_client/feature/data/model/kv_setting/kv_setting_response.dart';
import 'package:dipantau_desktop_client/feature/domain/usecase/set_kv_setting/set_kv_setting.dart';
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

  setUp(() {
    mockHelper = MockHelper();
    mockGetKvSetting = MockGetKvSetting();
    mockSetKvSetting = MockSetKvSetting();
    bloc = SettingBloc(
      helper: mockHelper,
      getKvSetting: mockGetKvSetting,
      setKvSetting: mockSetKvSetting,
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
}
