import 'package:flutter/material.dart';

class ButtonStyles {
  static ButtonStyle elevatedButtonStyle({
    required Color backgroundColor,
    required double minWidth,
    required double height,
  }) {
    return ElevatedButton.styleFrom(
      backgroundColor: backgroundColor,
      foregroundColor: Colors.white,
      minimumSize: Size(minWidth, height),
      textStyle: const TextStyle(fontSize: 20.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.0),
      ),
    );
  }
}
