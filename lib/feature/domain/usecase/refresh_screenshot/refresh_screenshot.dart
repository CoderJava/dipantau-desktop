import 'package:dipantau_desktop_client/core/error/failure.dart';
import 'package:dipantau_desktop_client/core/usecase/usecase.dart';
import 'package:dipantau_desktop_client/feature/data/model/screenshot_refresh/screenshot_refresh_body.dart';
import 'package:dipantau_desktop_client/feature/data/model/screenshot_refresh/screenshot_refresh_response.dart';
import 'package:dipantau_desktop_client/feature/domain/repository/screenshot/screenshot_repository.dart';
import 'package:equatable/equatable.dart';

class RefreshScreenshot implements UseCaseRecords<ScreenshotRefreshResponse?, ParamsRefreshScreenshot> {
  final ScreenshotRepository repository;

  RefreshScreenshot({required this.repository});

  @override
  Future<({Failure? failure, ScreenshotRefreshResponse? response})> call(ParamsRefreshScreenshot params) {
    return repository.refreshScreenshot(params.body);
  }
}

class ParamsRefreshScreenshot extends Equatable {
  final ScreenshotRefreshBody body;

  ParamsRefreshScreenshot({required this.body});

  @override
  List<Object?> get props => [
    body,
  ];

  @override
  String toString() {
    return 'ParamsRefreshScreenshot{body: $body}';
  }
}