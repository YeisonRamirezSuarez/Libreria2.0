import 'package:flutter/material.dart';

class BookDetail extends StatelessWidget {
  final String title;
  final String author;
  final String date;
  final double titleFontSize;
  final double detailFontSize;

  const BookDetail({
    required this.title,
    required this.author,
    required this.date,
    required this.titleFontSize,
    required this.detailFontSize,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
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
            overflow: TextOverflow.ellipsis,
          ),
          SizedBox(height: titleFontSize * 0.3),
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
            overflow: TextOverflow.ellipsis,
          ),
          SizedBox(height: detailFontSize * 0.3),
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
