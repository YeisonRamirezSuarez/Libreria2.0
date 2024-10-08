import 'dart:convert';
import 'package:LibreriaApp/config/config.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:LibreriaApp/models/api_response_models/api_response_base.dart';
import 'package:LibreriaApp/models/api_response_models/api_response_delete.dart';
import 'package:LibreriaApp/models/api_response_models/api_response_login.dart';
import 'package:LibreriaApp/models/api_response_models/api_response_registrer.dart';
import 'package:LibreriaApp/models/api_response_models/api_response_update.dart';
import 'package:LibreriaApp/models/book_model.dart';
import 'package:LibreriaApp/models/prestamo_model.dart';
import 'package:LibreriaApp/models/user_model.dart';
import 'package:LibreriaApp/models/usuario_model.dart';
import 'package:LibreriaApp/services/api_helpers.dart';
import 'api_endpoints.dart';

class ApiService {
  Future<ApiResponseLogin> login(String email, String password) async {
    final url = Uri.parse(ApiEndpoints.login);

    print("AppConfig.baseUrl : ${AppConfig.baseUrl}");
    print("AppConfig.wsUrl : ${AppConfig.wsUrl}");
    print("url : ${url}");

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'email': email, 'password': password}),
      );

      return handleLoginResponse(response, email);
    } catch (e) {
      return ApiResponseLogin(error: 'Error en la conexión: $e');
    }
  }

  Future<ApiResponseRegistrer> registerUser(User user) async {
    final url = Uri.parse(ApiEndpoints.registerUser);

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: json.encode(user.toJson()),
      );

      return ApiResponseRegistrer.fromJson(json.decode(response.body));
    } catch (error) {
      throw Exception('Error de red: $error');
    }
  }

  Future<ApiResponseBase> updateUser(User user) async {
    final url = Uri.parse('${ApiEndpoints.updateUser}&email=${user.email}');

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: json.encode(user.toJson()),
      );

      final responseBody = json.decode(response.body);
      return ApiResponseBase.fromJson(responseBody, "success update user");
    } catch (error) {
      throw Exception('Error de red: $error');
    }
  }

  Future<ApiResponseRegistrer> registerBook(Book book) async {
    final url = Uri.parse(ApiEndpoints.registerBook);

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: json.encode(book.toJson()),
      );

      return ApiResponseRegistrer.fromJson(json.decode(response.body));
    } catch (error) {
      throw Exception('Error de red: $error');
    }
  }

  Future<Book> fetchBookData(int libroId) async {
    final url = Uri.parse('${ApiEndpoints.fetchBook}&id=$libroId');

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

  Future<List<Book>> fetchBooks() async {
    final url = Uri.parse(ApiEndpoints.fetchBooks);

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

  Future<ApiResponseUpdate> updateBook(Book book) async {
    final url = Uri.parse('${ApiEndpoints.updateBook}&id=${book.id}');

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

  Future<List<Usuario>> fetchBookForUser(String email) async {
    final url = Uri.parse('${ApiEndpoints.fetchBooks}?email=$email');

    try {
      final response = await http.get(url);

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
        throw Exception(
            'Error al obtener el historial de libros. Código de estado: ${response.statusCode}');
      }
    } catch (error) {
      throw Exception('Error de red: $error');
    }
  }

  Future<List<Usuario>> fetchBookPrestados() async {
    final url = Uri.parse(ApiEndpoints.fetchPrestados);

    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        if (data is Map<String, dynamic> &&
            data.containsKey('data') &&
            data['data'] is List) {
          final List<dynamic> jsonList = data['data'] as List<dynamic>;

          return jsonList
              .map((item) {
                try {
                  return Usuario.fromJson(item as Map<String, dynamic>);
                } catch (e) {
                  print('Error parsing item: $e');
                  return null;
                }
              })
              .whereType<Usuario>()
              .toList();
        } else {
          throw Exception(
              'La respuesta no contiene una lista de libros en la clave "data".');
        }
      } else {
        throw Exception(
            'Error al obtener el historial de libros. Código de estado: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error en la solicitud: $e');
    }
  }

  Future<ApiResponseBase> prestarLibro(Usuario usuario) async {
    final url = Uri.parse(ApiEndpoints.prestarLibro);
    final DateFormat formatter = DateFormat('dd MMMM yyyy, hh:mm a');

    // Constructing the new Usuario object
    final prestarLibroUsuario = Usuario(
      idBook: usuario.idBook,
      title: usuario.title,
      author: usuario.author,
      bookUrl: usuario.bookUrl,
      imageUrl: usuario.imageUrl,
      description: usuario.description,
      prestamos: [
        Prestamo(
          fechaPrestamo: formatter.format(DateTime.now()),
          correoUsuario: usuario.prestamos[0].correoUsuario,
          nombreUsuario: usuario.prestamos[0].nombreUsuario,
          telefonoUsuario: usuario.prestamos[0].telefonoUsuario,
        ),
      ],
    );

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: json.encode(prestarLibroUsuario.toJson()),
      );

      if (response.statusCode == 201 || response.statusCode == 205) {
        final responseBody = json.decode(response.body);
        return ApiResponseBase.fromJson(responseBody, "success lend book");
      } else {
        throw Exception('Error al prestar libro: ${response.statusCode}');
      }
    } catch (error) {
      throw Exception('Error de red: $error');
    }
  }

  Future<ApiResponseDelete> deleteLibroPrestado(Usuario usuario) async {
    final url = Uri.parse(
        '${ApiEndpoints.deletePrestado}&id=${usuario.id}&email=${usuario.prestamos[0].correoUsuario}');
    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 201) {
        final responseBody = json.decode(response.body);
        return ApiResponseDelete.fromJson(responseBody);
      } else {
        throw Exception(
            'Error al eliminar libro prestado: ${response.statusCode}');
      }
    } catch (error) {
      throw Exception('Error de red: $error');
    }
  }

  Future<ApiResponseDelete> deleteLibro(String idLibro) async {
    final url = Uri.parse('${ApiEndpoints.deleteBook}&id=$idLibro');

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 201 || response.statusCode == 205) {
        final responseBody = json.decode(response.body);
        return ApiResponseDelete.fromJson(responseBody);
      } else {
        throw Exception('Error al eliminar libro: ${response.statusCode}');
      }
    } catch (error) {
      throw Exception('Error de red: $error');
    }
  }
}
