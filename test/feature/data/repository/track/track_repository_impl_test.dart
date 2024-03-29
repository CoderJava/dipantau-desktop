import 'dart:convert';

import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:dipantau_desktop_client/core/error/failure.dart';
import 'package:dipantau_desktop_client/feature/data/model/create_track/bulk_create_track_data_body.dart';
import 'package:dipantau_desktop_client/feature/data/model/create_track/bulk_create_track_image_body.dart';
import 'package:dipantau_desktop_client/feature/data/model/create_track/create_track_body.dart';
import 'package:dipantau_desktop_client/feature/data/model/general/general_response.dart';
import 'package:dipantau_desktop_client/feature/data/model/manual_create_track/manual_create_track_body.dart';
import 'package:dipantau_desktop_client/feature/data/model/track_user/track_user_response.dart';
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
        when(mockRemoteDataSource.getTrackUserLite(any, any)).thenAnswer((_) async => tResponse);

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
        when(mockRemoteDataSource.getTrackUserLite(any, any))
            .thenThrow(DioException(requestOptions: tRequestOptions, message: 'testError'));

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
        when(mockRemoteDataSource.getTrackUserLite(any, any)).thenThrow(
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
        final result = await repository.getTrackUserLite(tDate, tProjectId);

        // assert
        verify(mockRemoteDataSource.getTrackUserLite(tDate, tProjectId));
        expect(result, Left(ServerFailure('400 testMessageError')));
      },
    );

    testServerFailureString(
      () => mockRemoteDataSource.getTrackUserLite(any, any),
      () => repository.getTrackUserLite(tDate, tProjectId),
      () => mockRemoteDataSource.getTrackUserLite(tDate, tProjectId),
    );

    testParsingFailure(
      () => mockRemoteDataSource.getTrackUserLite(any, any),
      () => repository.getTrackUserLite(tDate, tProjectId),
      () => mockRemoteDataSource.getTrackUserLite(tDate, tProjectId),
    );

    testDisconnected(() => repository.getTrackUserLite(tDate, tProjectId));
  });

  group('createTrack', () {
    final tBody = CreateTrackBody.fromJson(
      json.decode(
        fixture('create_track_body.json'),
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
        when(mockRemoteDataSource.createTrack(any)).thenAnswer((_) async => tResponse);

        // act
        final result = await repository.createTrack(tBody);

        // assert
        verify(mockRemoteDataSource.createTrack(tBody));
        expect(result.response, tResponse);
      },
    );

    test(
      'pastikan mengembalikan objek ServerFailure ketika RemoteDataSource berhasil menerima '
      'respon timeout dari endpoint',
      () async {
        // arrange
        setUpMockNetworkConnected();
        when(mockRemoteDataSource.createTrack(any))
            .thenThrow(DioException(requestOptions: tRequestOptions, message: 'testError'));

        // act
        final result = await repository.createTrack(tBody);

        // assert
        verify(mockRemoteDataSource.createTrack(tBody));
        expect(result.failure, ServerFailure('testError'));
      },
    );

    test(
      'pastikan mengembalikan objek ServerFailure ketika RemoteDataSource menerima respon kegagalan '
      'dari endpoint',
      () async {
        // arrange
        setUpMockNetworkConnected();
        when(mockRemoteDataSource.createTrack(any)).thenThrow(
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
        final result = await repository.createTrack(tBody);

        // assert
        verify(mockRemoteDataSource.createTrack(tBody));
        expect(result.failure, ServerFailure('400 testMessageError'));
      },
    );

    testServerFailureString2(
      () => mockRemoteDataSource.createTrack(any),
      () => repository.createTrack(tBody),
      () => mockRemoteDataSource.createTrack(tBody),
    );

    testParsingFailure2(
      () => mockRemoteDataSource.createTrack(any),
      () => repository.createTrack(tBody),
      () => mockRemoteDataSource.createTrack(tBody),
    );

    testDisconnected2(() => repository.createTrack(tBody));
  });

  group('bulkCreateTrackData', () {
    final tBody = BulkCreateTrackDataBody.fromJson(
      json.decode(
        fixture('bulk_create_track_data_body.json'),
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
        when(mockRemoteDataSource.bulkCreateTrackData(any)).thenAnswer((_) async => tResponse);

        // act
        final result = await repository.bulkCreateTrackData(tBody);

        // assert
        verify(mockRemoteDataSource.bulkCreateTrackData(tBody));
        expect(result.response, tResponse);
      },
    );

    test(
      'pastikan mengembalikan objek ServerFailure ketika RemoteDataSource berhasil menerima '
      'respon timeout dari endpoint',
      () async {
        // arrange
        setUpMockNetworkConnected();
        when(mockRemoteDataSource.bulkCreateTrackData(any))
            .thenThrow(DioException(requestOptions: tRequestOptions, message: 'testError'));

        // act
        final result = await repository.bulkCreateTrackData(tBody);

        // assert
        verify(mockRemoteDataSource.bulkCreateTrackData(tBody));
        expect(result.failure, ServerFailure('testError'));
      },
    );

    test(
      'pastikan mengembalikan objek ServerFailure ketika RemoteDataSource menerima respon kegagalan '
      'dari endpoint',
      () async {
        // arrange
        setUpMockNetworkConnected();
        when(mockRemoteDataSource.bulkCreateTrackData(any)).thenThrow(
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
        final result = await repository.bulkCreateTrackData(tBody);

        // assert
        verify(mockRemoteDataSource.bulkCreateTrackData(tBody));
        expect(result.failure, ServerFailure('400 testMessageError'));
      },
    );

    testServerFailureString2(
      () => mockRemoteDataSource.bulkCreateTrackData(any),
      () => repository.bulkCreateTrackData(tBody),
      () => mockRemoteDataSource.bulkCreateTrackData(tBody),
    );

    testParsingFailure2(
      () => mockRemoteDataSource.bulkCreateTrackData(any),
      () => repository.bulkCreateTrackData(tBody),
      () => mockRemoteDataSource.bulkCreateTrackData(tBody),
    );

    testDisconnected2(() => repository.bulkCreateTrackData(tBody));
  });

  group('bulkCreateTrackImage', () {
    final tBody = BulkCreateTrackImageBody.fromJson(
      json.decode(
        fixture('bulk_create_track_image_body.json'),
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
        when(mockRemoteDataSource.bulkCreateTrackImage(any)).thenAnswer((_) async => tResponse);

        // act
        final result = await repository.bulkCreateTrackImage(tBody);

        // assert
        verify(mockRemoteDataSource.bulkCreateTrackImage(tBody));
        expect(result.response, tResponse);
      },
    );

    test(
      'pastikan mengembalikan objek ServerFailure ketika RemoteDataSource berhasil menerima '
      'respon timeout dari endpoint',
      () async {
        // arrange
        setUpMockNetworkConnected();
        when(mockRemoteDataSource.bulkCreateTrackImage(any))
            .thenThrow(DioException(requestOptions: tRequestOptions, message: 'testError'));

        // act
        final result = await repository.bulkCreateTrackImage(tBody);

        // assert
        verify(mockRemoteDataSource.bulkCreateTrackImage(tBody));
        expect(result.failure, ServerFailure('testError'));
      },
    );

    test(
      'pastikan mengembalikan objek ServerFailure ketika RemoteDataSource menerima respon kegagalan '
      'dari endpoint',
      () async {
        // arrange
        setUpMockNetworkConnected();
        when(mockRemoteDataSource.bulkCreateTrackImage(any)).thenThrow(
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
        final result = await repository.bulkCreateTrackImage(tBody);

        // assert
        verify(mockRemoteDataSource.bulkCreateTrackImage(tBody));
        expect(result.failure, ServerFailure('400 testMessageError'));
      },
    );

    testServerFailureString2(
      () => mockRemoteDataSource.bulkCreateTrackImage(any),
      () => repository.bulkCreateTrackImage(tBody),
      () => mockRemoteDataSource.bulkCreateTrackImage(tBody),
    );

    testParsingFailure2(
      () => mockRemoteDataSource.bulkCreateTrackImage(any),
      () => repository.bulkCreateTrackImage(tBody),
      () => mockRemoteDataSource.bulkCreateTrackImage(tBody),
    );

    testDisconnected2(() => repository.bulkCreateTrackImage(tBody));
  });

  group('getTrackUser', () {
    const tUserId = 'testUserId';
    const tDate = 'testDate';
    final tResponse = TrackUserResponse.fromJson(
      json.decode(
        fixture('track_user_response.json'),
      ),
    );

    test(
      'pastikan mengembalikan objek model TrackUserResponse ketika RemoteDataSource berhasil menerima '
      'respon sukses dari endpoint',
      () async {
        // arrange
        setUpMockNetworkConnected();
        when(mockRemoteDataSource.getTrackUser(any, any)).thenAnswer((_) async => tResponse);

        // act
        final result = await repository.getTrackUser(tUserId, tDate);

        // assert
        verify(mockRemoteDataSource.getTrackUser(tUserId, tDate));
        expect(result.response, tResponse);
      },
    );

    test(
      'pastikan mengembalikan objek ServerFailure ketika RemoteDataSource berhasil menerima '
      'respon timeout dari endpoint',
      () async {
        // arrange
        setUpMockNetworkConnected();
        when(mockRemoteDataSource.getTrackUser(any, any))
            .thenThrow(DioException(requestOptions: tRequestOptions, message: 'testError'));

        // act
        final result = await repository.getTrackUser(tUserId, tDate);

        // assert
        verify(mockRemoteDataSource.getTrackUser(tUserId, tDate));
        expect(result.failure, ServerFailure('testError'));
      },
    );

    test(
      'pastikan mengembalikan objek ServerFailure ketika RemoteDataSource menerima respon kegagalan '
      'dari endpoint',
      () async {
        // arrange
        setUpMockNetworkConnected();
        when(mockRemoteDataSource.getTrackUser(any, any)).thenThrow(
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
        final result = await repository.getTrackUser(tUserId, tDate);

        // assert
        verify(mockRemoteDataSource.getTrackUser(tUserId, tDate));
        expect(result.failure, ServerFailure('400 testMessageError'));
      },
    );

    testServerFailureString2(
      () => mockRemoteDataSource.getTrackUser(any, any),
      () => repository.getTrackUser(tUserId, tDate),
      () => mockRemoteDataSource.getTrackUser(tUserId, tDate),
    );

    testParsingFailure2(
      () => mockRemoteDataSource.getTrackUser(any, any),
      () => repository.getTrackUser(tUserId, tDate),
      () => mockRemoteDataSource.getTrackUser(tUserId, tDate),
    );

    testDisconnected2(() => repository.getTrackUser(tUserId, tDate));
  });

  group('deleteTrackUser', () {
    const trackId = 1;
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
        when(mockRemoteDataSource.deleteTrackUser(any)).thenAnswer((_) async => tResponse);

        // act
        final result = await repository.deleteTrackUser(trackId);

        // assert
        verify(mockRemoteDataSource.deleteTrackUser(trackId));
        expect(result.response, tResponse);
      },
    );

    test(
      'pastikan mengembalikan objek ServerFailure ketika RemoteDataSource berhasil menerima '
      'respon timeout dari endpoint',
      () async {
        // arrange
        setUpMockNetworkConnected();
        when(mockRemoteDataSource.deleteTrackUser(any))
            .thenThrow(DioException(requestOptions: tRequestOptions, message: 'testError'));

        // act
        final result = await repository.deleteTrackUser(trackId);

        // assert
        verify(mockRemoteDataSource.deleteTrackUser(trackId));
        expect(result.failure, ServerFailure('testError'));
      },
    );

    test(
      'pastikan mengembalikan objek ServerFailure ketika RemoteDataSource menerima respon kegagalan '
      'dari endpoint',
      () async {
        // arrange
        setUpMockNetworkConnected();
        when(mockRemoteDataSource.deleteTrackUser(any)).thenThrow(
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
        final result = await repository.deleteTrackUser(trackId);

        // assert
        verify(mockRemoteDataSource.deleteTrackUser(trackId));
        expect(result.failure, ServerFailure('400 testMessageError'));
      },
    );

    testServerFailureString2(
      () => mockRemoteDataSource.deleteTrackUser(any),
      () => repository.deleteTrackUser(trackId),
      () => mockRemoteDataSource.deleteTrackUser(trackId),
    );

    testParsingFailure2(
      () => mockRemoteDataSource.deleteTrackUser(any),
      () => repository.deleteTrackUser(trackId),
      () => mockRemoteDataSource.deleteTrackUser(trackId),
    );

    testDisconnected2(() => repository.deleteTrackUser(trackId));
  });

  group('createManualTrack', () {
    final tBody = ManualCreateTrackBody.fromJson(
      json.decode(
        fixture('manual_create_track_body.json'),
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
        when(mockRemoteDataSource.createManualTrack(any)).thenAnswer((_) async => tResponse);

        // act
        final result = await repository.createManualTrack(tBody);

        // assert
        verify(mockRemoteDataSource.createManualTrack(tBody));
        expect(result.response, tResponse);
      },
    );

    test(
      'pastikan mengembalikan objek ServerFailure ketika RemoteDataSource berhasil menerima '
      'respon timeout dari endpoint',
      () async {
        // arrange
        setUpMockNetworkConnected();
        when(mockRemoteDataSource.createManualTrack(any))
            .thenThrow(DioException(requestOptions: tRequestOptions, message: 'testError'));

        // act
        final result = await repository.createManualTrack(tBody);

        // assert
        verify(mockRemoteDataSource.createManualTrack(tBody));
        expect(result.failure, ServerFailure('testError'));
      },
    );

    test(
      'pastikan mengembalikan objek ServerFailure ketika RemoteDataSource menerima respon kegagalan '
      'dari endpoint',
      () async {
        // arrange
        setUpMockNetworkConnected();
        when(mockRemoteDataSource.createManualTrack(any)).thenThrow(
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
        final result = await repository.createManualTrack(tBody);

        // assert
        verify(mockRemoteDataSource.createManualTrack(tBody));
        expect(result.failure, ServerFailure('400 testMessageError'));
      },
    );

    testServerFailureString2(
      () => mockRemoteDataSource.createManualTrack(any),
      () => repository.createManualTrack(tBody),
      () => mockRemoteDataSource.createManualTrack(tBody),
    );

    testParsingFailure2(
      () => mockRemoteDataSource.createManualTrack(any),
      () => repository.createManualTrack(tBody),
      () => mockRemoteDataSource.createManualTrack(tBody),
    );

    testDisconnected2(() => repository.createManualTrack(tBody));
  });
}
