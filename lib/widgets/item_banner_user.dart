import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart'; // Asegúrate de importar Cupertino
import 'package:http/http.dart' as http;
import 'package:libreria_app/models/api_response.dart';
import 'package:libreria_app/pages/login_page.dart';
import 'package:libreria_app/pages/user_libros_disponibles_page.dart';
import 'package:libreria_app/services/api_services.dart';
import 'package:libreria_app/services/dialog_service.dart';

class ItemBannerUser extends StatefulWidget {
  final bool viewAdd; // Estado del usuario
  final bool seaching;
  final bool deleteBook;
  final String titleBaner;
  final String rolUser;
  String nameUser; // Cambiado a mutable
  final List<Option> options; // Lista de opciones
  final String idLibro;
  final Function(String)? searchCallback; // Callback para la búsqueda
  final bool removerBanner;
  final bool viewVolver;
  final bool viewLogout;
  IconData selectedIcon;

  ItemBannerUser({
    super.key,
    this.viewAdd = false,
    this.seaching = false,
    this.deleteBook = false,
    this.titleBaner = 'Titulo del Banner',
    this.rolUser = 'Rol de Usuario',
    required this.nameUser, // Requiere un nombre inicial
    this.options = const [],
    this.idLibro = '0',
    this.searchCallback,
    this.removerBanner = false,
    this.viewVolver = false,
    this.selectedIcon = Icons.person,
    this.viewLogout = false,
  });

  @override
  _ItemBannerUserState createState() => _ItemBannerUserState();
}

class _ItemBannerUserState extends State<ItemBannerUser> {
  late FocusNode _searchFocusNode;
  final TextEditingController _searchController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  OverlayEntry? _overlayEntry;
  final GlobalKey _iconKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    _searchFocusNode = FocusNode();
    _nameController.text = widget.nameUser;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      FocusScope.of(context).unfocus();
    });

    _searchController.addListener(() {
      if (widget.searchCallback != null) {
        widget.searchCallback!(
            _searchController.text); // Llama al callback cuando cambia el texto
      }
    });
  }

  @override
  void dispose() {
    _searchFocusNode.dispose();
    _searchController.dispose();
    _nameController.dispose();
    _overlayEntry?.remove();
    super.dispose();
  }

  Future<void> _deleteLibro() async {
    try {
      final response = await ApiService.deleteLibro(widget.idLibro.toString());

      if (response.success) {
        DialogService.showSuccessSnackBar(
            context, 'Libro eliminado exitosamente');
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) =>
                  const UserLibrosDisponiblesPage(isPrincipal: true)),
        );
      } else {
        DialogService.showErrorSnackBar(
            context, response.error ?? 'Error desconocido');
      }
    } catch (error) {
      DialogService.showErrorSnackBar(context, 'Error de red: $error');
    }
  }

  void _showOverlay() {
    if (_overlayEntry != null) {
      _overlayEntry!.remove();
      _overlayEntry = null;
    } else {
      final RenderBox renderBox =
          _iconKey.currentContext!.findRenderObject() as RenderBox;
      final Offset offset = renderBox.localToGlobal(Offset.zero);

      _overlayEntry = OverlayEntry(
        builder: (context) => Stack(
          children: [
            // Fondo oscuro que cubre el resto de la pantalla
            GestureDetector(
              onTap: () {
                _overlayEntry?.remove(); // Cierra el menú emergente
                _overlayEntry = null;
              },
              child: Container(
                color: Colors.black54, // Color de fondo semitransparente
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
              ),
            ),
            // Menú emergente
            Positioned(
              left: offset.dx -
                  140, // Ajusta esta posición para que el menú esté a la izquierda del ícono
              top: offset.dy,
              width: 200,
              child: Material(
                color: Colors.transparent,
                child: ClipRRect(
                  borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(10.0),
                      bottomLeft:
                          Radius.circular(10.0)), // Ajusta el radio del círculo
                  child: Container(
                    color: Colors.redAccent,
                    width: 180, // Ajusta el ancho del menú
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: widget.options.map((option) {
                        return ListTile(
                          leading: option.icon,
                          iconColor: Colors.white,
                          title: Text(option.title,
                              style: const TextStyle(color: Colors.white)),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      );

      Overlay.of(context)!.insert(_overlayEntry!);
    }
  }

  @override
  Widget build(BuildContext context) {
    return FocusScope(
      node: FocusScopeNode(),
      child: SingleChildScrollView(
        child: Container(
          width: double.infinity,
          color: Colors.black,
          padding: const EdgeInsets.all(12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              if (!widget.removerBanner)
                Container(
                  color: Colors.black,
                  child: Row(
                    children: <Widget>[
                      CircleAvatar(
                        radius: 30.0,
                        backgroundColor: Colors.grey[200],
                        child: Icon(
                          widget.selectedIcon,
                          size: 30,
                          color: Colors.black,
                        ),
                      ),
                      const SizedBox(width: 20.0),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              widget.rolUser,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 18.0,
                              ),
                            ),
                            Text(
                              widget.nameUser,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 15.0,
                              ),
                            ),
                          ],
                        ),
                      ),
                      if (widget.viewAdd)
                        GestureDetector(
                          key: _iconKey,
                          onTap: () => _showOverlay(),
                          child: const Icon(
                            Icons.add,
                            size: 50.0,
                            color: Colors.redAccent,
                          ),
                        )
                      else if (widget.viewVolver)
                        IconButton(
                          icon: const Icon(Icons.arrow_back),
                          iconSize: 50.0,
                          color: Colors.redAccent,
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          tooltip: 'Volver',
                        )
                      else if (widget.viewLogout)
                        IconButton(
                          icon: const Icon(Icons.logout,
                              color: Colors.redAccent, size: 50),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const LoginScreen()),
                            );
                          },
                          tooltip: 'Cerrar Sesión',

                        )
                    ],
                  ),
                ),
              const SizedBox(height: 10.0),
              Visibility(
                visible: widget.seaching,
                child: TextField(
                  focusNode: _searchFocusNode,
                  controller: _searchController,
                  decoration: InputDecoration(
                    hintText: 'Buscar por nombre o autor',
                    prefixIcon: const Icon(Icons.search),
                    suffixIcon: GestureDetector(
                      onTap: () {
                        _searchController.clear();
                        _searchFocusNode.unfocus();
                      },
                      child: const Icon(Icons.close),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10.0),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        widget.titleBaner,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 30.0,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.left,
                      ),
                    ),
                    if (widget.deleteBook)
                      IconButton(
                        icon: const Icon(
                          Icons.delete_rounded,
                          color: Colors.redAccent,
                          size: 50,
                        ),
                        onPressed: () {
                          _deleteLibro();
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      const UserLibrosDisponiblesPage(
                                        isPrincipal: true,
                                      )));
                        },
                      ),
                  ],
                ),
              ),
              Container(
                height: 3.0,
                color: Colors.redAccent,
                width: double.infinity,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class Option {
  final Icon icon;
  final String title;
  final VoidCallback onTap;

  Option({
    required this.icon,
    required this.title,
    required this.onTap,
  });
}
