import 'package:flutter/material.dart';
class CustomTextField extends StatelessWidget {
  final String hintText;
  final IconData icon;
  final bool obscureText;
  final IconData? suffixIcon;
  final TextInputType? keyboardType;

  const CustomTextField({
    required this.hintText,
    required this.icon,
    this.obscureText = false,
    this.suffixIcon,
    this.keyboardType,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 70.0, // Adjust the height to make the TextField taller
      child: TextField(
        obscureText: obscureText,
        keyboardType: keyboardType,
        decoration: InputDecoration(
          hintText: hintText,
          prefixIcon: Icon(icon, color: Theme.of(context).inputDecorationTheme.prefixIconColor),
          suffixIcon: suffixIcon != null
              ? Icon(suffixIcon, color: Theme.of(context).inputDecorationTheme.suffixIconColor)
              : null,
          // Customize the border
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20.0), // Rounded corners
            borderSide: BorderSide(
              color: Colors.white, // Border color
              width: 1.0, // Increased border width
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20.0), // Rounded corners
            borderSide: BorderSide(
              color: Colors.black, // Border color when the field is enabled
              width: 1.0, // Increased border width
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20.0), // Rounded corners
            borderSide: BorderSide(
              color: Colors.white.withOpacity(0.4), // Border color when the field is focused
              width: 1.0, // Increased border width
            ),
          ),
          contentPadding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 15.0), // Adjust padding for height
        ),
        style: const TextStyle(color: Colors.white, fontSize: 20.0), // Adjust text size if needed
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
        const SizedBox(height: 5.0),
        Text(
          description1,
          style: const TextStyle(
            fontSize: 15.0,
            color: Color(0xFF636060),
          ),
          textAlign: TextAlign.center,
        ),
        Text(
          description2,
          style: const TextStyle(
            fontSize: 15.0,
            color: Color(0xFF636060),
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}

