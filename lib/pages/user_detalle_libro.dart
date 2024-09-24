import 'package:flutter/material.dart';
import 'package:LibreriaApp/models/usuario_model.dart';
import 'package:LibreriaApp/pages/user_prestado_page.dart';
import 'package:LibreriaApp/services/api_service.dart';
import 'package:LibreriaApp/services/snack_bar_service.dart';
import 'package:LibreriaApp/widgets/custom_widgets.dart';
import 'package:url_launcher/url_launcher.dart';

class BookDetailPage extends StatefulWidget {
  final Usuario usuario;
  final String role;
  final String name;
  final String titleBaner;
  final int cantButton;
  final IconData selectedIcon;

  const BookDetailPage({
    super.key,
    required this.usuario,
    required this.role,
    required this.name,
    required this.titleBaner,
    required this.cantButton,
    required this.selectedIcon,
  });

  @override
  _BookDetailPageState createState() => _BookDetailPageState();
}

class _BookDetailPageState extends State<BookDetailPage> {
  final ApiService _apiService = ApiService();
  bool _isLoading = false; // Bandera para controlar la pantalla de carga

  Future<void> _launchURL(BuildContext context, String url) async {
    if (!url.startsWith('http') && !url.startsWith('https')) {
      SnackBarService.showErrorSnackBar(
          context, "No se pudo abrir la URL: $url");
      return;
    }

    if (!await launchUrl(Uri.parse(url))) {
      throw Exception('No se pudo abrir la URL: $url');
    }
  }

  Future<void> _handleReturn() async {
    setState(() {
      _isLoading = true; // Activar la pantalla de carga
    });
    try {
      final response = await _apiService.deleteLibroPrestado(widget.usuario);

      if (response.success) {
        SnackBarService.showSuccessSnackBar(
            context, 'Libro devuelto exitosamente');
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const UserPrestadoPage(isPrincipal: true),
          ),
        );
      } else {
        SnackBarService.showErrorSnackBar(
            context, response.error ?? 'Error desconocido');
      }
    } catch (error) {
      SnackBarService.showErrorSnackBar(context, 'Error de red: $error');
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false; // Desactivar la pantalla de carga
        });
      }
    }
  }

  Future<void> _handleLend() async {
    setState(() {
      _isLoading = true; // Activar la pantalla de carga
    });
    try {
      final response = await _apiService.prestarLibro(widget.usuario);
      if (response.success) {
        SnackBarService.showSuccessSnackBar(
            context, 'Libro prestado exitosamente');
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const UserPrestadoPage(isPrincipal: true),
          ),
        );
      } else {
        SnackBarService.showErrorSnackBar(
            context, response.error ?? 'Error desconocido');
      }
    } catch (error) {
      SnackBarService.showErrorSnackBar(context, 'Error de red: $error');
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false; // Desactivar la pantalla de carga
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.black,
        body: Stack(
          children: [
            LayoutBuilder(
              builder: (context, constraints) {
                return _buildContent(context, constraints);
              },
            ),
            if (_isLoading) _buildLoadingOverlay(), // Mostrar overlay de carga
          ],
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
                  if (widget.usuario.prestamos.isNotEmpty &&
                      widget.usuario.prestamos[0].fechaPrestamo != null &&
                      widget.usuario.prestamos[0].fechaPrestamo.isNotEmpty) ...[
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
      titleBaner: widget.titleBaner,
      rolUser: widget.role,
      nameUser: widget.name,
      viewAdd: false,
      viewVolver: true,
      selectedIcon: widget.selectedIcon,
    );
  }

  Widget _buildImage(double size) {
    return ImageWidget(
      imageUrl: widget.usuario.imageUrl,
      height: size,
      width: size,
    );
  }

  Widget _buildTitle(double textSize) {
    return Text(
      widget.usuario.title,
      style: TextStyle(
        color: Colors.white,
        fontSize: textSize,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  Widget _buildAuthor(double textSize) {
    return Text(
      widget.usuario.author,
      style: TextStyle(
        color: Colors.grey[400],
        fontSize: textSize,
        fontStyle: FontStyle.italic,
      ),
    );
  }

  Widget _buildDescription(double textSize) {
    return Text(
      widget.usuario.description,
      style: TextStyle(
        color: Colors.grey[600],
        fontSize: textSize,
        fontStyle: FontStyle.italic,
      ),
    );
  }

  Widget _buildDate(double textSize) {
    return Text(
      'Fecha: ${widget.usuario.prestamos[0].fechaPrestamo}',
      style: TextStyle(
        color: Colors.white70,
        fontSize: textSize * 0.8,
      ),
      textAlign: TextAlign.center,
    );
  }

  Widget _buildButtons(BuildContext context, double buttonSize) {
    if (widget.cantButton == 2) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          _buildReturnButton(context, buttonSize),
          _buildViewButton(context, buttonSize),
        ],
      );
    } else if (widget.cantButton == 1) {
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
          onPressed: _isLoading
              ? null
              : _handleReturn, // Deshabilitar si está cargando
          dimensioneBoton: buttonSize,
          colorFondo: Colors.redAccent,
        ),
      ),
    );
  }

  Widget _buildViewButton(BuildContext context, double buttonSize) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: CustomButton(
          text: 'Ver',
          onPressed: _isLoading
              ? null
              : () => _launchURL(context,
                  widget.usuario.bookUrl), // Deshabilitar si está cargando
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
        onPressed:
            _isLoading ? null : _handleLend, // Deshabilitar si está cargando
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

  // Widget para el overlay de carga
  Widget _buildLoadingOverlay() {
    return Positioned.fill(
      child: Stack(
        children: [
          ModalBarrier(
            dismissible: false,
            color: Colors.black.withOpacity(0.5),
          ),
          const Center(
            child: SizedBox(
              width: 100, // Ancho del CircularProgressIndicator
              height: 100, // Altura del CircularProgressIndicator
              child: CircularProgressIndicator(
                color: Colors.redAccent,
                strokeWidth: 8, // Ajusta el grosor del borde
              ),
            ),
          ),
        ],
      ),
    );
  }
}
