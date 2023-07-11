import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
import 'package:dipantau_desktop_client/core/network/network_info.dart';
import 'package:dipantau_desktop_client/core/util/helper.dart';
import 'package:dipantau_desktop_client/core/util/shared_preferences_manager.dart';
import 'package:dipantau_desktop_client/feature/data/datasource/auth/auth_remote_data_source.dart';
import 'package:dipantau_desktop_client/feature/data/datasource/project/project_remote_data_source.dart';
import 'package:dipantau_desktop_client/feature/data/datasource/setting/setting_remote_data_source.dart';
import 'package:dipantau_desktop_client/feature/data/datasource/track/track_remote_data_source.dart';
import 'package:dipantau_desktop_client/feature/data/datasource/user/user_remote_data_source.dart';
import 'package:dipantau_desktop_client/feature/domain/repository/auth/auth_repository.dart';
import 'package:dipantau_desktop_client/feature/domain/repository/project/project_repository.dart';
import 'package:dipantau_desktop_client/feature/domain/repository/setting/setting_repository.dart';
import 'package:dipantau_desktop_client/feature/domain/repository/track/track_repository.dart';
import 'package:dipantau_desktop_client/feature/domain/repository/user/user_repository.dart';
import 'package:dipantau_desktop_client/feature/domain/usecase/bulk_create_track_data/bulk_create_track_data.dart';
import 'package:dipantau_desktop_client/feature/domain/usecase/bulk_create_track_image/bulk_create_track_image.dart';
import 'package:dipantau_desktop_client/feature/domain/usecase/create_track/create_track.dart';
import 'package:dipantau_desktop_client/feature/domain/usecase/get_all_member/get_all_member.dart';
import 'package:dipantau_desktop_client/feature/domain/usecase/get_profile/get_profile.dart';
import 'package:dipantau_desktop_client/feature/domain/usecase/get_project/get_project.dart';
import 'package:dipantau_desktop_client/feature/domain/usecase/get_track_user/get_track_user.dart';
import 'package:dipantau_desktop_client/feature/domain/usecase/get_track_user_lite/get_track_user_lite.dart';
import 'package:dipantau_desktop_client/feature/domain/usecase/login/login.dart';
import 'package:dipantau_desktop_client/feature/domain/usecase/refresh_token/refresh_token.dart';
import 'package:dipantau_desktop_client/feature/domain/usecase/sign_up/sign_up.dart';
import 'package:dipantau_desktop_client/feature/domain/usecase/update_user/update_user.dart';
import 'package:mockito/annotations.dart';
import 'package:shared_preferences/shared_preferences.dart';

@GenerateNiceMocks([
  MockSpec<Connectivity>(),
  MockSpec<NetworkInfo>(),
  MockSpec<SharedPreferences>(),
  MockSpec<SharedPreferencesManager>(),
  MockSpec<Dio>(),
  MockSpec<HttpClientAdapter>(),
  MockSpec<Helper>(),
  MockSpec<AuthRemoteDataSource>(),
  MockSpec<UserRemoteDataSource>(),
  MockSpec<TrackRemoteDataSource>(),
  MockSpec<ProjectRemoteDataSource>(),
  MockSpec<SettingRemoteDataSource>(),
  MockSpec<AuthRepository>(),
  MockSpec<UserRepository>(),
  MockSpec<TrackRepository>(),
  MockSpec<ProjectRepository>(),
  MockSpec<SettingRepository>(),
  MockSpec<GetProject>(),
  MockSpec<CreateTrack>(),
  MockSpec<Login>(),
  MockSpec<SignUp>(),
  MockSpec<GetProfile>(),
  MockSpec<RefreshToken>(),
  MockSpec<GetTrackUserLite>(),
  MockSpec<BulkCreateTrackData>(),
  MockSpec<BulkCreateTrackImage>(),
  MockSpec<GetAllMember>(),
  MockSpec<UpdateUser>(),
  MockSpec<GetTrackUser>(),
])
void main() {}
