part of 'home_bloc.dart';

abstract class HomeEvent extends Equatable {
  const HomeEvent();
}

class PrepareDataHomeEvent extends HomeEvent {
  @override
  List<Object?> get props => [];
}

class LoadDataProjectHomeEvent extends HomeEvent {
  @override
  List<Object?> get props => [];
}