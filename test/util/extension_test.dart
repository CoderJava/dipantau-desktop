import 'package:dipantau_desktop_client/core/util/enum/appearance_mode.dart';
import 'package:dipantau_desktop_client/core/util/enum/user_role.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test(
    'pastikan output dari extension fromStringAppearanceMode yang di appearance_mode bisa mengembalikan enum AppearanceMode',
    () async {
      // arrange
      final light = AppearanceMode.light.name;
      final dark = AppearanceMode.dark.name;
      final system = AppearanceMode.system.name;

      // act
      final resultLight = light.fromStringAppearanceMode;
      final resultDark = dark.fromStringAppearanceMode;
      final resultSystem = system.fromStringAppearanceMode;

      // assert
      expect(resultLight, AppearanceMode.light);
      expect(resultDark, AppearanceMode.dark);
      expect(resultSystem, AppearanceMode.system);
    },
  );

  test(
    'pastikan output dari extension fromStringUserRole yang di user_role bisa mengembalikan enum UserRole',
    () async {
      // arrange
      final superAdmin = UserRole.superAdmin.name;
      final admin = UserRole.admin.name;
      final employee = UserRole.employee.name;

      // act
      final resultSuperAdmin = superAdmin.fromStringUserRole;
      final resultAdmin = admin.fromStringUserRole;
      final resultEmployee = employee.fromStringUserRole;

      // assert
      expect(resultSuperAdmin, UserRole.superAdmin);
      expect(resultAdmin, UserRole.admin);
      expect(resultEmployee, UserRole.employee);
    },
  );

  test(
    'pastiakn output dari extension toName yang di user_role bisa mengembalikan label dari enum UserRole',
    () async {
      // arrange
      const superAdmin = UserRole.superAdmin;
      const admin = UserRole.admin;
      const employee = UserRole.employee;

      // act
      final resultSuperAdmin = superAdmin.toName;
      final resultAdmin = admin.toName;
      final resultEmployee = employee.toName;

      // assert
      expect(resultSuperAdmin, 'super_admin');
      expect(resultAdmin, 'admin');
      expect(resultEmployee, 'employee');
    },
  );
}
