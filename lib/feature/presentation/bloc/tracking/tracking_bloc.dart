import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:dipantau_desktop_client/core/util/helper.dart';
import 'package:dipantau_desktop_client/feature/data/model/create_track/bulk_create_track_data_body.dart';
import 'package:dipantau_desktop_client/feature/data/model/create_track/bulk_create_track_image_body.dart';
import 'package:dipantau_desktop_client/feature/data/model/create_track/create_track_body.dart';
import 'package:dipantau_desktop_client/feature/domain/usecase/bulk_create_track_data/bulk_create_track_data.dart';
import 'package:dipantau_desktop_client/feature/domain/usecase/bulk_create_track_image/bulk_create_track_image.dart';
import 'package:dipantau_desktop_client/feature/domain/usecase/create_track/create_track.dart';

part 'tracking_event.dart';

part 'tracking_state.dart';

class TrackingBloc extends Bloc<TrackingEvent, TrackingState> {
  final CreateTrack createTrack;
  final BulkCreateTrackData bulkCreateTrackData;
  final Helper helper;
  final BulkCreateTrackImage bulkCreateTrackImage;

  TrackingBloc({
    required this.createTrack,
    required this.bulkCreateTrackData,
    required this.helper,
    required this.bulkCreateTrackImage,
  }) : super(InitialTrackingState()) {
    on<CreateTimeTrackingEvent>(_onCreateTimeTrackingEvent, transformer: sequential());

    on<CronTrackingEvent>(_onCronTrackingEvent, transformer: sequential());
  }

  FutureOr<void> _onCreateTimeTrackingEvent(
    CreateTimeTrackingEvent event,
    Emitter<TrackingState> emit,
  ) async {
    emit(LoadingTrackingState());
    final result = await createTrack(ParamsCreateTrack(body: event.body));
    final response = result.response;
    final failure = result.failure;
    if (response != null) {
      emit(
        SuccessCreateTimeTrackingState(
          files: event.body.files,
          trackEntityId: event.trackEntityId,
        ),
      );
      return;
    }

    final errorMessage = helper.getErrorMessageFromFailure(failure);
    emit(FailureTrackingState(errorMessage: errorMessage));
  }

  FutureOr<void> _onCronTrackingEvent(
    CronTrackingEvent event,
    Emitter<TrackingState> emit,
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
      SuccessCronTrackingState(
        ids: ids,
        files: files,
      ),
    );
  }
}
