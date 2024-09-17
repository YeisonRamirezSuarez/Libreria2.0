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

class User {
  final String name;
  final String email;
  final String phone;
  final String address;
  final String password;

  User({
    required this.name,
    required this.email,
    required this.phone,
    required this.address,
    required this.password,
  });

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'email': email,
      'phone': phone,
      'address': address,
      'password': password,
      'rol': 'usuario',
    };
  }
}
