import 'package:dio/dio.dart';

import '../config/app_config.dart';

/// Thin wrapper around Dio providing a configured client with auth header
/// injection and basic logging interceptors.
class DioClient {
  DioClient(this._dio) {
    _dio
      ..options.baseUrl = AppConfig.baseUrl
      ..options.connectTimeout = AppConfig.connectTimeout
      ..options.receiveTimeout = AppConfig.receiveTimeout
      ..options.headers = {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      };

    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          final token = _authToken;
          if (token != null) {
            options.headers['Authorization'] = 'Bearer $token';
          }
          handler.next(options);
        },
      ),
    );
  }

  final Dio _dio;
  String? _authToken;

  Dio get dio => _dio;

  void setAuthToken(String? token) => _authToken = token;

  Future<Response<T>> get<T>(
    String path, {
    Map<String, dynamic>? queryParameters,
  }) {
    return _dio.get<T>(path, queryParameters: queryParameters);
  }

  Future<Response<T>> post<T>(String path, {Object? data}) {
    return _dio.post<T>(path, data: data);
  }

  Future<Response<T>> put<T>(String path, {Object? data}) {
    return _dio.put<T>(path, data: data);
  }

  Future<Response<T>> delete<T>(String path, {Object? data}) {
    return _dio.delete<T>(path, data: data);
  }
}
