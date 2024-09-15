import 'package:flutter/material.dart';
import 'package:libreria_app/widgets/custom_widgets.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class UpdateLibroPage extends StatefulWidget {
  final String email;
  final String rol;
  final int libroId; // Añadimos un ID para identificar el libro

  const UpdateLibroPage(
      {super.key,
      required this.email,
      required this.rol,
      required this.libroId});

  @override
  _UpdateLibroPageState createState() => _UpdateLibroPageState();
}

class _UpdateLibroPageState extends State<UpdateLibroPage> {
  final _formKey = GlobalKey<FormState>();

  // Controladores para los campos de texto
  final _tituloController = TextEditingController();
  final _autorController = TextEditingController();
  final _cantidadController = TextEditingController();
  final _urlLibroController = TextEditingController();
  final _urlImagenController = TextEditingController();
  final _descripcionController = TextEditingController();

  // Método para obtener los datos del libro por ID
  Future<void> fetchLibroData(int libroId) async {
    final url =
        Uri.parse("http://192.168.80.20:80/libreria/api/libro.php?id=$libroId");

    try {
      final response = await http.get(url);

      print(response.body);
      print(response.statusCode);

      if (response.statusCode == 201) {
        final data = json.decode(response.body);
        setState(() {
          _tituloController.text = data['data'][0]['title'];
          _autorController.text = data['data'][0]['author'];
          _cantidadController.text = data['data'][0]['quantity'].toString();
          _urlLibroController.text = data['data'][0]['book_url'];
          _urlImagenController.text = data['data'][0]['image_url'];
          _descripcionController.text = data['data'][0]['description'];
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Error al obtener los datos del libro')),
        );
      }
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error de red: $error')),
      );
      print('Error de red: $error');
    }
  }

  // Método para actualizar los datos del libro
  Future<void> _updateLibro(String titulo, String autor, String cantidad,
      String urlLibro, String urlImagen, String descripcion) async {
    final url = Uri.parse(
        "http://192.168.80.20:80/libreria/api/libro.php?update=1&id=${widget.libroId}");

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          "id": widget.libroId,
          "title": titulo,
          "author": autor,
          "quantity": cantidad,
          "book_url": urlLibro,
          "image_url": urlImagen,
          "description": descripcion,
        }),
      );

      print(response.body);
      print(response.statusCode);

      if (response.statusCode == 201) {
        final responseBody = json.decode(response.body);
        if (responseBody['mensaje'] == 'success update') {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Libro actualizado exitosamente')),
          );
          Navigator.pop(context);
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
  void initState() {
    super.initState();
    // Obtener los datos del libro al abrir la página
    fetchLibroData(widget.libroId);
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
                      idLibro: widget.libroId,
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
                      text: 'Actualizar Libro',
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          _updateLibro(
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
