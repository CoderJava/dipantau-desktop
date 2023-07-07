import 'dart:convert';

import 'package:dipantau_desktop_client/feature/data/model/update_user/update_user_body.dart';
import 'package:dipantau_desktop_client/feature/domain/usecase/update_user/update_user.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../../../fixture/fixture_reader.dart';
import '../../../../helper/mock_helper.mocks.dart';

void main() {
  late UpdateUser useCase;
  late MockUserRepository mockRepository;

  setUp(() {
    mockRepository = MockUserRepository();
    useCase = UpdateUser(repository: mockRepository);
  });

  const tId = 1;
  final tBody = UpdateUserBody.fromJson(
    json.decode(
      fixture('update_user_body.json'),
    ),
  );
  final tParams = ParamsUpdateUser(body: tBody, id: tId);

  test(
    'pastikan objek repository berhasil menerima respon sukses atau gagal dari endpoint',
    () async {
      // arrange
      const tResponse = true;
      const tResult = (failure: null, response: tResponse);
      when(mockRepository.updateUser(any, any)).thenAnswer((_) async => tResult);

      // act
      final result = await useCase(tParams);

      // assert
      expect(result, tResult);
      verify(mockRepository.updateUser(tBody, tId));
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
          tParams.id,
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
        'ParamsUpdateUser{body: ${tParams.body}, id: ${tParams.id}}',
      );
    },
  );
}
