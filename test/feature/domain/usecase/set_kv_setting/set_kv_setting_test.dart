import 'dart:convert';

import 'package:dipantau_desktop_client/feature/data/model/kv_setting/kv_setting_body.dart';
import 'package:dipantau_desktop_client/feature/domain/usecase/set_kv_setting/set_kv_setting.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../../../fixture/fixture_reader.dart';
import '../../../../helper/mock_helper.mocks.dart';

void main() {
  late SetKvSetting useCase;
  late MockSettingRepository mockRepository;

  setUp(() {
    mockRepository = MockSettingRepository();
    useCase = SetKvSetting(repository: mockRepository);
  });

  final tBody = KvSettingBody.fromJson(
    json.decode(
      fixture('kv_setting_body.json'),
    ),
  );
  final tParams = ParamsSetKvSetting(body: tBody);

  test(
    'pastikan objek repository berhasil menerima respon sukses atau gagal dari endpoint',
    () async {
      // arrange
      const tResponse = true;
      const tResult = (failure: null, response: tResponse);
      when(mockRepository.setKvSetting(any)).thenAnswer((_) async => tResult);

      // act
      final result = await useCase(tParams);

      // assert
      expect(result, tResult);
      verify(mockRepository.setKvSetting(tBody));
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
        'ParamsSetKvSetting{body: ${tParams.body}}',
      );
    },
  );
}
