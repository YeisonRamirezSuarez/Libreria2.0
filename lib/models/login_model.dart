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

class UsuarioPrestado {
  final String emailUser;
  final String nameUser;
  final String phoneUser;

  UsuarioPrestado({
    required this.emailUser,
    required this.nameUser,
    required this.phoneUser,
  });

  factory UsuarioPrestado.fromJson(Map<String, dynamic> json) {
    return UsuarioPrestado(
      emailUser: json['email_user'] as String,
      nameUser: json['name_user'] as String,
      phoneUser: json['phone_user'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'email_user': emailUser,
      'name_user': nameUser,
      'phone_user': phoneUser,
    };
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
