import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'project_task_response.g.dart';

@JsonSerializable()
class ProjectTaskResponse extends Equatable {
  @JsonKey(name: 'data')
  final List<ItemProjectTaskResponse>? data;

  ProjectTaskResponse({
    required this.data,
  });

  factory ProjectTaskResponse.fromJson(Map<String, dynamic> json) => _$ProjectTaskResponseFromJson(json);

  Map<String, dynamic> toJson() => _$ProjectTaskResponseToJson(this);

  @override
  List<Object?> get props => [
        data,
      ];

  @override
  String toString() {
    return 'ProjectTaskResponse{data: $data}';
  }
}

@JsonSerializable()
class ItemProjectTaskResponse extends Equatable {
  @JsonKey(name: 'project_id')
  final int? projectId;
  @JsonKey(name: 'project_name')
  final String? projectName;
  @JsonKey(name: 'tasks')
  final List<ItemTaskLiteProjectTaskResponse> tasks;

  ItemProjectTaskResponse({
    required this.projectId,
    required this.projectName,
    required this.tasks,
  });

  factory ItemProjectTaskResponse.fromJson(Map<String, dynamic> json) => _$ItemProjectTaskResponseFromJson(json);

  Map<String, dynamic> toJson() => _$ItemProjectTaskResponseToJson(this);

  @override
  List<Object?> get props => [
        projectId,
        projectName,
        tasks,
      ];

  @override
  String toString() {
    return 'ItemProjectTaskResponse{projectId: $projectId, projectName: $projectName, tasks: $tasks}';
  }
}

@JsonSerializable()
class ItemTaskLiteProjectTaskResponse extends Equatable {
  @JsonKey(name: 'id')
  final int? id;
  @JsonKey(name: 'name')
  final String? name;

  ItemTaskLiteProjectTaskResponse({
    required this.id,
    required this.name,
  });

  factory ItemTaskLiteProjectTaskResponse.fromJson(Map<String, dynamic> json) =>
      _$ItemTaskLiteProjectTaskResponseFromJson(json);

  Map<String, dynamic> toJson() => _$ItemTaskLiteProjectTaskResponseToJson(this);

  @override
  List<Object?> get props => [
        id,
        name,
      ];

  @override
  String toString() {
    return 'ItemTaskLiteProjectTaskResponse{id: $id, name: $name}';
  }
}
