import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:dipantau_desktop_client/config/flavor_config.dart';
import 'package:dipantau_desktop_client/feature/data/model/general/general_response.dart';
import 'package:dipantau_desktop_client/feature/data/model/project/project_response_bak.dart';
import 'package:dipantau_desktop_client/feature/data/model/tracking_data/tracking_data_body.dart';
import 'package:flutter/services.dart';

abstract class GeneralRemoteDataSource {
  /// Panggil endpoint [host]/api/projects
  /// query parameter
  /// email - Nilai email user yang sedang login
  ///
  /// Throws [DioError] untuk semua error kode
  late String pathGetProject;

  Future<ProjectResponseBak> getProject(String email);

  /// Panggil endpoint [host]/api/tracking
  ///
  /// Throws [DioError] untuk semua error kode
  late String pathCreateTrackingData;

  Future<GeneralResponse> createTrackingData(TrackingDataBody body);
}

class GeneralRemoteDataSourceImpl implements GeneralRemoteDataSource {
  final Dio dio;

  GeneralRemoteDataSourceImpl({
    required this.dio,
  });

  final baseUrl = FlavorConfig.instance.values.baseUrl;

  @override
  String pathGetProject = '';

  @override
  Future<ProjectResponseBak> getProject(String email) async {
    // TODO: Masih pakai fake json
    await Future.delayed(const Duration(seconds: 1));
    final jsonString = await rootBundle.loadString('assets/fake_json/get_project.json');
    final response = ProjectResponseBak.fromJson(json.decode(jsonString));
    return response;
    /*pathGetProject = '$baseUrl/api/projects';
    final response = await dio.get(
      pathGetProject,
    );
    if (response.statusCode.toString().startsWith('2')) {
      return ProjectResponse.fromJson(response.data);
    } else {
      throw DioError(requestOptions: RequestOptions(path: pathGetProject));
    }*/
  }

  @override
  String pathCreateTrackingData = '';

  @override
  Future<GeneralResponse> createTrackingData(TrackingDataBody body) async {
    pathCreateTrackingData = '$baseUrl/api/tracking';
    final response = await dio.post(
      pathCreateTrackingData,
      data: body.toJson(),
    );
    if (response.statusCode.toString().startsWith('2')) {
      return GeneralResponse.fromJson(response.data);
    } else {
      throw DioError(requestOptions: RequestOptions(path: pathCreateTrackingData));
    }
  }

}
