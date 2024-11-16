import 'dart:convert';

import 'package:dipantau_desktop_client/core/usecase/usecase.dart';
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

  test(
    'pastikan objek repository berhasil menerima respon sukses atau gagal dari endpoint',
    () async {
      // arrange
      final tResponse = GeneralResponse.fromJson(
        json.decode(
          fixture('general_response.json'),
        ),
      );
      final tParams = NoParams();
      final tResult = (failure: null, response: tResponse);
      when(mockRepository.ping()).thenAnswer((_) async => tResult);

      // act
      final result = await useCase(tParams);

      // assert
      expect(result, tResult);
      verify(mockRepository.ping());
      verifyNoMoreInteractions(mockRepository);
    },
  );
}
