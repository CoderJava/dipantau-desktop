import 'dart:convert';

import 'package:dipantau_desktop_client/feature/data/model/login/login_body.dart';
import 'package:dipantau_desktop_client/feature/presentation/bloc/login/login_bloc.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../fixture/fixture_reader.dart';

void main() {
  group('SubmitLoginEvent', () {
    final tBody = LoginBody.fromJson(
      json.decode(
        fixture('login_body.json'),
      ),
    );
    final tEvent = SubmitLoginEvent(body: tBody);

    test(
      'pastikan output dari nilai props',
      () async {
        // assert
        expect(
          tEvent.props,
          [
            tEvent.body,
          ],
        );
      },
    );

    test(
      'pastikan output dari fungsi toString',
      () async {
        // assert
        expect(
          tEvent.toString(),
          'SubmitLoginEvent{body: ${tEvent.body}}',
        );
      },
    );
  });
}
