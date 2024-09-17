import 'package:flutter/material.dart';
import 'package:libreria_app/models/usuario_model.dart';
import 'package:libreria_app/pages/login_page.dart';
import 'package:libreria_app/pages/user_detalle_libro.dart';
import 'package:libreria_app/pages/user_libros_disponibles_page.dart';
import 'package:libreria_app/services/api_services.dart';
import 'package:libreria_app/services/shared_preferences.dart';
import 'package:libreria_app/widgets/custom_widgets.dart';

class UserPrestadoPage extends StatefulWidget {
  const UserPrestadoPage({super.key});

  @override
  _UserPrestadoPageState createState() => _UserPrestadoPageState();
}

class _UserPrestadoPageState extends State<UserPrestadoPage> {
  Map<String, String>? _userInfo;
  List<Usuario>? _books;
  List<Usuario> _filteredBooks = [];
  bool _isDataLoaded = false;

  Future<void> _loadData() async {
    // Cargar la información del usuario
    _userInfo = await LoadUserInfo();
    final String email = _userInfo!['email']!;
    
    // Cargar los libros del usuario
    final books = await ApiService.fetchBookForUser(email);
    setState(() {
      _books = books;
      _filteredBooks = books;
      _isDataLoaded = true;
    });
  }

  @override
  void initState() {
    super.initState();
    _loadData(); // Cargar los datos cuando se inicializa el estado
  }

  @override
  Widget build(BuildContext context) {
    return Builder(
      builder: (context) {
        if (!_isDataLoaded) {
          return const Center(child: CircularProgressIndicator());
        }

        if (_userInfo == null) {
          return const Center(child: Text('No data found'));
        }

        final role = _userInfo!['role']!;
        final email = _userInfo!['email']!;
        final name = _userInfo!['name']!;
        final phone = _userInfo!['phone']!;

        return GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus(); // Ocultar el teclado al tocar en cualquier parte de la pantalla
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
                    nameUser: name,
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
                        },
                      ),
                    ],
                  ),
                  Expanded(
                    child: ListView.builder(
                      itemCount: _filteredBooks.length,
                      itemBuilder: (context, index) {
                        final book = _filteredBooks[index];
                        return Padding(
                          padding: const EdgeInsets.all(2.0),
                          child: GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => BookDetailPage(
                                    titleBaner: "Mi Libro",
                                    usuario: book,
                                    role: role,
                                    name: name,
                                    cantButton: 2,
                                  ),
                                ),
                              );
                            },
                            child: BookCard(
                              imageUrl: book.imageUrl,
                              title: book.title,
                              author: book.author,
                              date: book.date,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
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
