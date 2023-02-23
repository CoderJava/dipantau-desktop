import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'tracking_data_body.g.dart';

@JsonSerializable()
class TrackingDataBody extends Equatable {
  @JsonKey(name: 'data')
  final List<ItemTrackingDataBody> data;

  TrackingDataBody({required this.data});

  factory TrackingDataBody.fromJson(Map<String, dynamic> json) => _$TrackingDataBodyFromJson(json);

  Map<String, dynamic> toJson() => _$TrackingDataBodyToJson(this);

  @override
  List<Object?> get props => [
    data,
  ];

  @override
  String toString() {
    return 'TrackingDataBody{data: $data}';
  }
}

@JsonSerializable()
class ItemTrackingDataBody extends Equatable {
  @JsonKey(name: 'email')
  final String email;
  @JsonKey(name: 'formatted_start_time')
  final String formattedStartTime;
  @JsonKey(name: 'formatted_end_time')
  final String formattedEndTime;
  @JsonKey(name: 'duration_activity_in_seconds')
  final int durationActivityInSeconds;
  @JsonKey(name: 'interval_in_seconds')
  final int intervalInSeconds;
  @JsonKey(name: 'percent_activity')
  final double percentActivity;
  @JsonKey(name: 'screenshots')
  final List<String> screenshots;

  ItemTrackingDataBody({
    required this.email,
    required this.formattedStartTime,
    required this.formattedEndTime,
    required this.durationActivityInSeconds,
    required this.intervalInSeconds,
    required this.percentActivity,
    required this.screenshots,
  });

  factory ItemTrackingDataBody.fromJson(Map<String, dynamic> json) => _$ItemTrackingDataBodyFromJson(json);

  Map<String, dynamic> toJson() => _$ItemTrackingDataBodyToJson(this);

  @override
  List<Object?> get props => [
        email,
        formattedStartTime,
        formattedEndTime,
        durationActivityInSeconds,
        intervalInSeconds,
        percentActivity,
        screenshots,
      ];

  @override
  String toString() {
    return 'ItemTrackingDataBody{email: $email, formattedStartTime: $formattedStartTime, '
        'formattedEndTime: $formattedEndTime, durationActivityInSeconds: $durationActivityInSeconds, '
        'intervalInSeconds: $intervalInSeconds, percentActivity: $percentActivity, screenshots: $screenshots}';
  }
}
