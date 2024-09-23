import 'package:flutter/material.dart';
import 'package:libreria_app/models/user_model.dart';
import 'package:libreria_app/pages/login_page.dart';
import 'package:libreria_app/services/api_service.dart';
import 'package:libreria_app/services/snack_bar_service.dart';
import 'package:libreria_app/utils/validators.dart';
import 'package:libreria_app/widgets/custom_widgets.dart';
import 'dart:async';
import 'dart:io';

class RegisterUserPage extends StatefulWidget {
  const RegisterUserPage({super.key});

  @override
  RegisterUserPageState createState() => RegisterUserPageState();
}

class RegisterUserPageState extends State<RegisterUserPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _addressController = TextEditingController();
  final _passwordController = TextEditingController();
  AutovalidateMode _autoValidateMode = AutovalidateMode.disabled;
  final ApiService _apiService =
      ApiService(); // Crear una instancia de ApiService
  bool _isLoading = false; // Nueva bandera para controlar el estado de carga

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _registerUser() async {
    if (!_formKey.currentState!.validate()) {
      setState(() {
        _autoValidateMode = AutovalidateMode.always;
      });
      return;
    }

    setState(() {
      _isLoading = true; // Activar la pantalla de carga
    });

    final user = User(
      name: _nameController.text,
      email: _emailController.text,
      phone: _phoneController.text,
      address: _addressController.text,
      password: _passwordController.text,
    );

    try {
      final response = await _apiService.registerUser(user).timeout(
            const Duration(seconds: 5),
          );

      if (!mounted) return;

      if (response.success) {
        _showSuccessDialog();
      } else {
        _showErrorDialog(response.error ?? 'Error desconocido');
      }
    } on TimeoutException {
      if (mounted) {
        _showErrorDialog(
          'El tiempo de espera para la conexión ha expirado. Por favor, informe que el servicio está apagado o no responde.',
        );
      }
    } on SocketException {
      if (mounted) {
        _showErrorDialog(
          'No se pudo conectar con el servidor. Por favor, verifique su conexión a Internet.',
        );
      }
    } catch (e) {
      if (mounted) {
        _showErrorDialog(
          'Se ha producido un error inesperado: ${e.toString()}',
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false; // Desactivar la pantalla de carga
        });
      }
    }
  }

  void _showSuccessDialog() {
    SnackBarService.showSuccessSnackBar(context, 'Registro exitoso');
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => const LoginPage(),
      ),
    );
  }

  void _showErrorDialog(String message) {
    SnackBarService.showErrorSnackBar(context, message);
  }

  @override
  Widget build(BuildContext context) {
    return KeyboardDismiss(
      child: SafeArea(
        child: Scaffold(
          body: Stack(
            children: [
              SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Padding(
                  padding:
                      EdgeInsets.all(MediaQuery.of(context).size.width * 0.05),
                  child: Form(
                    key: _formKey,
                    autovalidateMode: _autoValidateMode,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>[
                        _buildHeader(),
                        SizedBox(
                            height: MediaQuery.of(context).size.height * 0.04),
                        _buildTextField(
                          controller: _nameController,
                          hintText: 'Nombre Completo',
                          icon: Icons.person,
                          validator: Validators.requiredFieldValidator,
                        ),
                        SizedBox(
                            height: MediaQuery.of(context).size.height * 0.02),
                        _buildTextField(
                          controller: _emailController,
                          hintText: 'Correo Electrónico',
                          icon: Icons.email,
                          keyboardType: TextInputType.emailAddress,
                          validator: Validators.emailValidator,
                        ),
                        SizedBox(
                            height: MediaQuery.of(context).size.height * 0.02),
                        _buildTextField(
                          controller: _phoneController,
                          hintText: 'Número Teléfono',
                          icon: Icons.phone,
                          keyboardType: TextInputType.phone,
                          maxLength: 10,
                          validator: Validators.phoneValidator,
                        ),
                        SizedBox(
                            height: MediaQuery.of(context).size.height * 0.02),
                        _buildTextField(
                          controller: _addressController,
                          hintText: 'Dirección',
                          icon: Icons.home,
                          keyboardType: TextInputType.streetAddress,
                          validator: Validators.addressValidator,
                        ),
                        SizedBox(
                            height: MediaQuery.of(context).size.height * 0.02),
                        _buildTextField(
                          controller: _passwordController,
                          hintText: 'Contraseña',
                          icon: Icons.lock,
                          obscureText: true,
                          validator: Validators.passwordValidator,
                        ),
                        SizedBox(
                            height: MediaQuery.of(context).size.height * 0.05),
                        _buildRegisterButton(),
                        SizedBox(
                            height: MediaQuery.of(context).size.height * 0.04),
                        _buildLoginPrompt(),
                      ],
                    ),
                  ),
                ),
              ),
              if (_isLoading) // Mostrar la pantalla de carga si _isLoading es true
                _buildLoadingOverlay(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return const HeaderText(
      title: 'Crea Tu Cuenta',
      description1: 'Disfruta miles de libros en la palma',
      description2: 'de tu mano',
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hintText,
    required IconData icon,
    bool obscureText = false,
    TextInputType keyboardType = TextInputType.text,
    int? maxLength,
    String? Function(String?)? validator,
  }) {
    return CustomTextField(
      controller: controller,
      hintText: hintText,
      icon: icon,
      obscureText: obscureText,
      keyboardType: keyboardType,
      maxLength: maxLength,
      validator: validator,
    );
  }

  Widget _buildRegisterButton() {
    return CustomButton(
      text: 'Registrarse',
      onPressed: _canRegister() ? _registerUser : null,
      enabled: !_isLoading,
      colorFondo: Colors.redAccent,
    );
  }

  bool _canRegister() {
    return Validators.requiredFieldValidator(_nameController.text) == null &&
        Validators.emailValidator(_emailController.text) == null &&
        Validators.phoneValidator(_phoneController.text) == null &&
        Validators.addressValidator(_addressController.text) == null &&
        Validators.passwordValidator(_passwordController.text) == null &&
        _formKey.currentState?.validate() == true;
  }

  Widget _buildLoginPrompt() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        const Text(
          '¿Tienes Cuenta?',
          style: TextStyle(fontSize: 14.0, color: Colors.white),
        ),
        SizedBox(width: MediaQuery.of(context).size.width * 0.02),
        GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
            _formKey.currentState?.reset();
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => const LoginPage(),
              ),
            );
          },
          child: const Text(
            'Iniciar Sesión',
            style: TextStyle(fontSize: 14.0, color: Colors.redAccent),
          ),
        ),
      ],
    );
  }

  // Widget para el overlay de carga
  Widget _buildLoadingOverlay() {
    return Positioned.fill(
      child: Stack(
        children: [
          ModalBarrier(
            dismissible: false,
            color: Colors.black.withOpacity(0.5),
          ),
          const Center(
            child: SizedBox(
              width: 100, // Ancho del CircularProgressIndicator
              height: 100, // Altura del CircularProgressIndicator
              child: CircularProgressIndicator(
                color: Colors.redAccent,
                strokeWidth: 8, // Ajusta el grosor del borde
              ),
            ),
          ),
        ],
      ),
    );
  }
}
