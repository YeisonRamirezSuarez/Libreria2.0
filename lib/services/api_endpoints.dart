import 'package:LibreriaApp/config/config.dart';

class ApiEndpoints {
  static String get baseUrl => AppConfig.baseUrl;

  static String get login => '$baseUrl/login.php';
  static String get registerUser => '$baseUrl/usuario.php';
  static String get updateUser => '$baseUrl/usuario.php?update=1';
  static String get registerBook => '$baseUrl/libro.php';
  static String get fetchBook => '$baseUrl/libro.php';
  static String get fetchBooks => '$baseUrl/libro.php';
  static String get updateBook => '$baseUrl/libro.php?update=1';
  static String get fetchPrestados => '$baseUrl/peticiones.php?prestado=1';
  static String get prestarLibro => '$baseUrl/peticiones.php?prestar=1';
  static String get deletePrestado => '$baseUrl/peticiones.php?delete=1';
  static String get deleteBook => '$baseUrl/libro.php?delete=1';
}
