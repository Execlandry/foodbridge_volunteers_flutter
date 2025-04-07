import 'package:foodbridge_volunteers_flutter/core/api/api_endpoints.dart';
import 'package:foodbridge_volunteers_flutter/core/api/dio_client.dart';
import 'package:foodbridge_volunteers_flutter/core/utils/token_storage.dart';

// class UserInfo {
//   final String? id;
//   final String? name;
//   final String? email;
//   final String? mobno;

//   UserInfo({
//     this.id,
//     this.name,
//     this.email,
//     this.mobno,
//   });

//   factory UserInfo.fromJson(Map<String, dynamic> json) {
//     return UserInfo(
//       id: json['id'] as String?,
//       name: json['name'] as String?,
//       email: json['email'] as String?,
//       mobno: json['mobno'] as String?,
//     );
//   }

//   Map<String, dynamic> toJson() {
//     return {
//       'id': id,
//       'name': name,
//       'email': email,
//       'mobno': mobno,
//     };
//   }
// }

Future<void> checkHealth() async {
  try {
    final dio = DioClient().dio;
    final response = await dio.get(ApiEndpoints.authHealth);
    print('User Service Health ✅: ${response.data}');
  } catch (e) {
    print('User Service Health ❌: $e');
  }
}

// Future<UserInfo?> getUserProfile() async {
//   try {
//     final dio = DioClient().dio;
//     final response = await dio.get(ApiEndpoints.authUserProfile);
//     if (response.statusCode == 200) {
//       final userData = response.data as Map<String, dynamic>;
//       final userInfo = UserInfo.fromJson(userData);
//       await TokenStorage.saveUserInfo(userData);
//       return userInfo;
//     }
//   } catch (e) {
//     print('Error fetching user profile: $e');
//   }

//   // Try getting from local storage if API call fails
//   final userJson = await TokenStorage.getUserInfo();
//   if (userJson != null) {
//     return UserInfo.fromJson(userJson);
//   }

//   return null;
// }
