import 'package:flutter/material.dart';
import 'package:libreria_app/config/config.dart';
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
  OverlayEntry? _overlayEntry;
  final GlobalKey _fabKey = GlobalKey();
  bool _showFloatingActionButton = false;
  final ApiService _apiService =
      ApiService(); // Crear una instancia de ApiService
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
      Uri.parse(AppConfig.wsUrl), // Cambia la URL según sea necesario
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

  IconData getIconFromString(String iconString) {
    print('iconString: $iconString');
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
    // Mostrar un indicador de carga mientras se cargan los datos
    if (!_isDataLoaded) {
      return const Center(
        child: SizedBox(
          width: 100,
          height: 100,
          child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(Colors.redAccent),
            strokeWidth: 8,  // Ajusta el grosor del borde
          ),
        ),
      );
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
    final icono = _userInfo!['icono']!;

    _selectedIcon = getIconFromString(icono);

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
                            const PrestamosTab(),
                            PerfilTab(
                                userName: name,
                                rolUser: role,
                                emailUser: email,
                                selectedIcon: _selectedIcon, // Usa el IconData convertido
                                onIconChanged: (icon) => setState(() {
                                  _selectedIcon = icon; // Actualiza el icono seleccionado
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
