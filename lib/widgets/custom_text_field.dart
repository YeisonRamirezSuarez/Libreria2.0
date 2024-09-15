import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final String hintText;
  final IconData icon;
  final bool obscureText;
  final IconData? suffixIcon;
  final TextInputType? keyboardType;
  final String? Function(String?)? validator;
  final TextEditingController controller;
  final int? maxLines; // Añadido para manejar múltiples líneas

  const CustomTextField({
    required this.hintText,
    required this.icon,
    required this.controller,
    this.obscureText = false,
    this.suffixIcon,
    this.keyboardType,
    this.validator,
    this.maxLines = 1, // Valor predeterminado para una sola línea
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    // Obtener tamaño de pantalla para hacer el diseño responsivo
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Container(
      // Aplicar restricciones de tamaño personalizadas
      width: screenWidth *
          0.98, // Hacer que el campo ocupe el 98% del ancho de la pantalla
      constraints: BoxConstraints(
        minHeight: screenHeight * 0.07, // Altura mínima
        maxHeight: screenHeight * 0.12, // Altura máxima
      ),
      child: TextFormField(
        obscureText: obscureText,
        controller: controller,
        keyboardType: keyboardType,
        cursorColor: Colors.redAccent, // Color del cursor
        maxLines: maxLines, // Establecer el número máximo de líneas

        decoration: InputDecoration(
          labelText: hintText, // Usar labelText en lugar de hintText
          labelStyle: const TextStyle(
            color: Colors.white, // Color del texto de la etiqueta
            fontSize: 18.0, // Tamaño del texto de la etiqueta
          ),
          prefixIcon: Icon(icon,
              color: Theme.of(context).inputDecorationTheme.prefixIconColor),
          suffixIcon: suffixIcon != null
              ? Icon(suffixIcon,
                  color: Theme.of(context).inputDecorationTheme.suffixIconColor)
              : null,
          // Personalizar el borde
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20.0), // Esquinas redondeadas
            borderSide: const BorderSide(
              color: Colors.white, // Color del borde
              width: 2.0, // Grosor del borde
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20.0),
            borderSide: const BorderSide(
              color: Colors.black, // Color del borde cuando está habilitado
              width: 2.0,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20.0),
            borderSide: const BorderSide(
              color: Colors.redAccent, // Color del borde cuando está enfocado
              width: 1.0,
            ),
          ),
          // Borde cuando hay un error
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20.0), // Esquinas redondeadas
            borderSide: const BorderSide(
              color: Colors.redAccent, // Color del borde cuando hay error
              width: 3.0, // Grosor del borde cuando hay error
            ),
          ),
          // Borde cuando está enfocado y hay error
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20.0), // Esquinas redondeadas
            borderSide: const BorderSide(
              color: Colors
                  .redAccent, // Color del borde cuando hay error y está enfocado
              width: 3.0, // Grosor del borde cuando hay error y está enfocado
            ),
          ),
          contentPadding: EdgeInsets.symmetric(
            vertical: screenHeight * 0.029, // Aumenta el padding vertical
            horizontal: screenWidth * 0.04, // Aumenta el padding horizontal
          ),
          // Estilo del texto del error
          errorStyle: const TextStyle(
            color: Colors.redAccent, // Cambia el color del texto de error
            fontSize: 16.0, // Cambia el tamaño del texto de error
          ),
        ),
        style: const TextStyle(
            color: Colors.white,
            fontSize: 22.0), // Aumentar el tamaño del texto
        validator: validator, // Función de validación
      ),
    );
  }
}

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
    // Obtener tamaño de pantalla para hacer el diseño responsivo
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
        SizedBox(
            height: screenWidth *
                0.02), // Ajuste del espacio entre el título y descripciones
        Text(
          description1,
          style: TextStyle(
            fontSize: screenWidth * 0.045, // Ajustar tamaño de texto
            color: const Color(0xFF636060),
          ),
          textAlign: TextAlign.center,
        ),
        Text(
          description2,
          style: TextStyle(
            fontSize: screenWidth * 0.045, // Ajustar tamaño de texto
            color: const Color(0xFF636060),
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
