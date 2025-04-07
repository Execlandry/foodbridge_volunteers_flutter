
// import 'package:foodbridge_volunteers_flutter/core/model/user_info.dart';

// class LoginRequest {
//   final String email;
//   final String password;

//   LoginRequest({
//     required this.email,
//     required this.password,
//   });

//   Map<String, dynamic> toJson() {
//     return {
//       'email': email,
//       'password': password,
//     };
//   }
// }

// class RegisterRequest {
//   final String name;
//   final String email;
//   final String mobno;
//   final String password;

//   RegisterRequest({
//     required this.name,
//     required this.email,
//     required this.mobno,
//     required this.password,
//   });

//   Map<String, dynamic> toJson() {
//     return {
//       'name': name,
//       'email': email,
//       'mobno': mobno,
//       'password': password,
//     };
//   }
// }

// class AuthResponse {
//   final String token;
//   final UserInfo? user;
//   final String message;
//   final bool success;

//   AuthResponse({
//     required this.token,
//     this.user,
//     required this.message,
//     required this.success,
//   });

//   factory AuthResponse.fromJson(Map<String, dynamic> json) {
//     return AuthResponse(
//       token: json['token'] as String,
//       user: json['user'] != null ? UserInfo.fromJson(json['user']) : null,
//       message: json['message'] as String,
//       success: json['success'] as bool,
//     );
//   }
// }