import 'package:flutter/material.dart';
import 'package:libreria_app/models/data_usuario.dart';
import 'package:libreria_app/models/usuario_model.dart';
import 'package:libreria_app/widgets/custom_widgets.dart';


class BookHistoryCardPage extends StatelessWidget {
  final String imageUrl;
  final String bookTitle;
  final String bookAuthor;
  final String bookDescription;
  final List<Prestamo> usuarios;

  const BookHistoryCardPage({
    super.key,
    required this.imageUrl,
    required this.bookTitle,
    required this.bookAuthor,
    required this.bookDescription,
    required this.usuarios,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(5),
      child: Padding(
        padding: const EdgeInsets.all(5),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            _buildLibroDetails(),
            const SizedBox(height: 20),
            _buildDivider(),
            const SizedBox(height: 20),
            _buildHistoryLibros(),
          ],
        ),
      ),
    );
  }

  Widget _buildLibroDetails() {
    return LibroDetails(
      imageUrl: imageUrl,
      bookTitle: bookTitle,
      bookAuthor: bookAuthor,
      bookDescription: bookDescription,
    );
  }

  Widget _buildDivider() {
    return Container(
      height: 3.0,
      color: Colors.redAccent,
      width: double.infinity,
    );
  }

  Widget _buildHistoryLibros() {
    return HistoryLibros(usuarios: usuarios);
  }
}
