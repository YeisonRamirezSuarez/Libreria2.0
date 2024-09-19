import 'package:flutter/material.dart';
import 'package:libreria_app/models/book_model.dart';
import 'package:libreria_app/pages/user_libros_disponibles_page.dart';
import 'package:libreria_app/services/api_services.dart';
import 'package:libreria_app/services/dialog_service.dart';
import 'package:libreria_app/widgets/custom_widgets.dart';

class RegisterLibroPage extends StatefulWidget {
  final String name;
  final String rol;

  const RegisterLibroPage({super.key, required this.name, required this.rol});

  @override
  _RegisterLibroPageState createState() => _RegisterLibroPageState();
}

class _RegisterLibroPageState extends State<RegisterLibroPage> {
  final _formKey = GlobalKey<FormState>();
  final _tituloController = TextEditingController();
  final _autorController = TextEditingController();
  final _cantidadController = TextEditingController();
  final _urlLibroController = TextEditingController();
  final _urlImagenController = TextEditingController();
  final _descripcionController = TextEditingController();
  AutovalidateMode _autoValidateMode = AutovalidateMode.disabled;

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

  Future<void> registerLibro() async {
    if (!_formKey.currentState!.validate()) {
      setState(() {
        _autoValidateMode = AutovalidateMode.always;
      });
      return;
    }

    final book = Book(
      title: _tituloController.text,
      author: _autorController.text,
      quantity: _cantidadController.text,
      bookUrl: _urlLibroController.text,
      imageUrl: _urlImagenController.text,
      description: _descripcionController.text,
    );

    try {
      final response = await ApiService.registerBook(book);

      if (response.success) {
        DialogService.showSuccessSnackBar(
            context, 'Libro registrado exitosamente');

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) => const UserLibrosDisponiblesPage(
                    isPrincipal: true,
                  )),
        );
      } else {
        DialogService.showErrorSnackBar(
            context, response.error ?? 'Error desconocido');
      }
    } catch (error) {
      DialogService.showErrorSnackBar(context, 'Error de red: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: SafeArea(
        child: Scaffold(
          body: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Padding(
              padding: EdgeInsets.all(screenWidth * 0.01),
              child: Column(
                children: [
                  ItemBannerUser(
                    estadoUsuario: false,
                    seaching: false,
                    titleBaner: "Agregar libro",
                    rolUser: widget.rol,
                    nameUser: widget.name,
                    removerBanner: true,
                  ),
                  FormLibro(
                    formKey: _formKey,
                    autoValidateMode: _autoValidateMode,
                    tituloController: _tituloController,
                    autorController: _autorController,
                    cantidadController: _cantidadController,
                    urlLibroController: _urlLibroController,
                    urlImagenController: _urlImagenController,
                    descripcionController: _descripcionController,
                    onPressed: registerLibro,
                    name: widget.name,
                    rol: widget.rol,
                    botonTitle: "Agregar Libro",
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
