import 'package:flutter/material.dart';
import 'package:libreria_app/models/data_usuario.dart';
import 'package:libreria_app/models/usuario_model.dart';
import 'package:libreria_app/models/usuario_prestado_model.dart';
import 'package:libreria_app/pages/book_history_card_page.dart';
import 'package:libreria_app/services/api_service.dart';
import 'package:libreria_app/widgets/custom_widgets.dart';

class BookDetailHistoryPage extends StatelessWidget {
  final Usuario usuario;
  final String role;
  final String name;
  final ApiService _apiService = ApiService(); // Crear una instancia de ApiService


  BookDetailHistoryPage({
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
            _buildHeader(),
            Expanded(child: _buildBody(context)),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return ItemBannerUser(
      seaching: false,
      titleBaner: "Mi Libro",
      rolUser: role,
      nameUser: name,
      viewAdd: false,
      viewVolver: true,
    );
  }

  Widget _buildBody(BuildContext context) {
    return FutureBuilder<List<UsuarioPrestado>>(
      future: _apiService.fetchUsuariosConLibrosPrestados(usuario.idBook),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return _buildLoading();
        } else if (snapshot.hasError) {
          return _buildError(snapshot.error);
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return _buildEmptyState();
        }

        final usuarioWidgets = _convertUsuariosToWidgets(snapshot.data!);

        return BookHistoryCardPage(
          imageUrl: usuario.imageUrl,
          bookTitle: usuario.title,
          bookAuthor: usuario.author,
          bookDescription: usuario.description,
          usuarios: usuarioWidgets,
        );
      },
    );
  }

  Widget _buildLoading() {
    return const Center(child: CircularProgressIndicator());
  }

  Widget _buildError(Object? error) {
    return Center(child: Text('Error: ${error.toString()}'));
  }

  Widget _buildEmptyState() {
    return const Center(
      child: Text(
        'No hay usuarios con libros prestados',
        style: TextStyle(color: Colors.white, fontSize: 20),
      ),
    );
  }

  List<DataUsuario> _convertUsuariosToWidgets(List<UsuarioPrestado> usuarios) {
    return usuarios.map((usuario) => DataUsuario(
      nombre: usuario.nameUser,
      telefono: usuario.phoneUser,
      email: usuario.emailUser,
    )).toList();
  }
}
