import 'dart:convert';

import 'package:dipantau_desktop_client/feature/data/model/general/general_response.dart';
import 'package:dipantau_desktop_client/feature/data/model/sign_up_by_user/sign_up_by_user_body.dart';
import 'package:dipantau_desktop_client/feature/domain/usecase/sign_up_by_user/sign_up_by_user.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../../../fixture/fixture_reader.dart';
import '../../../../helper/mock_helper.mocks.dart';

void main() {
  late SignUpByUser useCase;
  late MockAuthRepository mockRepository;

  setUp(() {
    mockRepository = MockAuthRepository();
    useCase = SignUpByUser(repository: mockRepository);
  });

  final tBody = SignUpByUserBody.fromJson(
    json.decode(
      fixture('sign_up_by_user_body.json'),
    ),
  );
  final tParams = ParamsSignUpByUser(body: tBody);

  test(
    'pastikan objek repository berhasil menerima respon sukses atau gagal dari endpoint',
    () async {
      // arrange
      final tResponse = GeneralResponse.fromJson(
        json.decode(
          fixture('general_response.json'),
        ),
      );
      final tResult = (failure: null, response: tResponse);
      when(mockRepository.signUpByUser(any)).thenAnswer((_) async => tResult);

      // act
      final result = await useCase(tParams);

      // assert
      expect(result, tResult);
      verify(mockRepository.signUpByUser(tBody));
      verifyNoMoreInteractions(mockRepository);
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
        'ParamsSignUpByUser{body: $tBody}',
      );
    },
  );
}
