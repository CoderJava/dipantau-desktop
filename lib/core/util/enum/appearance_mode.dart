enum AppearanceMode {
  system,
  light,
  dark,
}

extension AppearanceModeExtension on String {
  AppearanceMode? get fromString {
    if (this == AppearanceMode.system.name) {
      return AppearanceMode.system;
    } else if (this == AppearanceMode.light.name) {
      return AppearanceMode.light;
    } else if (this == AppearanceMode.dark.name) {
      return AppearanceMode.dark;
    }
    return null;
  }
}