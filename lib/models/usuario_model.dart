class Usuario {
  final String? id; // Hacer id opcional
  final String idBook;
  final String title;
  final String author;
  final String bookUrl;
  final String imageUrl;
  final String description;
  final String date;
  final String emailUser;
  final String nameUser;
  final String phoneUser;
  final List<Prestamo> prestamos; // Agregar una lista de préstamos

  Usuario({
    this.id,
    required this.idBook,
    required this.title,
    required this.author,
    required this.bookUrl,
    required this.imageUrl,
    required this.description,
    required this.date,
    required this.emailUser,
    required this.nameUser,
    required this.phoneUser,
    this.prestamos = const [], // Inicializar como lista vacía
  });

  factory Usuario.fromJson(Map<String, dynamic> json) {
    var prestamosFromJson = json['prestamos'] as List? ?? [];
    List<Prestamo> prestamosList = prestamosFromJson
        .map((prestamoJson) => Prestamo.fromJson(prestamoJson))
        .toList();

    return Usuario(
      id: json['id'] as String?,
      idBook: json['id_book'] as String? ?? '',
      title: json['title'] as String? ?? '',
      author: json['author'] as String? ?? '',
      bookUrl: json['book_url'] as String? ?? '',
      imageUrl: json['image_url'] as String? ?? '',
      description: json['description'] as String? ?? '',
      date: json['date'] as String? ?? '',
      emailUser: json['email_user'] as String? ?? '',
      nameUser: json['name_user'] as String? ?? '',
      phoneUser: json['phone_user'] as String? ?? '',
      prestamos: prestamosList, // Asignar la lista de préstamos
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {
      'id_book': idBook,
      'title': title,
      'author': author,
      'book_url': bookUrl,
      'image_url': imageUrl,
      'description': description,
      'date': date,
      'email_user': emailUser,
      'name_user': nameUser,
      'phone_user': phoneUser,
      'prestamos': prestamos
          .map((prestamo) => prestamo.toJson())
          .toList(), // Convertir lista de préstamos a JSON
    };
    if (id != null) {
      data['id'] = id;
    }
    return data;
  }
}

class Prestamo {
  final String fechaPrestamo;
  final String correoUsuario;
  final String nombreUsuario;
  final String telefonoUsuario;
  final String fechaRetorno;

  Prestamo({
    required this.fechaPrestamo,
    required this.correoUsuario,
    required this.nombreUsuario,
    required this.telefonoUsuario,
    required this.fechaRetorno,
  });

  factory Prestamo.fromJson(Map<String, dynamic> json) {
    return Prestamo(
      fechaPrestamo: json['Fecha_Prestamo'] as String? ?? '',
      correoUsuario: json['Correo_Usuario'] as String? ?? '',
      nombreUsuario: json['Nombre_Usuario'] as String? ?? '',
      telefonoUsuario: json['Telefono_Usuario'] as String? ?? '',
      fechaRetorno: json['Fecha_Retorno'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'Fecha_Prestamo': fechaPrestamo,
      'Correo_Usuario': correoUsuario,
      'Nombre_Usuario': nombreUsuario,
      'Telefono_Usuario': telefonoUsuario,
      'Fecha_Retorno': fechaRetorno,
    };
  }
}
