import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'track_user_response.g.dart';

@JsonSerializable()
class TrackUserResponse extends Equatable {
  @JsonKey(name: 'data')
  final List<ItemTrackUserResponse>? data;

  TrackUserResponse({
    required this.data,
  });

  factory TrackUserResponse.fromJson(Map<String, dynamic> json) => _$TrackUserResponseFromJson(json);

  Map<String, dynamic> toJson() => _$TrackUserResponseToJson(this);

  @override
  List<Object?> get props => [
        data,
      ];

  @override
  String toString() {
    return 'TrackUserResponse{data: $data}';
  }
}

@JsonSerializable()
class ItemTrackUserResponse extends Equatable {
  @JsonKey(name: 'id')
  final int? id;
  @JsonKey(name: 'task_id')
  final int? taskId;
  @JsonKey(name: 'task_name')
  final String? taskName;
  @JsonKey(name: 'project_id')
  final int? projectId;
  @JsonKey(name: 'project_name')
  final String? projectName;
  @JsonKey(name: 'start_date')
  final String? startDate;
  @JsonKey(name: 'finish_date')
  final String? finishDate;
  @JsonKey(name: 'activity')
  final int? activityInPercent;
  @JsonKey(name: 'duration')
  final int? durationInSeconds;
  @JsonKey(name: 'user_id')
  final int? userId;
  @JsonKey(name: 'user')
  final String? user;
  @JsonKey(name: 'files')
  final List<ItemFileTrackUserResponse>? files;

  ItemTrackUserResponse({
    required this.id,
    required this.taskId,
    required this.taskName,
    required this.projectId,
    required this.projectName,
    required this.startDate,
    required this.finishDate,
    required this.activityInPercent,
    required this.durationInSeconds,
    required this.userId,
    required this.user,
    required this.files,
  });

  factory ItemTrackUserResponse.fromJson(Map<String, dynamic> json) => _$ItemTrackUserResponseFromJson(json);

  Map<String, dynamic> toJson() => _$ItemTrackUserResponseToJson(this);

  @override
  List<Object?> get props => [
        id,
        taskId,
        taskName,
        projectId,
        projectName,
        startDate,
        finishDate,
        activityInPercent,
        durationInSeconds,
        userId,
        user,
        files,
      ];

  @override
  String toString() {
    return 'ItemTrackUserResponse{id: $id, taskId: $taskId, taskName: $taskName, projectId: $projectId, '
        'projectName: $projectName, startDate: $startDate, finishDate: $finishDate, '
        'activityInPercent: $activityInPercent, durationInSeconds: $durationInSeconds, userId: $userId, user: $user, '
        'files: $files}';
  }
}

@JsonSerializable()
class ItemFileTrackUserResponse extends Equatable {
  @JsonKey(name: 'id')
  final int? id;
  @JsonKey(name: 'url')
  final String? url;
  @JsonKey(name: 'size')
  final int? sizeInByte;
  @JsonKey(name: 'url_blur')
  final String? urlBlur;
  @JsonKey(name: 'size_blur')
  final int? sizeBlurInByte;

  ItemFileTrackUserResponse({
    required this.id,
    required this.url,
    required this.sizeInByte,
    required this.urlBlur,
    required this.sizeBlurInByte,
  });

  factory ItemFileTrackUserResponse.fromJson(Map<String, dynamic> json) => _$ItemFileTrackUserResponseFromJson(json);

  Map<String, dynamic> toJson() => _$ItemFileTrackUserResponseToJson(this);

  @override
  List<Object?> get props => [
        id,
        url,
        sizeInByte,
        urlBlur,
        sizeBlurInByte,
      ];

  @override
  String toString() {
    return 'ItemFileTrackUserResponse{id: $id, url: $url, sizeInByte: $sizeInByte, urlBlur: $urlBlur, '
        'sizeBlurInByte: $sizeBlurInByte}';
  }
}
