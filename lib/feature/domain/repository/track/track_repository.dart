import 'package:dartz/dartz.dart';
import 'package:dipantau_desktop_client/core/error/failure.dart';
import 'package:dipantau_desktop_client/feature/data/model/create_track/bulk_create_track_data_body.dart';
import 'package:dipantau_desktop_client/feature/data/model/create_track/bulk_create_track_image_body.dart';
import 'package:dipantau_desktop_client/feature/data/model/create_track/create_track_body.dart';
import 'package:dipantau_desktop_client/feature/data/model/general/general_response.dart';
import 'package:dipantau_desktop_client/feature/data/model/manual_create_track/manual_create_track_body.dart';
import 'package:dipantau_desktop_client/feature/data/model/track_user/track_user_response.dart';
import 'package:dipantau_desktop_client/feature/data/model/track_user_lite/track_user_lite_response.dart';

abstract class TrackRepository {
  Future<Either<Failure, TrackUserLiteResponse>> getTrackUserLite(String date, String projectId);

  Future<({Failure? failure, GeneralResponse? response})> createTrack(CreateTrackBody body);

  Future<({Failure? failure, GeneralResponse? response})> bulkCreateTrackData(BulkCreateTrackDataBody body);

  Future<({Failure? failure, GeneralResponse? response})> bulkCreateTrackImage(BulkCreateTrackImageBody body);

  Future<({Failure? failure, TrackUserResponse? response})> getTrackUser(String userId, String date);

  Future<({Failure? failure, GeneralResponse? response})> deleteTrackUser(int trackId);

  Future<({Failure? failure, GeneralResponse? response})> createManualTrack(ManualCreateTrackBody body);
}