import 'package:flutter/material.dart';
import 'package:libreria_app/models/usuario_model.dart';
import 'package:libreria_app/services/api_services.dart';
import 'package:libreria_app/widgets/custom_widgets.dart';


class BookDetailPage extends StatelessWidget {
  final Usuario usuario;
  final String role;
  final String correo;
  final String titleBaner;
  final int cantButton;

  const BookDetailPage({
    super.key,
    required this.usuario,
    required this.role,
    required this.correo,
    required this.titleBaner,
    required this.cantButton,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.black,
        body: Column(
          children: [
            ItemBannerUser(
              estadoUsuario: false,
              seaching: false,
              titleBaner: titleBaner,
              rolUser: role,
              nameUser: correo,
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      ImageWidget(
                        imageUrl: usuario.imageUrl,
                        height: 200.0,
                        width: 200.0,
                      ),
                      Text(
                        usuario.title,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        usuario.author,
                        style: TextStyle(
                          color: Colors.grey[400],
                          fontSize: 16,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                      if (usuario.date.isNotEmpty)
                        ...[
                          const SizedBox(height: 10),
                          Text(
                            'Fecha: ${usuario.date}',
                            style: const TextStyle(
                              color: Colors.white70,
                              fontSize: 14,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      const SizedBox(height: 20),
                      const Divider(
                        color: Colors.redAccent,
                        thickness: 2,
                      ),
                      const SizedBox(height: 40),
                      _buildButtons(context),
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

  Widget _buildButtons(BuildContext context) {
    if (cantButton == 2) {
      return Row(
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
      );
    } else if (cantButton == 1) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: CustomButton(
          text: 'Prestar',
          onPressed: () async {
            try {
              await ApiService.prestarLibro(usuario);
              print('Libro prestado');
            } catch (e) {
              print('Error al prestar libro: $e');
            }
          },
          dimensioneBoton: 60.0,
          colorFondo: Colors.redAccent,
        ),
      );
    } else {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: Text(
          'Número de botones no válido',
          style: TextStyle(color: Colors.redAccent, fontSize: 16),
        ),
      );
    }
  }
}
