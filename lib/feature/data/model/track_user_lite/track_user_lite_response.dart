import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'track_user_lite_response.g.dart';

@JsonSerializable()
class TrackUserLiteResponse extends Equatable {
  @JsonKey(name: 'project_id')
  final int? projectId;
  @JsonKey(name: 'project_name')
  final String? projectName;
  @JsonKey(name: 'tracked_in_seconds')
  final int? trackedInSeconds;
  @JsonKey(name: 'list_tracks')
  final List<ItemTrackUserLiteResponse>? listTracks;
  @JsonKey(name: 'list_tasks')
  final List<ItemTaskUserLiteResponse>? listTasks;

  TrackUserLiteResponse({
    required this.projectId,
    required this.projectName,
    required this.trackedInSeconds,
    required this.listTracks,
    required this.listTasks,
  });

  factory TrackUserLiteResponse.fromJson(Map<String, dynamic> json) => _$TrackUserLiteResponseFromJson(json);

  Map<String, dynamic> toJson() => _$TrackUserLiteResponseToJson(this);

  @override
  List<Object?> get props => [
        projectId,
        projectName,
        trackedInSeconds,
        listTracks,
        listTasks,
      ];

  @override
  String toString() {
    return 'TrackUserLiteResponse{projectId: $projectId, projectName: $projectName, trackedInSeconds: $trackedInSeconds, '
        'listTracks: $listTracks, listTasks: $listTasks}';
  }
}

@JsonSerializable()
class ItemTrackUserLiteResponse extends Equatable {
  @JsonKey(name: 'task_id')
  final int? taskId;
  @JsonKey(name: 'task_name')
  final String? taskName;
  @JsonKey(name: 'tracked_in_seconds')
  final int? trackedInSeconds;

  ItemTrackUserLiteResponse({
    required this.taskId,
    required this.taskName,
    required this.trackedInSeconds,
  });

  factory ItemTrackUserLiteResponse.fromJson(Map<String, dynamic> json) => _$ItemTrackUserLiteResponseFromJson(json);

  Map<String, dynamic> toJson() => _$ItemTrackUserLiteResponseToJson(this);

  @override
  List<Object?> get props => [
        taskId,
        taskName,
        trackedInSeconds,
      ];

  @override
  String toString() {
    return 'ItemTrackUserLiteResponse{taskId: $taskId, taskName: $taskName, trackedInSeconds: $trackedInSeconds}';
  }
}

@JsonSerializable()
class ItemTaskUserLiteResponse extends Equatable {
  @JsonKey(name: 'id')
  final int? id;
  @JsonKey(name: 'name')
  final String? name;

  ItemTaskUserLiteResponse({
    required this.id,
    required this.name,
  });

  factory ItemTaskUserLiteResponse.fromJson(Map<String, dynamic> json) => _$ItemTaskUserLiteResponseFromJson(json);

  Map<String, dynamic> toJson() => _$ItemTaskUserLiteResponseToJson(this);

  @override
  List<Object?> get props => [
    id,
    name,
  ];

  @override
  String toString() {
    return 'ItemTaskUserLiteResponse{id: $id, name: $name}';
  }
}
