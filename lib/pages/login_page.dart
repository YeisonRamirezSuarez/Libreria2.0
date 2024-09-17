import 'package:flutter/material.dart';
import 'package:libreria_app/models/api_response.dart';
import 'package:libreria_app/pages/user_libros_disponibles_page.dart';
import 'package:libreria_app/pages/user_prestado_page.dart';
import 'package:libreria_app/services/api_services.dart';
import 'package:libreria_app/utils/validators.dart';
import 'package:libreria_app/widgets/custom_widgets.dart';
import 'package:libreria_app/pages/registrer_page.dart';
import 'package:libreria_app/services/dialog_service.dart';
import 'dart:async';
import 'dart:io';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final ApiService _apiService = ApiService();
  AutovalidateMode _autoValidateMode = AutovalidateMode.disabled;
  late final List<TextEditingController> _controllers;

  @override
  void initState() {
    super.initState();
    _controllers = [
      _emailController,
      _passwordController,
    ];

    for (var controller in _controllers) {
      controller.addListener(() {
        if (_autoValidateMode == AutovalidateMode.always) {
          setState(() {});
        }
      });
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _login() async {
    if (!_formKey.currentState!.validate()) {
      setState(() {
        _autoValidateMode = AutovalidateMode.always;
      });
      return;
    }

    final email = _emailController.text;
    final password = _passwordController.text;

    try {
      // Usar un timeout para la solicitud HTTP
      final response = await _apiService
          .login(email, password)
          .timeout(Duration(seconds: 5));

      if (response.user != null) {
        _navigateBasedOnRole(response.user!.role);
      } else {
        DialogService.showInfoDialog(
            context, response.error ?? 'Error desconocido');
      }
    } on TimeoutException catch (_) {
      // Manejar el caso de timeout
      DialogService.showInfoDialog(context,
          'El tiempo de espera para la conexión ha expirado. Por favor, informa que el servicio esta apagado o no responde.');
    } on SocketException catch (_) {
      // Manejar el caso de problemas de red
      DialogService.showInfoDialog(context,
          'No se pudo conectar con el servidor. Por favor, verifique su conexión a Internet.');
    } catch (e) {
      // Manejar cualquier otro tipo de excepción
      DialogService.showInfoDialog(
          context, 'Se ha producido un error inesperado: ${e.toString()}');
    }
  }

  void _navigateBasedOnRole(String role) {
    if (role == 'administrador') {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => UserLibrosDisponiblesPage()),
      );
    } else if (role == 'usuario') {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const UserPrestadoPage()),
      );
    } else {
      DialogService.showInfoDialog(context, 'Rol no reconocido');
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return GestureDetector(
      onTap: () {
        // Oculta el teclado al tocar fuera de un campo de texto
        FocusScope.of(context).unfocus();
      },
      child: SafeArea(
        child: Scaffold(
          body: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Padding(
              padding: EdgeInsets.all(screenWidth * 0.05),
              child: Form(
                key: _formKey,
                autovalidateMode: _autoValidateMode,
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
                      validator: Validators.emailValidator,
                    ),
                    SizedBox(height: screenHeight * 0.02),
                    CustomTextField(
                      hintText: 'Contraseña',
                      icon: Icons.lock,
                      obscureText: true, // Indica que es un campo de contraseña
                      controller: _passwordController,
                      validator: Validators.passwordValidator,
                    ),
                    SizedBox(height: screenHeight * 0.05),
                    CustomButton(
                      text: 'Iniciar Sesion',
                      colorFondo: Colors.redAccent,
                      onPressed: _login,
                    ),
                    SizedBox(height: screenHeight * 0.05),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        const Text(
                          'No estás Registrado?',
                          style: TextStyle(fontSize: 14.0, color: Colors.white),
                        ),
                        SizedBox(width: screenWidth * 0.02),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const RegisterUserPage(),
                              ),
                            );
                          },
                          child: const Text(
                            'Crear Cuenta',
                            style: TextStyle(
                                fontSize: 14.0, color: Colors.redAccent),
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
      ),
    );
  }
}
