import 'dart:async';

import 'package:bloc/bloc.dart';

part 'appearance_event.dart';

part 'appearance_state.dart';

class AppearanceBloc extends Bloc<AppearanceEvent, AppearanceState> {
  AppearanceBloc() : super(InitialAppearanceState()) {
    on<UpdateAppearanceEvent>(_onUpdateAppearanceEvent);
  }

  FutureOr<void> _onUpdateAppearanceEvent(
    UpdateAppearanceEvent event,
    Emitter<AppearanceState> emit,
  ) {
    emit(UpdatedAppearanceState(isDarkMode: event.isDarkMode));
  }
}
