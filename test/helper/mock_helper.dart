import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
import 'package:dipantau_desktop_client/core/network/network_info.dart';
import 'package:dipantau_desktop_client/core/util/helper.dart';
import 'package:dipantau_desktop_client/core/util/shared_preferences_manager.dart';
import 'package:dipantau_desktop_client/feature/data/datasource/auth/auth_remote_data_source.dart';
import 'package:dipantau_desktop_client/feature/data/datasource/general/general_remote_data_source.dart';
import 'package:dipantau_desktop_client/feature/data/datasource/project/project_remote_data_source.dart';
import 'package:dipantau_desktop_client/feature/data/datasource/track/track_remote_data_source.dart';
import 'package:dipantau_desktop_client/feature/data/datasource/user/user_remote_data_source.dart';
import 'package:dipantau_desktop_client/feature/domain/repository/auth/auth_repository.dart';
import 'package:dipantau_desktop_client/feature/domain/repository/general/general_repository.dart';
import 'package:dipantau_desktop_client/feature/domain/repository/track/track_repository.dart';
import 'package:dipantau_desktop_client/feature/domain/repository/user/user_repository.dart';
import 'package:dipantau_desktop_client/feature/domain/usecase/create_tracking_data/create_tracking_data.dart';
import 'package:dipantau_desktop_client/feature/domain/usecase/get_profile/get_profile.dart';
import 'package:dipantau_desktop_client/feature/domain/usecase/get_project/get_project.dart';
import 'package:dipantau_desktop_client/feature/domain/usecase/get_track_user_lite/get_track_user_lite.dart';
import 'package:dipantau_desktop_client/feature/domain/usecase/login/login.dart';
import 'package:dipantau_desktop_client/feature/domain/usecase/refresh_token/refresh_token.dart';
import 'package:dipantau_desktop_client/feature/domain/usecase/sign_up/sign_up.dart';
import 'package:mockito/annotations.dart';
import 'package:shared_preferences/shared_preferences.dart';

@GenerateMocks([
  Connectivity,
  NetworkInfo,
  SharedPreferences,
  SharedPreferencesManager,
  Dio,
  HttpClientAdapter,
  Helper,
  GeneralRemoteDataSource,
  AuthRemoteDataSource,
  UserRemoteDataSource,
  TrackRemoteDataSource,
  ProjectRemoteDataSource,
  GeneralRepository,
  AuthRepository,
  UserRepository,
  TrackRepository,
  GetProject,
  CreateTrackingData,
  Login,
  SignUp,
  GetProfile,
  RefreshToken,
  GetTrackUserLite,
])
void main() {}