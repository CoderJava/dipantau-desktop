import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
import 'package:dipantau_desktop_client/core/network/network_info.dart';
import 'package:dipantau_desktop_client/core/util/helper.dart';
import 'package:dipantau_desktop_client/core/util/shared_preferences_manager.dart';
import 'package:dipantau_desktop_client/feature/data/datasource/auth/auth_remote_data_source.dart';
import 'package:dipantau_desktop_client/feature/data/datasource/general/general_remote_data_source.dart';
import 'package:dipantau_desktop_client/feature/domain/repository/auth/auth_repository.dart';
import 'package:dipantau_desktop_client/feature/domain/repository/general/general_repository.dart';
import 'package:dipantau_desktop_client/feature/domain/usecase/create_tracking_data/create_tracking_data.dart';
import 'package:dipantau_desktop_client/feature/domain/usecase/get_project/get_project.dart';
import 'package:dipantau_desktop_client/feature/domain/usecase/login/login.dart';
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
  GeneralRepository,
  AuthRepository,
  GetProject,
  CreateTrackingData,
  Login,
])
void main() {}