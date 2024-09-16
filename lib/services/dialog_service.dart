import 'package:flutter/material.dart';

class DialogService {
  static void showErrorDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Error'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('OK', style: TextStyle(color: Colors.redAccent)),
          ),
        ],
      ),
    );
  }

  static void showInfoDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Información'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('OK', style: TextStyle(color: Colors.redAccent)),
          ),
        ],
      ),
    );
  }

  static void showErrorSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        //alinear al centro el contenido
        content: Container(
          alignment: Alignment.center,
          width: double.infinity, 
          height: 70,// Ocupa todo el ancho de la pantalla
          padding:
              EdgeInsets.symmetric(horizontal: 16.0), // Espaciado horizontal
          child: Text(
            message,
            style: TextStyle(
              color: Colors.white,
              fontSize: 16.0, // Tamaño del texto más grande
              // Texto en negrita
            ),
            textAlign: TextAlign.center, // Centra el texto
          ),
        ),
        backgroundColor: Colors.redAccent, // Color de fondo rojo
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(topLeft: Radius.circular(10), topRight: Radius.circular(10),),
        ),
        //aqui ponerle un 
      
        
        duration: Duration(seconds: 5), // Duración del SnackBar
        behavior: SnackBarBehavior.floating, // Comportamiento flotante
        padding: EdgeInsets.zero, // Elimina el padding por defecto
        margin: EdgeInsets.all(0), // Elimina el margen por defecto
      ),
    );
  }

  static void showSuccessSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Container(
          width: double.infinity, // Ocupa todo el ancho de la pantalla
          padding:
              EdgeInsets.symmetric(horizontal: 16.0), // Espaciado horizontal
          child: Text(
            message,
            style: TextStyle(
              color: Colors.white,
              fontSize: 18.0, // Tamaño del texto más grande
              fontWeight: FontWeight.bold, // Texto en negrita
            ),
            textAlign: TextAlign.center, // Centra el texto
          ),
        ),
        backgroundColor: Colors.green, // Color de fondo verde para éxito
        duration: Duration(seconds: 3), // Duración del SnackBar
        behavior: SnackBarBehavior.floating, // Comportamiento flotante
        padding: EdgeInsets.zero, // Elimina el padding por defecto
        margin: EdgeInsets.all(0), // Elimina el margen por defecto
      ),
    );
  }
}
