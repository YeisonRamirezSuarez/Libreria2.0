import 'package:shared_preferences/shared_preferences.dart';

Future<Map<String, String>> LoadUserInfo() async {
    final prefs = await SharedPreferences.getInstance();
    final role = prefs.getString('rol') ?? 'Rol de Usuario';
    final email = prefs.getString('email') ?? 'correo del Administrador';
    final name = prefs.getString('name') ?? 'Nombre del Administrador';
    final phone = prefs.getString('phone') ??
        'telefono del Administrador'; //para obtener la info del usuario backend
    return {'role': role, 'email': email, 'name': name, 'phone': phone};
  }