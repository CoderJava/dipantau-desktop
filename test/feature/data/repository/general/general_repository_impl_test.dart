import 'dart:convert';

import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:dipantau_desktop_client/core/error/failure.dart';
import 'package:dipantau_desktop_client/feature/data/model/general/general_response.dart';
import 'package:dipantau_desktop_client/feature/data/model/project/project_response_bak.dart';
import 'package:dipantau_desktop_client/feature/data/model/tracking_data/tracking_data_body.dart';
import 'package:dipantau_desktop_client/feature/data/repository/general/general_repository_impl.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../../../fixture/fixture_reader.dart';
import '../../../../helper/mock_helper.mocks.dart';

void main() {
  late GeneralRepositoryImpl generalRepositoryImpl;
  late MockGeneralRemoteDataSource mockGeneralRemoteDataSource;
  late MockNetworkInfo mockNetworkInfo;

  setUp(() {
    mockGeneralRemoteDataSource = MockGeneralRemoteDataSource();
    mockNetworkInfo = MockNetworkInfo();
    generalRepositoryImpl = GeneralRepositoryImpl(
      generalRemoteDataSource: mockGeneralRemoteDataSource,
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

  group('getProject', () {
    const tEmail = 'testEmail';
    final tResponse = ProjectResponseBak.fromJson(
      json.decode(
        fixture('project_response.json'),
      ),
    );

    test(
      'pastikan mengembalikan objek model ProjectResponse ketika GeneralRemoteDataSource berhasil menerima '
      'respon sukses dari endpoint',
      () async {
        // arrange
        setUpMockNetworkConnected();
        when(mockGeneralRemoteDataSource.getProject(any)).thenAnswer((_) async => tResponse);

        // act
        final result = await generalRepositoryImpl.getProject(tEmail);

        // assert
        verify(mockGeneralRemoteDataSource.getProject(tEmail));
        expect(result, Right(tResponse));
      },
    );

    test(
      'pastikan mengembalikan objek ServerFailure ketika GeneralRemoteDataSource berhasil menerima '
      'respon timeout dari endpoint',
      () async {
        // arrange
        setUpMockNetworkConnected();
        when(mockGeneralRemoteDataSource.getProject(any))
            .thenThrow(DioError(requestOptions: tRequestOptions, error: 'testError'));

        // act
        final result = await generalRepositoryImpl.getProject(tEmail);

        // assert
        verify(mockGeneralRemoteDataSource.getProject(tEmail));
        expect(result, Left(ServerFailure('testError')));
      },
    );

    test(
      'pastikan mengembalikan objek ServerFailure ketika GeneralRemoteDataSource menerima respon kegagalan '
      'dari endpoint',
      () async {
        // arrange
        setUpMockNetworkConnected();
        when(mockGeneralRemoteDataSource.getProject(any)).thenThrow(
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
        final result = await generalRepositoryImpl.getProject(tEmail);

        // assert
        verify(mockGeneralRemoteDataSource.getProject(tEmail));
        expect(result, Left(ServerFailure('400 testMessageError')));
      },
    );

    testServerFailureString(
      () => mockGeneralRemoteDataSource.getProject(any),
      () => generalRepositoryImpl.getProject(tEmail),
      () => mockGeneralRemoteDataSource.getProject(tEmail),
    );

    testParsingFailure(
      () => mockGeneralRemoteDataSource.getProject(any),
      () => generalRepositoryImpl.getProject(tEmail),
      () => mockGeneralRemoteDataSource.getProject(tEmail),
    );

    testDisconnected(() => generalRepositoryImpl.getProject(tEmail));
  });

  group('createTrackingData', () {
    final tBody = TrackingDataBody.fromJson(
      json.decode(
        fixture('tracking_data_body.json'),
      ),
    );
    final tResponse = GeneralResponse.fromJson(
      json.decode(
        fixture('project_response.json'),
      ),
    );

    test(
      'pastikan mengembalikan objek model GeneralResponse ketika GeneralRemoteDataSource berhasil menerima '
      'respon sukses dari endpoint',
      () async {
        // arrange
        setUpMockNetworkConnected();
        when(mockGeneralRemoteDataSource.createTrackingData(any)).thenAnswer((_) async => tResponse);

        // act
        final result = await generalRepositoryImpl.createTrackingData(tBody);

        // assert
        verify(mockGeneralRemoteDataSource.createTrackingData(tBody));
        expect(result, Right(tResponse));
      },
    );

    test(
      'pastikan mengembalikan objek ServerFailure ketika GeneralRemoteDataSource berhasil menerima '
      'respon timeout dari endpoint',
      () async {
        // arrange
        setUpMockNetworkConnected();
        when(mockGeneralRemoteDataSource.createTrackingData(any))
            .thenThrow(DioError(requestOptions: tRequestOptions, error: 'testError'));

        // act
        final result = await generalRepositoryImpl.createTrackingData(tBody);

        // assert
        verify(mockGeneralRemoteDataSource.createTrackingData(tBody));
        expect(result, Left(ServerFailure('testError')));
      },
    );

    test(
      'pastikan mengembalikan objek ServerFailure ketika GeneralRemoteDataSource menerima respon kegagalan '
      'dari endpoint',
      () async {
        // arrange
        setUpMockNetworkConnected();
        when(mockGeneralRemoteDataSource.createTrackingData(any)).thenThrow(
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
        final result = await generalRepositoryImpl.createTrackingData(tBody);

        // assert
        verify(mockGeneralRemoteDataSource.createTrackingData(tBody));
        expect(result, Left(ServerFailure('400 testMessageError')));
      },
    );

    testServerFailureString(
      () => mockGeneralRemoteDataSource.createTrackingData(any),
      () => generalRepositoryImpl.createTrackingData(tBody),
      () => mockGeneralRemoteDataSource.createTrackingData(tBody),
    );

    testParsingFailure(
      () => mockGeneralRemoteDataSource.createTrackingData(any),
      () => generalRepositoryImpl.createTrackingData(tBody),
      () => mockGeneralRemoteDataSource.createTrackingData(tBody),
    );

    testDisconnected(() => generalRepositoryImpl.createTrackingData(tBody));
  });
}
