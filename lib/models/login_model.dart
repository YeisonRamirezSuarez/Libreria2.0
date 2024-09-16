class UserModel {
  final String email;
  final String role;

  UserModel({required this.email, required this.role});

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      email: json['email'] ?? 'unknown_email',  // Proporciona un valor por defecto si es null
      role: json['rol'] ?? 'unknown_role',      // Proporciona un valor por defecto si es null
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
