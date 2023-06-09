import 'dart:convert';

import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:dipantau_desktop_client/core/error/failure.dart';
import 'package:dipantau_desktop_client/core/usecase/usecase.dart';
import 'package:dipantau_desktop_client/core/util/shared_preferences_manager.dart';
import 'package:dipantau_desktop_client/feature/data/model/login/login_body.dart';
import 'package:dipantau_desktop_client/feature/data/model/login/login_response.dart';
import 'package:dipantau_desktop_client/feature/data/model/user_profile/user_profile_response.dart';
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
  late MockGetProfile mockGetProfile;

  setUp(() {
    mockLogin = MockLogin();
    mockSharedPreferencesManager = MockSharedPreferencesManager();
    mockGetProfile = MockGetProfile();
    bloc = LoginBloc(
      login: mockLogin,
      sharedPreferencesManager: mockSharedPreferencesManager,
      getProfile: mockGetProfile,
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

  group('submit login', () {
    // TODO: lanjutkan di sini
    // Untuk fitur-nya yang sudah selesai adalah sebagai berikut:
    // 1. Fitur start/stop task
    // 2. Fitur screenshot
    // 3. Fitur activity
    // Fitur selanjutnya adalah simpan dan kirimkan data-data pada poin diatas ke server
    final tBody = LoginBody.fromJson(
      json.decode(
        fixture('login_body.json'),
      ),
    );
    final tLoginResponse = LoginResponse.fromJson(
      json.decode(
        fixture('login_response.json'),
      ),
    );
    final tLoginParams = LoginParams(body: tBody);
    final tUserProfileResponse = UserProfileResponse.fromJson(
      json.decode(
        fixture('user_profile_admin_response.json'),
      ),
    );
    final tNoParams = NoParams();
    final tEvent = SubmitLoginEvent(body: tBody);

    void buildMockSharedPreferencesManagerLogin() {
      when(mockSharedPreferencesManager.putString(SharedPreferencesManager.keyEmail, tBody.username))
          .thenAnswer((_) async => true);
      when(mockSharedPreferencesManager.putString(SharedPreferencesManager.keyUserId, (tUserProfileResponse.id ?? -1).toString()))
          .thenAnswer((_) async => true);
      when(mockSharedPreferencesManager.putString(SharedPreferencesManager.keyFullName, tUserProfileResponse.name))
          .thenAnswer((_) async => true);
      when(mockSharedPreferencesManager.putString(SharedPreferencesManager.keyUserRole, tUserProfileResponse.role?.name ?? ''))
          .thenAnswer((_) async => true);
      when(mockSharedPreferencesManager.putBool(SharedPreferencesManager.keyIsLogin, true))
          .thenAnswer((_) async => true);
    }

    void buildMockSharedPreferencesManagerToken() {
      when(mockSharedPreferencesManager.putString(SharedPreferencesManager.keyAccessToken, tLoginResponse.accessToken))
          .thenAnswer((_) async => true);
      when(mockSharedPreferencesManager.putString(
              SharedPreferencesManager.keyRefreshToken, tLoginResponse.refreshToken))
          .thenAnswer((_) async => true);
    }

    void buildMockSharedPreferencesManagerClearAll() {
      when(mockSharedPreferencesManager.clearAll()).thenAnswer((_) async => true);
    }

    void verifyMockSharedPreferencesManagerLogin() {
      verify(mockSharedPreferencesManager.putString(SharedPreferencesManager.keyEmail, tBody.username));
      verify(mockSharedPreferencesManager.putString(SharedPreferencesManager.keyUserId, (tUserProfileResponse.id ?? -1).toString()));
      verify(mockSharedPreferencesManager.putString(SharedPreferencesManager.keyFullName, tUserProfileResponse.name));
      verify(mockSharedPreferencesManager.putString(SharedPreferencesManager.keyUserRole, tUserProfileResponse.role?.name ?? ''));
      verify(mockSharedPreferencesManager.putBool(SharedPreferencesManager.keyIsLogin, true));
    }

    void verifyMockSharedPreferencesManagerToken() {
      verify(
          mockSharedPreferencesManager.putString(SharedPreferencesManager.keyAccessToken, tLoginResponse.accessToken));
      verify(mockSharedPreferencesManager.putString(
          SharedPreferencesManager.keyRefreshToken, tLoginResponse.refreshToken));
    }

    void verifyMockSharedPreferencesManagerClearAll() {
      verify(mockSharedPreferencesManager.clearAll());
    }

    blocTest(
      'pastikan emit [LoadingLoginState, SuccessSubmitLoginState] ketika terima event '
      'SubmitLoginEvent dengan proses berhasil',
      build: () {
        when(mockLogin(any)).thenAnswer((_) async => Right(tLoginResponse));
        buildMockSharedPreferencesManagerToken();
        when(mockGetProfile(any)).thenAnswer((_) async => Right(tUserProfileResponse));
        buildMockSharedPreferencesManagerLogin();
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
        verify(mockLogin(tLoginParams));
        verifyMockSharedPreferencesManagerToken();
        verify(mockGetProfile(tNoParams));
        verifyMockSharedPreferencesManagerLogin();
      },
    );

    blocTest(
      'pastikan emit [LoadingLoginState, FailureLoginState] ketika terima event '
      'SubmitLoginEvent dengan proses gagal dari endpoint login',
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
        verify(mockLogin(tLoginParams));
      },
    );

    blocTest(
      'pastikan emit [LoadingLoginState, FailureLoginState] ketika terima event '
      'SubmitLoginEvent dengan kondisi internet tidak terhubung ketika hit endpoint login',
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
        verify(mockLogin(tLoginParams));
      },
    );

    blocTest(
      'pastikan emit [LoadingLoginState, FailureLoginState] ketika terima event '
      'SubmitLoginEvent dengan proses gagal parsing respon JSON dari endpoint login',
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
        verify(mockLogin(tLoginParams));
      },
    );

    blocTest(
      'pastikan emit [LoadingLoginState, FailureLoginState] ketika terima event '
      'SubmitLoginEvent dengan proses gagal dari endpoint getProfile',
      build: () {
        when(mockLogin(any)).thenAnswer((_) async => Right(tLoginResponse));
        buildMockSharedPreferencesManagerToken();
        when(mockGetProfile(any)).thenAnswer((_) async => Left(ServerFailure(ConstantErrorMessage().testErrorMessage)));
        buildMockSharedPreferencesManagerClearAll();
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
        verify(mockLogin(tLoginParams));
        verifyMockSharedPreferencesManagerToken();
        verify(mockGetProfile(tNoParams));
        verifyMockSharedPreferencesManagerClearAll();
      },
    );

    blocTest(
      'pastikan emit [LoadingLoginState, FailureLoginState] ketika terima event '
      'SubmitLoginEvent dengan kondisi internet tidak terhubung ketika hit endpoint getProfile',
      build: () {
        when(mockLogin(any)).thenAnswer((_) async => Right(tLoginResponse));
        buildMockSharedPreferencesManagerToken();
        when(mockGetProfile(any)).thenAnswer((_) async => Left(ConnectionFailure()));
        buildMockSharedPreferencesManagerClearAll();
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
        verify(mockLogin(tLoginParams));
        verifyMockSharedPreferencesManagerToken();
        verify(mockGetProfile(tNoParams));
        verifyMockSharedPreferencesManagerClearAll();
      },
    );

    blocTest(
      'pastikan emit [LoadingLoginState, FailureLoginState] ketika terima event '
      'SubmitLoginEvent dengan proses gagal parsing respon dari endpoint getProfile',
      build: () {
        when(mockLogin(any)).thenAnswer((_) async => Right(tLoginResponse));
        buildMockSharedPreferencesManagerToken();
        when(mockGetProfile(any))
            .thenAnswer((_) async => Left(ParsingFailure(ConstantErrorMessage().testErrorMessage)));
        buildMockSharedPreferencesManagerClearAll();
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
        verify(mockLogin(tLoginParams));
        verifyMockSharedPreferencesManagerToken();
        verify(mockGetProfile(tNoParams));
        verifyMockSharedPreferencesManagerClearAll();
      },
    );
  });
}
