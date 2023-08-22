import 'dart:convert';

import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:dipantau_desktop_client/core/error/failure.dart';
import 'package:dipantau_desktop_client/feature/data/model/forgot_password/forgot_password_body.dart';
import 'package:dipantau_desktop_client/feature/data/model/general/general_response.dart';
import 'package:dipantau_desktop_client/feature/data/model/login/login_body.dart';
import 'package:dipantau_desktop_client/feature/data/model/login/login_response.dart';
import 'package:dipantau_desktop_client/feature/data/model/refresh_token/refresh_token_body.dart';
import 'package:dipantau_desktop_client/feature/data/model/sign_up/sign_up_body.dart';
import 'package:dipantau_desktop_client/feature/data/model/sign_up/sign_up_response.dart';
import 'package:dipantau_desktop_client/feature/data/model/verify_forgot_password/verify_forgot_password_body.dart';
import 'package:dipantau_desktop_client/feature/data/repository/auth/auth_repository_impl.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../../../fixture/fixture_reader.dart';
import '../../../../helper/mock_helper.mocks.dart';

void main() {
  late AuthRepositoryImpl repository;
  late MockAuthRemoteDataSource mockRemoteDataSource;
  late MockNetworkInfo mockNetworkInfo;

  setUp(() {
    mockRemoteDataSource = MockAuthRemoteDataSource();
    mockNetworkInfo = MockNetworkInfo();
    repository = AuthRepositoryImpl(
      remoteDataSource: mockRemoteDataSource,
      networkInfo: mockNetworkInfo,
    );
  });

  final tRequestOptions = RequestOptions(path: '');

  void setUpMockNetworkConnected() {
    when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
  }

  void setUpMockNetworkDisconnected() {
    when(mockNetworkInfo.isConnected).thenAnswer((_) async => false);
  }

  void testDisconnected(Function endpointInvoke) {
    test(
      'pastikan mengembalikan objek ConnectionFailure ketika device tidak terhubung ke internet',
      () async {
        // arrange
        setUpMockNetworkDisconnected();

        // act
        final result = await endpointInvoke.call();

        // assert
        verify(mockNetworkInfo.isConnected);
        expect(result, Left(ConnectionFailure()));
      },
    );
  }

  void testDisconnected2(Function endpointInvoke) {
    test(
      'pastikan mengembalikan objek ConnectionFailure ketika device tidak terhubung ke internet',
      () async {
        // arrange
        setUpMockNetworkDisconnected();

        // act
        final result = await endpointInvoke.call();

        // assert
        verify(mockNetworkInfo.isConnected);
        expect(result.failure, ConnectionFailure());
      },
    );
  }

  void testServerFailureString(Function whenInvoke, Function actInvoke, Function verifyInvoke) {
    test(
      'pastikan mengembalikan objek ServerFailure ketika EmployeeRepository menerima respon kegagalan '
      'dari endpoint dengan respon data html atau string',
      () async {
        // arrange
        setUpMockNetworkConnected();
        when(whenInvoke.call()).thenThrow(
          DioException(
            requestOptions: tRequestOptions,
            message: 'testError',
            response: Response(
              requestOptions: tRequestOptions,
              data: 'testDataError',
              statusCode: 400,
            ),
          ),
        );

        // act
        final result = await actInvoke.call();

        // assert
        verify(verifyInvoke.call());
        expect(result, Left(ServerFailure('testError')));
      },
    );
  }

  void testServerFailureString2(Function whenInvoke, Function actInvoke, Function verifyInvoke) {
    test(
      'pastikan mengembalikan objek ServerFailure ketika repository menerima respon kegagalan '
      'dari endpoint dengan respon data html atau string',
      () async {
        // arrange
        setUpMockNetworkConnected();
        when(whenInvoke.call()).thenThrow(
          DioException(
            requestOptions: tRequestOptions,
            message: 'testError',
            response: Response(
              requestOptions: tRequestOptions,
              data: 'testDataError',
              statusCode: 400,
            ),
          ),
        );

        // act
        final result = await actInvoke.call();

        // assert
        verify(verifyInvoke.call());
        expect(result.failure, ServerFailure('testError'));
      },
    );
  }

  void testParsingFailure(Function whenInvoke, Function actInvoke, Function verifyInvoke) {
    test(
      'pastikan mengembalikan objek ParsingFailure ketika RemoteDataSource menerima respon kegagalan '
      'dari endpoint',
      () async {
        // arrange
        setUpMockNetworkConnected();
        when(whenInvoke.call()).thenThrow(TypeError());

        // act
        final result = await actInvoke.call();

        // assert
        verify(verifyInvoke.call());
        expect(result, Left(ParsingFailure(TypeError().toString())));
      },
    );
  }

  void testParsingFailure2(Function whenInvoke, Function actInvoke, Function verifyInvoke) {
    test(
      'pastikan mengembalikan objek ParsingFailure ketika RemoteDataSource menerima respon kegagalan '
      'dari endpoint',
      () async {
        // arrange
        setUpMockNetworkConnected();
        when(whenInvoke.call()).thenThrow(TypeError());

        // act
        final result = await actInvoke.call();

        // assert
        verify(verifyInvoke.call());
        expect(result.failure, ParsingFailure(TypeError().toString()));
      },
    );
  }

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

    test(
      'pastikan mengembalikan objek model LoginResponse ketika RemoteDataSource berhasil menerima '
      'respon sukses dari endpoint',
      () async {
        // arrange
        setUpMockNetworkConnected();
        when(mockRemoteDataSource.login(any)).thenAnswer((_) async => tResponse);

        // act
        final result = await repository.login(tBody);

        // assert
        verify(mockRemoteDataSource.login(tBody));
        expect(result, Right(tResponse));
      },
    );

    test(
      'pastikan mengembalikan objek ServerFailure ketika RemoteDataSource berhasil menerima '
      'respon timeout dari endpoint',
      () async {
        // arrange
        setUpMockNetworkConnected();
        when(mockRemoteDataSource.login(any))
            .thenThrow(DioException(requestOptions: tRequestOptions, message: 'testError'));

        // act
        final result = await repository.login(tBody);

        // assert
        verify(mockRemoteDataSource.login(tBody));
        expect(result, Left(ServerFailure('testError')));
      },
    );

    test(
      'pastikan mengembalikan objek ServerFailure ketika RemoteDataSource menerima respon kegagalan '
      'dari endpoint',
      () async {
        // arrange
        setUpMockNetworkConnected();
        when(mockRemoteDataSource.login(any)).thenThrow(
          DioException(
            requestOptions: tRequestOptions,
            message: 'testError',
            response: Response(
              requestOptions: tRequestOptions,
              data: {
                'title': 'testTitleError',
                'message': 'testMessageError',
              },
              statusCode: 400,
            ),
          ),
        );

        // act
        final result = await repository.login(tBody);

        // assert
        verify(mockRemoteDataSource.login(tBody));
        expect(result, Left(ServerFailure('400 testMessageError')));
      },
    );

    testServerFailureString(
      () => mockRemoteDataSource.login(any),
      () => repository.login(tBody),
      () => mockRemoteDataSource.login(tBody),
    );

    testParsingFailure(
      () => mockRemoteDataSource.login(any),
      () => repository.login(tBody),
      () => mockRemoteDataSource.login(tBody),
    );

    testDisconnected(() => repository.login(tBody));
  });

  group('sign up', () {
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

    test(
      'pastikan mengembalikan objek model SignUpResponse ketika RemoteDataSource berhasil menerima '
      'respon sukses dari endpoint',
      () async {
        // arrange
        setUpMockNetworkConnected();
        when(mockRemoteDataSource.signUp(any)).thenAnswer((_) async => tResponse);

        // act
        final result = await repository.signUp(tBody);

        // assert
        verify(mockRemoteDataSource.signUp(tBody));
        expect(result, Right(tResponse));
      },
    );

    test(
      'pastikan mengembalikan objek ServerFailure ketika RemoteDataSource berhasil menerima '
      'respon timeout dari endpoint',
      () async {
        // arrange
        setUpMockNetworkConnected();
        when(mockRemoteDataSource.signUp(any))
            .thenThrow(DioException(requestOptions: tRequestOptions, message: 'testError'));

        // act
        final result = await repository.signUp(tBody);

        // assert
        verify(mockRemoteDataSource.signUp(tBody));
        expect(result, Left(ServerFailure('testError')));
      },
    );

    test(
      'pastikan mengembalikan objek ServerFailure ketika RemoteDataSource menerima respon kegagalan '
      'dari endpoint',
      () async {
        // arrange
        setUpMockNetworkConnected();
        when(mockRemoteDataSource.signUp(any)).thenThrow(
          DioException(
            requestOptions: tRequestOptions,
            message: 'testError',
            response: Response(
              requestOptions: tRequestOptions,
              data: {
                'title': 'testTitleError',
                'message': 'testMessageError',
              },
              statusCode: 400,
            ),
          ),
        );

        // act
        final result = await repository.signUp(tBody);

        // assert
        verify(mockRemoteDataSource.signUp(tBody));
        expect(result, Left(ServerFailure('400 testMessageError')));
      },
    );

    testServerFailureString(
      () => mockRemoteDataSource.signUp(any),
      () => repository.signUp(tBody),
      () => mockRemoteDataSource.signUp(tBody),
    );

    testParsingFailure(
      () => mockRemoteDataSource.signUp(any),
      () => repository.signUp(tBody),
      () => mockRemoteDataSource.signUp(tBody),
    );

    testDisconnected(() => repository.signUp(tBody));
  });

  group('refresh token', () {
    final tBody = RefreshTokenBody.fromJson(
      json.decode(
        fixture('refresh_token_body.json'),
      ),
    );
    final tResponse = LoginResponse.fromJson(
      json.decode(
        fixture('login_response.json'),
      ),
    );

    test(
      'pastikan mengembalikan objek model LoginResponse ketika RemoteDataSource berhasil menerima '
      'respon sukses dari endpoint',
      () async {
        // arrange
        setUpMockNetworkConnected();
        when(mockRemoteDataSource.refreshToken(any)).thenAnswer((_) async => tResponse);

        // act
        final result = await repository.refreshToken(tBody);

        // assert
        verify(mockRemoteDataSource.refreshToken(tBody));
        expect(result, Right(tResponse));
      },
    );

    test(
      'pastikan mengembalikan objek ServerFailure ketika RemoteDataSource berhasil menerima '
      'respon timeout dari endpoint',
      () async {
        // arrange
        setUpMockNetworkConnected();
        when(mockRemoteDataSource.refreshToken(any))
            .thenThrow(DioException(requestOptions: tRequestOptions, message: 'testError'));

        // act
        final result = await repository.refreshToken(tBody);

        // assert
        verify(mockRemoteDataSource.refreshToken(tBody));
        expect(result, Left(ServerFailure('testError')));
      },
    );

    test(
      'pastikan mengembalikan objek ServerFailure ketika RemoteDataSource menerima respon kegagalan '
      'dari endpoint',
      () async {
        // arrange
        setUpMockNetworkConnected();
        when(mockRemoteDataSource.refreshToken(any)).thenThrow(
          DioException(
            requestOptions: tRequestOptions,
            message: 'testError',
            response: Response(
              requestOptions: tRequestOptions,
              data: {
                'title': 'testTitleError',
                'message': 'testMessageError',
              },
              statusCode: 400,
            ),
          ),
        );

        // act
        final result = await repository.refreshToken(tBody);

        // assert
        verify(mockRemoteDataSource.refreshToken(tBody));
        expect(result, Left(ServerFailure('400 testMessageError')));
      },
    );

    testServerFailureString(
      () => mockRemoteDataSource.refreshToken(any),
      () => repository.refreshToken(tBody),
      () => mockRemoteDataSource.refreshToken(tBody),
    );

    testParsingFailure(
      () => mockRemoteDataSource.refreshToken(any),
      () => repository.refreshToken(tBody),
      () => mockRemoteDataSource.refreshToken(tBody),
    );

    testDisconnected(() => repository.refreshToken(tBody));
  });

  group('forgot password', () {
    final tBody = ForgotPasswordBody.fromJson(
      json.decode(
        fixture('forgot_password_body.json'),
      ),
    );
    final tResponse = GeneralResponse.fromJson(
      json.decode(
        fixture('general_response.json'),
      ),
    );

    test(
      'pastikan mengembalikan objek model GeneralResponse ketika RemoteDataSource berhasil menerima '
      'respon sukses dari endpoint',
      () async {
        // arrange
        setUpMockNetworkConnected();
        when(mockRemoteDataSource.forgotPassword(any)).thenAnswer((_) async => tResponse);

        // act
        final result = await repository.forgotPassword(tBody);

        // assert
        verify(mockRemoteDataSource.forgotPassword(tBody));
        expect(result.response, tResponse);
      },
    );

    test(
      'pastikan mengembalikan objek ServerFailure ketika RemoteDataSource berhasil menerima '
      'respon timeout dari endpoint',
      () async {
        // arrange
        setUpMockNetworkConnected();
        when(mockRemoteDataSource.forgotPassword(any))
            .thenThrow(DioException(requestOptions: tRequestOptions, message: 'testError'));

        // act
        final result = await repository.forgotPassword(tBody);

        // assert
        verify(mockRemoteDataSource.forgotPassword(tBody));
        expect(result.failure, ServerFailure('testError'));
      },
    );

    test(
      'pastikan mengembalikan objek ServerFailure ketika RemoteDataSource menerima respon kegagalan '
      'dari endpoint',
      () async {
        // arrange
        setUpMockNetworkConnected();
        when(mockRemoteDataSource.forgotPassword(any)).thenThrow(
          DioException(
            requestOptions: tRequestOptions,
            message: 'testError',
            response: Response(
              requestOptions: tRequestOptions,
              data: {
                'title': 'testTitleError',
                'message': 'testMessageError',
              },
              statusCode: 400,
            ),
          ),
        );

        // act
        final result = await repository.forgotPassword(tBody);

        // assert
        verify(mockRemoteDataSource.forgotPassword(tBody));
        expect(result.failure, ServerFailure('400 testMessageError'));
      },
    );

    testServerFailureString2(
      () => mockRemoteDataSource.forgotPassword(any),
      () => repository.forgotPassword(tBody),
      () => mockRemoteDataSource.forgotPassword(tBody),
    );

    testParsingFailure2(
      () => mockRemoteDataSource.forgotPassword(any),
      () => repository.forgotPassword(tBody),
      () => mockRemoteDataSource.forgotPassword(tBody),
    );

    testDisconnected2(() => repository.forgotPassword(tBody));
  });

  group('verify forgot password', () {
    final tBody = VerifyForgotPasswordBody.fromJson(
      json.decode(
        fixture('verify_forgot_password_body.json'),
      ),
    );
    final tResponse = GeneralResponse.fromJson(
      json.decode(
        fixture('general_response.json'),
      ),
    );

    test(
      'pastikan mengembalikan objek model GeneralResponse ketika RemoteDataSource berhasil menerima '
          'respon sukses dari endpoint',
          () async {
        // arrange
        setUpMockNetworkConnected();
        when(mockRemoteDataSource.verifyForgotPassword(any)).thenAnswer((_) async => tResponse);

        // act
        final result = await repository.verifyForgotPassword(tBody);

        // assert
        verify(mockRemoteDataSource.verifyForgotPassword(tBody));
        expect(result.response, tResponse);
      },
    );

    test(
      'pastikan mengembalikan objek ServerFailure ketika RemoteDataSource berhasil menerima '
          'respon timeout dari endpoint',
          () async {
        // arrange
        setUpMockNetworkConnected();
        when(mockRemoteDataSource.verifyForgotPassword(any))
            .thenThrow(DioException(requestOptions: tRequestOptions, message: 'testError'));

        // act
        final result = await repository.verifyForgotPassword(tBody);

        // assert
        verify(mockRemoteDataSource.verifyForgotPassword(tBody));
        expect(result.failure, ServerFailure('testError'));
      },
    );

    test(
      'pastikan mengembalikan objek ServerFailure ketika RemoteDataSource menerima respon kegagalan '
          'dari endpoint',
          () async {
        // arrange
        setUpMockNetworkConnected();
        when(mockRemoteDataSource.verifyForgotPassword(any)).thenThrow(
          DioException(
            requestOptions: tRequestOptions,
            message: 'testError',
            response: Response(
              requestOptions: tRequestOptions,
              data: {
                'title': 'testTitleError',
                'message': 'testMessageError',
              },
              statusCode: 400,
            ),
          ),
        );

        // act
        final result = await repository.verifyForgotPassword(tBody);

        // assert
        verify(mockRemoteDataSource.verifyForgotPassword(tBody));
        expect(result.failure, ServerFailure('400 testMessageError'));
      },
    );

    testServerFailureString2(
          () => mockRemoteDataSource.verifyForgotPassword(any),
          () => repository.verifyForgotPassword(tBody),
          () => mockRemoteDataSource.verifyForgotPassword(tBody),
    );

    testParsingFailure2(
          () => mockRemoteDataSource.verifyForgotPassword(any),
          () => repository.verifyForgotPassword(tBody),
          () => mockRemoteDataSource.verifyForgotPassword(tBody),
    );

    testDisconnected2(() => repository.verifyForgotPassword(tBody));
  });
}
