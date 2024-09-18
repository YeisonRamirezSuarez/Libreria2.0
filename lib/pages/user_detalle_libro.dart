import 'package:flutter/material.dart';
import 'package:libreria_app/models/usuario_model.dart';
import 'package:libreria_app/pages/user_prestado_page.dart';
import 'package:libreria_app/services/api_services.dart';
import 'package:libreria_app/services/dialog_service.dart';
import 'package:libreria_app/widgets/custom_widgets.dart';
import 'package:url_launcher/url_launcher.dart';

class BookDetailPage extends StatelessWidget {
  final Usuario usuario;
  final String role;
  final String name;
  final String titleBaner;
  final int cantButton;

  const BookDetailPage({
    super.key,
    required this.usuario,
    required this.role,
    required this.name,
    required this.titleBaner,
    required this.cantButton,
  });

  Future<void> _launchURL(String url) async {
    if (!await launchUrl(Uri.parse(url))) {
      throw Exception('No se pudo abrir la URL: $url');
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.black,
        body: LayoutBuilder(
          builder: (context, constraints) {
            double imageSize = constraints.maxWidth * 0.5; // Ajusta el tamaño de la imagen en función del ancho
            double textSizeTitle = constraints.maxWidth * 0.06; // Tamaño del texto del título
            double textSizeDetail = constraints.maxWidth * 0.05; // Tamaño del texto de detalles
            double buttonSize = constraints.maxWidth * 0.15; // Tamaño del botón

            return Column(
              children: [
                ItemBannerUser(
                  estadoUsuario: false,
                  seaching: false,
                  titleBaner: titleBaner,
                  rolUser: role,
                  nameUser: name,
                ),
                Expanded(
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: EdgeInsets.all(constraints.maxWidth * 0.05), // Ajusta el padding
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          ImageWidget(
                            imageUrl: usuario.imageUrl,
                            height: imageSize,
                            width: imageSize,
                          ),
                          SizedBox(height: constraints.maxWidth * 0.02), // Espaciado dinámico
                          Text(
                            usuario.title,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: textSizeTitle,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: constraints.maxWidth * 0.01),
                          Text(
                            usuario.author,
                            style: TextStyle(
                              color: Colors.grey[400],
                              fontSize: textSizeDetail,
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                          SizedBox(height: constraints.maxWidth * 0.01),
                          Text(
                            usuario.description,
                            style: TextStyle(
                              color: Colors.grey[600],
                              fontSize: textSizeDetail,
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                          if (usuario.date.isNotEmpty) ...[
                            SizedBox(height: constraints.maxWidth * 0.02),
                            Text(
                              'Fecha: ${usuario.date}',
                              style: TextStyle(
                                color: Colors.white70,
                                fontSize: textSizeDetail * 0.8,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                          SizedBox(height: constraints.maxWidth * 0.04),
                          const Divider(
                            color: Colors.redAccent,
                            thickness: 2,
                          ),
                          SizedBox(height: constraints.maxWidth * 0.08),
                          _buildButtons(context, buttonSize),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildButtons(BuildContext context, double buttonSize) {
    if (cantButton == 2) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: CustomButton(
                text: 'Devolver',
                onPressed: () async {
                  try {
                    final response =
                        await ApiService.deleteLibroPrestado(usuario);

                    if (response.success) {
                      print('Libro devuelto exitosamente');
                      DialogService.showSuccessSnackBar(
                          context, 'Libro devuelto exitosamente');
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const UserPrestadoPage(isPrincipal: true,)),
                      );
                    } else {
                      DialogService.showErrorSnackBar(
                          context, response.error ?? 'Error desconocido');
                    }
                  } catch (error) {
                    DialogService.showErrorSnackBar(
                        context, 'Error de red: $error');
                  }
                },
                dimensioneBoton: buttonSize,
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
                  _launchURL(usuario.bookUrl);
                },
                dimensioneBoton: buttonSize,
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
              final response = await ApiService.prestarLibro(usuario);

              if (response.success) {
                DialogService.showSuccessSnackBar(
                    context, 'Libro prestado exitosamente');
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const UserPrestadoPage(isPrincipal: true,)),
                );
              } else {
                DialogService.showErrorSnackBar(
                    context, response.error ?? 'Error desconocido');
              }
            } catch (error) {
              DialogService.showErrorSnackBar(context, 'Error de red: $error');
            }
          },
          dimensioneBoton: buttonSize,
          colorFondo: Colors.redAccent,
        ),
      );
    } else {
      return const Padding(
        padding: EdgeInsets.symmetric(horizontal: 8.0),
        child: Text(
          'Número de botones no válido',
          style: TextStyle(color: Colors.redAccent, fontSize: 16),
        ),
      );
    }
  }
}
