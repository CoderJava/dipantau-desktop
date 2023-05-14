import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:dipantau_desktop_client/config/flavor_config.dart';
import 'package:dipantau_desktop_client/feature/data/datasource/user/user_remote_data_source.dart';
import 'package:dipantau_desktop_client/feature/data/model/user_profile/user_profile_response.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../../../fixture/fixture_reader.dart';
import '../../../../helper/mock_helper.mocks.dart';

void main() {
  late UserRemoteDataSource remoteDataSource;
  late MockDio mockDio;
  late MockHttpClientAdapter mockDioAdapter;

  const baseUrl = 'https://example.com/user';

  setUp(() {
    FlavorConfig(
      values: FlavorValues(
        baseUrl: '',
        baseUrlAuth: '',
        baseUrlUser: baseUrl,
        baseUrlTrack: '',
        baseUrlProject: '',
      ),
    );
    mockDio = MockDio();
    mockDioAdapter = MockHttpClientAdapter();
    mockDio.httpClientAdapter = mockDioAdapter;
    remoteDataSource = UserRemoteDataSourceImpl(dio: mockDio);
  });

  final tRequestOptions = RequestOptions(path: '');

  group('getProfile', () {
    const tPathResponse = 'user_profile_super_admin_response.json';
    final tResponse = UserProfileResponse.fromJson(
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
      when(mockDio.get(any)).thenAnswer((_) async => response);
    }

    test(
      'pastikan endpoint getProfile benar-benar terpanggil dengan method GET',
      () async {
        // arrange
        setUpMockDioSuccess();

        // act
        await remoteDataSource.getProfile();

        // assert
        verify(mockDio.get('$baseUrl/profile'));
      },
    );

    test(
      'pastikan mengembalikan objek class model UserProfileResponse ketika menerima respon sukses '
      'dari endpoint',
      () async {
        // arrange
        setUpMockDioSuccess();

        // act
        final result = await remoteDataSource.getProfile();

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
        when(mockDio.get(any)).thenAnswer((_) async => response);

        // act
        final call = remoteDataSource.getProfile();

        // assert
        expect(() => call, throwsA(const TypeMatcher<DioError>()));
      },
    );
  });
}
