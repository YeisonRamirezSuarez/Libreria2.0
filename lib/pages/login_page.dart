import 'package:flutter/material.dart';
import 'package:libreria_app/pages/registrer_page.dart';
import 'package:libreria_app/pages/user_libros_disponibles_page.dart';
import 'package:libreria_app/pages/user_prestado_page.dart';
import 'package:libreria_app/services/api_service.dart';
import 'package:libreria_app/utils/validators.dart';
import 'package:libreria_app/services/dialog_service.dart';
import 'dart:async';
import 'dart:io';
import 'package:libreria_app/widgets/custom_widgets.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  LoginPageState createState() => LoginPageState();
}

class LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final ApiService _apiService = ApiService();
  AutovalidateMode _autoValidateMode = AutovalidateMode.disabled;

  @override
  void initState() {
    super.initState();
    _emailController.addListener(_updateButtonState);
    _passwordController.addListener(_updateButtonState);
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _updateButtonState() {
    if (mounted) {
      setState(() {});
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
          .timeout(const Duration(seconds: 5));

      if (!mounted) return;

      if (response.user != null) {
        _navigateBasedOnRole(response.user!.role);
      } else {
        _showInfoDialog(response.error ?? 'Error desconocido');
      }
    } on TimeoutException catch (_) {
      if (!mounted) return;
      _showInfoDialog('El tiempo de espera para la conexión ha expirado. Por favor, informa que el servicio está apagado o no responde.');
    } on SocketException catch (_) {
      if (!mounted) return;
      _showInfoDialog('No se pudo conectar con el servidor. Por favor, verifique su conexión a Internet.');
    } catch (e) {
      if (!mounted) return;
      _showInfoDialog('Se ha producido un error inesperado: ${e.toString()}');
    }
  }

  void _navigateBasedOnRole(String role) {
    final route = role == 'administrador'
        ? UserLibrosDisponiblesPage(isPrincipal: true)
        : UserPrestadoPage(isPrincipal: true);

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => route),
    );
  }

  void _showInfoDialog(String message) {
    DialogService.showInfoDialog(context, message);
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return KeyboardDismiss(
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
                    _buildHeader(),
                    SizedBox(height: screenHeight * 0.1),
                    _buildEmailField(),
                    SizedBox(height: screenHeight * 0.02),
                    _buildPasswordField(),
                    SizedBox(height: screenHeight * 0.05),
                    _buildLoginButton(),
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

  Widget _buildHeader() {
    return const HeaderText(
      title: "Iniciar Sesión",
      description1: "Ven a leer y deja que tu imaginación",
      description2: "pueda volar sin límites",
    );
  }

  Widget _buildEmailField() {
    return CustomTextField(
      hintText: 'Correo electrónico',
      icon: Icons.email,
      keyboardType: TextInputType.emailAddress,
      controller: _emailController,
      validator: Validators.emailValidator,
    );
  }

  Widget _buildPasswordField() {
    return CustomTextField(
      hintText: 'Contraseña',
      icon: Icons.lock,
      obscureText: true,
      controller: _passwordController,
      validator: Validators.passwordValidator,
    );
  }

  Widget _buildLoginButton() {
    return CustomButton(
      text: 'Iniciar Sesión',
      colorFondo: Colors.redAccent,
      onPressed: (_emailController.text.isNotEmpty &&
              _passwordController.text.isNotEmpty &&
              _formKey.currentState?.validate() == true)
          ? _login
          : null,
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
