import 'package:flutter/material.dart';
import 'package:libreria_app/models/usuario_model.dart';
import 'package:libreria_app/pages/user_detalle_libro.dart';
import 'package:libreria_app/widgets/custom_widgets.dart';

class MisLibrosTab extends StatelessWidget {
  final List<Usuario> books;
  final String role;
  final String name;
  final void Function(String) filterCallback;
  final IconData selectedIcon;

  const MisLibrosTab({
    required this.books,
    required this.role,
    required this.name,
    required this.filterCallback,
    required this.selectedIcon,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        ItemBannerUser(
          viewAdd: false,
          viewVolver: false,
          seaching: true,
          titleBaner: "Mis Libros Prestados",
          rolUser: role,
          nameUser: name,
          searchCallback: filterCallback,
          selectedIcon: selectedIcon,
        ),
        Expanded(
          child: ListView.builder(
            itemCount: books.length,
            itemBuilder: (context, index) {
              final book = books[index];
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 0.5),
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => BookDetailPage(
                          titleBaner: "Mi Libro",
                          usuario: book,
                          role: role,
                          name: name,
                          cantButton: 2,
                        ),
                      ),
                    );
                  },
                  child: BookCard(
                    imageUrl: book.imageUrl,
                    title: book.title,
                    author: book.author,
                    date: book.date,
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
