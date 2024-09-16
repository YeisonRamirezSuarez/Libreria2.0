import 'package:flutter/material.dart';
import 'package:libreria_app/models/book_model.dart';
import 'package:libreria_app/models/usuario_model.dart';
import 'package:libreria_app/pages/user_detalle_libro.dart';
import 'package:libreria_app/services/api_services.dart';
import 'package:libreria_app/widgets/custom_widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../pages/register_libro_page.dart';
import '../pages/login_page.dart';
import '../pages/update_libro_page.dart';
import '../pages/user_detalle_libro_history.dart';

class UserLibrosDisponiblesPage extends StatefulWidget {
  final bool isAdminHistoric;
  final bool isUserHistoric;

  UserLibrosDisponiblesPage(
      {super.key, this.isAdminHistoric = false, this.isUserHistoric = false});

  @override
  _UserLibrosDisponiblesPageState createState() =>
      _UserLibrosDisponiblesPageState();
}

class _UserLibrosDisponiblesPageState extends State<UserLibrosDisponiblesPage> {
  Future<List<Book>> _fetchLibros() async {
    return ApiService.fetchBooks();
  }

  Future<Map<String, String>> _loadUserInfo() async {
    final prefs = await SharedPreferences.getInstance();
    final role = prefs.getString('rol') ?? 'Rol de Usuario';
    final email = prefs.getString('email') ?? 'Nombre del Administrador';
    //final name = prefs.getString('name') ?? 'Nombre del Administrador';
    //final phone = prefs.getString('phone') ?? 'Nombre del Administrador'; //para obtener la info del usuario backend
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
            FocusScope.of(context).unfocus();
          },
          child: SafeArea(
            child: Scaffold(
              body: Column(
                children: [
                  ItemBannerUser(
                    estadoUsuario:
                        role == 'administrador' && !widget.isAdminHistoric,
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
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        UserLibrosDisponiblesPage(
                                      isAdminHistoric: true,
                                    ),
                                  ),
                                );
                              },
                            ),
                            Option(
                              icon: const Icon(Icons.add_box_outlined),
                              title: 'Agregar libro',
                              onTap: () async {
                                final result = await Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => RegisterLibroPage(
                                      email: email,
                                      rol: role,
                                    ),
                                  ),
                                );

                                if (result == true) {
                                  setState(() {});
                                }
                              },
                            ),
                            Option(
                              icon: const Icon(Icons.exit_to_app),
                              title: 'Cerrar Sesión',
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => LoginScreen(),
                                  ),
                                );
                              },
                            ),
                          ]
                        : [],
                  ),
                  Expanded(
                    child: FutureBuilder<List<Book>>(
                      future: _fetchLibros(),
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
                            child: Text('No hay libros disponibles'),
                          );
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
                              return libroCard(
                                context,
                                libro.id!,
                                libro.title,
                                libro.author,
                                libro.imageUrl,
                                libro.description,
                                isAdminHistoric: widget.isAdminHistoric,
                                isUserHistoric: widget.isUserHistoric,
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
      bool isUserHistoric = false,
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
                libroId: id,
              ),
            ),
          );
        } else if (isUserHistoric) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => BookDetailPage(
                usuario: Usuario(
                  idBook: id.toString(),
                  title: titulo,
                  author: autor,
                  bookUrl: imageUrl,
                  imageUrl: imageUrl,
                  description: descripcion,
                  date: '',
                  emailUser: email,
                  nameUser: '',
                  phoneUser: '',
                ),
                titleBaner: 'Prestar Libro',
                role: role,
                correo: email,
                cantButton: 1,
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
