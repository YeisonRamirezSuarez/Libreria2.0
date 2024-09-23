import 'package:flutter/material.dart';
import 'package:libreria_app/pages/user_libros_disponibles_page.dart';

class PrestamosTab extends StatelessWidget {
  const PrestamosTab({super.key});

  @override
  Widget build(BuildContext context) {
    return const UserLibrosDisponiblesPage(
      isAdminHistoric: true,
    );
  }
}
