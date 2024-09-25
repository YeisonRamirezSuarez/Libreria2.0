class DataUsuario {
  final String nombre;
  final String telefono;
  final String email;

  DataUsuario({
    required this.nombre,
    required this.telefono,
    required this.email,
  });

  factory DataUsuario.fromJson(Map<String, dynamic> json) {
    return DataUsuario(
      nombre: json['nombre'] as String,
      telefono: json['telefono'] as String,
      email: json['email'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'nombre': nombre,
      'telefono': telefono,
      'email': email,
    };
  }
}
