class UserLogin {
  final String role;
  final String name;
  final String phone;

  UserLogin({
    required this.role,
    required this.name,
    required this.phone,
  });

  factory UserLogin.fromJson(Map<String, dynamic> json) {
    return UserLogin(
      role: json['rol'] ?? 'unknown_role',
      name: json['name'] ?? 'unknown_name',
      phone: json['phone'] ?? 'unknown_phone',
    );
  }
}
