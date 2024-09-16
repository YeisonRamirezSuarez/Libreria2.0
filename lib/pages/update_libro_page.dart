import 'package:flutter/material.dart';
import 'package:libreria_app/models/book_model.dart';
import 'package:libreria_app/services/api_services.dart';
import '../widgets/custom_text_field.dart';
import '../widgets/custom_button.dart';
import '../widgets/item_banner_user.dart';
import '../utils/validators.dart';

class UpdateLibroPage extends StatefulWidget {
  final String email;
  final String rol;
  final String libroId;

  const UpdateLibroPage({
    super.key,
    required this.email,
    required this.rol,
    required this.libroId,
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

  Future<void> _fetchLibroData() async {
    try {
      final book = await ApiService.fetchBookData(int.parse(widget.libroId));
      setState(() {
        _tituloController.text = book.title;
        _autorController.text = book.author;
        _cantidadController.text = book.quantity;
        _urlLibroController.text = book.bookUrl;
        _urlImagenController.text = book.imageUrl;
        _descripcionController.text = book.description;
      });
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al obtener los datos: $error')),
      );
    }
  }

  Future<void> _updateLibro() async {
    final book = Book(
      id: widget.libroId,
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
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Libro actualizado exitosamente')),
        );
        Navigator.pop(context);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('${response.error}')),
        );
      }
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error de red: $error')),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    _fetchLibroData();
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
                      nameUser: widget.email,
                      idLibro: int.parse(widget.libroId),
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
