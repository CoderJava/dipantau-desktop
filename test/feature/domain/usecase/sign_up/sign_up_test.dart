import 'dart:convert';

import 'package:dartz/dartz.dart';
import 'package:dipantau_desktop_client/feature/data/model/sign_up/sign_up_body.dart';
import 'package:dipantau_desktop_client/feature/data/model/sign_up/sign_up_response.dart';
import 'package:dipantau_desktop_client/feature/domain/usecase/sign_up/sign_up.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../../../fixture/fixture_reader.dart';
import '../../../../helper/mock_helper.mocks.dart';

void main() {
  late SignUp useCase;
  late MockAuthRepository mockAuthRepository;

  setUp(() {
    mockAuthRepository = MockAuthRepository();
    useCase = SignUp(repository: mockAuthRepository);
  });

  final tBody = SignUpBody.fromJson(
    json.decode(
      fixture('sign_up_body.json'),
    ),
  );
  final tParams = ParamsSignUp(body: tBody);

  test(
    'pastikan objek repository berhasil menerima respon sukses atau gagal dari endpoint',
    () async {
      // arrange
      final tResponse = SignUpResponse.fromJson(
        json.decode(
          fixture('sign_up_response.json'),
        ),
      );
      when(mockAuthRepository.signUp(any)).thenAnswer((_) async => Right(tResponse));

      // act
      final result = await useCase(tParams);

      // assert
      expect(result, Right(tResponse));
      verify(mockAuthRepository.signUp(tBody));
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
        'ParamsSignUp{body: ${tParams.body}}',
      );
    },
  );
}
