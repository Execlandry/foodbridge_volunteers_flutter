class UserProfileDetails {
  final String? id;
  final String? email;
  final String? lastName;
  final String? firstName;
  final String? name;
  final String? mobno;
  final String? pictureUrl;
  final String? passwordReset;
  final String? createdAt;
  final String? updatedAt;

  UserProfileDetails({
    required this.id,
    required this.email,
    required this.lastName,
    required this.firstName,
    required this.name,
    required this.mobno,
    required this.pictureUrl,
    required this.passwordReset,
    required this.createdAt,
    required this.updatedAt,
  });

  factory UserProfileDetails.fromJson(Map<String, dynamic> json) {
    return UserProfileDetails(
      id: json['id'] as String?,
      email: json['email'] as String?,
      lastName: json['last_name'] as String?,
      firstName: json['first_name'] as String?,
      name: json['name'] as String?,
      mobno: json['mobno'] as String?,
      pictureUrl: json['picture_url'] as String?,
      passwordReset: json['passwordReset'] as String?,
      createdAt: json['created_at'] as String?,
      updatedAt: json['updated_at'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'last_name': lastName,
      'first_name': firstName,
      'name': name,
      'mobno': mobno,
      'picture_url': pictureUrl,
      'passwordReset': passwordReset,
      'created_at': createdAt,
      'updated_at': updatedAt,
    };
  }

  UserProfileDetails copyWith({
    String? id,
    String? email,
    String? lastName,
    String? firstName,
    String? name,
    String? mobno,
    String? pictureUrl,
    String? passwordReset,
    String? createdAt,
    String? updatedAt,
  }) {
    return UserProfileDetails(
      id: id ?? this.id,
      email: email ?? this.email,
      lastName: lastName ?? this.lastName,
      firstName: firstName ?? this.firstName,
      name: name ?? this.name,
      mobno: mobno ?? this.mobno,
      pictureUrl: pictureUrl ?? this.pictureUrl,
      passwordReset: passwordReset ?? this.passwordReset,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}