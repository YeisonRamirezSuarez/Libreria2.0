import 'package:flutter/material.dart';
import 'package:libreria_app/models/usuario_model.dart';
import 'package:libreria_app/pages/user_libros_disponibles_page.dart';
import 'package:libreria_app/services/api_service.dart';
import 'package:libreria_app/services/shared_preferences.dart';
import 'package:libreria_app/widgets/mis_libros_tab.dart';
import 'package:libreria_app/widgets/perfil_tab.dart';

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

  final ApiService _apiService = ApiService(); 


  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
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
    final books = await _apiService.fetchBookForUser(email);
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
    if (!_isDataLoaded) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_userInfo == null) {
      return const Center(child: Text('No data found'), );
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
              _buildMisLibrosTab(context, role, name),
               UserLibrosDisponiblesPage(isUserHistoric: true),
              _buildPerfilTab(context, name, role),
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
  }

  Widget _buildMisLibrosTab(BuildContext context, String role, String name) {
    return MisLibrosTab(
      books: _filteredBooks,
      role: role,
      name: name,
      filterCallback: _filterBooks,
      selectedIcon: _selectedIcon,
    );
  }

  Widget _buildPerfilTab(BuildContext context, String userName, String rolUser) {
    return PerfilTab(
      userName: userName,
      rolUser: rolUser,
      selectedIcon: _selectedIcon,
      onIconChanged: (IconData icon) {
        setState(() {
          _selectedIcon = icon;
          _tabController.index = 0;
        });
      },
    );
  }
}
