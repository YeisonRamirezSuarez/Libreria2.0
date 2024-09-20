import 'package:flutter/material.dart';
import 'package:libreria_app/models/book_model.dart';
import 'package:libreria_app/models/usuario_model.dart';
import 'package:libreria_app/pages/user_libros_disponibles_page.dart';
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

  final ApiService _apiService = ApiService(); // Crear una instancia de ApiService


  @override
  void initState() {
    super.initState();
    _initializeControllers();
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
      quantity: _cantidadController.text,
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
          body: SingleChildScrollView(
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
}
