import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'screenshot_refresh_body.g.dart';

@JsonSerializable()
class ScreenshotRefreshBody extends Equatable {
  @JsonKey(name: 'attachment_urls')
  final List<ItemAttachmentUrlScreenshotBody> attachmentUrls;

  ScreenshotRefreshBody({
    required this.attachmentUrls,
  });

  factory ScreenshotRefreshBody.fromJson(Map<String, dynamic> json) => _$ScreenshotRefreshBodyFromJson(json);

  Map<String, dynamic> toJson() => _$ScreenshotRefreshBodyToJson(this);

  @override
  List<Object?> get props => [
        attachmentUrls,
      ];

  @override
  String toString() {
    return 'ScreenshotRefreshBody{attachmentUrls: $attachmentUrls}';
  }
}

@JsonSerializable()
class ItemAttachmentUrlScreenshotBody extends Equatable {
  @JsonKey(name: 'url')
  final String url;
  @JsonKey(name: 'url_blur')
  final String urlBlur;

  ItemAttachmentUrlScreenshotBody({
    required this.url,
    required this.urlBlur,
  });

  factory ItemAttachmentUrlScreenshotBody.fromJson(Map<String, dynamic> json) => _$ItemAttachmentUrlScreenshotBodyFromJson(json);

  Map<String, dynamic> toJson() => _$ItemAttachmentUrlScreenshotBodyToJson(this);

  @override
  List<Object?> get props => [
    url,
    urlBlur,
  ];

  @override
  String toString() {
    return 'ItemAttachmentUrlScreenshotBody{url: $url, urlBlur: $urlBlur}';
  }
}
