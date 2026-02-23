class LoginDTO {
  final String email;
  final String password;

  LoginDTO({
    required this.email,
    required this.password,
  });

  factory LoginDTO.fromJson(Map<String, dynamic> json) {
    return LoginDTO(
      email: json['email'],
      password: json['password'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'password': password,
    };
  }
}


class SessionDTO {
  final String token;
  final int userId;
  final String email;
  final String username;
  final String role;

  SessionDTO({
    required this.token,
    required this.userId,
    required this.email,
    required this.username,
    required this.role,
  });

  factory SessionDTO.fromJson(Map<String, dynamic> json) {
    return SessionDTO(
      token: json['token'] ?? '',
      userId: json['userId'] ?? 0,
      email: json['email'] ?? '',
      username: json['username'] ?? '',
      role: json['role'] ?? '',
    );
  }
}