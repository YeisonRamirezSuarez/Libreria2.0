import 'package:flutter/material.dart';

class User {
  final String name;
  final String email;
  final String phone;
  final String address;
  final String password;
  final String icono; // icono como String

  // Constructor para el registro (todos los valores son requeridos)
  User({
    required this.name,
    required this.email,
    required this.phone,
    required this.address,
    required this.password,
    this.icono = 'Icons.person', // Valor por defecto como String
  });

  // Constructor para actualización (valores opcionales para actualizar)
  User.update({
    String? name,
    String? email,
    String? phone,
    String? address,
    String? password,
    String? icono,
  })  : name = name ?? '',  // Valores predeterminados si no se pasan
        email = email ?? '',
        phone = phone ?? '',
        address = address ?? '',
        password = password ?? '',
        icono = icono ?? 'Icons.person'; // Valor por defecto como String

  // Método para convertir a JSON, solo incluye campos no vacíos
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};

    if (name.isNotEmpty) {
      data['name'] = name;
    }
    if (email.isNotEmpty) {
      data['email'] = email;
    }
    if (phone.isNotEmpty) {
      data['phone'] = phone;
    }
    if (address.isNotEmpty) {
      data['address'] = address;
    }
    if (password.isNotEmpty) {
      data['password'] = password;
    }
    if (icono.isNotEmpty) {
      data['icono'] = icono; // Enviar el valor del icono como String
    }

    // Asignar siempre el rol de usuario
    if (data['rol'] != 'administrador') {
      data['rol'] = 'usuario';  // El rol siempre será 'usuario'
    }

    return data;
  }

  // Método estático para obtener IconData desde un String
  static IconData getIconFromString(String iconString) {
    switch (iconString) {
      case 'Icons.person':
        return Icons.person;
      case 'Icons.home':
        return Icons.home;
      case 'Icons.email':
        return Icons.email;
      default:
        return Icons.person; // Valor por defecto si no coincide
    }
  }
}
