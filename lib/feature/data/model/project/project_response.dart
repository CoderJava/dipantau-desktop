import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'project_response.g.dart';

@JsonSerializable()
class ProjectResponse extends Equatable {
  @JsonKey(name: 'data')
  final List<ItemProjectResponse> data;

  ProjectResponse({
    required this.data,
  });

  factory ProjectResponse.fromJson(Map<String, dynamic> json) => _$ProjectResponseFromJson(json);

  Map<String, dynamic> toJson() => _$ProjectResponseToJson(this);

  @override
  List<Object?> get props => [
        data,
      ];

  @override
  String toString() {
    return 'ProjectResponse{data: $data}';
  }
}

@JsonSerializable()
class ItemProjectResponse extends Equatable {
  @JsonKey(name: 'id')
  final int? id;
  @JsonKey(name: 'name')
  final String? name;
  @JsonKey(name: 'tracked_in_seconds')
  final int? trackedInSeconds;
  @JsonKey(name: 'list_tasks')
  final List<ItemTaskProjectResponse> listTasks;

  ItemProjectResponse({
    required this.id,
    required this.name,
    required this.trackedInSeconds,
    required this.listTasks,
  });

  factory ItemProjectResponse.fromJson(Map<String, dynamic> json) => _$ItemProjectResponseFromJson(json);

  Map<String, dynamic> toJson() => _$ItemProjectResponseToJson(this);

  @override
  List<Object?> get props => [
        id,
        name,
        trackedInSeconds,
        listTasks,
      ];

  @override
  String toString() {
    return 'ItemProjectResponse{id: $id, name: $name, trackedInSeconds: $trackedInSeconds, listTasks}';
  }
}

@JsonSerializable()
class ItemTaskProjectResponse extends Equatable {
  @JsonKey(name: 'id')
  final int? id;
  @JsonKey(name: 'name')
  final String? name;
  @JsonKey(name: 'tracked_in_seconds')
  final int? trackedInSeconds;

  ItemTaskProjectResponse({
    required this.id,
    required this.name,
    required this.trackedInSeconds,
  });

  factory ItemTaskProjectResponse.fromJson(Map<String, dynamic> json) => _$ItemTaskProjectResponseFromJson(json);

  Map<String, dynamic> toJson() => _$ItemTaskProjectResponseToJson(this);

  @override
  List<Object?> get props => [
    id,
    name,
    trackedInSeconds,
  ];

  @override
  String toString() {
    return 'ItemTaskProjectResponse{id: $id, name: $name, trackedInSeconds: $trackedInSeconds}';
  }
}
