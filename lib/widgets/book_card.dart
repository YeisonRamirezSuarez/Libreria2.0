import 'package:flutter/material.dart';
import 'package:LibreriaApp/widgets/custom_widgets.dart';

class BookCard extends StatelessWidget {
  final String imageUrl;
  final String title;
  final String author;
  final String date;

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
        double imageWidth = constraints.maxWidth * 0.3;
        double imageHeight = imageWidth * 1.2;
        double padding = constraints.maxWidth * 0.05;

        return Container(
          padding: EdgeInsets.all(padding),
          margin:
              EdgeInsets.symmetric(horizontal: padding, vertical: padding / 2),
          decoration: BoxDecoration(
            color: Colors.grey[300],
            borderRadius: BorderRadius.circular(15),
          ),
          child: Row(
            children: [
              ImageWidget(
                imageUrl: imageUrl,
                width: imageWidth,
                height: imageHeight,
              ),
              SizedBox(width: padding),
              BookDetail(
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
