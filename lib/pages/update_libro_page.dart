import 'package:flutter/material.dart';
import 'package:libreria_app/models/book_model.dart';
import 'package:libreria_app/models/usuario_model.dart';
import 'package:libreria_app/services/api_service.dart';
import 'package:libreria_app/services/snack_bar_service.dart';
import 'package:libreria_app/widgets/custom_widgets.dart';

class UpdateLibroPage extends StatefulWidget {
  final String name;
  final String rol;
  final String cantidadLibro;
  final Usuario usuario;
  final IconData selectedIcon;

  const UpdateLibroPage({
    super.key,
    required this.name,
    required this.rol,
    required this.cantidadLibro,
    required this.usuario,
    required this.selectedIcon,
  });

  @override
  UpdateLibroPageState createState() => UpdateLibroPageState();
}

class UpdateLibroPageState extends State<UpdateLibroPage> {
  final _formKey = GlobalKey<FormState>();
  final _tituloController = TextEditingController();
  final _autorController = TextEditingController();
  final _cantidadController = TextEditingController();
  final _urlLibroController = TextEditingController();
  final _urlImagenController = TextEditingController();
  final _descripcionController = TextEditingController();
  AutovalidateMode _autoValidateMode = AutovalidateMode.disabled;
  final ApiService _apiService = ApiService();

  // Controlador para manejar el estado del progreso
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _initializeControllers();
  }

  void _setLoading(bool value) {
    print("Loading: $value");
    setState(() {
      _isLoading = value;
    });
  }

  @override
  void dispose() {
    _tituloController.dispose();
    _autorController.dispose();
    _cantidadController.dispose();
    _urlLibroController.dispose();
    _urlImagenController.dispose();
    _descripcionController.dispose();
    super.dispose();
  }

  void _initializeControllers() {
    _tituloController.text = widget.usuario.title;
    _autorController.text = widget.usuario.author;
    _cantidadController.text = widget.cantidadLibro;
    _urlLibroController.text = widget.usuario.bookUrl;
    _urlImagenController.text = widget.usuario.imageUrl;
    _descripcionController.text = widget.usuario.description;
  }

  Future<void> _updateLibro() async {
    if (!_formKey.currentState!.validate()) {
      setState(() {
        _autoValidateMode = AutovalidateMode.always;
      });
      return;
    }

    final book = Book(
      id: widget.usuario.idBook,
      title: _tituloController.text,
      author: _autorController.text,
      quantity: int.parse(_cantidadController.text),
      bookUrl: _urlLibroController.text,
      imageUrl: _urlImagenController.text,
      description: _descripcionController.text,
    );

    try {
      final response = await _apiService.updateBook(book);

      if (!mounted) return;

      if (response.success) {
        _showSuccessDialog();
      } else {
        _showErrorDialog(response.error ?? 'Error desconocido');
      }
    } catch (error) {
      if (mounted) {
        _showErrorDialog('Error de red: $error');
      }
    }
  }

  void _showSuccessDialog() {
    SnackBarService.showSuccessSnackBar(
      context,
      'Libro actualizado exitosamente',
    );
    Navigator.pop(context);
  }

  void _showErrorDialog(String message) {
    SnackBarService.showErrorSnackBar(
      context,
      message,
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return KeyboardDismiss(
      child: SafeArea(
        child: Scaffold(
          body: Stack(
            children: [
              SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Padding(
                  padding: EdgeInsets.all(screenWidth * 0.01),
                  child: Column(
                    children: [
                      _buildHeader(),
                      _buildForm(),
                    ],
                  ),
                ),
              ),
              if (_isLoading) _buildLoadingOverlay(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return ItemBannerUser(
      seaching: false,
      titleBaner: "Actualizar libro",
      rolUser: widget.rol,
      nameUser: widget.name,
      deleteBook: true,
      idLibro: widget.usuario.idBook,
      selectedIcon: widget.selectedIcon,
      viewAdd: false,
      viewVolver: true,
      onLoadingChange: _setLoading, // Pasar el estado de progreso al hijo
    );
  }

  Widget _buildForm() {
    return FormLibro(
      formKey: _formKey,
      autoValidateMode: _autoValidateMode,
      tituloController: _tituloController,
      autorController: _autorController,
      cantidadController: _cantidadController,
      urlLibroController: _urlLibroController,
      urlImagenController: _urlImagenController,
      descripcionController: _descripcionController,
      onPressed: _updateLibro,
      name: widget.name,
      rol: widget.rol,
      botonTitle: "Actualizar Libro",
    );
  }

  Widget _buildLoadingOverlay() {
    return Positioned.fill(
      child: Stack(
        children: [
          ModalBarrier(
            dismissible: false,
            color: Colors.black.withOpacity(0.5),
          ),
          Center(
            child: SizedBox(
              width: 100,
              height: 100,
              child: CircularProgressIndicator(
                color: Colors.redAccent,
                strokeWidth: 8,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
