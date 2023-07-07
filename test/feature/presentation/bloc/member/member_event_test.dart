import 'dart:convert';

import 'package:dipantau_desktop_client/feature/data/model/update_user/update_user_body.dart';
import 'package:dipantau_desktop_client/feature/presentation/bloc/member/member_bloc.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../fixture/fixture_reader.dart';

void main() {
  group('EditMemberEvent', () {
    final tEvent = EditMemberEvent(
      body: UpdateUserBody.fromJson(
        json.decode(
          fixture('update_user_body.json'),
        ),
      ),
      id: 1,
    );

    test(
      'pastikan output dari fungsi toString',
      () async {
        // assert
        expect(
          tEvent.toString(),
          'EditMemberEvent{body: ${tEvent.body}, id: ${tEvent.id}}',
        );
      },
    );
  });
}
