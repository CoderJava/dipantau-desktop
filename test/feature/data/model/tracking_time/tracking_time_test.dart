import 'package:dipantau_desktop_client/feature/data/model/tracking_time/tracking_time.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final tModel = TrackingTime(
    hour: 0,
    minute: 0,
    second: 0,
  );

  test(
    'pastikan output dari nilai props',
    () async {
      // assert
      expect(
        tModel.props,
        [
          tModel.hour,
          tModel.minute,
          tModel.second,
        ],
      );
    },
  );

  test(
    'pastikan output dari fungsi toString',
    () async {
      // assert
      expect(
        tModel.toString(),
        'TrackingTime{hour: ${tModel.hour}, minute: ${tModel.minute}, second: ${tModel.second}}',
      );
    },
  );
}
