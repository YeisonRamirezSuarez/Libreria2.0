import 'dart:io';
import 'package:LibreriaApp/config/config.dart';
import 'package:LibreriaApp/pages/login_page.dart';
import 'package:LibreriaApp/services/api_endpoints.dart';
import 'package:LibreriaApp/widgets/custom_widgets.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

class ConfigWidget extends StatefulWidget {
  @override
  _ConfigWidgetState createState() => _ConfigWidgetState();
}

class _ConfigWidgetState extends State<ConfigWidget> {
  final _baseUrlController = TextEditingController();
  final _wsUrlController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadConfig();
  }

  Future<void> _loadConfig() async {
    final directory = await getApplicationDocumentsDirectory();
    final file = File('${directory.path}/server.txt');

    if (await file.exists()) {
      final lines = await file.readAsLines();
      if (lines.length >= 2) {
        _baseUrlController.text = lines[0];
        _wsUrlController.text = lines[1];
      }
    } else {
      // Si no existe el archivo, crearlo con datos predeterminados
      await file.writeAsString(
          'http://104.197.99.238:80/api\nws://104.197.99.238:2026');
      _baseUrlController.text = 'http://104.197.99.238:80/api';
      _wsUrlController.text = 'ws://104.197.99.238:2026';
    }
  }

  Future<void> _saveConfig() async {
    final directory = await getApplicationDocumentsDirectory();
    final file = File('${directory.path}/server.txt');
    await file
        .writeAsString('${_baseUrlController.text}\n${_wsUrlController.text}');
    _showInfoDialog('Configuración guardada correctamente.');
  }

  void _showInfoDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Información'),
        content: Text(message),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              FocusScope.of(context).unfocus();
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => const LoginPage(),
                ),
              );
            },
            child: const Text('Aceptar', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CustomTextField(
            hintText: 'Base URL',
            icon: Icons.link,
            controller: _baseUrlController,
            keyboardType: TextInputType.url,
          ),
          const SizedBox(height: 30),
          CustomTextField(
            hintText: 'WebSocket URL',
            icon: Icons.link,
            controller: _wsUrlController,
            keyboardType: TextInputType.url,
          ),
          const SizedBox(height: 40),
          CustomButton(
            onPressed: _saveConfig,
            text: 'Guardar',
            colorFondo: Colors.redAccent,
            dimensioneBoton: 60.0,
          ),
        ],
      ),
    );
  }
}
