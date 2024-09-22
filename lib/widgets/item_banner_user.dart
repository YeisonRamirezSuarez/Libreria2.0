import 'package:flutter/material.dart';
import 'package:libreria_app/pages/login_page.dart';
import 'package:libreria_app/pages/user_libros_disponibles_page.dart';
import 'package:libreria_app/services/api_service.dart';
import 'package:libreria_app/services/snack_bar_service.dart';
import 'package:libreria_app/widgets/custom_widgets.dart';

class ItemBannerUser extends StatefulWidget {
  final bool viewAdd;
  final bool seaching;
  final bool deleteBook;
  final String titleBaner;
  final String rolUser;
  final String nameUser;
  final List<Option> options;
  final String idLibro;
  final Function(String)? searchCallback;
  final bool removerBanner;
  final bool viewVolver;
  final bool viewLogout;
  final IconData selectedIcon;
  final Function(bool)? onLoadingChange; // Callback para controlar la carga

  const ItemBannerUser({
    super.key,
    this.viewAdd = false,
    this.seaching = false,
    this.deleteBook = false,
    this.titleBaner = 'Titulo del Banner',
    this.rolUser = 'Rol de Usuario',
    required this.nameUser,
    this.options = const [],
    this.idLibro = '0',
    this.searchCallback,
    this.removerBanner = false,
    this.viewVolver = false,
    this.selectedIcon = Icons.person,
    this.viewLogout = false,
    this.onLoadingChange, // Asegurarse de recibir el callback
  });

  @override
  ItemBannerUserState createState() => ItemBannerUserState();
}

class ItemBannerUserState extends State<ItemBannerUser> {
  late FocusNode _searchFocusNode;
  final TextEditingController _searchController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  OverlayEntry? _overlayEntry;
  final GlobalKey _iconKey = GlobalKey();
  final ApiService _apiService = ApiService();

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
        widget.searchCallback!(_searchController.text);
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
    if (widget.onLoadingChange != null) {
      widget.onLoadingChange!(true); // Mostrar el CircularProgressIndicator
    }
    try {
      final response = await _apiService.deleteLibro(widget.idLibro.toString());

      if (mounted) {
        if (response.success) {
          SnackBarService.showSuccessSnackBar(
              context, 'Libro eliminado exitosamente');
          Navigator.pop(context);
        } else {
          SnackBarService.showErrorSnackBar(
              context, response.error ?? 'Error desconocido');
        }
      }
    } catch (error) {
      if (mounted) {
        SnackBarService.showErrorSnackBar(context, 'Error de red: $error');
      }
    } finally {
      if (widget.onLoadingChange != null) {
        widget.onLoadingChange!(false); // Ocultar el CircularProgressIndicator
      }
    }
  }

  void _showOverlay() {
    if (_overlayEntry != null) {
      _overlayEntry!.remove();
      _overlayEntry = null;
    } else {
      final RenderBox renderBox =
          _iconKey.currentContext!.findRenderObject() as RenderBox;

      _overlayEntry = OverlayEntry(
        builder: (context) => OverlayMenu(
          options: widget.options,
          renderBox: renderBox,
          onClose: () {
            if (_overlayEntry != null) {
              _overlayEntry!.remove();
              _overlayEntry = null;
            }
          },
        ),
      );

      // If you are sure Overlay.of(context) is not null, directly use it
      Overlay.of(context).insert(_overlayEntry!);
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
                BannerHeader(
                  rolUser: widget.rolUser,
                  nameUser: widget.nameUser,
                  viewAdd: widget.viewAdd,
                  viewVolver: widget.viewVolver,
                  viewLogout: widget.viewLogout,
                  selectedIcon: widget.selectedIcon,
                  onAddTap: () => _showOverlay(),
                  onBackTap: () => Navigator.pop(context),
                  onLogoutTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const LoginPage()),
                  ),
                ),
              const SizedBox(height: 10.0),
              Visibility(
                visible: widget.seaching,
                child: SearchField(
                  controller: _searchController,
                  focusNode: _searchFocusNode,
                  onClear: () {
                    _searchController.clear();
                    _searchFocusNode.unfocus();
                  },
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
                          // Navigator.push(
                          //     context,
                          //     MaterialPageRoute(
                          //         builder: (context) =>
                          //             UserLibrosDisponiblesPage(
                          //               isPrincipal: true,
                          //             )));
                          // Navigator.pop(context);
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
