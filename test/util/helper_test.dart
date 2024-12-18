import 'package:dipantau_desktop_client/config/flavor_config.dart';
import 'package:dipantau_desktop_client/core/error/failure.dart';
import 'package:dipantau_desktop_client/core/util/helper.dart';
import 'package:dipantau_desktop_client/core/util/shared_preferences_manager.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:mockito/mockito.dart';

import '../helper/mock_helper.mocks.dart';

void main() {
  late Helper helper;
  late MockSharedPreferencesManager mockSharedPreferencesManager;

  setUp(() {
    initializeDateFormatting('en', '');
    mockSharedPreferencesManager = MockSharedPreferencesManager();
    helper = Helper(sharedPreferencesManager: mockSharedPreferencesManager);
  });

  test(
    'pastikan fungsi checkValidationEmail bisa mengecek apakah email-nya valid atau tidak',
    () async {
      // act
      final result = helper.checkValidationEmail('yudisetiawan@nusa.net.id');
      final result2 = helper.checkValidationEmail('eva.yosefin@surya-nusantara.com');
      final result3 = helper.checkValidationEmail('eva-yosefin.pablo@surya-nusantara.com');

      // assert
      expect(result, true);
      expect(result2, true);
      expect(result3, true);
    },
  );

  test(
    'pastikan output dari variable getDefaultPaddingLayout',
    () async {
      // assert
      expect(helper.getDefaultPaddingLayout, 16.0);
    },
  );

  test(
    'pastikan output dari variable getDefaultPaddingLayoutTop',
    () async {
      // assert
      expect(helper.getDefaultPaddingLayoutTop, 8.0);
    },
  );

  test(
    'pastikan output dari variable getDefaultPaddingLayoutBottom',
    () async {
      // assert
      expect(helper.getDefaultPaddingLayoutBottom, 24.0);
    },
  );

  test(
    'pastikan output dari variable getDefaultWindowSize',
    () async {
      // assert
      expect(helper.getDefaultWindowSize, 500.0);
    },
  );

  test(
    'pastikan fungsi setDateFormat bisa mengembalikan objek DateFormat sesuai dengan pattern yang diberikan',
    () async {
      // act
      final result = helper.setDateFormat('dd');
      final result2 = helper.setDateFormat('dd', languageCode: 'id');

      // assert
      expect(result.pattern, DateFormat('dd', 'en').pattern);
      expect(result2.pattern, DateFormat('dd', 'id').pattern);
    },
  );

  test(
    'pastikan fungsi convertSecondToHms bisa mengembalikan waktu dalam satuan jam, menit, dan detik',
    () async {
      // act
      final result = helper.convertSecondToHms(34);
      final result2 = helper.convertSecondToHms(95);
      final result3 = helper.convertSecondToHms(3666);

      // assert
      expect(result, (hour: 0, minute: 0, second: 34));
      expect(result2, (hour: 0, minute: 1, second: 35));
      expect(result3, (hour: 1, minute: 1, second: 6));
    },
  );

  test(
    'pastikan fungsi convertTrackingTimeToString bisa mengubah nilai detik menjadi string dalam bentuk HH:mm:ss',
    () async {
      // act
      final result = helper.convertTrackingTimeToString(3666);

      // assert
      expect(result, '01:01:06');
    },
  );

  test(
    'pastikan fungsi setDomainApiToFlavor bisa set nilai FlavorConfig',
    () async {
      // arrange
      const baseUrl = 'https://example.com';
      const baseUrlAuth = '$baseUrl/api/auth';
      const baseUrlUser = '$baseUrl/api/user';
      const baseUrlTrack = '$baseUrl/api/track';
      const baseUrlProject = '$baseUrl/api/project';
      const baseUrlSetting = '$baseUrl/api/setting';

      // act
      helper.setDomainApiToFlavor('https://example.com');

      // assert
      expect(FlavorConfig.instance.values.baseUrl, baseUrl);
      expect(FlavorConfig.instance.values.baseUrlAuth, baseUrlAuth);
      expect(FlavorConfig.instance.values.baseUrlUser, baseUrlUser);
      expect(FlavorConfig.instance.values.baseUrlTrack, baseUrlTrack);
      expect(FlavorConfig.instance.values.baseUrlProject, baseUrlProject);
      expect(FlavorConfig.instance.values.baseUrlSetting, baseUrlSetting);
    },
  );

  test(
    'pastikan function setLogout bisa menghapus semua value didalam SharedPreferences',
    () async {
      // arrange
      const domainApi = 'https://example.com';
      const appearanceMode = 'testAppearanceMode';
      when(mockSharedPreferencesManager.getString(SharedPreferencesManager.keyDomainApi)).thenReturn(domainApi);
      when(mockSharedPreferencesManager.getString(SharedPreferencesManager.keyAppearanceMode))
          .thenReturn(appearanceMode);

      // act
      await helper.setLogout();

      // assert
      verify(mockSharedPreferencesManager.getString(SharedPreferencesManager.keyDomainApi));
      verify(mockSharedPreferencesManager.getString(SharedPreferencesManager.keyAppearanceMode));
      verify(mockSharedPreferencesManager.putString(SharedPreferencesManager.keyDomainApi, domainApi));
      verify(mockSharedPreferencesManager.putString(SharedPreferencesManager.keyAppearanceMode, appearanceMode));
    },
  );

  test(
    'pastikan function getErrorMessageFromFailure bisa mengembalikan pesan sesuai dengan class-nya',
    () async {
      // arrange
      const message = 'testErrorMessage';
      final constantErrorMessage = ConstantErrorMessage();

      // act
      final serverFailure = helper.getErrorMessageFromFailure(ServerFailure(message));
      final connectionFailure = helper.getErrorMessageFromFailure(ConnectionFailure());
      final parsingFailure = helper.getErrorMessageFromFailure(ParsingFailure(message));
      final unknownFailure = helper.getErrorMessageFromFailure(null);

      // assert
      expect(serverFailure, message);
      expect(connectionFailure, constantErrorMessage.connectionError);
      expect(parsingFailure, constantErrorMessage.parsingError);
      expect(unknownFailure, constantErrorMessage.failureUnknown);
    },
  );

  test(
    'pastikan function removeTrailingSlash bisa menghapus karakter "/" diakhir dari sebuah string.',
    () async {
      // arrange
      const input = 'https://example.com/';
      const input2 = 'https://example.com';
      const input3 = 'https://example.com////';
      const output = 'https://example.com';

      // act
      final actual1 = helper.removeTrailingSlash(input);
      final actual2 = helper.removeTrailingSlash(input2);
      final actual3 = helper.removeTrailingSlash(input3);

      // assert
      expect(actual1, output);
      expect(actual2, output);
      expect(actual3, output);
    },
  );
}
