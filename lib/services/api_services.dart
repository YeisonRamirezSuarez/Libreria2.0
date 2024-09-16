import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:libreria_app/models/api_response.dart';
import 'package:libreria_app/models/book_model.dart';
import 'package:libreria_app/models/usuario_model.dart';
import 'package:libreria_app/widgets/card_libro_history.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/login_model.dart';
import '../config/config.dart';

class ApiService {
  Future<ApiResponseLogin> login(String email, String password) async {
    final url = Uri.parse('${AppConfig.baseUrl}login.php');

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'email': email, 'password': password}),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('email', email);
        await prefs.setString('rol', data['rol']);

        return ApiResponseLogin(user: UserModel.fromJson(data));
      } else if (response.statusCode == 400) {
        final data = json.decode(response.body);
        return ApiResponseLogin(error: data['rol'] ?? 'Error no controlado');
      } else {
        final data = json.decode(response.body);
        return ApiResponseLogin(error: data['error'] ?? 'Error desconocido');
      }
    } catch (e) {
      return ApiResponseLogin(error: 'Error en la conexión: $e');
    }
  }

  static Future<ApiResponseRegistrer> registerUser(User user) async {
    final url = Uri.parse('${AppConfig.baseUrl}/usuario.php');

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: json.encode(user.toJson()),
      );

      final responseBody = json.decode(response.body);
      return ApiResponseRegistrer.fromJson(responseBody);
    } catch (error) {
      throw Exception('Error de red: $error');
    }
  }

  static Future<ApiResponseRegistrer> registerBook(Book book) async {
    final url = Uri.parse('${AppConfig.baseUrl}/libro.php');

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: json.encode(book.toJson()),
      );

      final responseBody = json.decode(response.body);
      return ApiResponseRegistrer.fromJson(responseBody);
    } catch (error) {
      throw Exception('Error de red: $error');
    }
  }

  static Future<Book> fetchBookData(int libroId) async {
    final url = Uri.parse('${AppConfig.baseUrl}/libro.php?id=$libroId');

    try {
      final response = await http.get(url);

      if (response.statusCode == 201) {
        final data = json.decode(response.body);
        return Book.fromJson(data['data'][0]);
      } else {
        throw Exception('Error al obtener los datos del libro');
      }
    } catch (error) {
      throw Exception('Error de red: $error');
    }
  }

  static Future<List<Book>> fetchBooks() async {
    final url = Uri.parse('${AppConfig.baseUrl}/libro.php');

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['data'] is List) {
          return (data['data'] as List)
              .map((item) => Book.fromJson(item))
              .toList();
        } else {
          throw Exception('La respuesta no contiene una lista de libros');
        }
      } else {
        throw Exception('Error de servidor: ${response.statusCode}');
      }
    } catch (error) {
      throw Exception('Error de red: $error');
    }
  }

  static Future<ApiResponseUpdate> updateBook(Book book) async {
    final url =
        Uri.parse('${AppConfig.baseUrl}/libro.php?update=1&id=${book.id}');

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: json.encode(book.toJson()),
      );

      return ApiResponseUpdate.fromJson(json.decode(response.body));
    } catch (error) {
      throw Exception('Error de red: $error');
    }
  }

  static Future<List<Usuario>> fetchUsuariosHistorial() async {
    final url = Uri.parse('${AppConfig.baseUrl}/peticiones.php?prestado=1');

    final response = await http.get(url);

    print(response.statusCode);
    print(response.body);

    if (response.statusCode == 200) {
      final data = json.decode(response.body);

      if (data['data'] is List) {
        return (data['data'] as List)
            .map((item) => Usuario.fromJson(item))
            .toList();
      } else {
        throw Exception('La respuesta no contiene una lista de libros');
      }
    } else {
      // Add this throw statement to handle non-200 status codes.
      throw Exception(
          'Error al obtener el historial de libros. Código de estado: ${response.statusCode}');
    }
  }

 
}
