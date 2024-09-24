import 'package:flutter/material.dart';
import 'package:LibreriaApp/services/snack_bar_service.dart';
import 'package:LibreriaApp/widgets/custom_widgets.dart';

class UserEditWidget extends StatefulWidget {
  final List<IconData> availableIcons;
  final String initialName;
  final IconData selectedIcon;
  final Function(IconData, String) onSave;
  final Function() onCancel;

  const UserEditWidget({
    super.key,
    required this.availableIcons,
    required this.initialName,
    required this.selectedIcon,
    required this.onSave,
    required this.onCancel,
  });

  @override
  UserEditWidgetState createState() => UserEditWidgetState();
}

class UserEditWidgetState extends State<UserEditWidget> {
  late IconData _tempSelectedIcon;
  late TextEditingController _tempNameController;

  @override
  void initState() {
    super.initState();
    _tempSelectedIcon = widget.selectedIcon;
    _tempNameController = TextEditingController(text: widget.initialName);
  }

  @override
  void dispose() {
    _tempNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Definir el tamaño del botón dinámicamente
    final double screenWidth = MediaQuery.of(context).size.width;
    double buttonSize; // Tamaño del botón

    return Dialog(
      child: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          buttonSize = constraints.maxWidth * 0.15;
          return ConstrainedBox(
            constraints: BoxConstraints(
              maxWidth: screenWidth *
                  0.9, // Limitar el ancho máximo al 90% de la pantalla
            ),
            child: SingleChildScrollView(
              child: Container(
                padding: const EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.circular(8.0),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 8.0,
                      offset: Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Selecciona un ícono:',
                      style: TextStyle(fontSize: 18, color: Colors.white),
                    ),
                    const SizedBox(height: 10),
                    SizedBox(
                      height: constraints.maxHeight *
                          0.4, // Ajustar altura del GridView
                      child: GridView.builder(
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: screenWidth > 600
                              ? 6
                              : 4, // Cambiar el número de columnas según el tamaño de pantalla
                          crossAxisSpacing: 10.0,
                          mainAxisSpacing: 10.0,
                        ),
                        itemCount: widget.availableIcons.length,
                        itemBuilder: (BuildContext context, int index) {
                          IconData icon = widget.availableIcons[index];
                          bool isSelected = _tempSelectedIcon == icon;
                          return GestureDetector(
                            onTap: () {
                              setState(() {
                                _tempSelectedIcon = icon;
                              });
                            },
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  icon,
                                  color: isSelected
                                      ? Colors.redAccent
                                      : Colors.white,
                                  size: screenWidth *
                                      0.08, // Tamaño del ícono ajustado dinámicamente
                                ),
                                const SizedBox(height: 8),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 20),
                    TextField(
                      controller: _tempNameController,
                      cursorColor: Colors.redAccent,
                      style: const TextStyle(color: Colors.white),
                      decoration: const InputDecoration(
                        labelText: 'Nombre',
                        hintText: 'Ingresa tu nombre',
                        hintStyle: TextStyle(color: Colors.white70),
                        floatingLabelStyle: TextStyle(color: Colors.white),
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.white54),
                        ),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.redAccent),
                        ),
                      ),
                    ),
                    const SizedBox(height: 50),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        Expanded(
                          child: Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 8.0),
                            child: CustomButton(
                              text: 'Guardar',
                              onPressed: () {
                                widget.onSave(_tempSelectedIcon,
                                    _tempNameController.text);
                                SnackBarService.showSuccessSnackBar(
                                    context, 'Usuario editado con éxito');
                              },
                              dimensioneBoton: buttonSize,
                              colorFondo: Colors.redAccent,
                            ),
                          ),
                        ),
                        Expanded(
                          child: Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 8.0),
                            child: CustomButton(
                              text: 'Cancelar',
                              onPressed: () {
                                widget.onCancel();
                              },
                              dimensioneBoton: buttonSize,
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
          );
        },
      ),
    );
  }
}
