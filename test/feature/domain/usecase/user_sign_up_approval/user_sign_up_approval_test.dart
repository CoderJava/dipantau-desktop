import 'dart:convert';

import 'package:dipantau_desktop_client/feature/data/model/general/general_response.dart';
import 'package:dipantau_desktop_client/feature/data/model/user_sign_up_approval/user_sign_up_approval_body.dart';
import 'package:dipantau_desktop_client/feature/domain/usecase/user_sign_up_approval/user_sign_up_approval.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../../../fixture/fixture_reader.dart';
import '../../../../helper/mock_helper.mocks.dart';

void main() {
  late UserSignUpApproval useCase;
  late MockUserRepository mockRepository;

  setUp(() {
    mockRepository = MockUserRepository();
    useCase = UserSignUpApproval(repository: mockRepository);
  });

  final tBody = UserSignUpApprovalBody.fromJson(
    json.decode(
      fixture('user_sign_up_approval_body.json'),
    ),
  );
  final tParams = ParamsUserSignUpApproval(body: tBody);

  test(
    'pastikan objek repository berhasil menerima respon sukses atau gagal dari endpoint',
    () async {
      // arrange
      final tResponse = GeneralResponse.fromJson(
        json.decode(
          fixture('general_response.json'),
        ),
      );
      final tResult = (failure: null, response: tResponse);
      when(mockRepository.userSignUpApproval(any)).thenAnswer((_) async => tResult);

      // act
      final result = await useCase(tParams);

      // assert
      expect(result, tResult);
      verify(mockRepository.userSignUpApproval(tBody));
      verifyNoMoreInteractions(mockRepository);
    },
  );

  test(
    'pastikan output dari nilai props',
    () async {
      // assert
      expect(
        tParams.props,
        [
          tParams.body,
        ],
      );
    },
  );

  test(
    'pastikan output dari fungsi toString',
    () async {
      // assert
      expect(
        tParams.toString(),
        'ParamsUserSignUpApproval{body: ${tParams.body}}',
      );
    },
  );
}
