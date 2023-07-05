enum UserRole {
  superAdmin,
  admin,
  employee,
}

extension UserRoleExtension on String {
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