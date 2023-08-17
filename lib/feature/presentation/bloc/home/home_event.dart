part of 'home_bloc.dart';

abstract class HomeEvent extends Equatable {
  const HomeEvent();
}

class LoadDataHomeEvent extends HomeEvent {
  final String date;
  final String projectId;
  final bool isAutoStart;
  final UserVersionBody? userVersionBody;

  LoadDataHomeEvent({
    required this.date,
    required this.projectId,
    required this.isAutoStart,
    this.userVersionBody,
  });

  @override
  List<Object?> get props => [
        date,
        projectId,
        isAutoStart,
        userVersionBody,
      ];

  @override
  String toString() {
    return 'LoadDataHomeEvent{date: $date, projectId: $projectId, isAutoStart: $isAutoStart, '
        'userVersionBody: $userVersionBody}';
  }
}
