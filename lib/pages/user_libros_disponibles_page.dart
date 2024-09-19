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
import 'package:libreria_app/widgets/edit_user_dialog.dart';

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

class _UserLibrosDisponiblesPageState extends State<UserLibrosDisponiblesPage>
    with SingleTickerProviderStateMixin {
  Map<String, String>? _userInfo;
  List<dynamic>? _books;
  List<dynamic> _filteredBooks = [];
  bool _isDataLoaded = false;
  late TabController _tabController;
  late IconData _selectedIcon = Icons.person;
  OverlayEntry? _overlayEntry;
  final GlobalKey _fabKey = GlobalKey();
  bool _showFloatingActionButton = false;

  Future<void> _loadData() async {
    _userInfo = await LoadUserInfo();
    final email = _userInfo?['email']!;

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
    _tabController = TabController(length: 3, vsync: this)
      ..addListener(() {
        setState(() {
          _showFloatingActionButton = _tabController.index == 0 &&
              !widget.isUserHistoric &&
              !widget.isAdminHistoric;
        });
      });
    _loadData();

    // Aseguramos que el botón se muestre solo si la pestaña inicial es 0 y no es una pantalla histórica
    _showFloatingActionButton = _tabController.index == 0 &&
        !widget.isUserHistoric &&
        !widget.isAdminHistoric;
  }

  @override
  void dispose() {
    _tabController.dispose();
    _overlayEntry?.remove(); // Remove overlay if it's active
    super.dispose();
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
        child: Stack(
          children: [
            Scaffold(
              resizeToAvoidBottomInset: false,
              body: widget.isUserHistoric || widget.isAdminHistoric
                  ? _buildLibrosTab(context, role, email, name, phone)
                  : DefaultTabController(
                      length: 3,
                      child: Scaffold(
                        resizeToAvoidBottomInset: false,
                        body: TabBarView(
                          controller: _tabController,
                          children: [
                            _buildLibrosTab(context, role, email, name, phone),
                            _buildPrestamosTab(context),
                            _buildPerfilTab(context, name, role),
                          ],
                        ),
                        bottomNavigationBar: TabBar(
                          controller: _tabController,
                          tabs: const [
                            Tab(
                                icon: Icon(Icons.library_books),
                                text: 'Libros'),
                            Tab(
                                icon: Icon(Icons.book),
                                text: 'Libros Prestados'),
                            Tab(icon: Icon(Icons.person), text: 'Perfil'),
                          ],
                          labelColor: Colors.redAccent,
                          unselectedLabelColor: Colors.grey,
                          indicatorColor: Colors.redAccent,
                        ),
                      ),
                    ),
            ),
            if (_showFloatingActionButton)
              Positioned(
                bottom: 95.0, // Adjust this value to move the button up or down
                right:
                    30.0, // Adjust this value to move the button left or right
                child: FloatingActionButton(
                  key: _fabKey,
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => RegisterLibroPage(
                          name: name,
                          rol: role,
                          selectedIcon: _selectedIcon,
                        ),
                      ),
                    );
                  },
                  child: Icon(Icons.add, color: Colors.white, size: 40.0),
                  backgroundColor: Colors.redAccent,
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildLibrosTab(BuildContext context, String role, String email,
      String name, String phone) {
    return Column(
      children: [
        ItemBannerUser(
          viewAdd: false,
          seaching: true,
          titleBaner: role == 'administrador' && widget.isAdminHistoric
              ? 'Libros Prestados'
              : 'Libros Disponibles',
          rolUser: role,
          nameUser: name,
          viewVolver: false,
          searchCallback: _filterBooks,
          selectedIcon: _selectedIcon,
        ),
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
      isAdminHistoric: true,
    );
  }

  Widget _buildPerfilTab(
      BuildContext context, String _userName, String _rolUser) {
    List<IconData> availableIcons = const [
      Icons.person,
      Icons.account_circle,
      Icons.face,
      Icons.people,
      Icons.supervised_user_circle,
      Icons.group,
      Icons.business,
      Icons.work,
      Icons.person_add,
      Icons.person_remove,
      Icons.contact_mail,
      Icons.contact_phone,
      Icons.email,
      Icons.phone,
      Icons.card_membership,
      Icons.badge,
      Icons.security,
      Icons.lock,
      Icons.vpn_key,
      Icons.help,
      Icons.info,
    ];

    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: Column(
              children: [
                ItemBannerUser(
                  viewAdd: false,
                  seaching: false,
                  nameUser: _userName,
                  titleBaner: "Editar Perfil",
                  rolUser: _rolUser,
                  selectedIcon: _selectedIcon,
                  viewVolver: false,
                  viewLogout: true,
                ),
                Expanded(
                  child: UserEditWidget(
                    availableIcons: availableIcons,
                    initialName: _userName,
                    selectedIcon: Icons.person,
                    onSave: (IconData icon, String name) {
                      setState(() {
                        _userName = name;
                        _selectedIcon = icon;
                        _tabController.index = 0;
                      });
                    },
                    onCancel: () {
                      setState(() {
                        _tabController.index = 0;
                      });
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
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
                selectedIcon: _selectedIcon,
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
          final double imageSize = cardWidth * 0.6;

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
              padding: const EdgeInsets.all(8.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  ImageWidget(
                    imageUrl: usuario.imageUrl,
                    height: imageSize,
                    width: imageSize,
                  ),
                  const SizedBox(height: 4.0),
                  Text(
                    usuario.title,
                    style: TextStyle(
                      fontSize: cardWidth * 0.08,
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
                      fontSize: cardWidth * 0.06,
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
