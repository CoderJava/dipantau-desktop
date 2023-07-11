import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:dipantau_desktop_client/core/error/failure.dart';
import 'package:dipantau_desktop_client/feature/data/model/kv_setting/kv_setting_body.dart';
import 'package:dipantau_desktop_client/feature/data/model/kv_setting/kv_setting_response.dart';
import 'package:dipantau_desktop_client/feature/data/repository/setting/setting_repository_impl.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../../../fixture/fixture_reader.dart';
import '../../../../helper/mock_helper.mocks.dart';

void main() {
  late SettingRepositoryImpl repository;
  late MockSettingRemoteDataSource mockRemoteDataSource;
  late MockNetworkInfo mockNetworkInfo;

  setUp(() {
    mockRemoteDataSource = MockSettingRemoteDataSource();
    mockNetworkInfo = MockNetworkInfo();
    repository = SettingRepositoryImpl(
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

  group('getKvSetting', () {
    final tResponse = KvSettingResponse.fromJson(
      json.decode(
        fixture('kv_setting_response.json'),
      ),
    );

    test(
      'pastikan mengembalikan objek model KvSettingResponse ketika remote data source berhasil menerima '
      'respon sukses dari endpoint',
      () async {
        // arrange
        setUpMockNetworkConnected();
        when(mockRemoteDataSource.getKvSetting()).thenAnswer((_) async => tResponse);

        // act
        final result = await repository.getKvSetting();

        // assert
        verify(mockRemoteDataSource.getKvSetting());
        expect(result.response, tResponse);
      },
    );

    test(
      'pastikan mengembalikan objek ServerFailure ketika remote data source berhasil menerima respon timeout dari endpoint',
      () async {
        // arrange
        setUpMockNetworkConnected();
        when(mockRemoteDataSource.getKvSetting())
            .thenThrow(DioException(requestOptions: tRequestOptions, message: 'testError'));

        // act
        final result = await repository.getKvSetting();

        // assert
        verify(mockRemoteDataSource.getKvSetting());
        expect(result.failure, ServerFailure('testError'));
      },
    );

    test(
      'pastikan mengembalikan objek ServerFailure ketika remote data source menerima respon kegagalan '
      'dari endpoint',
      () async {
        // arrange
        setUpMockNetworkConnected();
        when(mockRemoteDataSource.getKvSetting()).thenThrow(
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
        final result = await repository.getKvSetting();

        // assert
        verify(mockRemoteDataSource.getKvSetting());
        expect(result.failure, ServerFailure('400 testMessageError'));
      },
    );

    testServerFailureString(
      () => mockRemoteDataSource.getKvSetting(),
      () => repository.getKvSetting(),
      () => mockRemoteDataSource.getKvSetting(),
    );

    testParsingFailure(
      () => mockRemoteDataSource.getKvSetting(),
      () => repository.getKvSetting(),
      () => mockRemoteDataSource.getKvSetting(),
    );

    testDisconnected(() => repository.getKvSetting());
  });

  group('setKvSetting', () {
    final tBody = KvSettingBody.fromJson(
      json.decode(
        fixture('kv_setting_body.json'),
      ),
    );
    const tResponse = true;

    test(
      'pastikan mengembalikan nilai boolean true ketika remote data source berhasil menerima '
      'respon sukses dari endpoint',
      () async {
        // arrange
        setUpMockNetworkConnected();
        when(mockRemoteDataSource.setKvSetting(any)).thenAnswer((_) async => tResponse);

        // act
        final result = await repository.setKvSetting(tBody);

        // assert
        verify(mockRemoteDataSource.setKvSetting(tBody));
        expect(result.response, tResponse);
      },
    );

    test(
      'pastikan mengembalikan objek ServerFailure ketika remote data source berhasil menerima respon timeout dari endpoint',
      () async {
        // arrange
        setUpMockNetworkConnected();
        when(mockRemoteDataSource.setKvSetting(any))
            .thenThrow(DioException(requestOptions: tRequestOptions, message: 'testError'));

        // act
        final result = await repository.setKvSetting(tBody);

        // assert
        verify(mockRemoteDataSource.setKvSetting(tBody));
        expect(result.failure, ServerFailure('testError'));
      },
    );

    test(
      'pastikan mengembalikan objek ServerFailure ketika remote data source menerima respon kegagalan '
      'dari endpoint',
      () async {
        // arrange
        setUpMockNetworkConnected();
        when(mockRemoteDataSource.setKvSetting(any)).thenThrow(
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
        final result = await repository.setKvSetting(tBody);

        // assert
        verify(mockRemoteDataSource.setKvSetting(tBody));
        expect(result.failure, ServerFailure('400 testMessageError'));
      },
    );

    testServerFailureString(
      () => mockRemoteDataSource.setKvSetting(any),
      () => repository.setKvSetting(tBody),
      () => mockRemoteDataSource.setKvSetting(tBody),
    );

    testParsingFailure(
      () => mockRemoteDataSource.setKvSetting(any),
      () => repository.setKvSetting(tBody),
      () => mockRemoteDataSource.setKvSetting(tBody),
    );

    testDisconnected(() => repository.setKvSetting(tBody));
  });
}
