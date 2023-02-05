part of 'project_bloc.dart';

abstract class ProjectEvent extends Equatable {
  const ProjectEvent();
}

class LoadDataProjectEvent extends ProjectEvent {
  @override
  List<Object?> get props => [];
}