import 'dart:convert';

import 'package:dartz/dartz.dart';
import 'package:dipantau_desktop_client/feature/data/model/login/login_response.dart';
import 'package:dipantau_desktop_client/feature/data/model/refresh_token/refresh_token_body.dart';
import 'package:dipantau_desktop_client/feature/domain/usecase/refresh_token/refresh_token.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../../../fixture/fixture_reader.dart';
import '../../../../helper/mock_helper.mocks.dart';

void main() {
  late RefreshToken useCase;
  late MockAuthRepository mockAuthRepository;

  setUp(() {
    mockAuthRepository = MockAuthRepository();
    useCase = RefreshToken(repository: mockAuthRepository);
  });

  final tBody = RefreshTokenBody.fromJson(
    json.decode(
      fixture('refresh_token_body.json'),
    ),
  );
  final tParams = ParamsRefreshToken(body: tBody);

  test(
    'pastikan objek repository berhasil menerima respon sukses dan gagal dari endpoint',
    () async {
      // arrange
      final tResponse = LoginResponse.fromJson(json.decode(fixture('login_response.json')));
      when(mockAuthRepository.refreshToken(any)).thenAnswer((_) async => Right(tResponse));

      // act
      final result = await useCase(tParams);

      // assert
      expect(result, Right(tResponse));
      verify(mockAuthRepository.refreshToken(tBody));
      verifyNoMoreInteractions(mockAuthRepository);
    },
  );

  test(
    'pastikan output dari nilai props',
    () async {
      // assert
      expect(
        tParams.props,
        [
          tParams.body,
        ],
      );
    },
  );

  test(
    'pastikan output dari fungsi toString',
    () async {
      // assert
      expect(
        tParams.toString(),
        'ParamsRefreshToken{body: ${tParams.body}}',
      );
    },
  );
}
