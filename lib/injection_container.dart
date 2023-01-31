import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
import 'package:dipantau_desktop_client/core/network/network_info.dart';
import 'package:dipantau_desktop_client/core/util/helper.dart';
import 'package:dipantau_desktop_client/core/util/shared_preferences_manager.dart';
import 'package:dipantau_desktop_client/feature/data/datasource/general/general_remote_data_source.dart';
import 'package:dipantau_desktop_client/feature/data/repository/general/general_repository_impl.dart';
import 'package:dipantau_desktop_client/feature/domain/repository/general/general_repository.dart';
import 'package:dipantau_desktop_client/feature/domain/usecase/get_project/get_project.dart';
import 'package:dipantau_desktop_client/feature/presentation/bloc/home/home_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

final sl = GetIt.instance;

Future<void> init() async {
  // bloc
  sl.registerFactory(
    () => HomeBloc(
      sharedPreferencesManager: sl(),
      getProject: sl(),
    ),
  );

  // use case
  sl.registerLazySingleton(() => GetProject(generalRepository: sl()));

  // repository
  sl.registerLazySingleton<GeneralRepository>(
    () => GeneralRepositoryImpl(
      generalRemoteDataSource: sl(),
      networkInfo: sl(),
    ),
  );

  // data source
  sl.registerLazySingleton<GeneralRemoteDataSource>(() => GeneralRemoteDataSourceImpl(dio: sl()));

  // core
  sl.registerLazySingleton<NetworkInfo>(() => NetworkInfoImpl(sl()));

  // external
  final sharedPreferences = await SharedPreferences.getInstance();
  final sharedPreferencesManager = SharedPreferencesManager.getInstance(sharedPreferences);
  sl.registerLazySingleton(() => sharedPreferencesManager);
  sl.registerLazySingleton(() => Dio());
  sl.registerLazySingleton(() => Connectivity());
  sl.registerLazySingleton(() => Helper());
}
