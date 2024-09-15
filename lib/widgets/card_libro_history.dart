import 'package:flutter/material.dart';
import 'package:libreria_app/widgets/custom_widgets.dart';

class BookHistoryCardPage extends StatelessWidget {
  final String imageUrl;
  final String bookTitle;
  final String bookAuthor;
  final String bookDescription;
  final List<Usuario>
      usuarios; // Cambiamos aquí para aceptar una lista de usuarios

  const BookHistoryCardPage({
    super.key,
    required this.imageUrl,
    required this.bookTitle,
    required this.bookAuthor,
    required this.bookDescription,
    required this.usuarios, // Lista de usuarios
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(5),
      child: Padding(
        padding: const EdgeInsets.all(5),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            // Sección de detalles del libro
            LibroDetails(
              imageUrl: imageUrl,
              bookTitle: bookTitle,
              bookAuthor: bookAuthor,
              bookDescription: bookDescription,
            ),
            // Línea divisoria
            const SizedBox(height: 20),
            Container(
              height: 3.0,
              color: Colors.redAccent,
              width: double.infinity,
            ),
            const SizedBox(height: 20),
            // Sección de información del usuario
            HistoryLibros(
                usuarios: usuarios), // Pasamos la lista de usuarios aquí
          ],
        ),
      ),
    );
  }
}

class LibroDetails extends StatelessWidget {
  const LibroDetails({
    super.key,
    required this.imageUrl,
    required this.bookTitle,
    required this.bookAuthor,
    required this.bookDescription,
  });

  final String imageUrl;
  final String bookTitle;
  final String bookAuthor;
  final String bookDescription;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [

        ImageWidget(
          imageUrl: imageUrl,
          width: 120,
          height: 160,
        ),
        const SizedBox(width: 10),
        // Book Details
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                bookTitle,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 5),
              Text(
                bookAuthor,
                style: const TextStyle(
                  fontSize: 14,
                  color: Colors.grey,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                bookDescription,
                style: const TextStyle(fontSize: 14),
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class HistoryLibros extends StatelessWidget {
  // Ahora recibimos una lista de usuarios
  const HistoryLibros({
    super.key,
    required this.usuarios,
  });

  final List<Usuario> usuarios;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.grey[850],
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header row with titles
          Container(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment
                  .spaceBetween, // Distribuye espacio entre los elementos
              children: [
                Expanded(
                  flex: 3,
                  child: Text(
                    'Nombre',
                    textAlign: TextAlign.center, // Centra el texto
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Text(
                    'Teléfono',
                    textAlign: TextAlign.center, // Centra el texto
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Expanded(
                  flex: 3,
                  child: Text(
                    'Correo Electrónico',
                    textAlign: TextAlign.center, // Centra el texto
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(
              height: 5), // Espacio entre header y la info de los usuarios

          // Mostrar la lista dinámica de usuarios
          Column(
            children: usuarios.map((usuario) {
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 5.0),
                child: _infoUserLibroPrestado(
                  userName: usuario.nombre,
                  userPhone: usuario.telefono,
                  userEmail: usuario.email,
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}

// Widget para mostrar la información de cada usuario
class _infoUserLibroPrestado extends StatelessWidget {
  const _infoUserLibroPrestado({
    super.key,
    required this.userName,
    required this.userPhone,
    required this.userEmail,
  });

  final String userName;
  final String userPhone;
  final String userEmail;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.orangeAccent[400], // Color de fondo
        borderRadius: BorderRadius.circular(10),
      ),
      padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment
            .spaceBetween, // Distribuye espacio entre los elementos
        children: [
          Expanded(
            flex: 3,
            child: Text(
              userName,
              textAlign: TextAlign.center, // Centra el texto
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              userPhone,
              textAlign: TextAlign.center, // Centra el texto
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: Text(
              userEmail,
              textAlign: TextAlign.center, // Centra el texto
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// Definir la clase para un usuario
class Usuario {
  final String nombre;
  final String telefono;
  final String email;

  Usuario({required this.nombre, required this.telefono, required this.email});
}
