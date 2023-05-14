import 'dart:convert';

import 'package:dartz/dartz.dart';
import 'package:dipantau_desktop_client/feature/data/model/project/project_response.dart';
import 'package:dipantau_desktop_client/feature/domain/usecase/get_project/get_project.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../../../fixture/fixture_reader.dart';
import '../../../../helper/mock_helper.mocks.dart';

void main() {
  late GetProject useCase;
  late MockProjectRepository mockProjectRepository;

  setUp(() {
    mockProjectRepository = MockProjectRepository();
    useCase = GetProject(repository: mockProjectRepository);
  });

  const tUserId = 'testUserId';
  final tParams = ParamsGetProject(userId: tUserId);

  test(
    'pastikan objek repository berhasil menerima respon sukses atau gagal dari endpoint getProject',
    () async {
      // arrange
      final tResponse = ProjectResponse.fromJson(
        json.decode(
          fixture('project_response.json'),
        ),
      );
      when(mockProjectRepository.getProject(any)).thenAnswer((_) async => Right(tResponse));

      // act
      final result = await useCase(tParams);

      // assert
      expect(result, Right(tResponse));
      verify(mockProjectRepository.getProject(tUserId));
      verifyNoMoreInteractions(mockProjectRepository);
    },
  );

  test(
    'pastikan output dari nilai props',
    () async {
      // assert
      expect(
        tParams.props,
        [
          tParams.userId,
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
        'ParamsGetProject{userId: ${tParams.userId}}',
      );
    },
  );
}
