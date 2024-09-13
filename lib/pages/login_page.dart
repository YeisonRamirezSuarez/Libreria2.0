import 'package:flutter/material.dart';
import 'package:libreria_app/pages/registrer_page.dart';
import 'package:libreria_app/pages/user_libros_disponibles_page.dart';
import 'package:libreria_app/pages/user_prestado_page.dart';
import 'package:libreria_app/widgets/custom_widgets.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              const SizedBox(height: 20.0),
              const HeaderText(
                title: 'Iniciar Sesión',
                description1: 'ven a leer y deja que tu imaginación',
                description2: 'pueda volar sin límites',
              ),
              const SizedBox(height: 90.0),
              const CustomTextField(
                hintText: 'Correo Electrónico',
                icon: Icons.email,
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 15.0),
              const CustomTextField(
                hintText: 'Contraseña',
                icon: Icons.lock,
                obscureText: true,
                suffixIcon: Icons.visibility_off,
              ),
              const SizedBox(height: 70.0),
              CustomButton(
                text: 'Iniciar Sesión',
                onPressed: () {
                   Navigator.push(context,
                        MaterialPageRoute(builder: (context) =>  UserLibrosDisponiblesPage()));
                },
                colorFondo: Colors.redAccent,
              ),
              const SizedBox(height: 50.0),
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
                  const SizedBox(width: 4.0),
                  GestureDetector(
                    onTap: () {
                       Navigator.push(context,
                        MaterialPageRoute(builder: (context) => const RegisterScreen()));
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
    );
  }
}

