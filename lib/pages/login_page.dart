import 'package:flutter/material.dart';
import 'package:libreria_app/pages/registrer_page.dart';
import 'package:libreria_app/pages/user_libros_disponibles_page.dart';
import 'package:libreria_app/pages/user_prestado_page.dart';
import 'package:libreria_app/widgets/custom_widgets.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  String? emailValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Este campo es obligatorio';
    }
    if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
      return 'Por favor ingresa un correo válido';
    }
    return null;
  }

  String? passwordValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Este campo es obligatorio';
    }
    if (value.length < 6) {
      return 'La contraseña debe tener al menos 6 caracteres';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Padding(
            padding: EdgeInsets.all(screenWidth * 0.05),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  HeaderText(
                    title: "Iniciar Sesión",
                    description1: "ven a leer y deja que tu imaginación",
                    description2: "pueda volar sin limites",
                  ),
                  SizedBox(height: screenHeight * 0.10),
                  CustomTextField(
                    hintText: 'Correo electrónico',
                    icon: Icons.email,
                    keyboardType: TextInputType.emailAddress,
                    controller: _emailController,
                    validator: emailValidator,
                  ),
                  SizedBox(height: screenHeight * 0.02),
                  CustomTextField(
                    hintText: 'Contraseña',
                    icon: Icons.lock,
                    obscureText: true,
                    controller: _passwordController,
                    validator: passwordValidator,
                  ),
                  SizedBox(height: screenHeight * 0.05),
                  CustomButton(
                    text: 'Iniciar Sesion',
                    colorFondo: Colors.redAccent,
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => UserLibrosDisponiblesPage(),
                          ),
                        );
                      }
                    },
                  ),
                  SizedBox(height: screenHeight * 0.05),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      const Text(
                        'No estás Registrado?',
                        style: TextStyle(
                          fontSize: 14.0,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(width: screenWidth * 0.02),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const RegisterScreen()));
                        },
                        child: const Text(
                          'Crear Cuenta',
                          style: TextStyle(
                            fontSize: 14.0,
                            color: Colors.redAccent,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
