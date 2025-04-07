// user_info.dart
class UserInfo {
  final String id;
  final String name;
  final String email;
  
  UserInfo({required this.id, required this.name, required this.email});
  
  factory UserInfo.fromMap(Map<String, dynamic> map) {
    return UserInfo(
      id: map['_id'] ?? map['id'] ?? '',
      name: map['name'] ?? '',
      email: map['email'] ?? '',
    );
  }
}

