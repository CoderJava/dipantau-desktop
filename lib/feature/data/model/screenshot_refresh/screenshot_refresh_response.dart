import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'screenshot_refresh_response.g.dart';

@JsonSerializable()
class ScreenshotRefreshResponse extends Equatable {
  @JsonKey(name: 'refreshed_urls')
  final List<ItemRefreshedUrlResponse>? refreshedUrls;

  ScreenshotRefreshResponse({
    required this.refreshedUrls,
  });

  factory ScreenshotRefreshResponse.fromJson(Map<String, dynamic> json) => _$ScreenshotRefreshResponseFromJson(json);

  Map<String, dynamic> toJson() => _$ScreenshotRefreshResponseToJson(this);

  @override
  List<Object?> get props => [
        refreshedUrls,
      ];

  @override
  String toString() {
    return 'ScreenshotRefreshResponse{refreshedUrls: $refreshedUrls}';
  }
}

@JsonSerializable()
class ItemRefreshedUrlResponse extends Equatable {
  @JsonKey(name: 'original')
  final AttachmentScreenshotRefreshResponse? original;
  @JsonKey(name: 'refreshed')
  final AttachmentScreenshotRefreshResponse? refreshed;

  ItemRefreshedUrlResponse({
    required this.original,
    required this.refreshed,
  });

  factory ItemRefreshedUrlResponse.fromJson(Map<String, dynamic> json) => _$ItemRefreshedUrlResponseFromJson(json);

  Map<String, dynamic> toJson() => _$ItemRefreshedUrlResponseToJson(this);

  @override
  List<Object?> get props => [
        original,
        refreshed,
      ];

  @override
  String toString() {
    return 'ItemRefreshedUrlResponse{original: $original, refreshed: $refreshed}';
  }
}

@JsonSerializable()
class AttachmentScreenshotRefreshResponse extends Equatable {
  @JsonKey(name: 'url')
  final String? url;
  @JsonKey(name: 'url_blur')
  final String? urlBlur;

  AttachmentScreenshotRefreshResponse({
    required this.url,
    required this.urlBlur,
  });

  factory AttachmentScreenshotRefreshResponse.fromJson(Map<String, dynamic> json) =>
      _$AttachmentScreenshotRefreshResponseFromJson(json);

  Map<String, dynamic> toJson() => _$AttachmentScreenshotRefreshResponseToJson(this);

  @override
  List<Object?> get props => [
        url,
        urlBlur,
      ];

  @override
  String toString() {
    return 'AttachmentScreenshotRefreshResponse{url: $url, urlBlur: $urlBlur}';
  }
}
