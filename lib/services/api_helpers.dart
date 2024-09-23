import 'dart:convert';
import 'package:libreria_app/models/api_response_models/api_response_login.dart';
import 'package:libreria_app/models/user_login_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

Future<ApiResponseLogin> handleLoginResponse(http.Response response, String email) async {
  if (response.statusCode == 200) {
    final data = json.decode(response.body);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('email', email);
    await prefs.setString('rol', data['rol']);
    await prefs.setString('name', data['name']);
    await prefs.setString('phone', data['phone']);
    await prefs.setString('icono', data['icono']);

    print("data['icono']: ${data['icono']}");

    return ApiResponseLogin(user: UserLogin.fromJson(data));
  } else {
    final data = json.decode(response.body);
    return ApiResponseLogin(error: data['error'] ?? 'Error desconocido');
  }
}
