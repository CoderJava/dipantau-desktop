import 'dart:convert';

import 'package:bloc_test/bloc_test.dart';
import 'package:dipantau_desktop_client/core/error/failure.dart';
import 'package:dipantau_desktop_client/feature/data/model/forgot_password/forgot_password_body.dart';
import 'package:dipantau_desktop_client/feature/data/model/general/general_response.dart';
import 'package:dipantau_desktop_client/feature/domain/usecase/forgot_password/forgot_password.dart';
import 'package:dipantau_desktop_client/feature/presentation/bloc/forgot_password/forgot_password_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../../../fixture/fixture_reader.dart';
import '../../../../helper/mock_helper.mocks.dart';

void main() {
  late ForgotPasswordBloc bloc;
  late MockHelper mockHelper;
  late MockForgotPassword mockForgotPassword;

  const errorMessage = 'testErrorMessage';

  setUp(() {
    mockHelper = MockHelper();
    mockForgotPassword = MockForgotPassword();
    bloc = ForgotPasswordBloc(
      helper: mockHelper,
      forgotPassword: mockForgotPassword,
    );
  });

  test(
    'pastikan output dari initialState',
    () async {
      // assert
      expect(
        bloc.state,
        isA<InitialForgotPasswordState>(),
      );
    },
  );

  group('submit forgot password', () {
    final body = ForgotPasswordBody.fromJson(
      json.decode(
        fixture('forgot_password_body.json'),
      ),
    );
    final params = ParamsForgotPassword(body: body);
    final event = SubmitForgotPasswordEvent(body: body);

    blocTest(
      'pastikan emit [LoadingForgotPasswordState, SuccessForgotPasswordState] ketika terima event '
      'SubmitForgotPasswordEvent dengan proses berhasil',
      build: () {
        final response = GeneralResponse.fromJson(
          json.decode(
            fixture('general_response.json'),
          ),
        );
        final result = (failure: null, response: response);
        when(mockForgotPassword(any)).thenAnswer((_) async => result);
        return bloc;
      },
      act: (ForgotPasswordBloc bloc) {
        return bloc.add(event);
      },
      expect: () => [
        isA<LoadingForgotPasswordState>(),
        isA<SuccessForgotPasswordState>(),
      ],
      verify: (_) {
        verify(mockForgotPassword(params));
      },
    );

    blocTest(
      'pastikan emit [LoadingForgotPasswordState, FailureForgotPasswordState] ketika terima event '
      'SubmitForgotPasswordEvent dengan proses gagal dari endpoint',
      build: () {
        final result = (failure: ServerFailure(errorMessage), response: null);
        when(mockForgotPassword(any)).thenAnswer((_) async => result);
        return bloc;
      },
      act: (ForgotPasswordBloc bloc) {
        return bloc.add(event);
      },
      expect: () => [
        isA<LoadingForgotPasswordState>(),
        isA<FailureForgotPasswordState>(),
      ],
      verify: (_) {
        verify(mockForgotPassword(params));
      },
    );

    blocTest(
      'pastikan emit [LoadingForgotPasswordState, FailureForgotPasswordState] ketika terima event '
      'SubmitForgotPasswordEvent dengan kondisi internet tidak terhubung ketika hit endpoint',
      build: () {
        final result = (failure: ConnectionFailure(), response: null);
        when(mockForgotPassword(any)).thenAnswer((_) async => result);
        return bloc;
      },
      act: (ForgotPasswordBloc bloc) {
        return bloc.add(event);
      },
      expect: () => [
        isA<LoadingForgotPasswordState>(),
        isA<FailureForgotPasswordState>(),
      ],
      verify: (_) {
        verify(mockForgotPassword(params));
      },
    );

    blocTest(
      'pastikan emit [LoadingForgotPasswordState, FailureForgotPasswordState] ketika terima event '
      'SubmitForgotPasswordEvent dengan proses gagal parsing respon JSON dari endpoint',
      build: () {
        final result = (failure: ParsingFailure(errorMessage), response: null);
        when(mockForgotPassword(any)).thenAnswer((_) async => result);
        return bloc;
      },
      act: (ForgotPasswordBloc bloc) {
        return bloc.add(event);
      },
      expect: () => [
        isA<LoadingForgotPasswordState>(),
        isA<FailureForgotPasswordState>(),
      ],
      verify: (_) {
        verify(mockForgotPassword(params));
      },
    );
  });
}
