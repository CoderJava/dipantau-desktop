import 'dart:convert';

import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:dipantau_desktop_client/core/error/failure.dart';
import 'package:dipantau_desktop_client/feature/data/model/track_user_lite/track_user_lite_response.dart';
import 'package:dipantau_desktop_client/feature/data/repository/track/track_repository_impl.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../../../fixture/fixture_reader.dart';
import '../../../../helper/mock_helper.mocks.dart';

void main() {
  late TrackRepositoryImpl repository;
  late MockTrackRemoteDataSource mockRemoteDataSource;
  late MockNetworkInfo mockNetworkInfo;

  setUp(() {
    mockRemoteDataSource = MockTrackRemoteDataSource();
    mockNetworkInfo = MockNetworkInfo();
    repository = TrackRepositoryImpl(
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

  group('getTrackUserLite', () {
    const tDate = 'testDate';
    const tProjectId = 'testProjectId';
    final tResponse = TrackUserLiteResponse.fromJson(
      json.decode(
        fixture('track_user_lite_response.json'),
      ),
    );

    test(
      'pastikan mengembalikan objek model TrackUserLiteResponse ketika RemoteDataSource berhasil menerima '
      'respon sukses dari endpoint',
      () async {
        // arrange
        setUpMockNetworkConnected();
        when(mockRemoteDataSource.getTrackUserLite(tDate, tProjectId)).thenAnswer((_) async => tResponse);

        // act
        final result = await repository.getTrackUserLite(tDate, tProjectId);

        // assert
        verify(mockRemoteDataSource.getTrackUserLite(tDate, tProjectId));
        expect(result, Right(tResponse));
      },
    );

    test(
      'pastikan mengembalikan objek ServerFailure ketika RemoteDataSource berhasil menerima '
      'respon timeout dari endpoint',
      () async {
        // arrange
        setUpMockNetworkConnected();
        when(mockRemoteDataSource.getTrackUserLite(tDate, tProjectId))
            .thenThrow(DioError(requestOptions: tRequestOptions, error: 'testError'));

        // act
        final result = await repository.getTrackUserLite(tDate, tProjectId);

        // assert
        verify(mockRemoteDataSource.getTrackUserLite(tDate, tProjectId));
        expect(result, Left(ServerFailure('testError')));
      },
    );

    test(
      'pastikan mengembalikan objek ServerFailure ketika RemoteDataSource menerima respon kegagalan '
      'dari endpoint',
      () async {
        // arrange
        setUpMockNetworkConnected();
        when(mockRemoteDataSource.getTrackUserLite(tDate, tProjectId)).thenThrow(
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
        final result = await repository.getTrackUserLite(tDate, tProjectId);

        // assert
        verify(mockRemoteDataSource.getTrackUserLite(tDate, tProjectId));
        expect(result, Left(ServerFailure('400 testMessageError')));
      },
    );

    testServerFailureString(
      () => mockRemoteDataSource.getTrackUserLite(tDate, tProjectId),
      () => repository.getTrackUserLite(tDate, tProjectId),
      () => mockRemoteDataSource.getTrackUserLite(tDate, tProjectId),
    );

    testParsingFailure(
      () => mockRemoteDataSource.getTrackUserLite(tDate, tProjectId),
      () => repository.getTrackUserLite(tDate, tProjectId),
      () => mockRemoteDataSource.getTrackUserLite(tDate, tProjectId),
    );

    testDisconnected(() => repository.getTrackUserLite(tDate, tProjectId));
  });
}
