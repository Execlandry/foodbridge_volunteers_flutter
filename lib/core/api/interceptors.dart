import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:foodbridge_volunteers_flutter/core/utils/shared_storage.dart';

class AppInterceptors extends Interceptor {
  AppInterceptors();

  @override
  Future<void> onRequest(
      RequestOptions options, RequestInterceptorHandler handler) async {
    final token = await SharedStorage.getToken();
    if (token != null) {
      options.headers['Authorization'] = 'Bearer $token';
    }
    debugPrint('➡️ [${options.method}] ${options.baseUrl}${options.path}');
    super.onRequest(options, handler);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    debugPrint('✅ [${response.statusCode}] ${response.data}');
    super.onResponse(response, handler);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    debugPrint('❌ [Error] ${err.response?.statusCode} => ${err.message}');
    super.onError(err, handler);
  }
}
