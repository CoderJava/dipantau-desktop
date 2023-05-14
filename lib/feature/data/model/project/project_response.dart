import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'project_response.g.dart';

@JsonSerializable()
class ProjectResponse extends Equatable {
  @JsonKey(name: 'id')
  final int? id;
  @JsonKey(name: 'name')
  final String? name;

  ProjectResponse({
    required this.id,
    required this.name,
  });

  factory ProjectResponse.fromJson(Map<String, dynamic> json) => _$ProjectResponseFromJson(json);

  Map<String, dynamic> toJson() => _$ProjectResponseToJson(this);

  @override
  List<Object?> get props => [
    id,
    name,
  ];

  @override
  String toString() {
    return 'ProjectResponse{id: $id, name: $name}';
  }
}
