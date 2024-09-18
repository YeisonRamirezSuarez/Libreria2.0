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
  final int? minLines;
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
    this.minLines,
    super.key,
  });

  @override
  _CustomTextFieldState createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  late bool _obscureText;
  String? _errorText;

  @override
  void initState() {
    super.initState();
    _obscureText = widget.obscureText;
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
      child: Stack(
        children: [
          TextFormField(
            obscureText: _obscureText,
            controller: widget.controller,
            keyboardType: widget.keyboardType,
            cursorColor: Colors.redAccent,
            maxLines: widget.maxLines,
            minLines: widget.minLines,
            maxLength: widget.maxLength,
            decoration: InputDecoration(
              labelText: widget.hintText,
              labelStyle: const TextStyle(
                color: Colors.white,
                fontSize: 18.0,
              ),
              prefixIcon: Icon(widget.icon, color: Theme.of(context).inputDecorationTheme.prefixIconColor),
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
                      ? Icon(widget.suffixIcon, color: Theme.of(context).inputDecorationTheme.suffixIconColor)
                      : null,
              border: InputBorder.none,
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(
                  color: _errorText != null ? Colors.redAccent : Colors.white,
                  width: 2.0,
                ),
              ),
              focusedBorder: UnderlineInputBorder(
                borderSide: const BorderSide(
                  color: Colors.redAccent,
                  width: 2.0,
                ),
              ),
              errorBorder: UnderlineInputBorder(
                borderSide: const BorderSide(
                  color: Colors.redAccent,
                  width: 2.0,
                ),
              ),
              focusedErrorBorder: UnderlineInputBorder(
                borderSide: const BorderSide(
                  color: Colors.redAccent,
                  width: 2.0,
                ),
              ),
              contentPadding: EdgeInsets.symmetric(
                vertical: screenHeight * 0.02,
                horizontal: screenWidth * 0.04,
              ),
              errorStyle: const TextStyle(
                color: Colors.redAccent,
                fontSize: 14.0,
              ),
              counterText: '', // Hide the character counter
            ),
            style: const TextStyle(color: Colors.white, fontSize: 16.0),
            onChanged: (value) {
              final error = widget.validator?.call(value);
              setState(() {
                _errorText = error;
              });
            },
            validator: (value) {
              final error = widget.validator?.call(value);
              setState(() {
                _errorText = error;
              });
              return null; // Return null here to let custom error handling manage the display
            },
          ),
          if (_errorText != null) // Show error message inside the TextFormField
            Positioned(
              right: 10.0,
              top: 0.0,
              child: Text(
                _errorText!,
                style: const TextStyle(
                  color: Colors.redAccent,
                  fontSize: 12.0,
                ),
              ),
            ),
            
        ],
        
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
        SizedBox(height: screenWidth * 0.02), // Ajuste del espacio entre el título y descripciones
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
