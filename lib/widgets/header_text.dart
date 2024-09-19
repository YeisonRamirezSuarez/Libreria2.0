import 'package:flutter/material.dart';

class HeaderText extends StatelessWidget {
  final String title;
  final String description1;
  final String description2;

  const HeaderText({
    required this.title,
    required this.description1,
    required this.description2,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Column(
      children: <Widget>[
        Text(
          title,
          style: const TextStyle(
            fontSize: 35.0,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
          textAlign: TextAlign.center,
        ),
        SizedBox(height: screenWidth * 0.02),
        Text(
          description1,
          style: TextStyle(
            fontSize: screenWidth * 0.045,
            color: const Color(0xFF636060),
          ),
          textAlign: TextAlign.center,
        ),
        Text(
          description2,
          style: TextStyle(
            fontSize: screenWidth * 0.045,
            color: const Color(0xFF636060),
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
