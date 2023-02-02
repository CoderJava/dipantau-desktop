import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:dipantau_desktop_client/config/flavor_config.dart';
import 'package:dipantau_desktop_client/feature/data/model/project/project_response.dart';
import 'package:flutter/services.dart';

abstract class GeneralRemoteDataSource {
  /// Panggil endpoint [host]/api/projects
  /// query parameter
  /// email - Nilai email user yang sedang login
  ///
  /// Throws [DioError] untuk semua error kode
  Future<ProjectResponse> getProject(String email);
}

class GeneralRemoteDataSourceImpl implements GeneralRemoteDataSource {
  final Dio dio;

  GeneralRemoteDataSourceImpl({
    required this.dio,
  });

  final baseUrl = FlavorConfig.instance.values.baseUrl;

  @override
  Future<ProjectResponse> getProject(String email) async {
    // TODO: Masih pakai fake json
    await Future.delayed(const Duration(seconds: 1));
    final jsonString = await rootBundle.loadString('assets/fake_json/get_project.json');
    final response = ProjectResponse.fromJson(json.decode(jsonString));
    return response;
    /*final path = '$baseUrl/api/projects';
    final response = await dio.get(
      path,
    );
    if (response.statusCode.toString().startsWith('2')) {
      return ProjectResponse.fromJson(response.data);
    } else {
      throw DioError(requestOptions: RequestOptions(path: path));
    }*/
  }
}
