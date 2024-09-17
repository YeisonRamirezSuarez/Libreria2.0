import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
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
        await prefs.setString('name', data['name']);
        await prefs.setString('phone', data['phone']);

        return ApiResponseLogin(user: UserLogin.fromJson(data));
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

  static Future<List<Usuario>> fetchUsuariosHistorial(String email) async {
    final url = Uri.parse('${AppConfig.baseUrl}/libro.php?email=$email');

    final response = await http.get(url);

    print(response.body);
    print(response.statusCode);

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

  static Future<ApiResponse> prestarLibro(Usuario usuario) async {
    final url = Uri.parse('${AppConfig.baseUrl}/peticiones.php?prestar=1');

    // Format the current date
    //10 ene. 2023, 14:58 este es el formato que necesito
    final DateFormat formatter = DateFormat('dd MMMM yyyy, hh:mm a');
    final updatedUsuario = Usuario(
      idBook: usuario.idBook,
      title: usuario.title,
      author: usuario.author,
      bookUrl: usuario.bookUrl,
      imageUrl: usuario.imageUrl,
      description: usuario.description,
      date: formatter.format(DateTime.now()), // Update date here
      emailUser: usuario.emailUser,
      nameUser: usuario.nameUser,
      phoneUser: usuario.phoneUser,
    );

    print(updatedUsuario.toJson());

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: json.encode(updatedUsuario.toJson()),
      );

      print(response.body);
      print(response.statusCode);

      if (response.statusCode == 201 || response.statusCode == 205) {
        final responseBody = json.decode(response.body);
        return ApiResponse.fromJson(responseBody);
      } else {
        throw Exception('Error al prestar libro: ${response.statusCode}');
      }
    } catch (error) {
      throw Exception('Error de red: $error');
    }
  }

  static Future<ApiResponseDelete> deleteLibroPrestado(Usuario usuario) async {
    final url = Uri.parse(
        '${AppConfig.baseUrl}/peticiones.php?delete=1&id=${usuario.id}');
    print(usuario.id);
    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
      );

      print(response.body);
      print(response.statusCode);

      if (response.statusCode == 201) {
        final responseBody = json.decode(response.body);
        return ApiResponseDelete.fromJson(responseBody);
      } else {
        throw Exception('Error al prestar libro: ${response.statusCode}');
      }
    } catch (error) {
      throw Exception('Error de red: $error');
    }
  }

  static Future<ApiResponseDelete> deleteLibro(String idLibro) async {
    final url =
        Uri.parse('${AppConfig.baseUrl}/libro.php?delete=1&id=$idLibro');

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
      );

      print(response.body);
      print(response.statusCode);

      if (response.statusCode == 201) {
        final responseBody = json.decode(response.body);
        return ApiResponseDelete.fromJson(responseBody);
      } else {
        throw Exception('Error al prestar libro: ${response.statusCode}');
      }
    } catch (error) {
      throw Exception('Error de red: $error');
    }
  }
}
