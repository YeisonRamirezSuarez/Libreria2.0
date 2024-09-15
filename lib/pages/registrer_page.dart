import 'package:flutter/material.dart';
import 'package:libreria_app/widgets/custom_widgets.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

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
      return '*Este campo es obligatorio';
    }
    if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
      return '*Por favor ingresa un correo válido';
    }
    return null;
  }

  // Validador para el campo de contraseña
  String? passwordValidator(String? value) {
    if (value == null || value.isEmpty) {
      return '*Este campo es obligatorio';
    }
    if (value.length < 6) {
      return '*La contraseña debe tener al menos 6 caracteres';
    }
    if (value.length > 20) {
      return '*La contraseña no puede exceder los 20 caracteres';
    }
    return null;
  }

  // Método para hacer la petición POST al API de registro
  Future<void> registerUser(String name, String email, String phone,
      String address, String password) async {
    final url = Uri.parse("http://192.168.80.20:80/libreria/api/usuario.php");

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          "name": name,
          "email": email,
          "phone": phone,
          "address": address,
          "password": password,
          "rol": "usuario",
        }),
      );
      print(url);
      print(response.body);
      // Decodificar la respuesta
      final responseBody = json.decode(response.body);

      print(responseBody);
      print(response.statusCode);

      if (response.statusCode == 201 || response.statusCode == 400) {
        // Si el servidor devolvió una respuesta OK
        if (responseBody['mensaje'] == 'success register') {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Registro del usuario exitoso')),
          );
          Navigator.pop(context);
          // Puedes navegar a otra pantalla o resetear el formulario
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('${responseBody['error']}')),
          );
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Error en el servidor')),
        );
      }
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error de red: $error')),
      );
      print('Error de red: $error');
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
                      validator: emailValidator,
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
                      validator: passwordValidator,
                    ),
                    SizedBox(height: screenHeight * 0.05),
                    CustomButton(
                      text: 'Registrarse',
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          // Si las validaciones son correctas, hacemos el registro
                          registerUser(
                            _nameController.text,
                            _emailController.text,
                            _phoneController.text,
                            _addressController.text,
                            _passwordController.text,
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
