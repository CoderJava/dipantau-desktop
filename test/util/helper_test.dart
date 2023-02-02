import 'package:dipantau_desktop_client/core/util/helper.dart';
import 'package:dipantau_desktop_client/feature/data/model/tracking_time/tracking_time.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';

void main() {
  late Helper helper;

  setUp(() {
    initializeDateFormatting('en', '');
    helper = Helper();
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
      expect(helper.getDefaultPaddingLayout, 24.0);
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
    'pastikan fungsi convertSecondToTrackingTime bisa mengembalikan waktu dalam satuan jam, menit, dan detik',
    () async {
      // act
      final result = helper.convertSecondToTrackingTime(34);
      final result2 = helper.convertSecondToTrackingTime(95);
      final result3 = helper.convertSecondToTrackingTime(3666);

      // assert
      expect(result, TrackingTime(hour: 0, minute: 0, second: 34));
      expect(result2, TrackingTime(hour: 0, minute: 1, second: 35));
      expect(result3, TrackingTime(hour: 1, minute: 1, second: 6));
    },
  );
}
