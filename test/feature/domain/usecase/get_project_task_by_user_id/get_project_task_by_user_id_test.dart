import 'dart:convert';

import 'package:dipantau_desktop_client/feature/data/model/project_task/project_task_response.dart';
import 'package:dipantau_desktop_client/feature/domain/usecase/get_project_task_by_user_id/get_project_task_by_user_id.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../../../fixture/fixture_reader.dart';
import '../../../../helper/mock_helper.mocks.dart';

void main() {
  late GetProjectTaskByUserId useCase;
  late MockProjectRepository mockRepository;

  setUp(() {
    mockRepository = MockProjectRepository();
    useCase = GetProjectTaskByUserId(repository: mockRepository);
  });

  const userId = 'userId';
  final tParams = ParamsGetProjectTaskByUserId(userId: userId);

  test(
    'pastikan objek repository berhasil menerima respon sukses atau gagal dari endpoint',
    () async {
      // arrange
      final tResponse = ProjectTaskResponse.fromJson(
        json.decode(
          fixture('project_task_response.json'),
        ),
      );
      final tResult = (failure: null, response: tResponse);
      when(mockRepository.getProjectTaskByUserId(any)).thenAnswer((_) async => tResult);

      // act
      final result = await useCase(tParams);

      // assert
      expect(result, tResult);
      verify(mockRepository.getProjectTaskByUserId(userId));
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
        'ParamsGetProjectTaskByUserId{userId: ${tParams.userId}}',
      );
    },
  );
}
