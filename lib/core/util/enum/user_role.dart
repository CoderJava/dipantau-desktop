import 'package:easy_localization/easy_localization.dart';

enum UserRole {
  superAdmin,
  admin,
  employee,
}

extension StringUserRoleExtension on String {
  UserRole? get fromStringUserRole {
    if (this == UserRole.superAdmin.name) {
      return UserRole.superAdmin;
    } else if (this == UserRole.admin.name) {
      return UserRole.admin;
    } else if (this == UserRole.employee.name) {
      return UserRole.employee;
    }
    return null;
  }
}

extension UserRoleExtension on UserRole {
  String? get toName {
    switch (this) {
      case UserRole.superAdmin:
        return 'super_admin'.tr();
      case UserRole.admin:
        return 'admin'.tr();
      case UserRole.employee:
        return 'employee'.tr();
      default:
        return null;
    }
  }
}