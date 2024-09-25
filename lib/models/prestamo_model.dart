class Prestamo {
  final String fechaPrestamo;
  final String correoUsuario;
  final String nombreUsuario;
  final String telefonoUsuario;
  final String? fechaRetorno;

  Prestamo({
    required this.fechaPrestamo,
    required this.correoUsuario,
    required this.nombreUsuario,
    required this.telefonoUsuario,
    this.fechaRetorno,
  });

  factory Prestamo.fromJson(Map<String, dynamic> json) {
    return Prestamo(
      fechaPrestamo: json['fecha_prestamo'] as String? ?? '',
      correoUsuario: json['correo_usuario'] as String? ?? '',
      nombreUsuario: json['nombre_usuario'] as String? ?? '',
      telefonoUsuario: json['telefono_usuario'] as String? ?? '',
      fechaRetorno: json['fecha_retorno'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'fecha_prestamo': fechaPrestamo,
      'correo_usuario': correoUsuario,
      'nombre_usuario': nombreUsuario,
      'telefono_usuario': telefonoUsuario,
      'fecha_retorno': fechaRetorno,
    };
  }
}
