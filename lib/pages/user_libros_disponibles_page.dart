import 'package:flutter/material.dart';
import 'package:LibreriaApp/config/config.dart';
import 'package:LibreriaApp/models/user_model.dart';
import 'package:LibreriaApp/pages/register_libro_page.dart';
import 'package:LibreriaApp/services/api_service.dart';
import 'package:LibreriaApp/services/shared_preferences.dart';
import 'package:LibreriaApp/services/snack_bar_service.dart';
import 'package:LibreriaApp/widgets/custom_widgets.dart';
import 'package:LibreriaApp/widgets/libros_tab.dart';
import 'package:LibreriaApp/widgets/perfil_tab.dart';
import 'package:LibreriaApp/widgets/prestamos_tab.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'dart:convert'; 

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
  late IconData _selectedIcon;
  late String _selectedName;
  OverlayEntry? _overlayEntry;
  final GlobalKey _fabKey = GlobalKey();
  bool _showFloatingActionButton = false;
  final ApiService _apiService =
      ApiService(); 
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

  Future<void> _loadData() async {
    _userInfo = await LoadUserInfo();
    final email = _userInfo?['email'];

    final books = widget.isAdminHistoric
        ? await _apiService.fetchBookPrestados()
        : await _apiService.fetchBooks();

    if (mounted) {
      setState(() {
        _books = books;
        _filteredBooks = books;
        _isDataLoaded = true;
      });
    }
  }

  void _connectToWebSocket() {
    _channel = WebSocketChannel.connect(
      Uri.parse(AppConfig.wsUrl), 
    );

    _channel.stream.listen((message) {
      print('Mensaje recibido: $message');
      final data = jsonDecode(message);
      if (data['tipo'] == 'actualizacion') {
        _loadData();
      }
    }, onError: (error) {
      SnackBarService.showErrorSnackBar(context, 'Error en WebSocket: $error');
    }, onDone: () {
      _connectToWebSocket();
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
        _onTabChanged();
        setState(() {
          _showFloatingActionButton = _tabController.index == 0 &&
              !widget.isUserHistoric &&
              !widget.isAdminHistoric;
        });
      });
    _loadData();
    _connectToWebSocket(); 
    _showFloatingActionButton = _tabController.index == 0 &&
        !widget.isUserHistoric &&
        !widget.isAdminHistoric;
  }

  @override
  void dispose() {
    _tabController.dispose();
    _channel.sink.close(); 
    _overlayEntry?.remove();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!_isDataLoaded) {
      return const Center(
        child: SizedBox(
          width: 100,
          height: 100,
          child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(Colors.redAccent),
          ),
        ),
      );
    }

    if (_userInfo == null) {
      return const Center(child: Text('No se encontraron datos'));
    }

    final role = _userInfo!['role']!;
    final email = _userInfo!['email']!;
    final phone = _userInfo!['phone']!;

    _selectedIcon = GetIconFromString(_userInfo!['icono']!);
    _selectedName = _userInfo!['name']!;

    return KeyboardDismiss(
      child: SafeArea(
        child: Stack(
          children: [
            Scaffold(
              resizeToAvoidBottomInset: false,
              body: widget.isUserHistoric || widget.isAdminHistoric
                  ? LibrosTab(
                      role: role,
                      email: email,
                      name: _selectedName,
                      phone: phone,
                      filterBooks: _filterBooks,
                      filteredBooks: _filteredBooks,
                      isAdminHistoric: widget.isAdminHistoric,
                      isUserHistoric: widget.isUserHistoric,
                      selectedIcon: _selectedIcon,
                    )
                  : DefaultTabController(
                      length: 3,
                      child: Scaffold(
                        resizeToAvoidBottomInset: false,
                        body: TabBarView(
                          controller: _tabController,
                          children: [
                            LibrosTab(
                              role: role,
                              email: email,
                              name: _selectedName,
                              phone: phone,
                              filterBooks: _filterBooks,
                              filteredBooks: _filteredBooks,
                              isAdminHistoric: widget.isAdminHistoric,
                              isUserHistoric: widget.isUserHistoric,
                              selectedIcon: _selectedIcon,
                            ),
                            const PrestamosTab(),
                            PerfilTab(
                              userName: _selectedName,
                              rolUser: role,
                              emailUser: email,
                              selectedIcon:
                                  _selectedIcon, // Usa el IconData convertido
                              onIconChanged: (icon) => setState(() {
                                _selectedIcon =
                                    icon; // Actualiza el icono seleccionado
                                _tabController.index = 0;
                              }),
                            ),
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
            // Botón flotante para agregar un libro
            if (_showFloatingActionButton)
              Positioned(
                bottom: 95.0,
                right: 30.0,
                child: FloatingActionButton(
                  key: _fabKey,
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => RegisterLibroPage(
                          name: _selectedName,
                          rol: role,
                          selectedIcon: _selectedIcon,
                        ),
                      ),
                    );
                  },
                  backgroundColor: Colors.redAccent,
                  child: const Icon(Icons.add, color: Colors.white, size: 40.0),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
