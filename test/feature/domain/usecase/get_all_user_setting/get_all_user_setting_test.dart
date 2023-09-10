import 'dart:convert';

import 'package:dipantau_desktop_client/core/usecase/usecase.dart';
import 'package:dipantau_desktop_client/feature/data/model/all_user_setting/all_user_setting_response.dart';
import 'package:dipantau_desktop_client/feature/domain/usecase/get_all_user_setting/get_all_user_setting.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../../../fixture/fixture_reader.dart';
import '../../../../helper/mock_helper.mocks.dart';

void main() {
  late GetAllUserSetting useCase;
  late MockSettingRepository mockRepository;

  setUp(() {
    mockRepository = MockSettingRepository();
    useCase = GetAllUserSetting(repository: mockRepository);
  });

  test(
    'pastikan objek repository berhasil menerima respon sukses atau gagal dari endpoint',
    () async {
      // arrange
      final tResponse = AllUserSettingResponse.fromJson(
        json.decode(
          fixture('all_user_setting_response.json'),
        ),
      );
      final tResult = (failure: null, response: tResponse);
      when(mockRepository.getAllUserSetting()).thenAnswer((_) async => tResult);

      // act
      final result = await useCase(NoParams());

      // assert
      expect(result, tResult);
      verify(mockRepository.getAllUserSetting());
      verifyNoMoreInteractions(mockRepository);
    },
  );
}
