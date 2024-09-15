import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart'; // Importa el paquete
import 'package:libreria_app/pages/registrer_page.dart';
import 'package:libreria_app/pages/user_libros_disponibles_page.dart';
import 'package:libreria_app/pages/user_prestado_page.dart';
import 'package:libreria_app/widgets/custom_widgets.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

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
      return '*Este campo es obligatorio';
    }
    if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
      return '*Por favor ingresa un correo válido';
    }
    return null;
  }

  String? passwordValidator(String? value) {
    if (value == null || value.isEmpty) {
      return '*Este campo es obligatorio';
    }
    if (value.length < 6) {
      return '*La contraseña debe tener al menos 6 caracteres';
    }
    return null;
  }

  Future<void> _login() async {
    final email = _emailController.text;
    final password = _passwordController.text;

    final url = Uri.parse('http://192.168.80.20:80/libreria/api/login.php');

    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'email': email,
        'password': password,
      }),
    );

    print(response.body);
    print(response.statusCode);

    if (response.statusCode == 200) {
      final data = json.decode(response.body);

      // Almacenar en SharedPreferences
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('email', email);
      await prefs.setString('rol', data['rol']);

      // Asumimos que el API devuelve un JSON con el campo "rol"
      final role = data['rol'];
      if (role == 'administrador') {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) =>
                UserLibrosDisponiblesPage(), // Página para administrador
          ),
        );
      } else if (role == 'usuario') {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => UserPrestadoPage(),
          ),
        );
      } else {
        // Manejo de error si el rol no es reconocido
        _showErrorDialog('Rol no reconocido');
      }
    } else {
      // Manejo de error si la solicitud falla
      _showErrorDialog('Error al iniciar sesión');
    }
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Error'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('OK'),
          ),
        ],
      ),
    );
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
                  const HeaderText(
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
                        _login(); // Llamar a la función de inicio de sesión
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
                          FocusScope.of(context).unfocus();
                          _formKey.currentState?.reset();
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      const RegisterUserPage()));
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
