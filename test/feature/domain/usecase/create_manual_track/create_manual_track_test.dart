import 'dart:convert';

import 'package:dipantau_desktop_client/feature/data/model/general/general_response.dart';
import 'package:dipantau_desktop_client/feature/data/model/manual_create_track/manual_create_track_body.dart';
import 'package:dipantau_desktop_client/feature/domain/usecase/create_manual_track/create_manual_track.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../../../fixture/fixture_reader.dart';
import '../../../../helper/mock_helper.mocks.dart';

void main() {
  late CreateManualTrack useCase;
  late MockTrackRepository mockRepository;

  setUp(() {
    mockRepository = MockTrackRepository();
    useCase = CreateManualTrack(repository: mockRepository);
  });

  final tBody = ManualCreateTrackBody.fromJson(
    json.decode(
      fixture('manual_create_track_body.json'),
    ),
  );
  final tParams = ParamsCreateManualTrack(body: tBody);

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
      when(mockRepository.createManualTrack(any)).thenAnswer((_) async => tResult);

      // act
      final result = await useCase(tParams);

      // assert
      expect(result, tResult);
      verify(mockRepository.createManualTrack(tBody));
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
        'ParamsCreateManualTrack{body: ${tParams.body}}',
      );
    },
  );
}
