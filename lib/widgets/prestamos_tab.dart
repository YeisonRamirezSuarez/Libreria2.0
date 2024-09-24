import 'package:flutter/material.dart';
import 'package:LibreriaApp/pages/user_libros_disponibles_page.dart';

class PrestamosTab extends StatelessWidget {
  const PrestamosTab({super.key});

  @override
  Widget build(BuildContext context) {
    return const UserLibrosDisponiblesPage(
      isAdminHistoric: true,
    );
  }
}
