import 'dart:convert';

import 'package:dipantau_desktop_client/feature/data/model/general/general_response.dart';
import 'package:dipantau_desktop_client/feature/domain/usecase/ping/ping.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../../../fixture/fixture_reader.dart';
import '../../../../helper/mock_helper.mocks.dart';

void main() {
  late Ping useCase;
  late MockGeneralRepository mockRepository;

  setUp(() {
    mockRepository = MockGeneralRepository();
    useCase = Ping(repository: mockRepository);
  });

  const hostname = 'https://example.com';
  final tParams = ParamsPing(baseUrl: hostname);

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
      when(mockRepository.ping(any)).thenAnswer((_) async => tResult);

      // act
      final result = await useCase(tParams);

      // assert
      expect(result, tResult);
      verify(mockRepository.ping(hostname));
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
          tParams.baseUrl,
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
        'ParamsPing{baseUrl: ${tParams.baseUrl}}',
      );
    },
  );
}
