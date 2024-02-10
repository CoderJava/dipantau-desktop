import 'dart:convert';

import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:dipantau_desktop_client/core/error/failure.dart';
import 'package:dipantau_desktop_client/feature/data/model/update_user/update_user_body.dart';
import 'package:dipantau_desktop_client/feature/data/model/user_profile/list_user_profile_response.dart';
import 'package:dipantau_desktop_client/feature/data/model/user_profile/user_profile_response.dart';
import 'package:dipantau_desktop_client/feature/data/model/user_sign_up_waiting/user_sign_up_waiting_response.dart';
import 'package:dipantau_desktop_client/feature/data/repository/user/user_repository_impl.dart';
import 'package:dipantau_desktop_client/feature/domain/usecase/user_version/user_version_body.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../../../fixture/fixture_reader.dart';
import '../../../../helper/mock_helper.mocks.dart';

void main() {
  late UserRepositoryImpl repository;
  late MockUserRemoteDataSource mockRemoteDataSource;
  late MockNetworkInfo mockNetworkInfo;

  setUp(() {
    mockRemoteDataSource = MockUserRemoteDataSource();
    mockNetworkInfo = MockNetworkInfo();
    repository = UserRepositoryImpl(
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

  group('getProfile', () {
    final tResponse = UserProfileResponse.fromJson(
      json.decode(
        fixture('user_profile_super_admin_response.json'),
      ),
    );

    test(
      'pastikan mengembalikan objek model UserProfileResponse ketika RemoteDataSource berhasil menerima '
      'respon sukses dari endpoint',
      () async {
        // arrange
        setUpMockNetworkConnected();
        when(mockRemoteDataSource.getProfile()).thenAnswer((_) async => tResponse);

        // act
        final result = await repository.getProfile();

        // assert
        verify(mockRemoteDataSource.getProfile());
        expect(result, Right(tResponse));
      },
    );

    test(
      'pastikan mengembalikan objek ServerFailure ketika RemoteDataSource berhasil menerima '
      'respon timeout dari endpoint',
      () async {
        // arrange
        setUpMockNetworkConnected();
        when(mockRemoteDataSource.getProfile())
            .thenThrow(DioException(requestOptions: tRequestOptions, message: 'testError'));

        // act
        final result = await repository.getProfile();

        // assert
        verify(mockRemoteDataSource.getProfile());
        expect(result, Left(ServerFailure('testError')));
      },
    );

    test(
      'pastikan mengembalikan objek ServerFailure ketika RemoteDataSource menerima respon kegagalan '
      'dari endpoint',
      () async {
        // arrange
        setUpMockNetworkConnected();
        when(mockRemoteDataSource.getProfile()).thenThrow(
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
        final result = await repository.getProfile();

        // assert
        verify(mockRemoteDataSource.getProfile());
        expect(result, Left(ServerFailure('400 testMessageError')));
      },
    );

    testServerFailureString(
      () => mockRemoteDataSource.getProfile(),
      () => repository.getProfile(),
      () => mockRemoteDataSource.getProfile(),
    );

    testParsingFailure(
      () => mockRemoteDataSource.getProfile(),
      () => repository.getProfile(),
      () => mockRemoteDataSource.getProfile(),
    );

    testDisconnected(() => repository.getProfile());
  });

  group('getAllMembers', () {
    final tResponse = ListUserProfileResponse.fromJson(
      json.decode(
        fixture('list_user_profile_response.json'),
      ),
    );

    test(
      'pastikan mengembalikan objek model ListUserProfileResponse ketika RemoteDataSource berhasil menerima '
      'respon sukses dari endpoint',
      () async {
        // arrange
        setUpMockNetworkConnected();
        when(mockRemoteDataSource.getAllMembers()).thenAnswer((_) async => tResponse);

        // act
        final result = await repository.getAllMembers();

        // assert
        verify(mockRemoteDataSource.getAllMembers());
        expect(result.response, tResponse);
      },
    );

    test(
      'pastikan mengembalikan objek ServerFailure ketika RemoteDataSource berhasil menerima '
      'respon timeout dari endpoint',
      () async {
        // arrange
        setUpMockNetworkConnected();
        when(mockRemoteDataSource.getAllMembers())
            .thenThrow(DioException(requestOptions: tRequestOptions, message: 'testError'));

        // act
        final result = await repository.getAllMembers();

        // assert
        verify(mockRemoteDataSource.getAllMembers());
        expect(result.failure, ServerFailure('testError'));
      },
    );

    test(
      'pastikan mengembalikan objek ServerFailure ketika RemoteDataSource menerima respon kegagalan '
      'dari endpoint',
      () async {
        // arrange
        setUpMockNetworkConnected();
        when(mockRemoteDataSource.getAllMembers()).thenThrow(
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
        final result = await repository.getAllMembers();

        // assert
        verify(mockRemoteDataSource.getAllMembers());
        expect(result.failure, ServerFailure('400 testMessageError'));
      },
    );

    testServerFailureString2(
      () => mockRemoteDataSource.getAllMembers(),
      () => repository.getAllMembers(),
      () => mockRemoteDataSource.getAllMembers(),
    );

    testParsingFailure2(
      () => mockRemoteDataSource.getAllMembers(),
      () => repository.getAllMembers(),
      () => mockRemoteDataSource.getAllMembers(),
    );

    testDisconnected2(() => repository.getAllMembers());
  });

  group('updateUser', () {
    const tId = 1;
    final tBody = UpdateUserBody.fromJson(
      json.decode(
        fixture('update_user_body.json'),
      ),
    );
    const tResponse = true;

    test(
      'pastikan mengembalikan boolean true ketika RemoteDataSource berhasil menerima '
      'respon sukses dari endpoint',
      () async {
        // arrange
        setUpMockNetworkConnected();
        when(mockRemoteDataSource.updateUser(any, any)).thenAnswer((_) async => tResponse);

        // act
        final result = await repository.updateUser(tBody, tId);

        // assert
        verify(mockRemoteDataSource.updateUser(tBody, tId));
        expect(result.response, tResponse);
      },
    );

    test(
      'pastikan mengembalikan objek ServerFailure ketika RemoteDataSource berhasil menerima '
      'respon timeout dari endpoint',
      () async {
        // arrange
        setUpMockNetworkConnected();
        when(mockRemoteDataSource.updateUser(any, any))
            .thenThrow(DioException(requestOptions: tRequestOptions, message: 'testError'));

        // act
        final result = await repository.updateUser(tBody, tId);

        // assert
        verify(mockRemoteDataSource.updateUser(tBody, tId));
        expect(result.failure, ServerFailure('testError'));
      },
    );

    test(
      'pastikan mengembalikan objek ServerFailure ketika RemoteDataSource menerima respon kegagalan '
      'dari endpoint',
      () async {
        // arrange
        setUpMockNetworkConnected();
        when(mockRemoteDataSource.updateUser(any, any)).thenThrow(
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
        final result = await repository.updateUser(tBody, tId);

        // assert
        verify(mockRemoteDataSource.updateUser(tBody, tId));
        expect(result.failure, ServerFailure('400 testMessageError'));
      },
    );

    testServerFailureString2(
      () => mockRemoteDataSource.updateUser(any, any),
      () => repository.updateUser(tBody, tId),
      () => mockRemoteDataSource.updateUser(tBody, tId),
    );

    testParsingFailure2(
      () => mockRemoteDataSource.updateUser(any, any),
      () => repository.updateUser(tBody, tId),
      () => mockRemoteDataSource.updateUser(tBody, tId),
    );

    testDisconnected2(() => repository.updateUser(tBody, tId));
  });

  group('sendAppVersion', () {
    final tBody = UserVersionBody.fromJson(
      json.decode(
        fixture('user_version_body.json'),
      ),
    );
    const tResponse = true;

    test(
      'pastikan mengembalikan boolean true ketika RemoteDataSource berhasil menerima '
      'respon sukses dari endpoint',
      () async {
        // arrange
        setUpMockNetworkConnected();
        when(mockRemoteDataSource.sendAppVersion(any)).thenAnswer((_) async => tResponse);

        // act
        final result = await repository.sendAppVersion(tBody);

        // assert
        verify(mockRemoteDataSource.sendAppVersion(tBody));
        expect(result.response, tResponse);
      },
    );

    test(
      'pastikan mengembalikan objek ServerFailure ketika RemoteDataSource berhasil menerima '
      'respon timeout dari endpoint',
      () async {
        // arrange
        setUpMockNetworkConnected();
        when(mockRemoteDataSource.sendAppVersion(any))
            .thenThrow(DioException(requestOptions: tRequestOptions, message: 'testError'));

        // act
        final result = await repository.sendAppVersion(tBody);

        // assert
        verify(mockRemoteDataSource.sendAppVersion(tBody));
        expect(result.failure, ServerFailure('testError'));
      },
    );

    test(
      'pastikan mengembalikan objek ServerFailure ketika RemoteDataSource menerima respon kegagalan '
      'dari endpoint',
      () async {
        // arrange
        setUpMockNetworkConnected();
        when(mockRemoteDataSource.sendAppVersion(any)).thenThrow(
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
        final result = await repository.sendAppVersion(tBody);

        // assert
        verify(mockRemoteDataSource.sendAppVersion(tBody));
        expect(result.failure, ServerFailure('400 testMessageError'));
      },
    );

    testServerFailureString2(
      () => mockRemoteDataSource.sendAppVersion(any),
      () => repository.sendAppVersion(tBody),
      () => mockRemoteDataSource.sendAppVersion(tBody),
    );

    testParsingFailure2(
      () => mockRemoteDataSource.sendAppVersion(any),
      () => repository.sendAppVersion(tBody),
      () => mockRemoteDataSource.sendAppVersion(tBody),
    );

    testDisconnected2(() => repository.sendAppVersion(tBody));
  });

  group('getUserSignUpWaiting', () {
    final tResponse = UserSignUpWaitingResponse.fromJson(
      json.decode(
        fixture('user_sign_up_waiting_response.json'),
      ),
    );

    test(
      'pastikan mengembalikan objek model UserSignUpWaitingResponse ketika RemoteDataSource berhasil menerima '
      'respon sukses dari endpoint',
      () async {
        // arrange
        setUpMockNetworkConnected();
        when(mockRemoteDataSource.getUserSignUpWaiting()).thenAnswer((_) async => tResponse);

        // act
        final result = await repository.getUserSignUpWaiting();

        // assert
        verify(mockRemoteDataSource.getUserSignUpWaiting());
        expect(result.response, tResponse);
      },
    );

    test(
      'pastikan mengembalikan objek ServerFailure ketika RemoteDataSource berhasil menerima '
      'respon timeout dari endpoint',
      () async {
        // arrange
        setUpMockNetworkConnected();
        when(mockRemoteDataSource.getUserSignUpWaiting())
            .thenThrow(DioException(requestOptions: tRequestOptions, message: 'testError'));

        // act
        final result = await repository.getUserSignUpWaiting();

        // assert
        verify(mockRemoteDataSource.getUserSignUpWaiting());
        expect(result.failure, ServerFailure('testError'));
      },
    );

    test(
      'pastikan mengembalikan objek ServerFailure ketika RemoteDataSource menerima respon kegagalan '
      'dari endpoint',
      () async {
        // arrange
        setUpMockNetworkConnected();
        when(mockRemoteDataSource.getUserSignUpWaiting()).thenThrow(
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
        final result = await repository.getUserSignUpWaiting();

        // assert
        verify(mockRemoteDataSource.getUserSignUpWaiting());
        expect(result.failure, ServerFailure('400 testMessageError'));
      },
    );

    testServerFailureString2(
      () => mockRemoteDataSource.getUserSignUpWaiting(),
      () => repository.getUserSignUpWaiting(),
      () => mockRemoteDataSource.getUserSignUpWaiting(),
    );

    testParsingFailure2(
      () => mockRemoteDataSource.getUserSignUpWaiting(),
      () => repository.getUserSignUpWaiting(),
      () => mockRemoteDataSource.getUserSignUpWaiting(),
    );

    testDisconnected2(() => repository.getUserSignUpWaiting());
  });
}
