import 'dart:convert';

import 'package:dipantau_desktop_client/feature/data/model/screenshot_refresh/screenshot_refresh_body.dart';
import 'package:dipantau_desktop_client/feature/data/model/screenshot_refresh/screenshot_refresh_response.dart';
import 'package:dipantau_desktop_client/feature/domain/usecase/refresh_screenshot/refresh_screenshot.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../../../fixture/fixture_reader.dart';
import '../../../../helper/mock_helper.mocks.dart';

void main() {
  late RefreshScreenshot useCase;
  late MockScreenshotRepository mockRepository;

  setUp(() {
    mockRepository = MockScreenshotRepository();
    useCase = RefreshScreenshot(repository: mockRepository);
  });

  final tBody = ScreenshotRefreshBody.fromJson(
    json.decode(
      fixture('screenshot_refresh_body.json'),
    ),
  );
  final tParams = ParamsRefreshScreenshot(body: tBody);

  test(
    'pastikan objek repository berhasil menerima respon sukses atau gagal dari endpoint',
    () async {
      // arrange
      final tResponse = ScreenshotRefreshResponse.fromJson(
        json.decode(
          fixture('screenshot_refresh_response.json'),
        ),
      );
      final tResult = (failure: null, response: tResponse);
      when(mockRepository.refreshScreenshot(any)).thenAnswer((_) async => tResult);

      // act
      final result = await useCase(tParams);

      // assert
      expect(result, tResult);
      verify(mockRepository.refreshScreenshot(tBody));
      verifyNoMoreInteractions(mockRepository);
    },
  );

  test(
    'pastikan output dari nilai props',
    () async {
      // assert
      expect(tParams.props, [
        tParams.body,
      ]);
    },
  );

  test(
    'pastikan output dari fungsi toString',
    () async {
      // assert
      expect(
        tParams.toString(),
        'ParamsRefreshScreenshot{body: ${tParams.body}}',
      );
    },
  );
}
