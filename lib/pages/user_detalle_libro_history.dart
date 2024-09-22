import 'package:flutter/material.dart';
import 'package:libreria_app/models/usuario_model.dart';
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
            Expanded(child: _buildBody(context, usuario)),
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

    Widget _buildBody(BuildContext context, Usuario usuario) {


        return BookHistoryCardPage(
          imageUrl: usuario.imageUrl,
          bookTitle: usuario.title,
          bookAuthor: usuario.author,
          bookDescription: usuario.description,
          usuarios: usuario.prestamos,
        );
      
    
  }
}
