import 'package:LibreriaApp/models/prestamo_model.dart';

class Usuario {
  final String? id;
  final String idBook;
  final String title;
  final String author;
  final String bookUrl;
  final String imageUrl;
  final String description;
  final List<Prestamo> prestamos;

  Usuario({
    this.id,
    required this.idBook,
    required this.title,
    required this.author,
    required this.bookUrl,
    required this.imageUrl,
    required this.description,
    this.prestamos = const [],
  });

  factory Usuario.fromJson(Map<String, dynamic> json) {

    var prestamosFromJson = json['prestamos'] as List? ?? [];
    List<Prestamo> prestamosList = prestamosFromJson
        .map((prestamoJson) => Prestamo.fromJson(prestamoJson))
        .toList();

    return Usuario(
      id: json['id'] as String? ?? '',
      idBook: json['id_book'] as String? ?? '',
      title: json['title'] as String? ?? '',
      author: json['author'] as String? ?? '',
      bookUrl: json['book_url'] as String? ?? '',
      imageUrl: json['image_url'] as String? ?? '',
      description: json['description'] as String? ?? '',
      prestamos: prestamosList,
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
      'prestamos': prestamos.map((prestamo) => prestamo.toJson()).toList(),
    };
    if (id != null) {
      data['id'] = id;
    }
    return data;
  }
}
