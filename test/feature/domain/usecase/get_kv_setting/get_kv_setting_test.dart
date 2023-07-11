import 'dart:convert';

import 'package:dipantau_desktop_client/core/usecase/usecase.dart';
import 'package:dipantau_desktop_client/feature/data/model/kv_setting/kv_setting_response.dart';
import 'package:dipantau_desktop_client/feature/domain/usecase/get_kv_setting/get_kv_setting.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../../../fixture/fixture_reader.dart';
import '../../../../helper/mock_helper.mocks.dart';

void main() {
  late GetKvSetting useCase;
  late MockSettingRepository mockRepository;

  setUp(() {
    mockRepository = MockSettingRepository();
    useCase = GetKvSetting(repository: mockRepository);
  });

  test(
    'pastikan objek repository berhasil menerima respon sukses atau gagal dari endpoint',
    () async {
      // arrange
      final tResponse = KvSettingResponse.fromJson(
        json.decode(
          fixture('kv_setting_response.json'),
        ),
      );
      final tParams = NoParams();
      final tResult = (failure: null, response: tResponse);
      when(mockRepository.getKvSetting()).thenAnswer((_) async => tResult);

      // act
      final result = await useCase(tParams);

      // assert
      expect(result, tResult);
      verify(mockRepository.getKvSetting());
      verifyNoMoreInteractions(mockRepository);
    },
  );
}
