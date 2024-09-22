import 'package:flutter/material.dart';
import 'package:libreria_app/pages/register_libro_page.dart';
import 'package:libreria_app/services/api_service.dart';
import 'package:libreria_app/services/shared_preferences.dart';
import 'package:libreria_app/widgets/libros_tab.dart';
import 'package:libreria_app/widgets/perfil_tab.dart';
import 'package:libreria_app/widgets/prestamos_tab.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:web_socket_channel/status.dart' as status;
import 'dart:convert'; // Para manejar JSON

class UserLibrosDisponiblesPage extends StatefulWidget {
  final bool isAdminHistoric;
  final bool isUserHistoric;
  final bool isPrincipal;

  UserLibrosDisponiblesPage({
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
  final ApiService _apiService = ApiService(); // Crear una instancia de ApiService
  late WebSocketChannel _channel; // Agregar WebSocketChannel

  // Método para cargar los datos desde la API
  Future<void> _loadData() async {
    _userInfo = await LoadUserInfo();
    final email = _userInfo?['email'];

    final books = widget.isAdminHistoric
        ? await _apiService.fetchBookPrestados()
        : await _apiService.fetchBooks();

    // Verificar si el widget está montado antes de llamar a setState
    if (mounted) {
      setState(() {
        _books = books;
        _filteredBooks = books;
        _isDataLoaded = true;
      });
    }
  }

  // Método para conectar el WebSocket
  void _connectToWebSocket() {
    _channel = WebSocketChannel.connect(
      Uri.parse('ws://192.168.80.23:2026'), // Cambia la URL según sea necesario
    );

    _channel.stream.listen((message) {
      print('Mensaje recibido: $message');
      // Manejar el mensaje recibido
      final data = jsonDecode(message);
      if (data['tipo'] == 'actualizacion') {
        // Realiza la consulta a la API nuevamente si hay una actualización
        _loadData();
        print(data['mensaje']); // Opcional: imprimir el mensaje
      }
    }, onError: (error) {
      print('Error en WebSocket: $error');
    }, onDone: () {
      print('Conexión cerrada del WebSocket');
      // Reconectar si la conexión se cierra
      _connectToWebSocket();
    });
  }

  // Método para filtrar libros
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
    _loadData(); // Cargar datos de la API
    _connectToWebSocket(); // Conectar al WebSocket
    _showFloatingActionButton = _tabController.index == 0 &&
        !widget.isUserHistoric &&
        !widget.isAdminHistoric;
  }

  @override
  void dispose() {
    _tabController.dispose();
    _channel.sink.close(); // Cerrar el WebSocket al salir
    _overlayEntry?.remove();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Mostrar un indicador de carga mientras se cargan los datos
    if (!_isDataLoaded) {
      return const Center(child: CircularProgressIndicator());
    }

    // Si no se encontró información del usuario
    if (_userInfo == null) {
      return const Center(child: Text('No se encontraron datos'));
    }

    // Obtener datos del usuario
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
                  ? LibrosTab(
                      role: role,
                      email: email,
                      name: name,
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
                              name: name,
                              phone: phone,
                              filterBooks: _filterBooks,
                              filteredBooks: _filteredBooks,
                              isAdminHistoric: widget.isAdminHistoric,
                              isUserHistoric: widget.isUserHistoric,
                              selectedIcon: _selectedIcon,
                            ),
                            PrestamosTab(),
                            PerfilTab(
                              userName: name,
                              rolUser: role,
                              selectedIcon: _selectedIcon,
                              onIconChanged: (icon) => setState(() {
                                _selectedIcon = icon;
                                _tabController.index = 0;
                              }),
                            ),
                          ],
                        ),
                        bottomNavigationBar: TabBar(
                          controller: _tabController,
                          tabs: const [
                            Tab(icon: Icon(Icons.library_books), text: 'Libros'),
                            Tab(icon: Icon(Icons.book), text: 'Libros Prestados'),
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
}
