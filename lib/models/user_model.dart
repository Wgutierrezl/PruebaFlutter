import 'role_model.dart';

class User {
  final int id;
  final String username;
  final String email;
  final Role role;
  final bool isActive;
  final DateTime createdAt;

  User({
    required this.id,
    required this.username,
    required this.email,
    required this.role,
    required this.isActive,
    required this.createdAt,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      username: json['username'],
      email: json['email'],
      role: Role.fromJson(json['role']),
      isActive: json['isActive'],
      createdAt: DateTime.parse(json['createdAt']),
    );
  }
}

class UserCreate {
  final String username;
  final int roleId;
  final String email;
  final String password;

  UserCreate({
    required this.username,
    required this.roleId,
    required this.email,
    required this.password,
  });

  factory UserCreate.fromJson(Map<String, dynamic> json) {
    return UserCreate(
      username: json['username'],
      roleId: json['roleId'],
      email: json['email'],
      password: json['password'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'username': username,
      'roleId': roleId,
      'email': email,
      'password': password,
    };
  }
}