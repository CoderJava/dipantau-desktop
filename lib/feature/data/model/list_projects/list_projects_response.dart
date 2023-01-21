import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'list_projects_response.g.dart';

@JsonSerializable()
class ListProjectsResponse extends Equatable {
  @JsonKey(name: 'data')
  final List<ItemProjectResponse> data;

  ListProjectsResponse({
    required this.data,
  });

  factory ListProjectsResponse.fromJson(Map<String, dynamic> json) => _$ListProjectsResponseFromJson(json);

  Map<String, dynamic> toJson() => _$ListProjectsResponseToJson(this);

  @override
  List<Object?> get props => [
        data,
      ];

  @override
  String toString() {
    return 'ListProjectsResponse{data: $data}';
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
