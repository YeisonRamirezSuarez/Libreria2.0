import 'package:flutter/material.dart';
import 'package:libreria_app/config/config.dart';
import 'package:libreria_app/models/usuario_model.dart';
import 'package:libreria_app/pages/user_libros_disponibles_page.dart';
import 'package:libreria_app/services/api_service.dart';
import 'package:libreria_app/services/shared_preferences.dart';
import 'package:libreria_app/widgets/mis_libros_tab.dart';
import 'package:libreria_app/widgets/perfil_tab.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'dart:convert';

class UserPrestadoPage extends StatefulWidget {
  final bool isPrincipal;
  const UserPrestadoPage({super.key, this.isPrincipal = false});

  @override
  _UserPrestadoPageState createState() => _UserPrestadoPageState();
}

class _UserPrestadoPageState extends State<UserPrestadoPage>
    with SingleTickerProviderStateMixin {
  Map<String, String>? _userInfo;
  List<Usuario>? _books;
  List<Usuario> _filteredBooks = [];
  bool _isDataLoaded = false;
  String _searchQuery = '';
  late TabController _tabController;
  late IconData _selectedIcon;

  final ApiService _apiService = ApiService();
  late WebSocketChannel _channel;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _loadData();
    _connectToWebSocket();
  }

  @override
  void dispose() {
    _tabController.dispose();
    _channel.sink.close(); // Cerrar el WebSocket
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
      _selectedIcon = getIconFromString(_userInfo!['icono']!); // Asignar icono aquí
    });
  }

  void _connectToWebSocket() {
    _channel = WebSocketChannel.connect(
      Uri.parse(AppConfig.wsUrl),
    );

    _channel.stream.listen((message) {
      final data = jsonDecode(message);
      if (data['tipo'] == 'actualizacion') {
        _loadData(); // Actualiza datos si hay un mensaje de actualización
      }
    }, onError: (error) {
      print('Error en WebSocket: $error');
    }, onDone: () {
      _connectToWebSocket(); // Reconectar si la conexión se cierra
    });
  }

  void _filterBooks(String query) {
    setState(() {
      _searchQuery = query.toLowerCase();
      _filteredBooks = _books!.where((book) {
        final titleLower = book.title.toLowerCase();
        final authorLower = book.author.toLowerCase();
        return titleLower.contains(_searchQuery) ||
            authorLower.contains(_searchQuery);
      }).toList();
    });
  }

  IconData getIconFromString(String iconString) {
    switch (iconString) {
      case 'Icons.person':
        return Icons.person;
      case 'Icons.account_circle':
        return Icons.account_circle;
      case 'Icons.face':
        return Icons.face;
      case 'Icons.people':
        return Icons.people;
      case 'Icons.supervised_user_circle':
        return Icons.supervised_user_circle;
      case 'Icons.group':
        return Icons.group;
      case 'Icons.business':
        return Icons.business;
      case 'Icons.work':
        return Icons.work;
      case 'Icons.person_add':
        return Icons.person_add;
      case 'Icons.person_remove':
        return Icons.person_remove;
      case 'Icons.contact_mail':
        return Icons.contact_mail;
      case 'Icons.contact_phone':
        return Icons.contact_phone;
      case 'Icons.email':
        return Icons.email;
      case 'Icons.phone':
        return Icons.phone;
      case 'Icons.card_membership':
        return Icons.card_membership;
      case 'Icons.badge':
        return Icons.badge;
      case 'Icons.security':
        return Icons.security;
      case 'Icons.lock':
        return Icons.lock;
      case 'Icons.vpn_key':
        return Icons.vpn_key;
      case 'Icons.help':
        return Icons.help;
      case 'Icons.info':
        return Icons.info;
      default:
        return Icons.person; // Valor por defecto si no coincide
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!_isDataLoaded) {
      return const Center(
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(Colors.redAccent),
          strokeWidth: 8,
        ),
      );
    }

    if (_userInfo == null) {
      return const Center(
        child: Text('No data found'),
      );
    }

    final role = _userInfo!['role']!;
    final name = _userInfo!['name']!;
    final email = _userInfo!['email']!;
    final icono = _userInfo!['icono']!;
  
    // _selectedIcon se inicializa en _loadData

    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: SafeArea(
        child: Scaffold(
          body: TabBarView(
            controller: _tabController,
            children: [
              _buildMisLibrosTab(context, role, name, _selectedIcon),
              const UserLibrosDisponiblesPage(isUserHistoric: true),
              _buildPerfilTab(context, name, role, email, _selectedIcon),
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

  Widget _buildMisLibrosTab(BuildContext context, String role, String name, IconData icono) {
    return MisLibrosTab(
      books: _filteredBooks,
      role: role,
      name: name,
      filterCallback: _filterBooks,
      selectedIcon: _selectedIcon,
    );
  }

  Widget _buildPerfilTab(
      BuildContext context, String userName, String rolUser, String email, IconData icono) {
    return PerfilTab(
      userName: userName,
      rolUser: rolUser,
      emailUser: email,
      selectedIcon: _selectedIcon,
      onIconChanged: (IconData icon) {
        setState(() {
          _selectedIcon = icon; // Actualiza el icono seleccionado
          _tabController.index = 0; // Cambia a la pestaña de "Mis Libros"
        });
      },
    );
  }
}
