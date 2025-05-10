import 'package:dio/dio.dart';
import 'package:foodbridge_volunteers_flutter/core/api/api_endpoints.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:foodbridge_volunteers_flutter/core/config/app_url.dart';

class TokenStorage {
  static const _tokenKey = 'access_token';


  static Future<void> saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_tokenKey,token);
  }

  static Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_tokenKey);
  }

  
  static Future<void> clearToken() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_tokenKey);
  }

  static Future<String?> refreshToken() async {
    try {
      final baseUrl = await AppUrl.getBaseUrl();
      final dio = Dio(BaseOptions(baseUrl: baseUrl));

      final response = await dio.post(ApiEndpoints.authRefresh);

      if (response.statusCode == 200 && response.data['access_token'] != null) {
        final newToken = response.data['access_token'];
        await saveToken(newToken);
        return newToken;
      } else {
        await clearToken();
        return null;
      }
    } catch (e) {
      await clearToken();
      return null;
    }
  }
}
