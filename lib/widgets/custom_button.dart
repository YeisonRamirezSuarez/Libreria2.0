import 'package:flutter/material.dart';
import 'package:libreria_app/widgets/custom_widgets.dart';

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
      style: ButtonStyles.elevatedButtonStyle(
        backgroundColor: colorFondo,
        minWidth: double.infinity,
        height: dimensioneBoton,
      ),
      child: Text(text),
    );
  }
}
