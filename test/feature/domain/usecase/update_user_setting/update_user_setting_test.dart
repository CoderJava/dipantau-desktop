import 'dart:convert';

import 'package:dipantau_desktop_client/feature/data/model/user_setting/user_setting_body.dart';
import 'package:dipantau_desktop_client/feature/domain/usecase/update_user_setting/update_user_setting.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../../../fixture/fixture_reader.dart';
import '../../../../helper/mock_helper.mocks.dart';

void main() {
  late UpdateUserSetting useCase;
  late MockSettingRepository mockRepository;

  setUp(() {
    mockRepository = MockSettingRepository();
    useCase = UpdateUserSetting(repository: mockRepository);
  });

  final body = UserSettingBody.fromJson(
    json.decode(
      fixture('user_setting_body.json'),
    ),
  );
  final params = ParamsUpdateUserSetting(body: body);

  test(
    'pastikan objek repository berhasil menerima respon sukses atau gagal dari endpoint',
    () async {
      // arrange
      const tResponse = true;
      const tResult = (failure: null, response: tResponse);
      when(mockRepository.updateUserSetting(any)).thenAnswer((_) async => tResult);

      // act
      final result = await useCase(params);

      // assert
      expect(result, tResult);
      verify(mockRepository.updateUserSetting(body));
      verifyNoMoreInteractions(mockRepository);
    },
  );

  test(
    'pastikan output dari nilai props',
    () async {
      // assert
      expect(
        params.props,
        [
          params.body,
        ],
      );
    },
  );

  test(
    'pastikan output dari fungsi toString',
    () async {
      // assert
      expect(
        params.toString(),
        'ParamsUpdateUserSetting{body: ${params.body}}',
      );
    },
  );
}
