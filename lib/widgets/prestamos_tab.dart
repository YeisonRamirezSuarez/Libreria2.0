import 'package:flutter/material.dart';
import 'package:libreria_app/pages/user_libros_disponibles_page.dart';

class PrestamosTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return UserLibrosDisponiblesPage(
      isAdminHistoric: true,
    );
  }
}
