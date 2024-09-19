import 'package:flutter/material.dart';
import 'package:libreria_app/models/login_model.dart';
import 'package:libreria_app/models/usuario_model.dart';
import 'package:libreria_app/services/api_services.dart';
import 'package:libreria_app/widgets/custom_widgets.dart';

class BookDetailHistoryPage extends StatelessWidget {
  final Usuario usuario;
  final String role;
  final String name;

  const BookDetailHistoryPage({
    super.key,
    required this.usuario,
    required this.role,
    required this.name,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.black,
        body: Column(
          children: [
            ItemBannerUser(
              estadoUsuario: false,
              seaching: false,
              titleBaner: "Mi Libro",
              rolUser: role,
              nameUser: name,
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    FutureBuilder<List<UsuarioPrestado>>(
                      future: ApiService.fetchUsuariosConLibrosPrestados(
                          usuario.idBook),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(
                              child: CircularProgressIndicator());
                        } else if (snapshot.hasError) {
                          return Center(
                              child: Text('Error: ${snapshot.error}'));
                        } else if (!snapshot.hasData ||
                            snapshot.data!.isEmpty) {
                          return const Center(
                            child: Text('No hay usuarios con libros prestados',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                )),
                          );
                        }

                        final usuarios = snapshot.data!;

                        // Convertir cada Usuario a un Widget
                        final usuarioWidgets = usuarios
                            .map((usuario) => DataUsuario(
                                  nombre: usuario.nameUser,
                                  telefono: usuario.phoneUser,
                                  email: usuario.emailUser,
                                ))
                            .toList();

                        return BookHistoryCardPage(
                          imageUrl: usuario.imageUrl,
                          bookTitle: usuario.title,
                          bookAuthor: usuario.author,
                          bookDescription: usuario.description,
                          usuarios: usuarioWidgets, // Pasar la lista de widgets
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
