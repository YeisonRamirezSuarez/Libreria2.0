import 'package:flutter/material.dart';
import 'package:libreria_app/utils/validators.dart';
import 'package:libreria_app/widgets/custom_text_field.dart';
import 'package:libreria_app/widgets/custom_button.dart';

class FormLibro extends StatefulWidget {
  final GlobalKey<FormState> formKey;
  final AutovalidateMode autoValidateMode;
  final TextEditingController tituloController;
  final TextEditingController autorController;
  final TextEditingController cantidadController;
  final TextEditingController urlLibroController;
  final TextEditingController urlImagenController;
  final TextEditingController descripcionController;
  final Future<void> Function()? onPressed;
  final String name;
  final String rol;
  final String botonTitle;

  const FormLibro({
    super.key,
    required this.formKey,
    required this.autoValidateMode,
    required this.tituloController,
    required this.autorController,
    required this.cantidadController,
    required this.urlLibroController,
    required this.urlImagenController,
    required this.descripcionController,
    this.onPressed,
    required this.name,
    required this.rol,
    required this.botonTitle,
  });

  @override
  _FormLibroState createState() => _FormLibroState();
}

class _FormLibroState extends State<FormLibro> {
  bool _isLoading = false;

  VoidCallback? _getOnPressedCallback() {
    bool isFormValid = Validators.requiredFieldValidator(
                widget.tituloController.text) ==
            null &&
        Validators.requiredFieldValidator(widget.autorController.text) ==
            null &&
        Validators.numberValidator(widget.cantidadController.text) == null &&
        Validators.urlValidator(widget.urlLibroController.text) == null &&
        Validators.urlValidator(widget.urlImagenController.text) == null &&
        Validators.requiredFieldValidator(widget.descripcionController.text) ==
            null &&
        widget.formKey.currentState?.validate() == true;

    return isFormValid ? _handleSubmit : null;
  }

  Future<void> _handleSubmit() async {
    if (_isLoading) return;

    setState(() {
      _isLoading = true;
    });

    try {
      if (widget.onPressed != null) {
        await widget.onPressed!();
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Form(
          key: widget.formKey,
          autovalidateMode: widget.autoValidateMode,
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                CustomTextField(
                  hintText: 'Título Libro',
                  icon: Icons.book,
                  controller: widget.tituloController,
                  keyboardType: TextInputType.text,
                  validator: Validators.requiredFieldValidator,
                ),
                const SizedBox(height: 16.0),
                CustomTextField(
                  hintText: 'Autor Libro',
                  icon: Icons.person,
                  controller: widget.autorController,
                  keyboardType: TextInputType.text,
                  validator: Validators.requiredFieldValidator,
                ),
                const SizedBox(height: 16.0),
                CustomTextField(
                  hintText: 'Cantidad Libro',
                  icon: Icons.format_list_numbered,
                  maxLength: 3,
                  controller: widget.cantidadController,
                  keyboardType: TextInputType.number,
                  validator: Validators.numberValidator,
                ),
                const SizedBox(height: 16.0),
                CustomTextField(
                  hintText: 'URL Libro',
                  icon: Icons.link,
                  controller: widget.urlLibroController,
                  keyboardType: TextInputType.url,
                  validator: Validators.urlValidator,
                ),
                const SizedBox(height: 16.0),
                CustomTextField(
                  hintText: 'Imagen Libro',
                  icon: Icons.image,
                  controller: widget.urlImagenController,
                  keyboardType: TextInputType.url,
                  validator: Validators.urlValidator,
                ),
                const SizedBox(height: 16.0),
                CustomTextField(
                  hintText: 'Descripción Libro',
                  icon: Icons.description,
                  controller: widget.descripcionController,
                  keyboardType: TextInputType.multiline,
                  maxLines: null,
                  minLines: 3,
                  validator: Validators.requiredFieldValidator,
                ),
                const SizedBox(height: 16.0),
                CustomButton(
                  text: widget.botonTitle,
                  onPressed: _getOnPressedCallback(),
                  colorFondo: Colors.redAccent,
                ),
              ],
            ),
          ),
        ),
        if (_isLoading) _buildLoadingOverlay(),
      ],
    );
  }

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
