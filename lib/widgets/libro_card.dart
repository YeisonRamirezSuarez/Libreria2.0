import 'package:flutter/material.dart';
import 'package:LibreriaApp/models/usuario_model.dart';
import 'package:LibreriaApp/pages/update_libro_page.dart';
import 'package:LibreriaApp/pages/user_detalle_libro.dart';
import 'package:LibreriaApp/pages/user_detalle_libro_history.dart';
import 'package:LibreriaApp/widgets/custom_widgets.dart';

class LibroCard extends StatelessWidget {
  final Usuario usuario;
  final bool isAdminHistoric;
  final bool isUserHistoric;
  final String role;
  final String name;
  final String cantidad;
  final IconData selectedIcon;

  const LibroCard({
    super.key,
    required this.usuario,
    this.isAdminHistoric = false,
    this.isUserHistoric = false,
    required this.role,
    required this.name,
    required this.cantidad,
    required this.selectedIcon,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (isAdminHistoric) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => BookDetailHistoryPage(
                usuario: usuario,
                role: role,
                name: name,
                selectedIcon: selectedIcon,
              ),
            ),
          );
        } else if (!isAdminHistoric && role == 'administrador') {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => UpdateLibroPage(
                name: name,
                rol: role,
                cantidadLibro: cantidad,
                usuario: usuario,
                selectedIcon: selectedIcon,
              ),
            ),
          );
        } else if (isUserHistoric) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => BookDetailPage(
                usuario: usuario,
                titleBaner: 'Prestar Libro',
                role: role,
                name: name,
                cantButton: 1,
                selectedIcon: selectedIcon,
              ),
            ),
          );
        }
      },
      child: LayoutBuilder(
        builder: (context, constraints) {
          final double cardWidth = constraints.maxWidth;
          final double imageSize = cardWidth * 0.6;

          return Container(
            margin: const EdgeInsets.all(12.0),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12.0),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  spreadRadius: 2,
                  blurRadius: 6,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  ImageWidget(
                    imageUrl: usuario.imageUrl,
                    height: imageSize,
                    width: imageSize,
                  ),
                  const SizedBox(height: 4.0),
                  Text(
                    usuario.title,
                    style: TextStyle(
                      fontSize: cardWidth * 0.08,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                    textAlign: TextAlign.center,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                  const SizedBox(height: 1.0),
                  Text(
                    usuario.author,
                    style: TextStyle(
                      fontSize: cardWidth * 0.06,
                      color: Colors.grey[600],
                    ),
                    textAlign: TextAlign.center,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
