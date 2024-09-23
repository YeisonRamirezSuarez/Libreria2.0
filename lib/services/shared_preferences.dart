import 'package:shared_preferences/shared_preferences.dart';

Future<Map<String, String>> LoadUserInfo() async {
    final prefs = await SharedPreferences.getInstance();
    final role = prefs.getString('rol') ?? 'Rol de Usuario';
    final email = prefs.getString('email') ?? 'correo del Administrador';
    final name = prefs.getString('name') ?? 'Nombre del Administrador';
    final phone = prefs.getString('phone') ?? 'telefono del Administrador'; 
    final icono = prefs.getString('icono') ?? 'Icono del Administrador'; 

    return {'role': role, 'email': email, 'name': name, 'phone': phone, 'icono': icono};
  }