import 'package:dio/dio.dart';
import 'package:foodbridge_volunteers_flutter/core/api/interceptors.dart';
import 'package:foodbridge_volunteers_flutter/core/config/app_url.dart';

class DioClient {
  static final DioClient _instance = DioClient._internal();
  
  late final Dio dio;
  bool _isInitialized = false;

  factory DioClient() {
    return _instance;
  }

  DioClient._internal() {
    _init();
  }

  Future<void> _init() async {
    final baseUrl = await AppUrl.getBaseUrl();

    dio = Dio(BaseOptions(
      baseUrl: baseUrl,
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10),
      headers: {
        'Accept': 'application/json',
      },
    ));

    dio.interceptors.add(AppInterceptors()); 
    _isInitialized = true;
  }

  Future<Dio> getDio() async {
    if (!_isInitialized) {
      await _init();
    }
    return dio;
  }
}