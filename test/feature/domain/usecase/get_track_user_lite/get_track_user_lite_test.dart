import 'dart:convert';

import 'package:dartz/dartz.dart';
import 'package:dipantau_desktop_client/feature/data/model/track_user_lite/track_user_lite_response.dart';
import 'package:dipantau_desktop_client/feature/domain/usecase/get_track_user_lite/get_track_user_lite.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../../../fixture/fixture_reader.dart';
import '../../../../helper/mock_helper.mocks.dart';

void main() {
  late GetTrackUserLite useCase;
  late MockTrackRepository mockRepository;

  setUp(() {
    mockRepository = MockTrackRepository();
    useCase = GetTrackUserLite(
      repository: mockRepository,
    );
  });

  const tDate = 'testDate';
  const tProjectId = 'testProjectId';
  final tParams = ParamsGetTrackUserLite(date: tDate, projectId: tProjectId);

  test(
    'pastikan objek repository berhasil menerima respon sukses atau gagal dari endpoint',
    () async {
      // arrange
      final tResponse = TrackUserLiteResponse.fromJson(
        json.decode(
          fixture('track_user_lite_response.json'),
        ),
      );
      when(mockRepository.getTrackUserLite(any, any)).thenAnswer((_) async => Right(tResponse));

      // act
      final result = await useCase(tParams);

      // assert
      expect(result, Right(tResponse));
      verify(mockRepository.getTrackUserLite(tDate, tProjectId));
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
          tParams.date,
          tParams.projectId,
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
        'ParamsGetTrackUserLite{date: ${tParams.date}, projectId: ${tParams.projectId}}',
      );
    },
  );
}
