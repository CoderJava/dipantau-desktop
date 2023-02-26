import 'dart:convert';

import 'package:dartz/dartz.dart';
import 'package:dipantau_desktop_client/feature/data/model/general/general_response.dart';
import 'package:dipantau_desktop_client/feature/data/model/tracking_data/tracking_data_body.dart';
import 'package:dipantau_desktop_client/feature/domain/usecase/create_tracking_data/create_tracking_data.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../../../fixture/fixture_reader.dart';
import '../../../../helper/mock_helper.mocks.dart';

void main() {
  late CreateTrackingData useCase;
  late MockGeneralRepository mockGeneralRepository;

  setUp(() {
    mockGeneralRepository = MockGeneralRepository();
    useCase = CreateTrackingData(generalRepository: mockGeneralRepository);
  });

  final tBody = TrackingDataBody.fromJson(
    json.decode(
      fixture('tracking_data_body.json'),
    ),
  );
  final tParams = ParamsCreateTrackingData(body: tBody);

  test(
    'pastikan objek repository berhasil menerima respon sukses atau gagal dari endpoint',
    () async {
      // arrange
      final tResponse = GeneralResponse.fromJson(
        json.decode(
          fixture('general_response.json'),
        ),
      );
      when(mockGeneralRepository.createTrackingData(any)).thenAnswer((_) async => Right(tResponse));

      // act
      final result = await useCase(tParams);

      // assert
      expect(result, Right(tResponse));
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
        'ParamsCreateTrackingData{body: ${tParams.body}}',
      );
    },
  );
}