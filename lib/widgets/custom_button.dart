import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final Color colorFondo;
  final double dimensioneBoton;

  const CustomButton({
    required this.text,
    this.onPressed,
    super.key,
    this.colorFondo = const Color(0xFF333333),
    this.dimensioneBoton = 80.0,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: colorFondo, // Color personalizado para el botón
        foregroundColor: Colors.white, // Color del texto del botón
        minimumSize: Size(double.infinity, dimensioneBoton),
        textStyle: const TextStyle(fontSize: 20.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.0),
        ),
      ),
      child: Text(text),
    );
  }
}