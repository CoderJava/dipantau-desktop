import 'dart:convert';

import 'package:dipantau_desktop_client/feature/data/model/track_user/track_user_response.dart';
import 'package:dipantau_desktop_client/feature/domain/usecase/get_track_user/get_track_user.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../../../fixture/fixture_reader.dart';
import '../../../../helper/mock_helper.mocks.dart';

void main() {
  late GetTrackUser useCase;
  late MockTrackRepository mockRepository;

  setUp(() {
    mockRepository = MockTrackRepository();
    useCase = GetTrackUser(repository: mockRepository);
  });

  const tUserId = 'testUserId';
  const tDate = 'testDate';
  final tParams = ParamsGetTrackUser(userId: tUserId, date: tDate);

  test(
    'pastikan objek repository berhasil menerima respon sukses atau gagal dari endpoint',
    () async {
      // arrange
      final tResponse = TrackUserResponse.fromJson(
        json.decode(
          fixture('track_user_response.json'),
        ),
      );
      final tResult = (failure: null, response: tResponse);
      when(mockRepository.getTrackUser(any, any)).thenAnswer((_) async => tResult);

      // act
      final result = await useCase(tParams);

      // assert
      expect(result, tResult);
      verify(mockRepository.getTrackUser(tUserId, tDate));
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
          tParams.date,
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
        'ParamsGetTrackUser{userId: ${tParams.userId}, date: ${tParams.date}}',
      );
    },
  );
}
