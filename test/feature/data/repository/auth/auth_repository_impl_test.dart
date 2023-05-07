import 'dart:convert';

import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:dipantau_desktop_client/core/error/failure.dart';
import 'package:dipantau_desktop_client/feature/data/model/login/login_body.dart';
import 'package:dipantau_desktop_client/feature/data/model/login/login_response.dart';
import 'package:dipantau_desktop_client/feature/data/model/sign_up/sign_up_body.dart';
import 'package:dipantau_desktop_client/feature/data/model/sign_up/sign_up_response.dart';
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

  void testServerFailureString(Function whenInvoke, Function actInvoke, Function verifyInvoke) {
    test(
      'pastikan mengembalikan objek ServerFailure ketika EmployeeRepository menerima respon kegagalan '
      'dari endpoint dengan respon data html atau string',
      () async {
        // arrange
        setUpMockNetworkConnected();
        when(whenInvoke.call()).thenThrow(
          DioError(
            requestOptions: tRequestOptions,
            error: 'testError',
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

  void testParsingFailure(Function whenInvoke, Function actInvoke, Function verifyInvoke) {
    test(
      'pastikan mengembalikan objek ParsingFailure ketika GeneralRemoteDataSource menerima respon kegagalan '
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
      'pastikan mengembalikan objek model LoginResponse ketika GeneralRemoteDataSource berhasil menerima '
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
      'pastikan mengembalikan objek ServerFailure ketika GeneralRemoteDataSource berhasil menerima '
      'respon timeout dari endpoint',
      () async {
        // arrange
        setUpMockNetworkConnected();
        when(mockRemoteDataSource.login(any)).thenThrow(DioError(requestOptions: tRequestOptions, error: 'testError'));

        // act
        final result = await repository.login(tBody);

        // assert
        verify(mockRemoteDataSource.login(tBody));
        expect(result, Left(ServerFailure('testError')));
      },
    );

    test(
      'pastikan mengembalikan objek ServerFailure ketika GeneralRemoteDataSource menerima respon kegagalan '
      'dari endpoint',
      () async {
        // arrange
        setUpMockNetworkConnected();
        when(mockRemoteDataSource.login(any)).thenThrow(
          DioError(
            requestOptions: tRequestOptions,
            error: 'testError',
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
      'pastikan mengembalikan objek model SignUpResponse ketika GeneralRemoteDataSource berhasil menerima '
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
      'pastikan mengembalikan objek ServerFailure ketika GeneralRemoteDataSource berhasil menerima '
      'respon timeout dari endpoint',
      () async {
        // arrange
        setUpMockNetworkConnected();
        when(mockRemoteDataSource.signUp(any)).thenThrow(DioError(requestOptions: tRequestOptions, error: 'testError'));

        // act
        final result = await repository.signUp(tBody);

        // assert
        verify(mockRemoteDataSource.signUp(tBody));
        expect(result, Left(ServerFailure('testError')));
      },
    );

    test(
      'pastikan mengembalikan objek ServerFailure ketika GeneralRemoteDataSource menerima respon kegagalan '
      'dari endpoint',
      () async {
        // arrange
        setUpMockNetworkConnected();
        when(mockRemoteDataSource.signUp(any)).thenThrow(
          DioError(
            requestOptions: tRequestOptions,
            error: 'testError',
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
}
