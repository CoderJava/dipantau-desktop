import 'dart:convert';

import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:dipantau_desktop_client/core/error/failure.dart';
import 'package:dipantau_desktop_client/core/util/shared_preferences_manager.dart';
import 'package:dipantau_desktop_client/feature/data/model/login/login_body.dart';
import 'package:dipantau_desktop_client/feature/data/model/login/login_response.dart';
import 'package:dipantau_desktop_client/feature/domain/usecase/login/login.dart';
import 'package:dipantau_desktop_client/feature/presentation/bloc/login/login_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../../../fixture/fixture_reader.dart';
import '../../../../helper/mock_helper.mocks.dart';

void main() {
  late LoginBloc bloc;
  late MockLogin mockLogin;
  late MockSharedPreferencesManager mockSharedPreferencesManager;

  setUp(() {
    mockLogin = MockLogin();
    mockSharedPreferencesManager = MockSharedPreferencesManager();
    bloc = LoginBloc(
      login: mockLogin,
      sharedPreferencesManager: mockSharedPreferencesManager,
    );
  });

  test(
    'pastikan output dari nilai initialState',
    () async {
      // assert
      expect(
        bloc.state,
        InitialLoginState(),
      );
    },
  );

  group('login', () {
    final tBody = LoginBody.fromJson(
      json.decode(
        fixture('login_body.json'),
      ),
    );
    final tResponse = LoginResponse.fromJson(
      json.decode(
        fixture('login_response.json'),
      ),
    );
    final tParams = LoginParams(body: tBody);
    final tEvent = SubmitLoginEvent(body: tBody);

    void buildMockSharedPreferencesManager() {
      when(mockSharedPreferencesManager.putString(SharedPreferencesManager.keyEmail, tBody.username))
          .thenAnswer((_) async => true);
      when(mockSharedPreferencesManager.putBool(SharedPreferencesManager.keyIsLogin, true))
          .thenAnswer((_) async => true);
      when(mockSharedPreferencesManager.putString(SharedPreferencesManager.keyAccessToken, tResponse.accessToken))
          .thenAnswer((_) async => true);
      when(mockSharedPreferencesManager.putString(SharedPreferencesManager.keyRefreshToken, tResponse.refreshToken))
          .thenAnswer((_) async => true);
      when(mockSharedPreferencesManager.putString(SharedPreferencesManager.keyUserRole, tResponse.role!.name))
          .thenAnswer((_) async => true);
    }

    void verifyMockSharedPreferencesManager() {
      verify(mockSharedPreferencesManager.putString(SharedPreferencesManager.keyEmail, tBody.username));
      verify(mockSharedPreferencesManager.putBool(SharedPreferencesManager.keyIsLogin, true));
      verify(mockSharedPreferencesManager.putString(SharedPreferencesManager.keyAccessToken, tResponse.accessToken));
      verify(mockSharedPreferencesManager.putString(SharedPreferencesManager.keyRefreshToken, tResponse.refreshToken));
      verify(mockSharedPreferencesManager.putString(SharedPreferencesManager.keyUserRole, tResponse.role!.name));
    }

    blocTest(
      'pastikan emit [LoadingLoginState, SuccessSubmitLoginState] ketika terima event '
      'SubmitLoginEvent dengan proses berhasil',
      build: () {
        when(mockLogin(any)).thenAnswer((_) async => Right(tResponse));
        buildMockSharedPreferencesManager();
        return bloc;
      },
      act: (LoginBloc bloc) {
        return bloc.add(tEvent);
      },
      expect: () => [
        LoadingLoginState(),
        SuccessSubmitLoginState(),
      ],
      verify: (_) {
        verify(mockLogin(tParams));
        verifyMockSharedPreferencesManager();
      },
    );

    blocTest(
      'pastikan emit [LoadingLoginState, FailureLoginState] ketika terima event '
      'SubmitLoginEvent dengan proses gagal dari endpoint',
      build: () {
        when(mockLogin(any)).thenAnswer((_) async => Left(ServerFailure(ConstantErrorMessage().testErrorMessage)));
        return bloc;
      },
      act: (LoginBloc bloc) {
        return bloc.add(tEvent);
      },
      expect: () => [
        LoadingLoginState(),
        FailureLoginState(errorMessage: ConstantErrorMessage().testErrorMessage),
      ],
      verify: (_) {
        verify(mockLogin(tParams));
      },
    );

    blocTest(
      'pastikan emit [LoadingLoginState, FailureLoginState] ketika terima event '
      'SubmitLoginEvent dengan kondisi internet tidak terhubung ketika hit endpoint',
      build: () {
        when(mockLogin(any)).thenAnswer((_) async => Left(ConnectionFailure()));
        return bloc;
      },
      act: (LoginBloc bloc) {
        return bloc.add(tEvent);
      },
      expect: () => [
        LoadingLoginState(),
        FailureLoginState(errorMessage: ConstantErrorMessage().connectionError),
      ],
      verify: (_) {
        verify(mockLogin(tParams));
      },
    );

    blocTest(
      'pastikan emit [LoadingLoginState, FailureLoginState] ketika terima event '
      'SubmitLoginEvent dengan proses gagal parsing respon JSON dari endpoint',
      build: () {
        when(mockLogin(any)).thenAnswer((_) async => Left(ParsingFailure(ConstantErrorMessage().testErrorMessage)));
        return bloc;
      },
      act: (LoginBloc bloc) {
        return bloc.add(tEvent);
      },
      expect: () => [
        LoadingLoginState(),
        FailureLoginState(errorMessage: ConstantErrorMessage().parsingError),
      ],
      verify: (_) {
        verify(mockLogin(tParams));
      },
    );
  });
}
