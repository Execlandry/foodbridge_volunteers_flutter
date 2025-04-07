import 'package:dio/dio.dart';
import 'package:foodbridge_volunteers_flutter/core/api/interceptors.dart';
import 'package:foodbridge_volunteers_flutter/core/config/app_url.dart';
import 'package:foodbridge_volunteers_flutter/core/utils/token_storage.dart';


class DioClient {
  static final DioClient _instance = DioClient._internal();
  late Dio dio;

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
    ));

    dio.interceptors.add(AppInterceptors());

    dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) async {
        final token = await TokenStorage.getToken();
        if (token != null) {
          options.headers['Authorization'] = 'Bearer $token';
        }
        return handler.next(options);
      },
      onError: (DioException error, handler) async {
          // Only handle 401 errors
          if (error.response?.statusCode == 401) {
            final refreshedToken = await TokenStorage.refreshToken(); 

            if (refreshedToken != null) {
              // Retry the failed request with new token
              final options = error.requestOptions;

              options.headers['Authorization'] = 'Bearer $refreshedToken';

              try {
                final cloneResponse = await dio.fetch(options);
                return handler.resolve(cloneResponse);
              } catch (e) {
                return handler.reject(e as DioException);
              }
            }
          }

          return handler.next(error);
        },
      ),
    );
  }

  /// Optional shortcut
  static Dio get instance => _instance.dio;
}
