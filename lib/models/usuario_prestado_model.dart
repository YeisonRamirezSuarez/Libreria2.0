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
