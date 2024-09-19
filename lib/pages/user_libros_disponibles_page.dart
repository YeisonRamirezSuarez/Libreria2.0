import 'package:flutter/material.dart';
import 'package:libreria_app/models/book_model.dart';
import 'package:libreria_app/models/usuario_model.dart';
import 'package:libreria_app/pages/update_libro_page.dart';
import 'package:libreria_app/pages/user_detalle_libro.dart';
import 'package:libreria_app/pages/register_libro_page.dart';
import 'package:libreria_app/pages/login_page.dart';
import 'package:libreria_app/pages/user_detalle_libro_history.dart';
import 'package:libreria_app/services/api_services.dart';
import 'package:libreria_app/services/shared_preferences.dart';
import 'package:libreria_app/widgets/custom_widgets.dart';

class UserLibrosDisponiblesPage extends StatefulWidget {
  final bool isAdminHistoric;
  final bool isUserHistoric;
  final bool isPrincipal;

  const UserLibrosDisponiblesPage({
    super.key,
    this.isAdminHistoric = false,
    this.isUserHistoric = false,
    this.isPrincipal = false,
  });

  @override
  _UserLibrosDisponiblesPageState createState() =>
      _UserLibrosDisponiblesPageState();
}

class _UserLibrosDisponiblesPageState extends State<UserLibrosDisponiblesPage> {
  Map<String, String>? _userInfo;
  List<dynamic>? _books;
  List<dynamic> _filteredBooks = [];
  bool _isDataLoaded = false;

  Future<void> _loadData() async {
    // Cargar la información del usuario
    _userInfo = await LoadUserInfo();
    final email = _userInfo?['email']!;

    // Cargar los libros según el rol y la condición
    final books = widget.isAdminHistoric
        ? await ApiService.fetchBookPrestados()
        : await ApiService.fetchBooks();

    setState(() {
      _books = books;
      _filteredBooks = books;
      _isDataLoaded = true;
    });
  }

  void _filterBooks(String query) {
    setState(() {
      final searchQuery = query.toLowerCase();
      _filteredBooks = _books?.where((book) {
            final titleLower = book.title.toLowerCase();
            final authorLower = book.author.toLowerCase();
            return titleLower.contains(searchQuery) ||
                authorLower.contains(searchQuery);
          }).toList() ??
          [];
    });
  }

  @override
  void initState() {
    super.initState();
    _loadData(); // Cargar los datos cuando se inicializa el estado
  }

  @override
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

    // Siempre envolver en Scaffold
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: SafeArea(
        child: Scaffold(
          body: widget.isUserHistoric || widget.isAdminHistoric
              ? _buildLibrosTab(context, role, email, name, phone)
              : DefaultTabController(
                  length: 3, // Define el número de pestañas
                  child: Scaffold(
                    body: TabBarView(
                      children: [
                        _buildLibrosTab(context, role, email, name, phone),
                        _buildPrestamosTab(context),
                        _buildAgregarLibroTab(context, role, name),
                        //const Center(child: Text('Perfil')), // Perfil del usuario
                      ],
                    ),
                    bottomNavigationBar: const TabBar(
                      tabs: [
                        Tab(icon: Icon(Icons.book), text: 'Libros'),
                        Tab(icon: Icon(Icons.history), text: 'Prestados'),
                        Tab(icon: Icon(Icons.add), text: 'Agregar Libro'),
                        //Tab(icon: Icon(Icons.person), text: 'Perfil'),
                      ],
                      labelColor:
                          Colors.redAccent, // Color de la pestaña seleccionada
                      unselectedLabelColor:
                          Colors.grey, // Color de las pestañas no seleccionadas
                      indicatorColor: Colors.redAccent, // Color del indicador
                    ),
                  ),
                ),
        ),
      ),
    );
  }

  Widget _buildLibrosTab(BuildContext context, String role, String email,
      String name, String phone) {
    return Column(
      children: [
        ItemBannerUser(
            isPrincipal: widget.isPrincipal,
            estadoUsuario: role == 'administrador' && !widget.isAdminHistoric,
            seaching: true,
            titleBaner: role == 'administrador' && widget.isAdminHistoric
                ? 'Libros Prestados'
                : 'Libros Disponibles',
            rolUser: role,
            nameUser: name,
            removerOption: (widget.isAdminHistoric && role == 'administrador')
                ? true
                : false,
            searchCallback: _filterBooks, // Callback de búsqueda
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
            ]),
        Expanded(
          child: GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
              childAspectRatio: 0.85,
            ),
            itemCount: _filteredBooks.length,
            itemBuilder: (context, index) {
              final libro = _filteredBooks[index];
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
                cantidad: (role == 'administrador' && widget.isAdminHistoric)
                    ? ''
                    : libro.quantity,
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildPrestamosTab(BuildContext context) {
    return const UserLibrosDisponiblesPage(
      isAdminHistoric: true, // Cargar la página de libros prestados
    );
  }

  Widget _buildAgregarLibroTab(BuildContext context, String role, String name) {
    return RegisterLibroPage(
      name: name,
      rol: role,
    );
  }
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
        // Use constraints to calculate responsive sizes based on the available width
        final double cardWidth = constraints.maxWidth;
        final double imageSize =
            cardWidth * 0.6; // Adjust image size based on card width

        return Container(
          margin: const EdgeInsets.all(12.0),
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
            padding: const EdgeInsets.all(
                8.0), // Use smaller padding to avoid overflow
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                ImageWidget(
                  imageUrl: usuario.imageUrl,
                  height:
                      imageSize, // Set image height relative to the card width
                  width:
                      imageSize, // Set image width relative to the card width
                ),
                const SizedBox(height: 4.0),
                Text(
                  usuario.title,
                  style: TextStyle(
                    fontSize: cardWidth *
                        0.08, // Adjust font size based on card width
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                  textAlign: TextAlign.center,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                ),
                const SizedBox(height: 1.0),
                Text(
                  usuario.author,
                  style: TextStyle(
                    fontSize: cardWidth *
                        0.06, // Adjust font size based on card width
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
