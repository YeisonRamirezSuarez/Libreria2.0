import 'package:flutter/material.dart';
import 'package:libreria_app/models/usuario_model.dart';
import 'package:libreria_app/services/api_services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:libreria_app/pages/login_page.dart';
import 'package:libreria_app/pages/user_detalle_libro.dart';
import 'package:libreria_app/pages/user_libros_disponibles_page.dart';
import 'package:libreria_app/widgets/custom_widgets.dart';

class UserPrestadoPage extends StatelessWidget {
  const UserPrestadoPage({super.key});

  Future<List<Usuario>> _fetchLibrosUser(String email) async {
    return ApiService.fetchUsuariosHistorial(
        email); // Assuming this method fetches the books
  }

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
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData) {
          return const Center(child: Text('No data found'));
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
                        icon: const Icon(Icons.exit_to_app),
                        title: 'Cerrar Sesión',
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const LoginScreen(),
                            ),
                          );
                        }, // Reemplaza con tu pantalla
                      ),
                    ],
                  ),

                  // Expanded widget to make the list scrollable and fill available space
                  Expanded(
                    child: FutureBuilder<List<Usuario>>(
                      future: _fetchLibrosUser(email),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(
                              child: CircularProgressIndicator());
                        } else if (snapshot.hasError) {
                          return Center(
                              child: Text('Error: ${snapshot.error}'));
                        } else if (!snapshot.hasData ||
                            snapshot.data!.isEmpty) {
                          return const Center(
                              child: Text('No hay libros prestados.'));
                        }

                        final books = snapshot.data!;

                        return ListView.builder(
                          itemCount: books.length,
                          itemBuilder: (context, index) {
                            final book =
                                books[index]; // Assuming books is List<Usuario>
                            return Padding(
                              padding: const EdgeInsets.all(2.0),
                              child: GestureDetector(
                                onTap: () {
                                  // Navegar a la pantalla de detalles al tocar
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => BookDetailPage(
                                        titleBaner: "Mis Libros Prestados",
                                        usuario: book,
                                        role: role,
                                        correo: email,
                                        cantButton: 2,
                                      ),
                                    ),
                                  );
                                },
                                child: BookCard(
                                  imageUrl:
                                      book.imageUrl, // Update as per your model
                                  title: book.title, // Update as per your model
                                  author:
                                      book.author, // Update as per your model
                                  date: book.date, // Update as per your model
                                ),
                              ),
                            );
                          },
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
                              builder: (context) => UserLibrosDisponiblesPage(
                                isUserHistoric: true,
                              ),
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
