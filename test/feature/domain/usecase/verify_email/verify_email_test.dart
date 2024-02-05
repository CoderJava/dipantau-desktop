import 'dart:convert';

import 'package:dipantau_desktop_client/feature/data/model/verify_email/verify_email_body.dart';
import 'package:dipantau_desktop_client/feature/data/model/verify_email/verify_email_response.dart';
import 'package:dipantau_desktop_client/feature/domain/usecase/verify_email/verify_email.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../../../fixture/fixture_reader.dart';
import '../../../../helper/mock_helper.mocks.dart';

void main() {
  late VerifyEmail useCase;
  late MockAuthRepository mockRepository;

  setUp(() {
    mockRepository = MockAuthRepository();
    useCase = VerifyEmail(repository: mockRepository);
  });

  final tBody = VerifyEmailBody.fromJson(
    json.decode(
      fixture('verify_email_body.json'),
    ),
  );
  final tParams = ParamsVerifyEmail(body: tBody);

  test(
    'pastikan objek repository berhasil menerima respon sukses atau gagal dari endpoint',
    () async {
      // arrange
      final tResponse = VerifyEmailResponse.fromJson(
        json.decode(
          fixture('verify_email_response.json'),
        ),
      );
      final tResult = (failure: null, response: tResponse);
      when(mockRepository.verifyEmail(any)).thenAnswer((_) async => tResult);

      // act
      final result = await useCase(tParams);

      // assert
      expect(result, tResult);
      verify(mockRepository.verifyEmail(tBody));
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
        'ParamsVerifyEmail{body: $tBody}',
      );
    },
  );
}
