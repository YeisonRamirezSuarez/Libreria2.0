import 'package:flutter/material.dart';
import 'package:libreria_app/widgets/card_libro_history.dart';
// Importa tus clases para ItemBannerUser y CustomButton si no lo has hecho ya
import 'package:libreria_app/widgets/custom_widgets.dart'; // Asegúrate de importar donde tengas tu ItemBannerUser y CustomButton

class BookDetailHistoryPage extends StatelessWidget {
  final String imageUrl;
  final String bookTitle;
  final String bookAuthor;
  final String bookDescription;
  final String userName;
  final String userPhone;
  final String userEmail;

  final String role;
  final String email;

  const BookDetailHistoryPage({
    super.key,
    required this.imageUrl,
    required this.bookTitle,
    required this.bookAuthor,
    required this.bookDescription,
    required this.userName,
    required this.userPhone,
    required this.userEmail,
    required this.role,
    required this.email,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.black,
        body: Column(
          children: [
            // Aquí agregamos el ItemBannerUser en la parte superior
            ItemBannerUser(
              estadoUsuario: false,
              seaching: false,
              titleBaner: "Mi Libro",
              rolUser: role,
              nameUser: email,
            ),

            Expanded(
              child: SingleChildScrollView(
                  child: BookHistoryCardPage(
                imageUrl: imageUrl,
                bookTitle: bookTitle,
                bookAuthor: bookAuthor,
                bookDescription: bookDescription,
                usuarios: [
                  Usuario1(
                      nombre: 'Karl',
                      telefono: '3001112548',
                      email: 'karl@wposs.com'),
                  Usuario1(
                      nombre: 'Ana',
                      telefono: '3002223333',
                      email: 'ana@gmail.com'),
                  Usuario1(
                      nombre: 'Luis',
                      telefono: '3003334444',
                      email: 'luis@hotmail.com'),
                ],
              )),
            ),
          ],
        ),
      ),
    );
  }
}
