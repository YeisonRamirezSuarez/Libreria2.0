import 'package:flutter/material.dart';
import 'package:libreria_app/models/usuario_model.dart';
import 'package:libreria_app/pages/login_page.dart';
import 'package:libreria_app/pages/user_detalle_libro.dart';
import 'package:libreria_app/pages/user_libros_disponibles_page.dart';
import 'package:libreria_app/services/api_services.dart';
import 'package:libreria_app/services/shared_preferences.dart';
import 'package:libreria_app/widgets/custom_widgets.dart';
import 'package:libreria_app/widgets/edit_user_dialog.dart';

class UserPrestadoPage extends StatefulWidget {
  final bool isPrincipal;
  const UserPrestadoPage({super.key, this.isPrincipal = false});

  @override
  _UserPrestadoPageState createState() => _UserPrestadoPageState();
}

class _UserPrestadoPageState extends State<UserPrestadoPage> with SingleTickerProviderStateMixin {
  Map<String, String>? _userInfo;
  List<Usuario>? _books;
  List<Usuario> _filteredBooks = [];
  bool _isDataLoaded = false;
  String _searchQuery = '';
  late TabController _tabController;
  IconData _selectedIcon = Icons.person;


  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this); // TabController para manejar las pestañas
    _loadData();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _loadData() async {
    _userInfo = await LoadUserInfo();
    final String email = _userInfo!['email']!;
    final books = await ApiService.fetchBookForUser(email);
    setState(() {
      _books = books;
      _filteredBooks = books;
      _isDataLoaded = true;
    });
  }

  void _filterBooks(String query) {
    setState(() {
      _searchQuery = query.toLowerCase();
      _filteredBooks = _books!.where((book) {
        final titleLower = book.title.toLowerCase();
        final authorLower = book.author.toLowerCase();
        return titleLower.contains(_searchQuery) || authorLower.contains(_searchQuery);
      }).toList();
    });
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
        final name = _userInfo!['name']!;

        return GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
          },
          child: SafeArea(
            child: Scaffold(
              body: TabBarView(
                controller: _tabController,
                children: [
                  _buildMisLibrosTab(context, role, name), // Pestaña "Mi Libro"
                  const UserLibrosDisponiblesPage(isUserHistoric: true), // Pestaña "Libros Disponibles"
                  _buildPerfilTab(context, name, role), // Pestaña "Perfil"
                ],
              ),
              bottomNavigationBar: BottomAppBar(
                color: Colors.black,
            
                child: TabBar(
                  
                  controller: _tabController,
                  tabs: const [
                    Tab(icon: Icon(Icons.book), text: 'Mis Libros'),
                    Tab(icon: Icon(Icons.library_books), text: 'Prestar Libros'),
                    Tab(icon: Icon(Icons.person), text: 'Perfil'),
                  ],
                  labelColor: Colors.redAccent,
                  unselectedLabelColor: Colors.grey,
                  indicatorColor: Colors.redAccent,
                ),
                
              ),
              
            ),
          ),
        );
      },
    );
  }

  // Contenido de la pestaña "Mi Libro"
  Widget _buildMisLibrosTab(BuildContext context, String role, String name) {
    return Column(
      children: <Widget>[
        ItemBannerUser(
          viewAdd: false,
          viewVolver: false,
          seaching: true,
          titleBaner: "Mis Libros Prestados",
          rolUser: role,
          nameUser: name,
          searchCallback: _filterBooks,
          selectedIcon: _selectedIcon,
        ),
        Expanded(
          child: ListView.builder(
            itemCount: _filteredBooks.length,
            itemBuilder: (context, index) {
              final book = _filteredBooks[index];
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 0.5),
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
      ],
    );
  }

  
   Widget _buildPerfilTab(BuildContext context, String _userName, String _rolUser) {
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
}