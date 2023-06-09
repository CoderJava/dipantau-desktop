part of 'home_bloc.dart';

abstract class HomeEvent extends Equatable {
  const HomeEvent();
}

class LoadDataHomeEvent extends HomeEvent {
  final String date;
  final String projectId;

  LoadDataHomeEvent({
    required this.date,
    required this.projectId,
  });

  @override
  List<Object?> get props => [
    date,
    projectId,
  ];

  @override
  String toString() {
    return 'LoadDataHomeEvent{date: $date, projectId: $projectId}';
  }
}
