import 'package:flutter/material.dart';
import 'package:LibreriaApp/config/config.dart';
import 'package:LibreriaApp/models/user_model.dart';
import 'package:LibreriaApp/models/usuario_model.dart';
import 'package:LibreriaApp/pages/user_libros_disponibles_page.dart';
import 'package:LibreriaApp/services/api_service.dart';
import 'package:LibreriaApp/services/shared_preferences.dart';
import 'package:LibreriaApp/widgets/custom_widgets.dart';
import 'package:LibreriaApp/widgets/mis_libros_tab.dart';
import 'package:LibreriaApp/widgets/perfil_tab.dart';
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
  late String _selectedName;
  final ApiService _apiService = ApiService();
  late WebSocketChannel _channel;

  void _onTabChanged() async {
    if (_tabController.index == 2) {
      return;
    }
    await _loadUserInfo();
    setState(() {
      _selectedIcon = GetIconFromString(_userInfo!['icono']!);
      _selectedName = _userInfo!['name']!;
    });
  }

  Future<void> _loadUserInfo() async {
    _userInfo = await LoadUserInfo();
  }

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this)
      ..addListener(() {
        _onTabChanged();
      });
    _loadData();
    _connectToWebSocket();
  }

  @override
  void dispose() {
    _tabController.dispose();
    _channel.sink.close();
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
      _selectedIcon =
          GetIconFromString(_userInfo!['icono']!); 
    });
  }

  void _connectToWebSocket() {
    _channel = WebSocketChannel.connect(
      Uri.parse(AppConfig.wsUrl),
    );

    _channel.stream.listen((message) {
      final data = jsonDecode(message);
      if (data['tipo'] == 'actualizacion') {
        _loadData(); 
      }
    }, onError: (error) {
      print('Error en WebSocket: $error');
    }, onDone: () {
      _connectToWebSocket(); 
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

  @override
  Widget build(BuildContext context) {
    if (!_isDataLoaded) {
      return const Center(
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(Colors.redAccent),
        ),
      );
    }

    if (_userInfo == null) {
      return const Center(
        child: Text('No data found'),
      );
    }

    final role = _userInfo!['role']!;
    final email = _userInfo!['email']!;

    _selectedIcon = GetIconFromString(_userInfo!['icono']!);
    _selectedName = _userInfo!['name']!;

    return KeyboardDismiss(
      child: SafeArea(
        child: Scaffold(
          body: TabBarView(
            controller: _tabController,
            children: [
              _buildMisLibrosTab(context, role),
              const UserLibrosDisponiblesPage(isUserHistoric: true),
              _buildPerfilTab(context, role, email),
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

  Widget _buildMisLibrosTab(BuildContext context, String role) {
    return MisLibrosTab(
      books: _filteredBooks,
      role: role,
      name: _selectedName,
      filterCallback: _filterBooks,
      selectedIcon: _selectedIcon,
    );
  }

  Widget _buildPerfilTab(BuildContext context, String rolUser, String email) {
    return PerfilTab(
      userName: _selectedName,
      rolUser: rolUser,
      emailUser: email,
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
