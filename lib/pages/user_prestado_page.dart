import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:libreria_app/pages/login_page.dart';
import 'package:libreria_app/pages/user_detalle_libro.dart';
import 'package:libreria_app/pages/user_libros_disponibles_page.dart';
import 'package:libreria_app/widgets/custom_widgets.dart';

class UserPrestadoPage extends StatelessWidget {
  const UserPrestadoPage({super.key});

  // Lista de libros dinámica (puedes reemplazar esta data con datos reales)
  final List<Map<String, String>> books = const [
    {
      'imageUrl': 'https://upload.wikimedia.org/wikipedia/en/0/05/Littleprince.JPG',
      'title': 'El Principito',
      'author': 'Antoine de Saint-Exupéry',
      'date': '13 Sep 2024, 15:09',
    },
    {
      'imageUrl': 'https://upload.wikimedia.org/wikipedia/en/0/05/Littleprince.JPG',
      'title': 'El Principito 2',
      'author': 'Antoine de Saint-Exupéry',
      'date': '14 Sep 2024, 12:00',
    },
    {
      'imageUrl': 'https://upload.wikimedia.org/wikipedia/en/0/05/Littleprince.JPG',
      'title': 'El Principito 3',
      'author': 'Antoine de Saint-Exupéry',
      'date': '15 Sep 2024, 10:00',
    },
  ];

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
              backgroundColor: Colors.black,
              body: Column(
                children: <Widget>[
                  ItemBannerUser(
                    estadoUsuario: true,
                    seaching: true,
                    titleBaner: "Mis Libros Prestados",
                    rolUser: role,
                    nameUser: email,
                    options: [
                      Option(
                        icon: Icon(Icons.exit_to_app),
                        title: 'Cerrar Sesión',
                        destination: LoginScreen(), // Reemplaza con tu pantalla
                      ),
                    ],
                  ),

                  // Expanded widget to make the list scrollable and fill available space
                  Expanded(
                    child: ListView.builder(
                      itemCount: books.length, // Dinámico según la lista de libros
                      itemBuilder: (context, index) {
                        final book = books[index];
                        return Padding(
                          padding: const EdgeInsets.all(2.0),
                          child: GestureDetector(
                            onTap: () {
                              // Navegar a la pantalla de detalles al tocar
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => BookDetailPage(
                                    imageUrl: book['imageUrl']!,
                                    title: book['title']!,
                                    author: book['author']!,
                                    date: book['date']!,
                                  ),
                                ),
                              );
                            },
                            child: BookCard(
                              imageUrl: book['imageUrl']!,
                              title: book['title']!,
                              author: book['author']!,
                              date: book['date']!,
                            ),
                          ),
                        );
                      },
                    ),
                  ),

                  // Divider lines
                  Container(
                    width: double.infinity,
                    height: 3.0,
                    color: Colors.redAccent,
                  ),
                  const SizedBox(height: 10.0),
                  Container(
                    width: double.infinity,
                    height: 3.0,
                    margin: const EdgeInsets.only(top: 2.0),
                    color: Colors.redAccent,
                  ),
                  const SizedBox(height: 4.0),
                  Container(
                    width: double.infinity,
                    height: 4.0,
                    margin: const EdgeInsets.only(bottom: 10.0),
                    color: Colors.redAccent,
                  ),

                  // Button at the bottom of the screen
                  SafeArea(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: CustomButton(
                        text: 'Prestar',
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => UserLibrosDisponiblesPage(),
                            ),
                          );
                        },
                        colorFondo: Colors.redAccent,
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
}
