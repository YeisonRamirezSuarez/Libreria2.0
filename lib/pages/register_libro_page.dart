import 'package:flutter/material.dart';
import 'package:libreria_app/models/book_model.dart';
import 'package:libreria_app/pages/user_libros_disponibles_page.dart';
import 'package:libreria_app/services/api_services.dart';
import 'package:libreria_app/services/dialog_service.dart';
import '../widgets/custom_text_field.dart';
import '../widgets/custom_button.dart';
import '../widgets/item_banner_user.dart';
import '../utils/validators.dart';

class RegisterLibroPage extends StatefulWidget {
  final String name;
  final String rol;

  const RegisterLibroPage({super.key, required this.name, required this.rol});

  @override
  _RegisterLibroPageState createState() => _RegisterLibroPageState();
}

class _RegisterLibroPageState extends State<RegisterLibroPage> {
  final _formKey = GlobalKey<FormState>();

  // Controladores para los campos de texto
  final _tituloController = TextEditingController();
  final _autorController = TextEditingController();
  final _cantidadController = TextEditingController();
  final _urlLibroController = TextEditingController();
  final _urlImagenController = TextEditingController();
  final _descripcionController = TextEditingController();
  AutovalidateMode _autoValidateMode = AutovalidateMode.disabled;
  late final List<TextEditingController> _controllers;

  @override
  void initState() {
    super.initState();

    // Inicializar los controladores
    _controllers = [
      _tituloController,
      _autorController,
      _cantidadController,
      _urlLibroController,
      _urlImagenController,
    ];

    // Agregar los listeners a cada controlador
    for (var controller in _controllers) {
      controller.addListener(() {
        if (_autoValidateMode == AutovalidateMode.always) {
          setState(() {});
        }
      });
    }
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
          MaterialPageRoute(builder: (context) => UserLibrosDisponiblesPage()),
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
    final screenHeight = MediaQuery.of(context).size.height;

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
              child: Form(
                key: _formKey,
                autovalidateMode: _autoValidateMode,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    ItemBannerUser(
                      estadoUsuario: false,
                      seaching: false,
                      titleBaner: "Agregar libro",
                      rolUser: widget.rol,
                      nameUser: widget.name,
                    ),
                    CustomTextField(
                      hintText: 'Título Libro',
                      icon: Icons.book,
                      controller: _tituloController,
                      keyboardType: TextInputType.text,
                      validator: Validators.requiredFieldValidator,
                    ),
                    SizedBox(height: screenHeight * 0.01),
                    CustomTextField(
                      hintText: 'Autor Libro',
                      icon: Icons.person,
                      controller: _autorController,
                      keyboardType: TextInputType.text,
                      validator: Validators.requiredFieldValidator,
                    ),
                    SizedBox(height: screenHeight * 0.01),
                    CustomTextField(
                      hintText: 'Cantidad Libro',
                      icon: Icons.format_list_numbered,
                      maxLength: 3,
                      controller: _cantidadController,
                      keyboardType: TextInputType.number,
                      validator: Validators.numberValidator,
                    ),
                    SizedBox(height: screenHeight * 0.01),
                    CustomTextField(
                      hintText: 'URL Libro',
                      icon: Icons.link,
                      controller: _urlLibroController,
                      keyboardType: TextInputType.url,
                      validator: Validators.urlValidator,
                    ),
                    SizedBox(height: screenHeight * 0.01),
                    CustomTextField(
                      hintText: 'Imagen Libro',
                      icon: Icons.image,
                      controller: _urlImagenController,
                      keyboardType: TextInputType.url,
                      validator: Validators.urlValidator,
                    ),
                    SizedBox(height: screenHeight * 0.01),
                    CustomTextField(
                      hintText: 'Descripción Libro',
                      icon: Icons.description,
                      controller: _descripcionController,
                      keyboardType: TextInputType.multiline,
                      maxLines: 3,
                      validator: Validators.requiredFieldValidator,
                    ),
                    SizedBox(height: screenHeight * 0.02),
                    CustomButton(
                      text: 'Agregar Libro',
                      onPressed: registerLibro,
                      colorFondo: Colors.redAccent,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
