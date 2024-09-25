import 'package:flutter/material.dart';
import 'package:LibreriaApp/widgets/custom_widgets.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final Color colorFondo;
  final double dimensioneBoton;
  final bool enabled; // Nueva propiedad para controlar el estado habilitado

  const CustomButton({
    required this.text,
    this.onPressed,
    this.enabled = true, // Valor predeterminado
    super.key,
    this.colorFondo = const Color(0xFF333333),
    this.dimensioneBoton = 80.0,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: enabled ? onPressed : null, // Habilitar o deshabilitar
      style: ButtonStyles.elevatedButtonStyle(
        backgroundColor: enabled
            ? colorFondo
            : colorFondo
                .withOpacity(0.5), // Cambiar el color si está deshabilitado
        minWidth: double.infinity,
        height: dimensioneBoton,
      ),
      child: Text(text),
    );
  }
}
