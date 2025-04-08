import 'package:dio/dio.dart';
import 'package:foodbridge_volunteers_flutter/core/api/api_endpoints.dart';
import 'package:foodbridge_volunteers_flutter/core/api/dio_client.dart';
import 'package:foodbridge_volunteers_flutter/core/model/user_profile_model.dart';

class UserRepository {
  Future<UserProfileDetails> fetchUserProfileDetails() async {
    try {
      final dio = await DioClient().getDio();
        final response = await dio.get(ApiEndpoints.authUserProfile);
      

      if (response.statusCode == 200) {
        return UserProfileDetails.fromJson(response.data);
      } else {
        throw Exception('Failed to load profile: ${response.statusCode}');
      }
    } on DioException catch (e) {
      throw Exception('Dio error: ${e.message}');
    } catch (e) {
      throw Exception('Unexpected error: $e');
    }
  }
}
