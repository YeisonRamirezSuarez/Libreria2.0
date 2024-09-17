import 'package:flutter/material.dart';
import 'package:libreria_app/models/book_model.dart';
import 'package:libreria_app/models/usuario_model.dart';
import 'package:libreria_app/pages/user_detalle_libro.dart';
import 'package:libreria_app/pages/register_libro_page.dart';
import 'package:libreria_app/pages/login_page.dart';
import 'package:libreria_app/pages/update_libro_page.dart';
import 'package:libreria_app/pages/user_detalle_libro_history.dart';
import 'package:libreria_app/services/api_services.dart';
import 'package:libreria_app/services/shared_preferences.dart';
import 'package:libreria_app/widgets/custom_widgets.dart';

class UserLibrosDisponiblesPage extends StatefulWidget {
  final bool isAdminHistoric;
  final bool isUserHistoric;

  const UserLibrosDisponiblesPage(
      {super.key, this.isAdminHistoric = false, this.isUserHistoric = false});

  @override
  _UserLibrosDisponiblesPageState createState() =>
      _UserLibrosDisponiblesPageState();
}

class _UserLibrosDisponiblesPageState extends State<UserLibrosDisponiblesPage> {
  Map<String, String>? _userInfo;
  List<dynamic>? _libros;
  bool _isDataLoaded = false;

  Future<void> _loadData() async {
    // Cargar la información del usuario
    _userInfo = await LoadUserInfo();
    final email = _userInfo?['email']!;

    // Cargar los libros según el rol y la condición
    final libros = widget.isAdminHistoric
        ? await ApiService.fetchBookPrestados()
        : await ApiService.fetchBooks();

    setState(() {
      _libros = libros;
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
                titleBaner: role == 'administrador' && widget.isAdminHistoric
                    ? 'Libros Prestados'
                    : 'Libros Disponibles',
                rolUser: role,
                nameUser: name,
                options: role == 'administrador' && !widget.isAdminHistoric
                    ? [
                        Option(
                          icon: const Icon(Icons.book),
                          title: 'Libros Prestados',
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => UserLibrosDisponiblesPage(
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
                                  name: name,
                                  rol: role,
                                ),
                              ),
                            );

                            if (result == true) {
                              setState(() {
                                _loadData(); // Recargar datos si se agregó un nuevo libro
                              });
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
                                builder: (context) => const LoginScreen(),
                              ),
                            );
                          },
                        ),
                      ]
                    : [],
              ),
              Expanded(
                child: GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                    childAspectRatio: 0.85,
                  ),
                  itemCount: _libros?.length ?? 0,
                  itemBuilder: (context, index) {
                    final libro = _libros![index];
                    final usuario = libro is Usuario
                        ? libro
                        : Usuario(
                            idBook: libro.id.toString(),
                            title: libro.title,
                            author: libro.author,
                            bookUrl: libro.bookUrl,
                            imageUrl: libro.imageUrl,
                            description: libro.description,
                            date: '',
                            emailUser: email,
                            nameUser: name,
                            phoneUser: phone,
                          );

                    return libroCard(
                      context,
                      usuario,
                      isAdminHistoric: widget.isAdminHistoric,
                      isUserHistoric: widget.isUserHistoric,
                      role: role,
                      name: name,
                      cantidad:
                          (role == 'administrador' && widget.isAdminHistoric)
                              ? ''
                              : libro.quantity,
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget libroCard(
    BuildContext context,
    Usuario usuario, {
    bool isAdminHistoric = false,
    bool isUserHistoric = false,
    required String role,
    required String name,
    required String cantidad,
  }) {
    return GestureDetector(
      onTap: () {
        if (isAdminHistoric) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => BookDetailHistoryPage(
                usuario: usuario,
                role: role,
                name: name,
              ),
            ),
          );
        } else if (!isAdminHistoric && role == 'administrador') {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => UpdateLibroPage(
                name: name,
                rol: role,
                cantidadLibro: cantidad,
                usuario: usuario,
              ),
            ),
          );
        } else if (isUserHistoric) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => BookDetailPage(
                usuario: usuario,
                titleBaner: 'Prestar Libro',
                role: role,
                name: name,
                cantButton: 1,
              ),
            ),
          );
        }
      },
      child: LayoutBuilder(
        builder: (context, constraints) {
          final double cardWidth = constraints.maxWidth;

          return Container(
            margin: const EdgeInsets.all(8.0),
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
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  ImageWidget(
                    imageUrl: usuario.imageUrl,
                    height: cardWidth *
                        0.6, // Ajusta el tamaño en función del ancho del Card
                    width: cardWidth * 0.6,
                  ),
                  const SizedBox(height: 8.0),
                  Text(
                    usuario.title,
                    style: const TextStyle(
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                    textAlign: TextAlign.center,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                  const SizedBox(height: 4.0),
                  Text(
                    usuario.author,
                    style: TextStyle(
                      fontSize: 14.0,
                      color: Colors.grey[600],
                    ),
                    textAlign: TextAlign.center,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
