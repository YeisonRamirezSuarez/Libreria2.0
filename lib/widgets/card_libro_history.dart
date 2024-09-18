import 'package:flutter/material.dart';
import 'package:libreria_app/widgets/custom_widgets.dart';

class BookHistoryCardPage extends StatelessWidget {
  final String imageUrl;
  final String bookTitle;
  final String bookAuthor;
  final String bookDescription;
  final List<DataUsuario> usuarios;

  const BookHistoryCardPage({
    super.key,
    required this.imageUrl,
    required this.bookTitle,
    required this.bookAuthor,
    required this.bookDescription,
    required this.usuarios,
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
            HistoryLibros(usuarios: usuarios),
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
  const HistoryLibros({
    super.key,
    required this.usuarios,
  });

  final List<DataUsuario> usuarios;

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
          // Encabezado
          Container(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  flex: 5,
                  child: Text(
                    'Nombre',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Expanded(
                  flex: 7,
                  child: Text(
                    'Teléfono',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Expanded(
                  flex: 6,
                  child: Text(
                    'Correo Electrónico',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 5),
          // Lista dinámica de usuarios con ListView.builder
          LimitedBox(
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: usuarios.length,
              itemBuilder: (context, index) {
                final usuario = usuarios[index];
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 5.0),
                  child: _infoUserLibroPrestado(
                    userName: usuario.nombre,
                    userPhone: usuario.telefono,
                    userEmail: usuario.email,
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _infoUserLibroPrestado extends StatelessWidget {
  const _infoUserLibroPrestado({
    required this.userName,
    required this.userPhone,
    required this.userEmail,
  });

  final String userName;
  final String userPhone;
  final String userEmail;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _showUserDetailsDialog(context),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white24,
          borderRadius: BorderRadius.circular(10),
          
        ),
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              flex: 3,
              child: Text(
                userName,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            Expanded(
              flex: 5,
              child: Text(
                userPhone,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            Expanded(
              flex: 4,
              child: Text(
                userEmail,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showUserDetailsDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return Dialog(
        backgroundColor: Colors.transparent, // Make the dialog background transparent
        child: Stack(
          children: [
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.black.withOpacity(0.8), Colors.black.withOpacity(0.6)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(15),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Title
                  Container(
                    padding: EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.6),
                      borderRadius: BorderRadius.vertical(top: Radius.circular(15)),
                    ),
                    child: Text(
                      'Detalles del Usuario',
                      style: TextStyle(color: Colors.redAccent,
                      fontSize: 20,
                       fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  // Content
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'Nombre',
                          style: TextStyle(color: Colors.redAccent, fontWeight: FontWeight.bold),
                          textAlign: TextAlign.center,
                        ),
                        Text(
                          userName,
                          style: TextStyle(color: Colors.white),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(height: 10),
                        Text(
                          'Teléfono',
                          style: TextStyle(color: Colors.redAccent, fontWeight: FontWeight.bold),
                          textAlign: TextAlign.center,
                        ),
                        Text(
                          userPhone,
                          style: TextStyle(color: Colors.white),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(height: 10),
                        Text(
                          'Correo Electrónico',
                          style: TextStyle(color: Colors.redAccent, fontWeight: FontWeight.bold),
                          textAlign: TextAlign.center,
                        ),
                        Text(
                          userEmail,
                          style: TextStyle(color: Colors.white),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                  // Actions
                  Container(
                    padding: EdgeInsets.all(8.0),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.6),
                      borderRadius: BorderRadius.vertical(bottom: Radius.circular(15)),
                    ),
                    child: Center(
                      child: TextButton(
                        onPressed: () => Navigator.of(context).pop(),
                        child: Text(
                          'Cerrar',
                          style: TextStyle(color: Colors.redAccent),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    },
  );
}

}

class DataUsuario {
  final String nombre;
  final String telefono;
  final String email;

  DataUsuario({
    required this.nombre,
    required this.telefono,
    required this.email,
  });
}
