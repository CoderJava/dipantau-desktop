import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
import 'package:dipantau_desktop_client/core/network/network_info.dart';
import 'package:dipantau_desktop_client/core/util/dio_logging_interceptor_refresh_token.dart';
import 'package:dipantau_desktop_client/core/util/helper.dart';
import 'package:dipantau_desktop_client/core/util/notification_helper.dart';
import 'package:dipantau_desktop_client/core/util/shared_preferences_manager.dart';
import 'package:dipantau_desktop_client/feature/data/datasource/auth/auth_remote_data_source.dart';
import 'package:dipantau_desktop_client/feature/data/datasource/project/project_remote_data_source.dart';
import 'package:dipantau_desktop_client/feature/data/datasource/track/track_remote_data_source.dart';
import 'package:dipantau_desktop_client/feature/data/datasource/user/user_remote_data_source.dart';
import 'package:dipantau_desktop_client/feature/data/repository/auth/auth_repository_impl.dart';
import 'package:dipantau_desktop_client/feature/data/repository/project/project_repository_impl.dart';
import 'package:dipantau_desktop_client/feature/data/repository/track/track_repository_impl.dart';
import 'package:dipantau_desktop_client/feature/data/repository/user/user_repository_impl.dart';
import 'package:dipantau_desktop_client/feature/database/app_database.dart';
import 'package:dipantau_desktop_client/feature/domain/repository/auth/auth_repository.dart';
import 'package:dipantau_desktop_client/feature/domain/repository/project/project_repository.dart';
import 'package:dipantau_desktop_client/feature/domain/repository/track/track_repository.dart';
import 'package:dipantau_desktop_client/feature/domain/repository/user/user_repository.dart';
import 'package:dipantau_desktop_client/feature/domain/usecase/bulk_create_track_data/bulk_create_track_data.dart';
import 'package:dipantau_desktop_client/feature/domain/usecase/bulk_create_track_image/bulk_create_track_image.dart';
import 'package:dipantau_desktop_client/feature/domain/usecase/create_track/create_track.dart';
import 'package:dipantau_desktop_client/feature/domain/usecase/get_profile/get_profile.dart';
import 'package:dipantau_desktop_client/feature/domain/usecase/get_project/get_project.dart';
import 'package:dipantau_desktop_client/feature/domain/usecase/get_track_user_lite/get_track_user_lite.dart';
import 'package:dipantau_desktop_client/feature/domain/usecase/login/login.dart';
import 'package:dipantau_desktop_client/feature/domain/usecase/refresh_token/refresh_token.dart';
import 'package:dipantau_desktop_client/feature/domain/usecase/sign_up/sign_up.dart';
import 'package:dipantau_desktop_client/feature/presentation/bloc/appearance/appearance_bloc.dart';
import 'package:dipantau_desktop_client/feature/presentation/bloc/home/home_bloc.dart';
import 'package:dipantau_desktop_client/feature/presentation/bloc/login/login_bloc.dart';
import 'package:dipantau_desktop_client/feature/presentation/bloc/project/project_bloc.dart';
import 'package:dipantau_desktop_client/feature/presentation/bloc/sign_up/sign_up_bloc.dart';
import 'package:dipantau_desktop_client/feature/presentation/bloc/tracking/tracking_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

final sl = GetIt.instance;

Future<void> init() async {
  const dioRefreshToken = 'dio_refresh_token';
  const dioLogging = 'dio_logging';

  // bloc
  sl.registerFactory(
    () => HomeBloc(
      getTrackUserLite: sl(),
    ),
  );
  sl.registerFactory(
    () => ProjectBloc(
      sharedPreferencesManager: sl(),
      getProject: sl(),
    ),
  );
  sl.registerFactory(
    () => TrackingBloc(
      createTrack: sl(),
      bulkCreateTrackData: sl(),
      helper: sl(),
      bulkCreateTrackImage: sl(),
    ),
  );
  sl.registerFactory(
    () => LoginBloc(
      login: sl(),
      sharedPreferencesManager: sl(),
      getProfile: sl(),
    ),
  );
  sl.registerFactory(
    () => SignUpBloc(
      signUp: sl(),
    ),
  );
  sl.registerFactory(
    () => AppearanceBloc(),
  );

  // use case
  sl.registerLazySingleton(() => GetProject(repository: sl()));
  sl.registerLazySingleton(() => Login(repository: sl()));
  sl.registerLazySingleton(() => SignUp(repository: sl()));
  sl.registerLazySingleton(() => GetProfile(repository: sl()));
  sl.registerLazySingleton(() => RefreshToken(repository: sl()));
  sl.registerLazySingleton(() => GetTrackUserLite(repository: sl()));
  sl.registerLazySingleton(() => CreateTrack(repository: sl()));
  sl.registerLazySingleton(() => BulkCreateTrackData(repository: sl()));
  sl.registerLazySingleton(() => BulkCreateTrackImage(repository: sl()));

  // repository
  sl.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(
      remoteDataSource: sl(),
      networkInfo: sl(),
    ),
  );
  sl.registerLazySingleton<UserRepository>(
    () => UserRepositoryImpl(
      remoteDataSource: sl(),
      networkInfo: sl(),
    ),
  );
  sl.registerLazySingleton<TrackRepository>(
    () => TrackRepositoryImpl(
      remoteDataSource: sl(),
      networkInfo: sl(),
    ),
  );
  sl.registerLazySingleton<ProjectRepository>(
    () => ProjectRepositoryImpl(
      remoteDataSource: sl(),
      networkInfo: sl(),
    ),
  );

  // data source
  sl.registerLazySingleton<AuthRemoteDataSource>(
    () => AuthRemoteDataSourceImpl(
      dio: sl(instanceName: dioLogging),
    ),
  );
  sl.registerLazySingleton<UserRemoteDataSource>(
    () => UserRemoteDataSourceImpl(
      dio: sl(instanceName: dioRefreshToken),
    ),
  );
  sl.registerLazySingleton<TrackRemoteDataSource>(
    () => TrackRemoteDataSourceImpl(
      dio: sl(instanceName: dioRefreshToken),
    ),
  );
  sl.registerLazySingleton<ProjectRemoteDataSource>(
    () => ProjectRemoteDataSourceImpl(
      dio: sl(instanceName: dioRefreshToken),
    ),
  );

  // core
  sl.registerLazySingleton<NetworkInfo>(() => NetworkInfoImpl(sl()));

  // external
  final sharedPreferences = await SharedPreferences.getInstance();
  final sharedPreferencesManager = SharedPreferencesManager.getInstance(sharedPreferences);
  sl.registerLazySingleton(() => sharedPreferencesManager);
  sl.registerLazySingleton(
    () {
      final dio = Dio();
      dio.interceptors.add(
        DioLoggingInterceptorRefreshToken(
          sharedPreferencesManager: sl(),
        ),
      );
      return dio;
    },
    instanceName: dioRefreshToken,
  );
  sl.registerLazySingleton(
    () {
      final dio = Dio();
      dio.interceptors.add(
        LogInterceptor(
          requestBody: true,
          responseBody: true,
          logPrint: (_) {},
        ),
      );
      return dio;
    },
    instanceName: dioLogging,
  );
  sl.registerLazySingleton(() => Connectivity());
  sl.registerLazySingleton(() => Helper(sharedPreferencesManager: sl()));
  sl.registerLazySingleton(() => NotificationHelper());

  // database
  final database = await $FloorAppDatabase.databaseBuilder('dipantau.db').build();
  /*final databasePath = await database.getDatabasePath();
  debugPrint('database path: $databasePath');*/
  sl.registerLazySingleton(() => database.trackDao);
}
