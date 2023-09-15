import 'dart:convert';

import 'package:dipantau_desktop_client/core/usecase/usecase.dart';
import 'package:dipantau_desktop_client/feature/data/model/user_setting/user_setting_response.dart';
import 'package:dipantau_desktop_client/feature/domain/usecase/get_user_setting/get_user_setting.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../../../fixture/fixture_reader.dart';
import '../../../../helper/mock_helper.mocks.dart';

void main() {
  late GetUserSetting useCase;
  late MockSettingRepository mockRepository;

  setUp(() {
    mockRepository = MockSettingRepository();
    useCase = GetUserSetting(repository: mockRepository);
  });

  test(
    'pastikan objek repository berhasil menerima respon sukses atau gagal dari endpoint',
    () async {
      // arrange
      final tResponse = UserSettingResponse.fromJson(
        json.decode(
          fixture('user_setting_response.json'),
        ),
      );
      final tResult = (failure: null, response: tResponse);
      when(mockRepository.getUserSetting()).thenAnswer((_) async => tResult);

      // act
      final result = await useCase(NoParams());

      // assert
      expect(result, tResult);
      verify(mockRepository.getUserSetting());
      verifyNoMoreInteractions(mockRepository);
    },
  );
}
