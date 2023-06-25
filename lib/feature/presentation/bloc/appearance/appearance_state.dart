part of 'appearance_bloc.dart';

abstract class AppearanceState {}

class InitialAppearanceState extends AppearanceState {}

class UpdatedAppearanceState extends AppearanceState {
  final bool isDarkMode;

  UpdatedAppearanceState({required this.isDarkMode});

  @override
  String toString() {
    return 'UpdatedAppearanceState{isDarkMode: $isDarkMode}';
  }
}