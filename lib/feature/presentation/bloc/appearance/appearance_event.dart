part of 'appearance_bloc.dart';

abstract class AppearanceEvent {}

class UpdateAppearanceEvent extends AppearanceEvent {
  final bool isDarkMode;

  UpdateAppearanceEvent({required this.isDarkMode});

  @override
  String toString() {
    return 'UpdateAppearanceEvent{isDarkMode: $isDarkMode}';
  }
}