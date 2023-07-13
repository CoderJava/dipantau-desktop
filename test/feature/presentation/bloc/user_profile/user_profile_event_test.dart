import 'dart:convert';

import 'package:dipantau_desktop_client/feature/data/model/update_user/update_user_body.dart';
import 'package:dipantau_desktop_client/feature/presentation/bloc/user_profile/user_profile_bloc.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../fixture/fixture_reader.dart';

void main() {
  group('UpdateDataUserProfileEvent', () {
    final tEvent = UpdateDataUserProfileEvent(
      body: UpdateUserBody.fromJson(
        json.decode(
          fixture('update_user_body.json'),
        ),
      ),
      id: 0,
    );

    test(
      'pastikan output dari fungsi toString',
      () async {
        // assert
        expect(
          tEvent.toString(),
          'UpdateDataUserProfileEvent{body: ${tEvent.body}, id: ${tEvent.id}}',
        );
      },
    );
  });
}
