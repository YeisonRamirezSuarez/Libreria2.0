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
    return LayoutBuilder(
      builder: (context, constraints) {
        // Ajuste dinámico basado en el ancho del contenedor
        double imageWidth = constraints.maxWidth * 0.3;
        double imageHeight = imageWidth * 1.2;
        double padding = constraints.maxWidth * 0.05;

        return Container(
          padding: EdgeInsets.all(padding),
          margin: EdgeInsets.symmetric(horizontal: padding, vertical: padding / 2),
          decoration: BoxDecoration(
            color: Colors.grey[300],
            borderRadius: BorderRadius.circular(15),
          ),
          child: Row(
            children: [
              // Imagen del libro
              ImageWidget(
                imageUrl: imageUrl,
                width: imageWidth,
                height: imageHeight,
              ),
              SizedBox(width: padding),
              // Información del libro
              _BookDetail(
                title: title,
                author: author,
                date: date,
                titleFontSize: constraints.maxWidth * 0.05,
                detailFontSize: constraints.maxWidth * 0.04,
              ),
            ],
          ),
        );
      },
    );
  }
}

class _BookDetail extends StatelessWidget {
  const _BookDetail({
    required this.title,
    required this.author,
    required this.date,
    required this.titleFontSize,
    required this.detailFontSize,
  });

  final String title;
  final String author;
  final String date;
  final double titleFontSize;
  final double detailFontSize;

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
            style: TextStyle(
              fontSize: titleFontSize,
              fontWeight: FontWeight.w600,
              color: Colors.black,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis, // Truncar con puntos suspensivos si es necesario
          ),
          SizedBox(height: titleFontSize * 0.3),
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
            style: TextStyle(
              fontSize: detailFontSize,
              color: Colors.black,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis, // Truncar con puntos suspensivos si es necesario
          ),
          SizedBox(height: detailFontSize * 0.3),
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
            style: TextStyle(
              fontSize: detailFontSize,
              color: Colors.black,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}
