import 'package:dipantau_desktop_client/feature/database/entity/track/track.dart';
import 'package:floor/floor.dart';

@dao
abstract class TrackDao {
  @Query('SELECT * FROM track WHERE user_id = :userId')
  Future<List<Track>> findAllTrack(String userId);

  @insert
  Future<void> insertTrack(Track track);

  @Query('DELETE FROM track WHERE id = :id')
  Future<void> deleteTrackById(int id);

  @Query('DELETE FROM track')
  Future<void> deleteAllTrack();

  @Query('SELECT * FROM track WHERE start_date LIKE :date OR finish_date LIKE :date')
  Future<List<Track>> findAllTrackLikeDate(String date);
}