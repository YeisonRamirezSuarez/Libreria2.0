import 'package:flutter/material.dart';

class User {
  final String name;
  final String email;
  final String phone;
  final String address;
  final String password;
  final String icono;
  final String rol;

  // Constructor para el registro (todos los valores son requeridos)
  User({
    required this.name,
    required this.email,
    required this.phone,
    required this.address,
    required this.password,
    this.icono = 'Icons.person', // Valor por defecto como String
    required this.rol,
  });

  // Constructor para actualización (valores opcionales para actualizar)
  User.update({
    String? name,
    String? email,
    String? phone,
    String? address,
    String? password,
    String? icono,
    String? rol,
  })  : name = name ?? '', // Valores predeterminados si no se pasan
        email = email ?? '',
        phone = phone ?? '',
        address = address ?? '',
        password = password ?? '',
        icono = icono ?? 'Icons.person', // Valor por defecto como String
        rol = rol ?? '';

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
    if (rol != 'administrador') {
      data['rol'] = 'usuario'; // El rol siempre será 'usuario'
    }

    return data;
  }
}

IconData GetIconFromString(String iconString) {
  switch (iconString) {
    case 'Icons.person':
      return Icons.person;
    case 'Icons.account_circle':
      return Icons.account_circle;
    case 'Icons.face':
      return Icons.face;
    case 'Icons.people':
      return Icons.people;
    case 'Icons.supervised_user_circle':
      return Icons.supervised_user_circle;
    case 'Icons.group':
      return Icons.group;
    case 'Icons.business':
      return Icons.business;
    case 'Icons.work':
      return Icons.work;
    case 'Icons.person_add':
      return Icons.person_add;
    case 'Icons.person_remove':
      return Icons.person_remove;
    case 'Icons.contact_mail':
      return Icons.contact_mail;
    case 'Icons.contact_phone':
      return Icons.contact_phone;
    case 'Icons.email':
      return Icons.email;
    case 'Icons.phone':
      return Icons.phone;
    case 'Icons.card_membership':
      return Icons.card_membership;
    case 'Icons.badge':
      return Icons.badge;
    case 'Icons.security':
      return Icons.security;
    case 'Icons.lock':
      return Icons.lock;
    case 'Icons.vpn_key':
      return Icons.vpn_key;
    case 'Icons.help':
      return Icons.help;
    case 'Icons.info':
      return Icons.info;
    default:
      return Icons.person; // Valor por defecto si no coincide
  }
}
