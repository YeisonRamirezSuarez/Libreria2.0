import 'package:flutter/material.dart';
import 'package:libreria_app/pages/register_libro_page.dart';
import 'package:libreria_app/pages/login_page.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:libreria_app/widgets/card_libro_view.dart';
import 'package:libreria_app/widgets/custom_button.dart';
import 'package:libreria_app/widgets/item_banner_user.dart';

class UserLibrosDisponiblesPage extends StatelessWidget {
  const UserLibrosDisponiblesPage({super.key});

  Future<Map<String, String>> _loadUserInfo() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final role = prefs.getString('rol') ?? 'Rol de Usuario';
    final email = prefs.getString('email') ?? 'Nombre del Administrador';
    return {
      'role': role,
      'email': email,
    };
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Map<String, String>>(
      future: _loadUserInfo(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData) {
          return Center(child: Text('No data found'));
        }

        final data = snapshot.data!;
        final role = data['role']!;
        final email = data['email']!;

        return GestureDetector(
          onTap: () {
            // Ocultar el teclado al tocar en cualquier parte de la pantalla
            FocusScope.of(context).unfocus();
          },
          child: SafeArea(
            child: Scaffold(
              body: Column(
                children: [
                  ItemBannerUser(
                    estadoUsuario: role == 'administrador' ? true : false,
                    seaching: true,
                    titleBaner: "Libros Disponibles",
                    rolUser: role,
                    nameUser: email,
                    options: role == 'administrador'
                        ? [
                            /* Option(
                              icon: Icon(Icons.book),
                              title: 'Libros Prestados',
                              destination: Text("ProcessTextPage"),
                              //AdminLibrosPrestadospage(), // Reemplaza con tu pantalla
                            ),*/
                            Option(
                              icon: Icon(Icons.add_box_outlined),
                              title: 'Agregar libro',
                              destination: 
                                  RegisterLibroPage(email: email, rol: role,), // Reemplaza con tu pantalla
                            ),
                            Option(
                              icon: Icon(Icons.exit_to_app),
                              title: 'Cerrar Sesión',
                              destination:
                                  LoginScreen(), // Reemplaza con tu pantalla
                            ),
                          ]
                        : [],
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: GridView.count(
                        crossAxisCount: 2, // Dos columnas
                        crossAxisSpacing: 10,
                        mainAxisSpacing: 10,
                        childAspectRatio:
                            0.85, // Proporción de las tarjetas (más compactas)
                        children: [
                          libroCard('El principito', 'Antoine de Saint-Exupéry',
                              'https://th.bing.com/th/id/OIP.6yF35Z7NHmGbFjZMc9aAhQHaKi?w=984&h=1400&rs=1&pid=ImgDetMain'),
                          libroCard(
                              'Harry Potter y la piedra filosofal',
                              'J.K. Rowling',
                              'https://th.bing.com/th/id/OIP.HMyiZ79cUZ2RtWOHeQqPYwHaLz?rs=1&pid=ImgDetMain'),
                          libroCard('Sofia Qm', 'princesa',
                              'https://th.bing.com/th/id/OIP.5NZ0uREl1IhFQhNIu9JDjQHaJn?rs=1&pid=ImgDetMain'),
                          libroCard('El West', 'STREAMING',
                              'https://th.bing.com/th/id/OIP.U8ToD6L1AYWfL4fpQWXtowHaEK?rs=1&pid=ImgDetMain'),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget libroCard(String titulo, String autor, String imageUrl) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white, // Fondo blanco
        borderRadius: BorderRadius.circular(12.0), // Bordes redondeados
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            spreadRadius: 2,
            blurRadius: 6,
            offset: const Offset(0, 3), // Sombra ligera
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(
                  8.0), // Bordes redondeados para la imagen
              child: Image.network(
                imageUrl,
                fit: BoxFit
                    .contain, // Cambia a "contain" para que la imagen no se recorte
                width: 150.0,
                height: 150.0,
              ),
            ),
            const SizedBox(height: 8.0),
            Text(
              titulo,
              style: const TextStyle(
                fontSize: 16.0,
                fontWeight: FontWeight.bold,
                color: Colors.black, // Texto negro
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 4.0),
            Text(
              autor,
              style: TextStyle(
                fontSize: 14.0,
                color: Colors.grey[600], // Texto gris para el autor
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
