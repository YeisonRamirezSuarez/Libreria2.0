import 'package:flutter/material.dart';
import 'package:LibreriaApp/models/prestamo_model.dart';
import 'package:LibreriaApp/models/usuario_model.dart';
import 'package:LibreriaApp/widgets/custom_widgets.dart';
import 'package:LibreriaApp/widgets/libro_card.dart';

class LibrosTab extends StatelessWidget {
  final String role;
  final String email;
  final String name;
  final String phone;
  final void Function(String) filterBooks;
  final List<dynamic> filteredBooks;
  final bool isAdminHistoric;
  final bool isUserHistoric;
  final IconData selectedIcon;

  const LibrosTab({
    super.key,
    required this.role,
    required this.email,
    required this.name,
    required this.phone,
    required this.filterBooks,
    required this.filteredBooks,
    this.isAdminHistoric = false,
    this.isUserHistoric = false,
    required this.selectedIcon,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ItemBannerUser(
          viewAdd: false,
          seaching: true,
          titleBaner: role == 'administrador' && isAdminHistoric
              ? 'Libros Prestados'
              : 'Libros Disponibles',
          rolUser: role,
          nameUser: name,
          viewVolver: false,
          searchCallback: filterBooks,
          selectedIcon: selectedIcon,
        ),
        Expanded(
          child: filteredBooks.isEmpty
              ? const Center(
                  child: Text(
                    'No se encontraron libros',
                    style: TextStyle(fontSize: 18, color: Colors.grey),
                  ),
                )
              : GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                    childAspectRatio: 0.85,
                  ),
                  itemCount: filteredBooks.length,
                  itemBuilder: (context, index) {
                    final libro = filteredBooks[index];
                    final usuario = libro is Usuario
                        ? libro
                        : Usuario(
                            idBook: libro.id.toString(),
                            title: libro.title,
                            author: libro.author,
                            bookUrl: libro.bookUrl,
                            imageUrl: libro.imageUrl,
                            description: libro.description,
                            prestamos: isAdminHistoric || isUserHistoric
                                ? [
                                    Prestamo(
                                      fechaPrestamo: '',
                                      correoUsuario: email,
                                      nombreUsuario: name,
                                      telefonoUsuario: phone,
                                    )
                                  ]
                                : [],
                          );
                    return LibroCard(
                      usuario: usuario,
                      isAdminHistoric: isAdminHistoric,
                      isUserHistoric: isUserHistoric,
                      role: role,
                      name: name,
                      cantidad: (role == 'administrador' && isAdminHistoric)
                          ? ''
                          : libro.quantity.toString(),
                      selectedIcon: selectedIcon,
                    );
                  },
                ),
        ),
      ],
    );
  }
}
