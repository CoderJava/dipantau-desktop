import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:dipantau_desktop_client/config/flavor_config.dart';
import 'package:dipantau_desktop_client/feature/data/datasource/auth/auth_remote_data_source.dart';
import 'package:dipantau_desktop_client/feature/data/model/login/login_body.dart';
import 'package:dipantau_desktop_client/feature/data/model/login/login_response.dart';
import 'package:dipantau_desktop_client/feature/data/model/sign_up/sign_up_body.dart';
import 'package:dipantau_desktop_client/feature/data/model/sign_up/sign_up_response.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../../../fixture/fixture_reader.dart';
import '../../../../helper/mock_helper.mocks.dart';

void main() {
  late AuthRemoteDataSource remoteDataSource;
  late MockDio mockDio;
  late MockHttpClientAdapter mockDioAdapter;

  const baseUrl = 'https://example.com/auth';

  setUp(() {
    FlavorConfig(
      values: FlavorValues(
        baseUrl: '',
        baseUrlAuth: baseUrl,
      ),
    );
    mockDio = MockDio();
    mockDioAdapter = MockHttpClientAdapter();
    mockDio.httpClientAdapter = mockDioAdapter;
    remoteDataSource = AuthRemoteDataSourceImpl(dio: mockDio);
  });

  final tRequestOptions = RequestOptions(path: '');

  group('login', () {
    const tPathBody = 'login_body.json';
    final tBody = LoginBody.fromJson(
      json.decode(
        fixture(tPathBody),
      ),
    );
    const tPathResponse = 'login_response.json';
    final tResponse = LoginResponse.fromJson(
      json.decode(
        fixture(tPathResponse),
      ),
    );

    void setUpMockDioSuccess() {
      final responsePayload = json.decode(fixture(tPathResponse));
      final response = Response(
        requestOptions: tRequestOptions,
        data: responsePayload,
        statusCode: 200,
        headers: Headers.fromMap({
          Headers.contentTypeHeader: [Headers.jsonContentType],
        }),
      );
      when(mockDio.post(any, data: anyNamed('data'))).thenAnswer((_) async => response);
    }

    test(
      'pastikan endpoint login benar-benar terpanggil dengan method POST',
      () async {
        // arrange
        setUpMockDioSuccess();

        // act
        await remoteDataSource.login(tBody);

        // assert
        verify(mockDio.post('$baseUrl/login', data: anyNamed('data')));
      },
    );

    test(
      'pastikan mengembalikan objek class model LoginResponse ketika menerima respon sukses '
      'dari endpoint',
      () async {
        // arrange
        setUpMockDioSuccess();

        // act
        final result = await remoteDataSource.login(tBody);

        // assert
        expect(result, tResponse);
      },
    );

    test(
      'pastikan akan menerima exception DioError ketika menerima respon kegagalan dari endpoint',
      () async {
        // arrange
        final response = Response(
          requestOptions: tRequestOptions,
          data: 'Bad Request',
          statusCode: 400,
        );
        when(mockDio.post(any, data: anyNamed('data'))).thenAnswer((_) async => response);

        // act
        final call = remoteDataSource.login(tBody);

        // assert
        expect(() => call, throwsA(const TypeMatcher<DioError>()));
      },
    );
  });

  group('sign up', () {
    const tPathBody = 'sign_up_body.json';
    final tBody = SignUpBody.fromJson(
      json.decode(
        fixture(tPathBody),
      ),
    );
    const tPathResponse = 'sign_up_response.json';
    final tResponse = SignUpResponse.fromJson(
      json.decode(
        fixture(tPathResponse),
      ),
    );

    void setUpMockDioSuccess() {
      final responsePayload = json.decode(fixture(tPathResponse));
      final response = Response(
        requestOptions: tRequestOptions,
        data: responsePayload,
        statusCode: 200,
        headers: Headers.fromMap({
          Headers.contentTypeHeader: [Headers.jsonContentType],
        }),
      );
      when(mockDio.post(any, data: anyNamed('data'))).thenAnswer((_) async => response);
    }

    test(
      'pastikan endpoint login benar-benar terpanggil dengan method POST',
      () async {
        // arrange
        setUpMockDioSuccess();

        // act
        await remoteDataSource.signUp(tBody);

        // assert
        verify(mockDio.post('$baseUrl/signup', data: anyNamed('data')));
      },
    );

    test(
      'pastikan mengembalikan objek class model SignUpResponse ketika menerima respon sukses '
      'dari endpoint',
      () async {
        // arrange
        setUpMockDioSuccess();

        // act
        final result = await remoteDataSource.signUp(tBody);

        // assert
        expect(result, tResponse);
      },
    );

    test(
      'pastikan akan menerima exception DioError ketika menerima respon kegagalan dari endpoint',
      () async {
        // arrange
        final response = Response(
          requestOptions: tRequestOptions,
          data: 'Bad Request',
          statusCode: 400,
        );
        when(mockDio.post(any, data: anyNamed('data'))).thenAnswer((_) async => response);

        // act
        final call = remoteDataSource.signUp(tBody);

        // assert
        expect(() => call, throwsA(const TypeMatcher<DioError>()));
      },
    );
  });
}
