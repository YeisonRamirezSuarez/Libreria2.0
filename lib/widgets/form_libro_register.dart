import 'package:flutter/material.dart';
import 'package:libreria_app/utils/validators.dart';
import 'package:libreria_app/widgets/custom_widgets.dart';

class FormLibro extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final AutovalidateMode autoValidateMode;
  final TextEditingController tituloController;
  final TextEditingController autorController;
  final TextEditingController cantidadController;
  final TextEditingController urlLibroController;
  final TextEditingController urlImagenController;
  final TextEditingController descripcionController;
  final VoidCallback onPressed; // O VoidCallback si no pasas argumentos
  final String name;
  final String rol;
  final String botonTitle;

  const FormLibro({
    Key? key,
    required this.formKey,
    required this.autoValidateMode,
    required this.tituloController,
    required this.autorController,
    required this.cantidadController,
    required this.urlLibroController,
    required this.urlImagenController,
    required this.descripcionController,
    required this.onPressed,
    required this.name,
    required this.rol,
    required this.botonTitle,
  }) : super(key: key);

  VoidCallback? _getOnPressedCallback() {
    bool isFormValid = Validators.requiredFieldValidator(tituloController.text) == null &&
        Validators.requiredFieldValidator(autorController.text) == null &&
        Validators.numberValidator(cantidadController.text) == null &&
        Validators.urlValidator(urlLibroController.text) == null &&
        Validators.urlValidator(urlImagenController.text) == null &&
        Validators.requiredFieldValidator(descripcionController.text) == null &&
        formKey.currentState?.validate() == true;

    return isFormValid ? onPressed : null;
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Form(
      key: formKey,
      autovalidateMode: autoValidateMode,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.02),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            CustomTextField(
              hintText: 'Título Libro',
              icon: Icons.book,
              controller: tituloController,
              keyboardType: TextInputType.text,
              validator: Validators.requiredFieldValidator,
            ),
            SizedBox(height: screenHeight * 0.02),
            CustomTextField(
              hintText: 'Autor Libro',
              icon: Icons.person,
              controller: autorController,
              keyboardType: TextInputType.text,
              validator: Validators.requiredFieldValidator,
            ),
            SizedBox(height: screenHeight * 0.02),
            CustomTextField(
              hintText: 'Cantidad Libro',
              icon: Icons.format_list_numbered,
              maxLength: 3,
              controller: cantidadController,
              keyboardType: TextInputType.number,
              validator: Validators.numberValidator,
            ),
            SizedBox(height: screenHeight * 0.02),
            CustomTextField(
              hintText: 'URL Libro',
              icon: Icons.link,
              controller: urlLibroController,
              keyboardType: TextInputType.url,
              validator: Validators.urlValidator,
            ),
            SizedBox(height: screenHeight * 0.02),
            CustomTextField(
              hintText: 'Imagen Libro',
              icon: Icons.image,
              controller: urlImagenController,
              keyboardType: TextInputType.url,
              validator: Validators.urlValidator,
            ),
            SizedBox(height: screenHeight * 0.02),
            CustomTextField(
              hintText: 'Descripción Libro',
              icon: Icons.description,
              controller: descripcionController,
              keyboardType: TextInputType.multiline,
              maxLines: null,
              minLines: 3,
              validator: Validators.requiredFieldValidator,
            ),
            SizedBox(height: screenHeight * 0.02),
            CustomButton(
              text: botonTitle,
              onPressed: _getOnPressedCallback(),
              colorFondo: Colors.redAccent,
            ),
          ],
        ),
      ),
    );
  }
}
