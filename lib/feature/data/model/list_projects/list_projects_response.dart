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
