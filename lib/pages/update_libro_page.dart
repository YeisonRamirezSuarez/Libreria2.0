import 'package:flutter/material.dart';
import 'package:libreria_app/models/book_model.dart';
import 'package:libreria_app/models/usuario_model.dart';
import 'package:libreria_app/pages/user_libros_disponibles_page.dart';
import 'package:libreria_app/services/api_services.dart';
import 'package:libreria_app/services/dialog_service.dart';
import '../widgets/custom_text_field.dart';
import '../widgets/custom_button.dart';
import '../widgets/item_banner_user.dart';
import '../utils/validators.dart';

class UpdateLibroPage extends StatefulWidget {
  final String name;
  final String rol;
  final String cantidadLibro;
  final Usuario usuario;

  const UpdateLibroPage({
    super.key,
    required this.name,
    required this.rol,
    required this.cantidadLibro,
    required this.usuario,
  });

  @override
  _UpdateLibroPageState createState() => _UpdateLibroPageState();
}

class _UpdateLibroPageState extends State<UpdateLibroPage> {
  final _formKey = GlobalKey<FormState>();

  final _tituloController = TextEditingController();
  final _autorController = TextEditingController();
  final _cantidadController = TextEditingController();
  final _urlLibroController = TextEditingController();
  final _urlImagenController = TextEditingController();
  final _descripcionController = TextEditingController();

  Future<void> _updateLibro() async {
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
      final response = await ApiService.updateBook(book);
      if (response.success) {
        DialogService.showSuccessSnackBar(
            context, 'Libro actualizado exitosamente');
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => UserLibrosDisponiblesPage()),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('${response.error}')),
        );
        DialogService.showErrorSnackBar(
            context, response.error ?? 'Error desconocido');
      }
    } catch (error) {
      DialogService.showErrorSnackBar(context, 'Error de red: $error');
    }
  }

  @override
  void initState() {
    super.initState();
    _tituloController.text = widget.usuario.title;
    _autorController.text = widget.usuario.author;
    _cantidadController.text = widget.cantidadLibro;
    _urlLibroController.text = widget.usuario.bookUrl;
    _urlImagenController.text = widget.usuario.imageUrl;
    _descripcionController.text = widget.usuario.description;
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
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    ItemBannerUser(
                      estadoUsuario: false,
                      seaching: false,
                      deleteBook: true,
                      titleBaner: "Actualizar libro",
                      rolUser: widget.rol,
                      nameUser: widget.name,
                      idLibro: int.parse(widget.usuario.idBook),
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
                      text: 'Actualizar Libro',
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          _updateLibro();
                        }
                      },
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
