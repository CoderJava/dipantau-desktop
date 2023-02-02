import 'package:dipantau_desktop_client/feature/data/model/detail_project/detail_project_response.dart';
import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'project_response.g.dart';

@JsonSerializable()
class ProjectResponse extends Equatable {
  @JsonKey(name: 'data')
  final List<DetailProjectResponse> data;

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
