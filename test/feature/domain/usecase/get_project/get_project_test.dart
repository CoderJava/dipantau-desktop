import 'dart:convert';

import 'package:dartz/dartz.dart';
import 'package:dipantau_desktop_client/feature/data/model/project/project_response_bak.dart';
import 'package:dipantau_desktop_client/feature/domain/usecase/get_project/get_project.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../../../fixture/fixture_reader.dart';
import '../../../../helper/mock_helper.mocks.dart';

void main() {
  late GetProject useCase;
  late MockGeneralRepository mockGeneralRepository;

  setUp(() {
    mockGeneralRepository = MockGeneralRepository();
    useCase = GetProject(generalRepository: mockGeneralRepository);
  });

  const tEmail = 'testEmail';
  final tParams = ParamsGetProject(email: tEmail);

  test(
    'pastikan objek repository berhasil menerima respon sukses atau gagal dari endpoint getProject',
    () async {
      // arrange
      final tResponse = ProjectResponseBak.fromJson(
        json.decode(
          fixture('project_response.json'),
        ),
      );
      when(mockGeneralRepository.getProject(any)).thenAnswer((_) async => Right(tResponse));

      // act
      final result = await useCase(tParams);

      // assert
      expect(result, Right(tResponse));
      verify(mockGeneralRepository.getProject(tEmail));
      verifyNoMoreInteractions(mockGeneralRepository);
    },
  );

  test(
    'pastikan output dari nilai props',
    () async {
      // assert
      expect(
        tParams.props,
        [
          tParams.email,
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
        'ParamsGetProject{email: ${tParams.email}}',
      );
    },
  );
}
