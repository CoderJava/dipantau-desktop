import 'dart:convert';

import 'package:dipantau_desktop_client/feature/domain/usecase/send_app_version/send_app_version.dart';
import 'package:dipantau_desktop_client/feature/domain/usecase/user_version/user_version_body.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../../../fixture/fixture_reader.dart';
import '../../../../helper/mock_helper.mocks.dart';

void main() {
  late SendAppVersion useCase;
  late MockUserRepository mockRepository;

  setUp(() {
    mockRepository = MockUserRepository();
    useCase = SendAppVersion(repository: mockRepository);
  });

  final tBody = UserVersionBody.fromJson(
    json.decode(
      fixture('user_version_body.json'),
    ),
  );
  final tParams = ParamsSendAppVersion(body: tBody);

  test(
    'pastikan objek repository berhasil menerima respon sukses atau gagal dari endpoint',
    () async {
      // arrange
      const tResponse = true;
      const tResult = (failure: null, response: tResponse);
      when(mockRepository.sendAppVersion(any)).thenAnswer((_) async => tResult);

      // act
      final result = await useCase(tParams);

      // assert
      expect(result, tResult);
      verify(mockRepository.sendAppVersion(tBody));
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
        'ParamsSendAppVersion{body: ${tParams.body}}',
      );
    },
  );
}
