import 'package:dipantau_desktop_client/core/util/shared_preferences_manager.dart';
import 'package:dipantau_desktop_client/feature/database/dao/track/track_dao.dart';
import 'package:package_info_plus/package_info_plus.dart';

const autoUpdaterUrl = 'https://raw.githubusercontent.com/CoderJava/dipantau-desktop/main/dist/appcast.xml';
late SharedPreferencesManager sharedPreferencesManager;
late TrackDao trackDao;
late PackageInfo packageInfo;

