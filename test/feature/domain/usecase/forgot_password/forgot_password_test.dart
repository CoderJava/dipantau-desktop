import 'dart:convert';

import 'package:dipantau_desktop_client/feature/data/model/forgot_password/forgot_password_body.dart';
import 'package:dipantau_desktop_client/feature/data/model/general/general_response.dart';
import 'package:dipantau_desktop_client/feature/domain/usecase/forgot_password/forgot_password.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../../../fixture/fixture_reader.dart';
import '../../../../helper/mock_helper.mocks.dart';

void main() {
  late ForgotPassword useCase;
  late MockAuthRepository mockRepository;

  setUp(() {
    mockRepository = MockAuthRepository();
    useCase = ForgotPassword(repository: mockRepository);
  });

  final body = ForgotPasswordBody.fromJson(
    json.decode(
      fixture('forgot_password_body.json'),
    ),
  );
  final tParams = ParamsForgotPassword(body: body);

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
      when(mockRepository.forgotPassword(any)).thenAnswer((_) async => tResult);

      // act
      final result = await useCase(tParams);

      // assert
      expect(result, tResult);
      verify(mockRepository.forgotPassword(body));
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
        'ParamsForgotPassword{body: $body}',
      );
    },
  );
}
