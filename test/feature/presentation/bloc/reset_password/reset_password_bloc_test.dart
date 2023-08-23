import 'dart:convert';

import 'package:bloc_test/bloc_test.dart';
import 'package:dipantau_desktop_client/core/error/failure.dart';
import 'package:dipantau_desktop_client/feature/data/model/general/general_response.dart';
import 'package:dipantau_desktop_client/feature/data/model/reset_password/reset_password_body.dart';
import 'package:dipantau_desktop_client/feature/domain/usecase/reset_password/reset_password.dart';
import 'package:dipantau_desktop_client/feature/presentation/bloc/reset_password/reset_password_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../../../fixture/fixture_reader.dart';
import '../../../../helper/mock_helper.mocks.dart';

void main() {
  late ResetPasswordBloc bloc;
  late MockHelper mockHelper;
  late MockResetPassword mockResetPassword;

  const errorMessage = 'testErrorMessage';

  setUp(() {
    mockHelper = MockHelper();
    mockResetPassword = MockResetPassword();
    bloc = ResetPasswordBloc(
      helper: mockHelper,
      resetPassword: mockResetPassword,
    );
  });

  test(
    'pastikan output dari initial state',
    () async {
      // assert
      expect(
        bloc.state,
        isA<InitialResetPasswordState>(),
      );
    },
  );

  group('submit reset password', () {
    final body = ResetPasswordBody.fromJson(
      json.decode(
        fixture('reset_password_body.json'),
      ),
    );
    final params = ParamsResetPassword(body: body);
    final event = SubmitResetPasswordEvent(body: body);

    blocTest(
      'pastikan emit [LoadingResetPasswordState, SuccessResetPasswordState] ketika terima '
      'event SubmitResetPasswordEvent dengan proses berhasil',
      build: () {
        final response = GeneralResponse.fromJson(
          json.decode(
            fixture('general_response.json'),
          ),
        );
        final result = (failure: null, response: response);
        when(mockResetPassword(any)).thenAnswer((_) async => result);
        return bloc;
      },
      act: (ResetPasswordBloc bloc) {
        return bloc.add(event);
      },
      expect: () => [
        isA<LoadingResetPasswordState>(),
        isA<SuccessResetPasswordState>(),
      ],
      verify: (_) {
        verify(mockResetPassword(params));
      },
    );

    blocTest(
      'pastikan emit [LoadingResetPasswordState, FailureResetPasswordState] ketika terima '
      'event SubmitResetPasswordEvent dengan proses gagal dari endpoint',
      build: () {
        final result = (failure: ServerFailure(errorMessage), response: null);
        when(mockResetPassword(any)).thenAnswer((_) async => result);
        return bloc;
      },
      act: (ResetPasswordBloc bloc) {
        return bloc.add(event);
      },
      expect: () => [
        isA<LoadingResetPasswordState>(),
        isA<FailureResetPasswordState>(),
      ],
      verify: (_) {
        verify(mockResetPassword(params));
      },
    );

    blocTest(
      'pastikan emit [LoadingResetPasswordState, FailureResetPasswordState] ketika terima '
      'event SubmitResetPasswordEvent dengan kondisi internet tidak terhubung ketika hit endpoint',
      build: () {
        final result = (failure: ConnectionFailure(), response: null);
        when(mockResetPassword(any)).thenAnswer((_) async => result);
        return bloc;
      },
      act: (ResetPasswordBloc bloc) {
        return bloc.add(event);
      },
      expect: () => [
        isA<LoadingResetPasswordState>(),
        isA<FailureResetPasswordState>(),
      ],
      verify: (_) {
        verify(mockResetPassword(params));
      },
    );

    blocTest(
      'pastikan emit [LoadingResetPasswordState, FailureResetPasswordState] ketika terima '
      'event SubmitResetPasswordEvent dengan proses gagal parsing respon JSON endpoint',
      build: () {
        final result = (failure: ParsingFailure(errorMessage), response: null);
        when(mockResetPassword(any)).thenAnswer((_) async => result);
        return bloc;
      },
      act: (ResetPasswordBloc bloc) {
        return bloc.add(event);
      },
      expect: () => [
        isA<LoadingResetPasswordState>(),
        isA<FailureResetPasswordState>(),
      ],
      verify: (_) {
        verify(mockResetPassword(params));
      },
    );
  });
}
