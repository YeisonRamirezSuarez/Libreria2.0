import 'package:flutter/material.dart';
// Importa tus clases para ItemBannerUser y CustomButton si no lo has hecho ya
import 'package:libreria_app/widgets/custom_widgets.dart'; // Asegúrate de importar donde tengas tu ItemBannerUser y CustomButton

class BookDetailPage extends StatelessWidget {
  final String imageUrl;
  final String title;
  final String author;
  final String date;

  const BookDetailPage({
    super.key,
    required this.imageUrl,
    required this.title,
    required this.author,
    required this.date,
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
              titleBaner: "Mis Libros Prestados",
              rolUser: "Usuario",
              nameUser: "Yeison Ramirez",
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      // Imagen del libro
                      Image.network(
                        imageUrl,
                        height: 200,
                      ),
                      const SizedBox(height: 20),

                      // Título del libro
                      Text(
                        title,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      const SizedBox(height: 5),

                      // Autor
                      Text(
                        author,
                        style: TextStyle(
                          color: Colors.grey[400],
                          fontSize: 16,
                          fontStyle: FontStyle.italic,
                        ),
                      ),

                      const SizedBox(height: 10),

                      // Fecha
                      Text(
                        'Fecha: $date',
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 14,
                        ),
                        textAlign: TextAlign.center,
                      ),

                      const SizedBox(height: 20),

                      // Línea divisora
                      const Divider(
                        color: Colors.redAccent,
                        thickness: 2,
                      ),

                      const SizedBox(height: 20),

                      // Botones "Devolver" y "Ver" usando Row con Expanded
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 8.0),
                              child: CustomButton(
                                text: 'Devolver',
                                onPressed: () {
                                  // Acción para el botón "Devolver"
                                  print('Libro devuelto');
                                },
                                dimensioneBoton: 60.0,
                                colorFondo: Colors.redAccent,
                              ),
                            ),
                          ),
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 8.0),
                              child: CustomButton(
                                text: 'Ver',
                                onPressed: () {
                                  // Acción para el botón "Ver"
                                  print('Ver libro');
                                },
                                dimensioneBoton: 60.0,
                                colorFondo: Colors.redAccent,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
