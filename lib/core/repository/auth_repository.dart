import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:foodbridge_volunteers_flutter/core/api/api_endpoints.dart';
import 'package:foodbridge_volunteers_flutter/core/api/dio_client.dart';
import 'package:foodbridge_volunteers_flutter/core/utils/shared_storage.dart';

class AuthRepository {
  final dio = DioClient().dio;

  Future<void> registerUser({
    required String firstName,
    required String lastName,
    required String email,
    required String password,
    required String mobno,
  }) async {
    try {
      final response = await dio.post(
        ApiEndpoints.authRegisterDeliveryUser,
        data: {
          "first_name": firstName,
          "last_name": lastName,
          "email": email,
          "password": password,
          "mobno": mobno,
        },
      );

      if (response.statusCode == 201) {
        debugPrint("User registered successfully");
      } else {
        debugPrint("Unexpected status code: ${response.statusCode}");
        throw Exception("Registration failed: ${response.statusCode}");
      }
    } on DioException catch (e) {
      debugPrint("DioError: ${e.response?.data ?? e.message}");
      throw Exception(
          "Registration failed: ${e.response?.data?['message'] ?? e.message}");
    } catch (e) {
      debugPrint("Unexpected error: $e");
      throw Exception("Registration failed: $e");
    }
  }

  Future<String> loginUser({
    required String email,
    required String password,
  }) async {
    try {
      final response = await dio.post(
        ApiEndpoints.authLogin,
        data: {"email": email, "password": password},
      );

      if (response.statusCode == 200) {
        final responseData = response.data as Map<String, dynamic>;
        final accessToken = responseData['access_token'] as String?;

        if (accessToken == null) {
          throw Exception("Access token missing in response");
        }

        await SharedStorage.saveToken(accessToken);
        debugPrint("User login successful");
        return accessToken;
      } else {
        debugPrint("Unexpected status code: ${response.statusCode}");
        throw Exception("Login failed: ${response.statusCode}");
      }
    } on DioException catch (e) {
      debugPrint("DioError: ${e.response?.data ?? e.message}");
      throw Exception(
          "Login failed: ${e.response?.data?['message'] ?? e.message}");
    } catch (e) {
      debugPrint("Unexpected error: $e");
      throw Exception("Login failed: $e");
    }
  }

  Future<String> stripeRefreshUrl() async {
    try {
      final response = await dio.post(
        ApiEndpoints.stripeOnboardingUrl,
      );

      if (response.statusCode == 201) {
        final onboardingUrl = response.data['onboarding_url'] as String;
        return onboardingUrl;
      } else {
        debugPrint("Unexpected status code: ${response.statusCode}");
        throw Exception(
            "Failed to generate stripe onboarding url: ${response.statusCode}");
      }
    } on DioException catch (e) {
      debugPrint("DioError: ${e.response?.data ?? e.message}");
      throw Exception(
          "Failed to generate stripe onboarding url: ${e.response?.data?['message'] ?? e.message}");
    } catch (e) {
      debugPrint("Unexpected error: $e");
      throw Exception("Failed to generate stripe onboarding url: $e");
    }
  }
}
