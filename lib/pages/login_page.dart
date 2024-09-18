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
  late final FocusNode _emailFocusNode;
  late final FocusNode _passwordFocusNode;

  @override
  void initState() {
    super.initState();
    _emailFocusNode = FocusNode();
    _passwordFocusNode = FocusNode();

    _emailController.addListener(_updateButtonState);
    _passwordController.addListener(_updateButtonState);
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _emailFocusNode.dispose();
    _passwordFocusNode.dispose();
    super.dispose();
  }

  void _updateButtonState() {
    if (mounted) {
      setState(() {}); // Update the button state
    }
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
      DialogService.showInfoDialog(context,
          'El tiempo de espera para la conexión ha expirado. Por favor, informa que el servicio está apagado o no responde.');
    } on SocketException catch (_) {
      DialogService.showInfoDialog(context,
          'No se pudo conectar con el servidor. Por favor, verifique su conexión a Internet.');
    } catch (e) {
      DialogService.showInfoDialog(
          context, 'Se ha producido un error inesperado: ${e.toString()}');
    }
  }

  void _navigateBasedOnRole(String role) {
    if (role == 'administrador') {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const UserLibrosDisponiblesPage(isPrincipal: true,)),
      );
    } else if (role == 'usuario') {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const UserPrestadoPage(isPrincipal: true,)),
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
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _buildHeader(screenWidth),
                    SizedBox(height: screenHeight * 0.1),
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
                      obscureText: true,
                      controller: _passwordController,
                      validator: Validators.passwordValidator,
                    ),
                    SizedBox(height: screenHeight * 0.05),
                    CustomButton(
                      text: 'Iniciar Sesión',
                      colorFondo: Colors.redAccent,
                      onPressed: (_emailController.text.isNotEmpty &&
                                  _passwordController.text.isNotEmpty &&
                                  _formKey.currentState?.validate() == true)
                          ? _login
                          : null,
                    ),
                    SizedBox(height: screenHeight * 0.05),
                    _buildFooter(screenWidth),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(double screenWidth) {
    return Column(
      children: [
        const HeaderText(
          title: "Iniciar Sesión",
          description1: "Ven a leer y deja que tu imaginación",
          description2: "pueda volar sin límites",
        ),
        SizedBox(height: screenWidth * 0.05),
      ],
    );
  }

  Widget _buildFooter(double screenWidth) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        const Text(
          '¿No estás Registrado?',
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
            style: TextStyle(fontSize: 14.0, color: Colors.redAccent),
          ),
        ),
      ],
    );
  }
}
