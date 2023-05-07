import 'dart:convert';

import 'package:dipantau_desktop_client/feature/data/model/user_profile/user_profile_response.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../fixture/fixture_reader.dart';

void main() {
  const tPathJsonSuperAdmin = 'user_profile_super_admin_response.json';
  const tPathJsonAdmin = 'user_profile_admin_response.json';
  const tPathJsonEmployee = 'user_profile_employee_response.json';
  final tModelSuperAdmin = UserProfileResponse.fromJson(
    json.decode(
      fixture(tPathJsonSuperAdmin),
    ),
  );
  final tModelAdmin = UserProfileResponse.fromJson(
    json.decode(
      fixture(tPathJsonAdmin),
    ),
  );
  final tModelEmployee = UserProfileResponse.fromJson(
    json.decode(
      fixture(tPathJsonEmployee),
    ),
  );

  test(
    'pastikan output dari nilai props',
    () async {
      // assert
      expect(
        tModelSuperAdmin.props,
        [
          tModelSuperAdmin.id,
          tModelSuperAdmin.name,
          tModelSuperAdmin.username,
          tModelSuperAdmin.role,
        ],
      );
    },
  );

  test(
    'pastikan output dari fungsi toString',
    () async {
      // assert
      expect(
        tModelSuperAdmin.toString(),
        'UserProfileResponse{id: ${tModelSuperAdmin.id}, name: ${tModelSuperAdmin.name}, '
        'username: ${tModelSuperAdmin.username}, role: ${tModelSuperAdmin.role}}',
      );
    },
  );

  test(
    'pastikan fungsi fromJson bisa mengembalikan objek class model',
    () async {
      // arrange
      final jsonDataSuperAdmin = json.decode(
        fixture(tPathJsonSuperAdmin),
      );
      final jsonDataAdmin = json.decode(
        fixture(tPathJsonAdmin),
      );
      final jsonDataEmployee = json.decode(
        fixture(tPathJsonEmployee),
      );

      // act
      final actualModelSuperAdmin = UserProfileResponse.fromJson(jsonDataSuperAdmin);
      final actualModelAdmin = UserProfileResponse.fromJson(jsonDataAdmin);
      final actualModelEmployee = UserProfileResponse.fromJson(jsonDataEmployee);

      // assert
      expect(actualModelSuperAdmin, tModelSuperAdmin);
      expect(actualModelAdmin, tModelAdmin);
      expect(actualModelEmployee, tModelEmployee);
    },
  );

  test(
    'pastikan fungsi toJson bisa mengembalikan objek map',
    () async {
      // arrange
      final model = UserProfileResponse.fromJson(
        json.decode(
          fixture(tPathJsonSuperAdmin),
        ),
      );

      // act
      final actualMap = json.encode(model.toJson());

      // assert
      expect(actualMap, json.encode(tModelSuperAdmin.toJson()));
    },
  );
}
