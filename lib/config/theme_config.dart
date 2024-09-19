import 'package:flutter/material.dart';

ThemeData appTheme() {
  return ThemeData.dark().copyWith(
    scaffoldBackgroundColor: Colors.black,
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: Colors.grey[800],
      hintStyle: const TextStyle(color: Color(0xFF787676)),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(20.0),
        borderSide: BorderSide.none,
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 20.0),
      prefixIconColor: Colors.white,
      suffixIconColor: Colors.white,
    ),
  );
}
