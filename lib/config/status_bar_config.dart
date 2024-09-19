import 'package:flutter/services.dart';
import 'package:flutter/material.dart';

void configureStatusBar() {
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.red, // Color rojo para la barra de estado
      statusBarIconBrightness: Brightness.light, // Iconos de color claro
    ),
  );
}
