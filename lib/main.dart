import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:libreria_app/pages/login_page.dart';
import 'package:libreria_app/pages/registrer_page.dart';
import 'package:libreria_app/pages/user_prestado_page.dart'; // Necesario para cambiar el color de la barra de estado

void main() {
  runApp(const MyApp());
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.red, // Color rojo para la barra de estado
      statusBarIconBrightness: Brightness.light, // Iconos de color claro
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark().copyWith(
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
      ),
      home: GestureDetector(
        onTap: () {
          // Oculta el teclado al tocar fuera de un campo de texto
          FocusScope.of(context).unfocus();
        },
        child: LoginScreen(), // O el widget que desees mostrar
      ),
    );
  }
}
