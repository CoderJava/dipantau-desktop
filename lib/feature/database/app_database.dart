import 'dart:async';

import 'package:dipantau_desktop_client/feature/database/dao/track/track_dao.dart';
import 'package:dipantau_desktop_client/feature/database/entity/track/track.dart';
import 'package:floor/floor.dart';
import 'package:sqflite/sqflite.dart' as sqflite;

part 'app_database.g.dart';

@Database(
  version: 1,
  entities: [
    Track,
  ],
)
abstract class AppDatabase extends FloorDatabase {
  TrackDao get trackDao;
}