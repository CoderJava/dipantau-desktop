import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
import 'package:dipantau_desktop_client/core/network/network_info.dart';
import 'package:dipantau_desktop_client/core/util/helper.dart';
import 'package:dipantau_desktop_client/core/util/shared_preferences_manager.dart';
import 'package:dipantau_desktop_client/feature/data/datasource/auth/auth_remote_data_source.dart';
import 'package:dipantau_desktop_client/feature/data/datasource/project/project_remote_data_source.dart';
import 'package:dipantau_desktop_client/feature/data/datasource/screenshot/screenshot_remote_data_source.dart';
import 'package:dipantau_desktop_client/feature/data/datasource/setting/setting_remote_data_source.dart';
import 'package:dipantau_desktop_client/feature/data/datasource/track/track_remote_data_source.dart';
import 'package:dipantau_desktop_client/feature/data/datasource/user/user_remote_data_source.dart';
import 'package:dipantau_desktop_client/feature/domain/repository/auth/auth_repository.dart';
import 'package:dipantau_desktop_client/feature/domain/repository/project/project_repository.dart';
import 'package:dipantau_desktop_client/feature/domain/repository/screenshot/screenshot_repository.dart';
import 'package:dipantau_desktop_client/feature/domain/repository/setting/setting_repository.dart';
import 'package:dipantau_desktop_client/feature/domain/repository/track/track_repository.dart';
import 'package:dipantau_desktop_client/feature/domain/repository/user/user_repository.dart';
import 'package:dipantau_desktop_client/feature/domain/usecase/bulk_create_track_data/bulk_create_track_data.dart';
import 'package:dipantau_desktop_client/feature/domain/usecase/bulk_create_track_image/bulk_create_track_image.dart';
import 'package:dipantau_desktop_client/feature/domain/usecase/create_manual_track/create_manual_track.dart';
import 'package:dipantau_desktop_client/feature/domain/usecase/create_track/create_track.dart';
import 'package:dipantau_desktop_client/feature/domain/usecase/delete_track_user/delete_track_user.dart';
import 'package:dipantau_desktop_client/feature/domain/usecase/forgot_password/forgot_password.dart';
import 'package:dipantau_desktop_client/feature/domain/usecase/get_all_member/get_all_member.dart';
import 'package:dipantau_desktop_client/feature/domain/usecase/get_all_user_setting/get_all_user_setting.dart';
import 'package:dipantau_desktop_client/feature/domain/usecase/get_kv_setting/get_kv_setting.dart';
import 'package:dipantau_desktop_client/feature/domain/usecase/get_profile/get_profile.dart';
import 'package:dipantau_desktop_client/feature/domain/usecase/get_project/get_project.dart';
import 'package:dipantau_desktop_client/feature/domain/usecase/get_project_task_by_user_id/get_project_task_by_user_id.dart';
import 'package:dipantau_desktop_client/feature/domain/usecase/get_track_user/get_track_user.dart';
import 'package:dipantau_desktop_client/feature/domain/usecase/get_track_user_lite/get_track_user_lite.dart';
import 'package:dipantau_desktop_client/feature/domain/usecase/get_user_setting/get_user_setting.dart';
import 'package:dipantau_desktop_client/feature/domain/usecase/login/login.dart';
import 'package:dipantau_desktop_client/feature/domain/usecase/refresh_screenshot/refresh_screenshot.dart';
import 'package:dipantau_desktop_client/feature/domain/usecase/refresh_token/refresh_token.dart';
import 'package:dipantau_desktop_client/feature/domain/usecase/reset_password/reset_password.dart';
import 'package:dipantau_desktop_client/feature/domain/usecase/send_app_version/send_app_version.dart';
import 'package:dipantau_desktop_client/feature/domain/usecase/set_kv_setting/set_kv_setting.dart';
import 'package:dipantau_desktop_client/feature/domain/usecase/sign_up/sign_up.dart';
import 'package:dipantau_desktop_client/feature/domain/usecase/update_user/update_user.dart';
import 'package:dipantau_desktop_client/feature/domain/usecase/update_user_setting/update_user_setting.dart';
import 'package:dipantau_desktop_client/feature/domain/usecase/verify_forgot_password/verify_forgot_password.dart';
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
  MockSpec<ScreenshotRemoteDataSource>(),
  MockSpec<ProjectRemoteDataSource>(),
  MockSpec<SettingRemoteDataSource>(),
  MockSpec<AuthRepository>(),
  MockSpec<UserRepository>(),
  MockSpec<TrackRepository>(),
  MockSpec<ProjectRepository>(),
  MockSpec<SettingRepository>(),
  MockSpec<ScreenshotRepository>(),
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
  MockSpec<GetKvSetting>(),
  MockSpec<SetKvSetting>(),
  MockSpec<SendAppVersion>(),
  MockSpec<DeleteTrackUser>(),
  MockSpec<ForgotPassword>(),
  MockSpec<VerifyForgotPassword>(),
  MockSpec<ResetPassword>(),
  MockSpec<CreateManualTrack>(),
  MockSpec<GetProjectTaskByUserId>(),
  MockSpec<GetAllUserSetting>(),
  MockSpec<GetUserSetting>(),
  MockSpec<UpdateUserSetting>(),
  MockSpec<RefreshScreenshot>(),
])
void main() {}
