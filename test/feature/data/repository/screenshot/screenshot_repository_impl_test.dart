import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:dipantau_desktop_client/core/error/failure.dart';
import 'package:dipantau_desktop_client/feature/data/model/screenshot_refresh/screenshot_refresh_body.dart';
import 'package:dipantau_desktop_client/feature/data/model/screenshot_refresh/screenshot_refresh_response.dart';
import 'package:dipantau_desktop_client/feature/data/repository/screenshot/screenshot_repository_impl.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../../../fixture/fixture_reader.dart';
import '../../../../helper/mock_helper.mocks.dart';

void main() {
  late ScreenshotRepositoryImpl repository;
  late MockScreenshotRemoteDataSource mockRemoteDataSource;
  late MockNetworkInfo mockNetworkInfo;

  setUp(() {
    mockRemoteDataSource = MockScreenshotRemoteDataSource();
    mockNetworkInfo = MockNetworkInfo();
    repository = ScreenshotRepositoryImpl(
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
        expect(result.failure, ConnectionFailure());
      },
    );
  }

  void testServerFailureString(Function whenInvoke, Function actInvoke, Function verifyInvoke) {
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
        expect(result.failure, ParsingFailure(TypeError().toString()));
      },
    );
  }

  group('refreshScreenshot', () {
    final tBody = ScreenshotRefreshBody.fromJson(
      json.decode(
        fixture('screenshot_refresh_body.json'),
      ),
    );
    final tResponse = ScreenshotRefreshResponse.fromJson(
      json.decode(
        fixture('screenshot_refresh_response.json'),
      ),
    );

    test(
      'pastikan mengembalikan objek model ScreenshotRefreshResponse ketika RemoteDataSource berhasil menerima '
      'respon sukses dari endpoint',
      () async {
        // arrange
        setUpMockNetworkConnected();
        when(mockRemoteDataSource.refreshScreenshot(any)).thenAnswer((_) async => tResponse);

        // act
        final result = await repository.refreshScreenshot(tBody);

        // assert
        verify(mockRemoteDataSource.refreshScreenshot(tBody));
        expect(result.response, tResponse);
      },
    );

    test(
      'pastikan mengembalikan objek ServerFailure ketika RemoteDataSource berhasil menerima '
      'respon timeout dari endpoint',
      () async {
        // arrange
        setUpMockNetworkConnected();
        when(mockRemoteDataSource.refreshScreenshot(any))
            .thenThrow(DioException(requestOptions: tRequestOptions, message: 'testError'));

        // act
        final result = await repository.refreshScreenshot(tBody);

        // assert
        verify(mockRemoteDataSource.refreshScreenshot(tBody));
        expect(result.failure, ServerFailure('testError'));
      },
    );

    test(
      'pastikan mengembalikan objek ServerFailure ketika RemoteDataSource menerima respon kegagalan '
      'dari endpoint',
      () async {
        // arrange
        setUpMockNetworkConnected();
        when(mockRemoteDataSource.refreshScreenshot(any)).thenThrow(
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
        final result = await repository.refreshScreenshot(tBody);

        // assert
        verify(mockRemoteDataSource.refreshScreenshot(tBody));
        expect(result.failure, ServerFailure('400 testMessageError'));
      },
    );

    testServerFailureString(
      () => mockRemoteDataSource.refreshScreenshot(any),
      () => repository.refreshScreenshot(tBody),
      () => mockRemoteDataSource.refreshScreenshot(tBody),
    );

    testParsingFailure(
      () => mockRemoteDataSource.refreshScreenshot(any),
      () => repository.refreshScreenshot(tBody),
      () => mockRemoteDataSource.refreshScreenshot(tBody),
    );

    testDisconnected(() => repository.refreshScreenshot(tBody));
  });
}
