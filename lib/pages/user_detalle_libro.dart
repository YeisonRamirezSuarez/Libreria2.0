import 'package:flutter/material.dart';
import 'package:libreria_app/models/usuario_model.dart';
import 'package:libreria_app/pages/user_prestado_page.dart';
import 'package:libreria_app/services/api_service.dart';
import 'package:libreria_app/services/snack_bar_service.dart';
import 'package:libreria_app/widgets/custom_widgets.dart';
import 'package:url_launcher/url_launcher.dart';

class BookDetailPage extends StatelessWidget {
  final Usuario usuario;
  final String role;
  final String name;
  final String titleBaner;
  final int cantButton;
  final ApiService _apiService = ApiService(); 


  BookDetailPage({
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
            return _buildContent(context, constraints);
          },
        ),
      ),
    );
  }

  Widget _buildContent(BuildContext context, BoxConstraints constraints) {
    double imageSize = constraints.maxWidth * 0.5;
    double textSizeTitle = constraints.maxWidth * 0.06;
    double textSizeDetail = constraints.maxWidth * 0.05;
    double buttonSize = constraints.maxWidth * 0.15;

    return Column(
      children: [
        _buildHeader(),
        Expanded(
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.all(constraints.maxWidth * 0.05),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  _buildImage(imageSize),
                  SizedBox(height: constraints.maxWidth * 0.02),
                  _buildTitle(textSizeTitle),
                  SizedBox(height: constraints.maxWidth * 0.01),
                  _buildAuthor(textSizeDetail),
                  SizedBox(height: constraints.maxWidth * 0.01),
                  _buildDescription(textSizeDetail),
                  if (usuario.date.isNotEmpty) ...[
                    SizedBox(height: constraints.maxWidth * 0.02),
                    _buildDate(textSizeDetail),
                  ],
                  SizedBox(height: constraints.maxWidth * 0.04),
                  const Divider(color: Colors.redAccent, thickness: 2),
                  SizedBox(height: constraints.maxWidth * 0.08),
                  _buildButtons(context, buttonSize),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildHeader() {
    return ItemBannerUser(
      seaching: false,
      titleBaner: titleBaner,
      rolUser: role,
      nameUser: name,
      viewAdd: false,
      viewVolver: true,
    );
  }

  Widget _buildImage(double size) {
    return ImageWidget(
      imageUrl: usuario.imageUrl,
      height: size,
      width: size,
    );
  }

  Widget _buildTitle(double textSize) {
    return Text(
      usuario.title,
      style: TextStyle(
        color: Colors.white,
        fontSize: textSize,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  Widget _buildAuthor(double textSize) {
    return Text(
      usuario.author,
      style: TextStyle(
        color: Colors.grey[400],
        fontSize: textSize,
        fontStyle: FontStyle.italic,
      ),
    );
  }

  Widget _buildDescription(double textSize) {
    return Text(
      usuario.description,
      style: TextStyle(
        color: Colors.grey[600],
        fontSize: textSize,
        fontStyle: FontStyle.italic,
      ),
    );
  }

  Widget _buildDate(double textSize) {
    return Text(
      'Fecha: ${usuario.date}',
      style: TextStyle(
        color: Colors.white70,
        fontSize: textSize * 0.8,
      ),
      textAlign: TextAlign.center,
    );
  }

  Widget _buildButtons(BuildContext context, double buttonSize) {
    if (cantButton == 2) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          _buildReturnButton(context, buttonSize),
          _buildViewButton(buttonSize),
        ],
      );
    } else if (cantButton == 1) {
      return _buildLendButton(context, buttonSize);
    } else {
      return _buildInvalidButtonCount();
    }
  }

  Widget _buildReturnButton(BuildContext context, double buttonSize) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: CustomButton(
          text: 'Devolver',
          onPressed: () async {
            try {
              final response = await _apiService.deleteLibroPrestado(usuario);
              if (response.success) {
                SnackBarService .showSuccessSnackBar(
                    context, 'Libro devuelto exitosamente');
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const UserPrestadoPage(isPrincipal: true),
                  ),
                );
              } else {
                SnackBarService .showErrorSnackBar(
                    context, response.error ?? 'Error desconocido');
              }
            } catch (error) {
              SnackBarService .showErrorSnackBar(
                  context, 'Error de red: $error');
            }
          },
          dimensioneBoton: buttonSize,
          colorFondo: Colors.redAccent,
        ),
      ),
    );
  }

  Widget _buildViewButton(double buttonSize) {
    return Expanded(
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
    );
  }

  Widget _buildLendButton(BuildContext context, double buttonSize) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: CustomButton(
        text: 'Prestar',
        onPressed: () async {
          try {
            final response = await _apiService.prestarLibro(usuario);
            if (response.success) {
              SnackBarService .showSuccessSnackBar(
                  context, 'Libro prestado exitosamente');
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => const UserPrestadoPage(isPrincipal: true),
                ),
              );
            } else {
              SnackBarService .showErrorSnackBar(
                  context, response.error ?? 'Error desconocido');
            }
          } catch (error) {
            SnackBarService .showErrorSnackBar(context, 'Error de red: $error');
          }
        },
        dimensioneBoton: buttonSize,
        colorFondo: Colors.redAccent,
      ),
    );
  }

  Widget _buildInvalidButtonCount() {
    return const Padding(
      padding: EdgeInsets.symmetric(horizontal: 8.0),
      child: Text(
        'Número de botones no válido',
        style: TextStyle(color: Colors.redAccent, fontSize: 16),
      ),
    );
  }
}
