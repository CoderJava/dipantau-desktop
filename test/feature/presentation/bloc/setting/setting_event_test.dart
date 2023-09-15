import 'dart:convert';

import 'package:dipantau_desktop_client/feature/data/model/kv_setting/kv_setting_body.dart';
import 'package:dipantau_desktop_client/feature/data/model/user_setting/user_setting_body.dart';
import 'package:dipantau_desktop_client/feature/presentation/bloc/setting/setting_bloc.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../fixture/fixture_reader.dart';

void main() {
  group('UpdateKvSettingEvent', () {
    final tEvent = UpdateKvSettingEvent(
      body: KvSettingBody.fromJson(
        json.decode(
          fixture('kv_setting_body.json'),
        ),
      ),
    );

    test(
      'pastikan output dari fungsi toString',
      () async {
        // assert
        expect(
          tEvent.toString(),
          'UpdateKvSettingEvent{body: ${tEvent.body}}',
        );
      },
    );
  });

  group('UpdateUserSettingEvent', () {
    final tEvent = UpdateUserSettingEvent(
      body: UserSettingBody.fromJson(
        json.decode(
          fixture('user_setting_body.json'),
        ),
      ),
    );

    test(
      'pastikan output dari fungsi toString',
      () async {
        // assert
        expect(
          tEvent.toString(),
          'UpdateUserSettingEvent{body: ${tEvent.body}}',
        );
      },
    );
  });
}
