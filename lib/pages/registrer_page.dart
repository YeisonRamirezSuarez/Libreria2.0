import 'package:flutter/material.dart';
import 'package:libreria_app/models/login_model.dart';
import 'package:libreria_app/services/api_services.dart';
import 'package:libreria_app/services/dialog_service.dart';
import 'package:libreria_app/utils/validators.dart';
import 'package:libreria_app/widgets/custom_widgets.dart';

class RegisterUserPage extends StatefulWidget {
  const RegisterUserPage({super.key});

  @override
  _RegisterUserPageState createState() => _RegisterUserPageState();
}

class _RegisterUserPageState extends State<RegisterUserPage> {
  final _formKey = GlobalKey<FormState>();

  // Controladores para los campos de texto
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _addressController = TextEditingController();
  final _passwordController = TextEditingController();
  AutovalidateMode _autoValidateMode = AutovalidateMode.disabled;
  late final List<TextEditingController> _controllers;


  @override
  void initState() {
    super.initState();

    _controllers = [
      _nameController,
      _emailController,
      _phoneController,
      _addressController,
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
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> registerUser() async {
    if (!_formKey.currentState!.validate()) {
      setState(() {
        _autoValidateMode = AutovalidateMode.always;
      });
      return;
    }

    final user = User(
      name: _nameController.text,
      email: _emailController.text,
      phone: _phoneController.text,
      address: _addressController.text,
      password: _passwordController.text,
    );

    try {
      final response = await ApiService.registerUser(user);

      if (response.success) {
        DialogService.showErrorSnackBar(context, 'Registro exitoso');
        Navigator.pop(context);
      } else {
        DialogService.showErrorSnackBar(
            context, response.error ?? 'Error desconocido');
      }
    } catch (error) {
      DialogService.showErrorSnackBar(context, 'Error de red: $error');
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
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    const SizedBox(),
                    const HeaderText(
                      title: 'Crea Tu Cuenta',
                      description1: 'Disfruta miles de libros en la palma',
                      description2: 'de tu mano',
                    ),
                    SizedBox(height: screenHeight * 0.04),
                    CustomTextField(
                      hintText: 'Nombre Completo',
                      icon: Icons.person,
                      controller: _nameController,
                      keyboardType: TextInputType.name,
                      validator: Validators.requiredFieldValidator,
                    ),
                    SizedBox(height: screenHeight * 0.02),
                    CustomTextField(
                      hintText: 'Correo Electrónico',
                      icon: Icons.email,
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                      validator: Validators.emailValidator,
                    ),
                    SizedBox(height: screenHeight * 0.02),
                    CustomTextField(
                      hintText: 'Número Teléfono',
                      icon: Icons.phone,
                      controller: _phoneController,
                      keyboardType: TextInputType.phone,
                      maxLength: 10, // Límite de 10 caracteres
                      validator: Validators.phoneValidator,
                    ),
                    SizedBox(height: screenHeight * 0.02),
                    CustomTextField(
                      hintText: 'Dirección',
                      icon: Icons.home,
                      controller: _addressController,
                      keyboardType: TextInputType.streetAddress,
                      validator: Validators.addressValidator,
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
                      text: 'Registrarse',
                      onPressed: registerUser,
                      colorFondo: Colors.redAccent,
                    ),
                    SizedBox(height: screenHeight * 0.04),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        const Text(
                          'Tienes Cuenta?',
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
                            Navigator.pop(context);
                          },
                          child: const Text(
                            'Iniciar Sesión',
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
      ),
    );
  }
}
