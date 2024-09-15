import 'dart:convert'; // Necesario para decodificar el JSON
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:libreria_app/pages/register_libro_page.dart';
import 'package:libreria_app/pages/login_page.dart';
import 'package:libreria_app/pages/update_libro_page.dart';
import 'package:libreria_app/pages/user_detalle_libro_history.dart';
import 'package:libreria_app/widgets/custom_widgets.dart';
import 'package:libreria_app/widgets/item_banner_user.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserLibrosDisponiblesPage extends StatefulWidget {
  bool isAdminHistoric;
  UserLibrosDisponiblesPage({super.key, this.isAdminHistoric = false});

  @override
  _UserLibrosDisponiblesPageState createState() =>
      _UserLibrosDisponiblesPageState();
}

class _UserLibrosDisponiblesPageState extends State<UserLibrosDisponiblesPage> {
  Future<List<dynamic>> _fetchLibros() async {
    try {
      final response = await http
          .get(Uri.parse('http://192.168.80.20:80/libreria/api/libro.php'));

      print(
          "Respuesta del servidor: ${response.body}"); // Esto imprimirá la respuesta completa del servidor

      if (response.statusCode == 200) {
        final decodedData = json.decode(response.body);

        // Comprueba si el objeto decodedData contiene la clave "data" y que es una lista
        if (decodedData['data'] != null && decodedData['data'] is List) {
          return decodedData['data']; // Retorna solo la lista de libros
        } else {
          throw Exception(
              'La respuesta no contiene la clave "data" o no es una lista');
        }
      } else {
        throw Exception('Error de servidor: ${response.statusCode}');
      }
    } catch (e) {
      print("Error al hacer la solicitud HTTP: $e");
      throw Exception(
          'Error al cargar los libros'); // Mantiene el mensaje de error original
    }
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
            FocusScope.of(context)
                .unfocus(); // Ocultar el teclado si está abierto
          },
          child: SafeArea(
            child: Scaffold(
              body: Column(
                children: [
                  ItemBannerUser(
                    estadoUsuario:
                        role == 'administrador' && !widget.isAdminHistoric
                            ? true
                            : false,
                    seaching: true,
                    titleBaner:
                        role == 'administrador' && widget.isAdminHistoric
                            ? 'Libros Prestados'
                            : 'Libros Disponibles',
                    rolUser: role,
                    nameUser: email,
                    options: role == 'administrador' && !widget.isAdminHistoric
                        ? [
                            Option(
                              icon: const Icon(Icons.book),
                              title: 'Libros Prestados',
                              destination: UserLibrosDisponiblesPage(
                                isAdminHistoric: true,
                              ),
                            ),
                            Option(
                              icon: const Icon(Icons.add_box_outlined),
                              title: 'Agregar libro',
                              destination: RegisterLibroPage(
                                email: email,
                                rol: role,
                              ),
                            ),
                            Option(
                              icon: const Icon(Icons.exit_to_app),
                              title: 'Cerrar Sesión',
                              destination: LoginScreen(),
                            ),
                          ]
                        : [],
                  ),
                  Expanded(
                    child: FutureBuilder<List<dynamic>>(
                      future: _fetchLibros(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(
                              child: CircularProgressIndicator());
                        } else if (snapshot.hasError) {
                          // Imprime el error en la consola
                          print('Error: ${snapshot.error}');

                          // Muestra el error en la interfaz de usuario
                          return Center(
                            child: Text('Error: ${snapshot.error}'),
                          );
                        } else if (!snapshot.hasData ||
                            snapshot.data!.isEmpty) {
                          return const Center(
                              child: Text('No hay libros disponibles'));
                        }

                        final libros = snapshot.data!;

                        return Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: GridView.builder(
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              crossAxisSpacing: 10,
                              mainAxisSpacing: 10,
                              childAspectRatio: 0.85,
                            ),
                            itemCount: libros.length,
                            itemBuilder: (context, index) {
                              final libro = libros[index];
                              print(libro['image_url']);
                              return libroCard(
                                context,
                                libro['id'],
                                libro['title'],
                                libro['author'],
                                libro['image_url'],
                                libro['description'],
                                isAdminHistoric: widget.isAdminHistoric,
                                role: role,
                                email: email,
                              );
                            },
                          ),
                        );
                      },
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

  Widget libroCard(BuildContext context, String id, String titulo, String autor,
      String imageUrl, String descripcion,
      {bool isAdminHistoric = false,
      required String role,
      required String email}) {
    return GestureDetector(
      onTap: () {
        if (isAdminHistoric) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => BookDetailHistoryPage(
                imageUrl: imageUrl,
                bookTitle: titulo,
                bookAuthor: autor,
                bookDescription: descripcion,
                userName: 'Karl',
                userPhone: '300112548',
                userEmail: 'karl@upb.com',
                role: role,
                email: email,
              ),
            ),
          );
        } else if (!isAdminHistoric && role == 'administrador') {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => UpdateLibroPage(
                email: email,
                rol: role,
                libroId: int.parse(id), // Cambia esto según tu implementación
              ),
            ),
          );
        }
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12.0),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              spreadRadius: 2,
              blurRadius: 6,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              ImageWidget(
                imageUrl: imageUrl,
                height: 150.0,
                width: 150.0,
              ),
              const SizedBox(height: 8.0),
              Text(
                titulo,
                style: const TextStyle(
                  fontSize: 16.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 4.0),
              Text(
                autor,
                style: TextStyle(
                  fontSize: 14.0,
                  color: Colors.grey[600],
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
