import 'dart:convert';

import 'package:dipantau_desktop_client/core/usecase/usecase.dart';
import 'package:dipantau_desktop_client/feature/data/model/user_profile/list_user_profile_response.dart';
import 'package:dipantau_desktop_client/feature/domain/usecase/get_all_member/get_all_member.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../../../fixture/fixture_reader.dart';
import '../../../../helper/mock_helper.mocks.dart';

void main() {
  late GetAllMember useCase;
  late MockUserRepository mockRepository;

  setUp(() {
    mockRepository = MockUserRepository();
    useCase = GetAllMember(repository: mockRepository);
  });

  test(
    'pastikan objek repository berhasil menerima respon sukses atau gagal dari endpoint',
    () async {
      // arrange
      final tResponse = ListUserProfileResponse.fromJson(
        json.decode(
          fixture('list_user_profile_response.json'),
        ),
      );
      final tResult = (failure: null, response: tResponse);
      when(mockRepository.getAllMembers()).thenAnswer((_) async => tResult);

      // act
      final result = await useCase(NoParams());

      // assert
      expect(result, tResult);
      verify(mockRepository.getAllMembers());
      verifyNoMoreInteractions(mockRepository);
    },
  );
}
