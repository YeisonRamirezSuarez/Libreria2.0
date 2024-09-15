import 'package:flutter/material.dart';
import 'package:libreria_app/widgets/custom_widgets.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class RegisterLibroPage extends StatefulWidget {
  final String email;
  final String rol;

  const RegisterLibroPage({super.key, required this.email, required this.rol});

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

  Future<void> registerLibro(String titulo, String autor, String cantidad,
      String urlLibro, String urlImagen, String descripcion) async {
    final url = Uri.parse("http://192.168.80.20:80/libreria/api/libro.php");

    print(titulo);
    print(autor);
    print(cantidad);
    print(urlLibro);
    print(urlImagen);
    print(descripcion);

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          "title": titulo,
          "author": autor,
          "quantity": cantidad,
          "book_url": urlLibro,
          "image_url": urlImagen,
          "description": descripcion,
        }),
      );

      // Imprime la respuesta cruda para depuración
      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 201 || response.statusCode == 400) {
        final responseBody = json.decode(response.body);

        if (responseBody['mensaje'] == 'success register') {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Registro del libro exitoso')),
          );
          Navigator.pop(context);
          Navigator.of(context).pop(); // Cierra el Modal si está abierto
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('${responseBody['error']}')),
          );
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Error en el servidor')),
        );
      }
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error de red: $error')),
      );
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
              padding: EdgeInsets.all(screenWidth * 0.05),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    ItemBannerUser(
                      estadoUsuario: false,
                      seaching: false,
                      titleBaner: "Agregar libro",
                      rolUser: widget.rol,
                      nameUser: widget.email,
                    ),
                    CustomTextField(
                      hintText: 'Título Libro',
                      icon: Icons.book,
                      controller: _tituloController,
                      keyboardType: TextInputType.text,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'El título es obligatorio';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: screenHeight * 0.01),
                    CustomTextField(
                      hintText: 'Autor Libro',
                      icon: Icons.person,
                      controller: _autorController,
                      keyboardType: TextInputType.text,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'El autor es obligatorio';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: screenHeight * 0.01),
                    CustomTextField(
                      hintText: 'Cantidad Libro',
                      icon: Icons.format_list_numbered,
                      controller: _cantidadController,
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'La cantidad es obligatoria';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: screenHeight * 0.01),
                    CustomTextField(
                      hintText: 'URL Libro',
                      icon: Icons.link,
                      controller: _urlLibroController,
                      keyboardType: TextInputType.url,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'La URL del libro es obligatoria';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: screenHeight * 0.01),
                    CustomTextField(
                      hintText: 'Imagen Libro',
                      icon: Icons.image,
                      controller: _urlImagenController,
                      keyboardType: TextInputType.url,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'La URL de la imagen es obligatoria';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: screenHeight * 0.01),
                    CustomTextField(
                      hintText: 'Descripción Libro',
                      icon: Icons.description,
                      controller: _descripcionController,
                      keyboardType: TextInputType.multiline,
                      maxLines: 3,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'La descripción es obligatoria';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: screenHeight * 0.02),
                    CustomButton(
                      text: 'Agregar Libro',
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          registerLibro(
                            _tituloController.text,
                            _autorController.text,
                            _cantidadController.text,
                            _urlLibroController.text,
                            _urlImagenController.text,
                            _descripcionController.text,
                          );
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
