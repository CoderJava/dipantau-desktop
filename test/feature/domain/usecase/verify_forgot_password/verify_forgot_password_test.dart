import 'dart:convert';

import 'package:dipantau_desktop_client/feature/data/model/general/general_response.dart';
import 'package:dipantau_desktop_client/feature/data/model/verify_forgot_password/verify_forgot_password_body.dart';
import 'package:dipantau_desktop_client/feature/domain/usecase/verify_forgot_password/verify_forgot_password.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../../../fixture/fixture_reader.dart';
import '../../../../helper/mock_helper.mocks.dart';

void main() {
  late VerifyForgotPassword useCase;
  late MockAuthRepository mockRepository;

  setUp(() {
    mockRepository = MockAuthRepository();
    useCase = VerifyForgotPassword(repository: mockRepository);
  });

  final body = VerifyForgotPasswordBody.fromJson(
    json.decode(
      fixture('verify_forgot_password_body.json'),
    ),
  );
  final tParams = ParamsVerifyForgotPassword(body: body);

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
      when(mockRepository.verifyForgotPassword(any)).thenAnswer((_) async => tResult);

      // act
      final result = await useCase(tParams);

      // assert
      expect(result, tResult);
      verify(mockRepository.verifyForgotPassword(body));
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
        'ParamsVerifyForgotPassword{body: $body}',
      );
    },
  );
}
