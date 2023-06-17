import 'package:dartz/dartz.dart';
import 'package:dipantau_desktop_client/core/error/failure.dart';
import 'package:dipantau_desktop_client/feature/data/model/create_track/create_track_body.dart';
import 'package:dipantau_desktop_client/feature/data/model/general/general_response.dart';
import 'package:dipantau_desktop_client/feature/data/model/track_user_lite/track_user_lite_response.dart';

abstract class TrackRepository {
  Future<Either<Failure, TrackUserLiteResponse>> getTrackUserLite(String date, String projectId);

  Future<({Failure? failure, GeneralResponse? response})> createTrack(CreateTrackBody body);
}