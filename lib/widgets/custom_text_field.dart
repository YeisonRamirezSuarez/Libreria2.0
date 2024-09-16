import 'package:flutter/material.dart';
class CustomTextField extends StatefulWidget {
  final String hintText;
  final IconData icon;
  final bool obscureText;
  final IconData? suffixIcon;
  final TextInputType? keyboardType;
  final String? Function(String?)? validator;
  final TextEditingController controller;
  final int? maxLines;
  final int? maxLength;

  const CustomTextField({
    required this.hintText,
    required this.icon,
    required this.controller,
    this.obscureText = false,
    this.suffixIcon,
    this.keyboardType,
    this.validator,
    this.maxLines = 1,
    this.maxLength,
    super.key,
  });

  @override
  _CustomTextFieldState createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  final FocusNode _focusNode = FocusNode();
  bool _hasError = false;
  bool _obscureText = false;

  @override
  void initState() {
    super.initState();
    _obscureText = widget.obscureText;
    _focusNode.addListener(() {
      if (_focusNode.hasFocus) {
        setState(() {
          _hasError = false;
        });
      }
    });
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Container(
      width: screenWidth * 0.98,
      constraints: BoxConstraints(
        minHeight: screenHeight * 0.07,
        maxHeight: screenHeight * 0.12,
      ),
      child: TextFormField(
        focusNode: _focusNode,
        obscureText: _obscureText,
        controller: widget.controller,
        keyboardType: widget.keyboardType,
        cursorColor: Colors.redAccent,
        maxLines: widget.maxLines,
        maxLength: widget.maxLength,
        decoration: InputDecoration(
          labelText: widget.hintText,
          labelStyle: const TextStyle(
            color: Colors.white,
            fontSize: 18.0,
          ),
          prefixIcon: Icon(widget.icon,
              color: Theme.of(context).inputDecorationTheme.prefixIconColor),
          suffixIcon: widget.obscureText
              ? IconButton(
                  icon: Icon(
                    _obscureText ? Icons.visibility : Icons.visibility_off,
                    color: Theme.of(context).inputDecorationTheme.suffixIconColor,
                  ),
                  onPressed: () {
                    setState(() {
                      _obscureText = !_obscureText;
                    });
                  },
                )
              : widget.suffixIcon != null
                  ? Icon(widget.suffixIcon,
                      color: Theme.of(context).inputDecorationTheme.suffixIconColor)
                  : null,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20.0),
            borderSide: BorderSide(
              color: _hasError ? Colors.redAccent : Colors.white,
              width: 2.0,
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20.0),
            borderSide: BorderSide(
              color: _hasError ? Colors.redAccent : Colors.black,
              width: 2.0,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20.0),
            borderSide: const BorderSide(
              color: Colors.redAccent,
              width: 1.0,
            ),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20.0),
            borderSide: const BorderSide(
              color: Colors.redAccent,
              width: 3.0,
            ),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20.0),
            borderSide: const BorderSide(
              color: Colors.redAccent,
              width: 3.0,
            ),
          ),
          contentPadding: EdgeInsets.symmetric(
            vertical: screenHeight * 0.029,
            horizontal: screenWidth * 0.04,
          ),
          errorStyle: const TextStyle(
            color: Colors.redAccent,
            fontSize: 16.0,
          ),
          counterText: '', // Esto oculta el contador de caracteres
        ),
        style: const TextStyle(
            color: Colors.white,
            fontSize: 22.0),
        validator: (value) {
          final error = widget.validator?.call(value);
          setState(() {
            _hasError = error != null;
          });
          return error;
        },
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
