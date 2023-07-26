import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:dipantau_desktop_client/core/util/helper.dart';
import 'package:dipantau_desktop_client/feature/data/model/create_track/bulk_create_track_data_body.dart';
import 'package:dipantau_desktop_client/feature/data/model/create_track/bulk_create_track_image_body.dart';
import 'package:dipantau_desktop_client/feature/domain/usecase/bulk_create_track_data/bulk_create_track_data.dart';
import 'package:dipantau_desktop_client/feature/domain/usecase/bulk_create_track_image/bulk_create_track_image.dart';

part 'cron_tracking_event.dart';

part 'cron_tracking_state.dart';

class CronTrackingBloc extends Bloc<CronTrackingEvent, CronTrackingState> {
  final Helper helper;
  final BulkCreateTrackData bulkCreateTrackData;
  final BulkCreateTrackImage bulkCreateTrackImage;

  CronTrackingBloc({
    required this.helper,
    required this.bulkCreateTrackData,
    required this.bulkCreateTrackImage,
  }) : super(InitialCronTrackingState()) {
    on<RunCronTrackingEvent>(_onRunCronTrackingEvent, transformer: restartable());
  }

  FutureOr<void> _onRunCronTrackingEvent(
    RunCronTrackingEvent event,
    Emitter<CronTrackingState> emit,
  ) async {
    final bodyData = event.bodyData;
    final ids = <int>[];
    if (bodyData != null) {
      final result = await bulkCreateTrackData(
        ParamsBulkCreateTrackData(
          body: bodyData,
        ),
      );
      if (result.response != null) {
        ids.addAll(bodyData.data.where((element) => element.id != null).map((e) => e.id!));
      }
    }

    final bodyImage = event.bodyImage;
    final files = <String>[];
    if (bodyImage != null) {
      final result = await bulkCreateTrackImage(
        ParamsBulkCreateTrackImage(
          body: bodyImage,
        ),
      );
      if (result.response != null) {
        files.addAll(bodyImage.files);
      }
    }
    emit(
      SuccessRunCronTrackingState(
        ids: ids,
        files: files,
      ),
    );
  }
}
