import 'package:flutter/material.dart';
import 'package:libreria_app/widgets/custom_widgets.dart';

class BookCard extends StatelessWidget {
  final String imageUrl; // URL o ruta de la imagen
  final String title; // Nombre del libro
  final String author; // Autor del libro
  final String date; // Fecha del préstamo

  const BookCard({
    super.key,
    required this.imageUrl,
    required this.title,
    required this.author,
    required this.date,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16), // Ajusta el padding según sea necesario
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
      decoration: BoxDecoration(
        color: Colors.grey[300],
        borderRadius: BorderRadius.circular(15),
      ),
      child: Row(
        children: [
          // Imagen del libro
          ImageWidget(
            imageUrl: imageUrl,
            width: 100,
            height: 150,
          ),
          const SizedBox(width: 20),
          // Información del libro
          _BookDetail(
            title: title,
            author: author,
            date: date,
          ),
        ],
      ),
    );
  }
}

class _BookDetail extends StatelessWidget {
  const _BookDetail({
    required this.title,
    required this.author,
    required this.date,
  });

  final String title;
  final String author;
  final String date;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Título del libro
          const Text(
            'Nombre:',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          Text(
            title,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.black,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis, // Truncar con puntos suspensivos si es necesario
          ),
          const SizedBox(height: 10),
          // Autor del libro
          const Text(
            'Autor:',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          Text(
            author,
            style: const TextStyle(
              fontSize: 16,
              color: Colors.black,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis, // Truncar con puntos suspensivos si es necesario
          ),
          const SizedBox(height: 10),
          // Fecha de préstamo
          const Text(
            'Fecha Préstamo:',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          Text(
            date,
            style: const TextStyle(
              fontSize: 16,
              color: Colors.black,
            ),
          ),
        ],
      ),
    );
  }
}
