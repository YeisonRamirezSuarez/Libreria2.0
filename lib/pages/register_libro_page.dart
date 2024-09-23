import 'package:flutter/material.dart';
import 'package:libreria_app/models/api_response_models/api_response_registrer.dart';
import 'package:libreria_app/models/book_model.dart';
import 'package:libreria_app/services/api_service.dart';
import 'package:libreria_app/services/snack_bar_service.dart';
import 'package:libreria_app/widgets/custom_widgets.dart';

class RegisterLibroPage extends StatefulWidget {
  final String name;
  final String rol;
  final IconData selectedIcon;

  const RegisterLibroPage({
    super.key,
    required this.name,
    required this.rol,
    required this.selectedIcon,
  });

  @override
  RegisterLibroPageState createState() => RegisterLibroPageState();
}

class RegisterLibroPageState extends State<RegisterLibroPage> {
  final _formKey = GlobalKey<FormState>();
  final _tituloController = TextEditingController();
  final _autorController = TextEditingController();
  final _cantidadController = TextEditingController();
  final _urlLibroController = TextEditingController();
  final _urlImagenController = TextEditingController();
  final _descripcionController = TextEditingController();
  AutovalidateMode _autoValidateMode = AutovalidateMode.disabled;

  final ApiService _apiService =
      ApiService(); // Crear una instancia de ApiService

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

  Future<void> _registerLibro() async {
    if (!_formKey.currentState!.validate()) {
      setState(() {
        _autoValidateMode = AutovalidateMode.always;
      });
      return;
    }

    final book = Book(
      title: _tituloController.text,
      author: _autorController.text,
      quantity: int.parse(_cantidadController.text),
      bookUrl: _urlLibroController.text,
      imageUrl: _urlImagenController.text,
      description: _descripcionController.text,
    );

    try {
      final ApiResponseRegistrer response = await _apiService
          .registerBook(book); // Llamar a través de la instancia

      if (!mounted) return;

      if (response.success) {
        _showSuccessDialog();
      } else {
        _showErrorDialog(response.error ?? 'Error desconocido');
      }
    } catch (error) {
      if (!mounted) return;
      _showErrorDialog('Error de red: $error');
    }
  }

  void _showSuccessDialog() {
    SnackBarService.showSuccessSnackBar(
        context, 'Libro registrado exitosamente');
    Navigator.pop(context);
  }

  void _showErrorDialog(String message) {
    SnackBarService.showErrorSnackBar(context, message);
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
      titleBaner: "Agregar libro",
      rolUser: widget.rol,
      nameUser: widget.name,
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
      onPressed: _registerLibro,
      name: widget.name,
      rol: widget.rol,
      botonTitle: "Agregar Libro",
    );
  }
}
