import 'package:easy_localization/easy_localization.dart';

extension StringExtension on String {
  String hideResponseCode() {
    final string = trim();
    final listResponseCode = <String>[
      '404',
      '405',
      '406',
      '407',
      '409',
      '410',
      '411',
      '412',
      '413',
      '414',
      '415',
      '416',
      '417',
      '418',
      '420',
      '421',
      '423',
      '424',
      '425',
      '426',
      '429',
      '431',
      '444',
      '450',
      '451',
      '497',
      '498',
      '499',
    ];
    if (string.startsWith(RegExp('^([0-9]{3})'))) {
      if (string.startsWith('504') || string.startsWith('408')) {
        return 'server_busy'.tr();
      } else if (string.startsWith('5')) {
        return 'oops_body'.tr();
      }
      return string.substring(3, string.length).trim();
    } else {
      if (string.contains(RegExp('504')) || string.contains(RegExp('408'))) {
        return 'server_busy'.tr();
      } else {
        for (String responseCode in listResponseCode) {
          if (string.contains(RegExp(responseCode))) {
            return 'oops_body'.tr();
          }
        }
      }
      return string;
    }
  }
}