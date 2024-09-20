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
