import 'package:flutter/material.dart';
import 'package:libreria_app/widgets/custom_widgets.dart';

class RegisterScreen extends StatelessWidget {
  const RegisterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(  // Envolver la columna en un SingleChildScrollView
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                const SizedBox(height: 20.0),
                const HeaderText(
                  title: 'Crea Tu Cuenta',
                  description1: 'Disfruta miles de libros en la palma',
                  description2: 'de tu mano',
                ),
                const SizedBox(height: 40.0),
                const CustomTextField(
                  hintText: 'Nombre Completo',
                  icon: Icons.person,
                  keyboardType: TextInputType.name,
                ),
                const SizedBox(height: 15.0),
                const CustomTextField(
                  hintText: 'Correo Electrónico',
                  icon: Icons.email,
                  keyboardType: TextInputType.emailAddress,
                ),
                const SizedBox(height: 15.0),
                const CustomTextField(
                  hintText: 'Número Teléfono',
                  icon: Icons.phone,
                  keyboardType: TextInputType.phone,
                ),
                const SizedBox(height: 15.0),
                const CustomTextField(
                  hintText: 'Dirección',
                  icon: Icons.home,
                  keyboardType: TextInputType.streetAddress,
                ),
                const SizedBox(height: 15.0),
                const CustomTextField(
                  hintText: 'Contraseña',
                  icon: Icons.lock,
                  obscureText: true,
                  suffixIcon: Icons.visibility_off,
                ),
                const SizedBox(height: 60.0),
                CustomButton(
                  text: 'Registrarse',
                  onPressed: () {},
                  colorFondo: Colors.redAccent,
                ),
                const SizedBox(height: 40.0),
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
                    const SizedBox(width: 7.0),
                    GestureDetector(
                      onTap: () {
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
    );
  }
}
