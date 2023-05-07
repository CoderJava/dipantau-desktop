import 'dart:convert';

import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:dipantau_desktop_client/core/error/failure.dart';
import 'package:dipantau_desktop_client/feature/data/model/sign_up/sign_up_body.dart';
import 'package:dipantau_desktop_client/feature/data/model/sign_up/sign_up_response.dart';
import 'package:dipantau_desktop_client/feature/domain/usecase/sign_up/sign_up.dart';
import 'package:dipantau_desktop_client/feature/presentation/bloc/sign_up/sign_up_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../../../fixture/fixture_reader.dart';
import '../../../../helper/mock_helper.mocks.dart';

void main() {
  late SignUpBloc bloc;
  late MockSignUp mockSignUp;

  setUp(() {
    mockSignUp = MockSignUp();
    bloc = SignUpBloc(signUp: mockSignUp);
  });

  test(
    'pastikan output dari initialState',
    () async {
      // assert
      expect(
        bloc.state,
        InitialSignUpState(),
      );
    },
  );

  group('submit sign up', () {
    final tBody = SignUpBody.fromJson(
      json.decode(
        fixture('sign_up_body.json'),
      ),
    );
    final tResponse = SignUpResponse.fromJson(
      json.decode(
        fixture('sign_up_response.json'),
      ),
    );
    final tParams = SignUpParams(body: tBody);
    final tEvent = SubmitSignUpEvent(body: tBody);

    blocTest(
      'pastikan emit [LoadingSignUpState, SuccessSubmitSignUpState] ketika terima event '
      'SubmitSignUpEvent dengan proses berhasil',
      build: () {
        when(mockSignUp(any)).thenAnswer((_) async => Right(tResponse));
        return bloc;
      },
      act: (SignUpBloc bloc) {
        return bloc.add(tEvent);
      },
      expect: () => [
        LoadingSignUpState(),
        SuccessSubmitSignUpState(response: tResponse),
      ],
      verify: (_) {
        verify(mockSignUp(tParams));
      },
    );

    blocTest(
      'pastikan emit [LoadingSignUpState, FailureSignUpState] ketika terima event '
      'SubmitSignUpEvent dengan proses gagal dari endpoint',
      build: () {
        when(mockSignUp(any)).thenAnswer((_) async => Left(ServerFailure(ConstantErrorMessage().testErrorMessage)));
        return bloc;
      },
      act: (SignUpBloc bloc) {
        return bloc.add(tEvent);
      },
      expect: () => [
        LoadingSignUpState(),
        FailureSignUpState(errorMessage: ConstantErrorMessage().testErrorMessage),
      ],
      verify: (_) {
        verify(mockSignUp(tParams));
      },
    );

    blocTest(
      'pastikan emit [LoadingSignUpState, FailureSignUpState] ketika terima event '
      'SubmitSignUpEvent dengan kondisi internet tidak terhubung ketika hit endpoint',
      build: () {
        when(mockSignUp(any)).thenAnswer((_) async => Left(ConnectionFailure()));
        return bloc;
      },
      act: (SignUpBloc bloc) {
        return bloc.add(tEvent);
      },
      expect: () => [
        LoadingSignUpState(),
        FailureSignUpState(errorMessage: ConstantErrorMessage().connectionError),
      ],
      verify: (_) {
        verify(mockSignUp(tParams));
      },
    );

    blocTest(
      'pastikan emit [LoadingSignUpState, FailureSignUpState] ketika terima event '
      'SubmitSignUpEvent dengan proses gagal parsing respon JSON dari endpoint',
      build: () {
        when(mockSignUp(any)).thenAnswer((_) async => Left(ParsingFailure(ConstantErrorMessage().testErrorMessage)));
        return bloc;
      },
      act: (SignUpBloc bloc) {
        return bloc.add(tEvent);
      },
      expect: () => [
        LoadingSignUpState(),
        FailureSignUpState(errorMessage: ConstantErrorMessage().parsingError),
      ],
      verify: (_) {
        verify(mockSignUp(tParams));
      },
    );
  });
}
