import 'package:flutter/material.dart';
import 'package:libreria_app/widgets/custom_widgets.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();

  // Controladores para los campos de texto
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _addressController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  // Validador para el campo de correo electrónico
  String? emailValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Este campo es obligatorio';
    }
    if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
      return 'Por favor ingresa un correo válido';
    }
    return null;
  }

  // Validador para el campo de contraseña
  String? passwordValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Este campo es obligatorio';
    }
    if (value.length < 6) {
      return 'La contraseña debe tener al menos 6 caracteres';
    }
    if (value.length > 20) {
      return 'La contraseña no puede exceder los 20 caracteres';
    }
    return null;
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
                key: _formKey, // Clave del formulario para gestionar validaciones
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
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'El nombre es obligatorio';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: screenHeight * 0.02),
                    CustomTextField(
                      hintText: 'Correo Electrónico',
                      icon: Icons.email,
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                      validator: emailValidator, // Validación para el correo
                    ),
                    SizedBox(height: screenHeight * 0.02),
                    CustomTextField(
                      hintText: 'Número Teléfono',
                      icon: Icons.phone,
                      controller: _phoneController,
                      keyboardType: TextInputType.phone,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'El teléfono es obligatorio';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: screenHeight * 0.02),
                    CustomTextField(
                      hintText: 'Dirección',
                      icon: Icons.home,
                      controller: _addressController,
                      keyboardType: TextInputType.streetAddress,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'La dirección es obligatoria';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: screenHeight * 0.02),
                    CustomTextField(
                      hintText: 'Contraseña',
                      icon: Icons.lock,
                      obscureText: true,
                      controller: _passwordController,
                      suffixIcon: Icons.visibility_off,
                      validator: passwordValidator, // Validación para la contraseña
                    ),
                    SizedBox(height: screenHeight * 0.05),
                    CustomButton(
                      text: 'Registrarse',
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          // Si las validaciones son correctas, mostramos un mensaje
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Formulario válido')),
                          );
                        }
                      },
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
                            // Navega a la pantalla de inicio de sesión
                            FocusScope.of(context).unfocus();
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
