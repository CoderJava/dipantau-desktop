import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'project_response.g.dart';

@JsonSerializable()
class ProjectResponse extends Equatable {
  @JsonKey(name: 'data')
  final List<ItemProjectResponse>? data;

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

  ItemProjectResponse({
    required this.id,
    required this.name,
  });

  factory ItemProjectResponse.fromJson(Map<String, dynamic> json) => _$ItemProjectResponseFromJson(json);

  Map<String, dynamic> toJson() => _$ItemProjectResponseToJson(this);

  @override
  List<Object?> get props => [
    id,
    name,
  ];

  @override
  String toString() {
    return 'ItemProjectResponse{id: $id, name: $name}';
  }
}
