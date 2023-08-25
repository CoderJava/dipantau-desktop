import 'dart:convert';

import 'package:dipantau_desktop_client/feature/data/model/reset_password/reset_password_body.dart';
import 'package:dipantau_desktop_client/feature/presentation/bloc/reset_password/reset_password_bloc.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../fixture/fixture_reader.dart';

void main() {
  group('SubmitResetPasswordEvent', () {
    final body = ResetPasswordBody.fromJson(
      json.decode(
        fixture('reset_password_body.json'),
      ),
    );
    final event = SubmitResetPasswordEvent(body: body);

    test(
      'pastikan output dari fungsi toString',
      () async {
        // assert
        expect(
          event.toString(),
          'SubmitResetPasswordEvent{body: $body}',
        );
      },
    );
  });
}
