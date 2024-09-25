import 'dart:io';
import 'package:path_provider/path_provider.dart';

class AppConfig {
  static String baseUrl = 'http://104.197.99.238:80/api'; // Default value
  static String wsUrl = 'ws://104.197.99.238:2026'; // Default value

  // Method to load the configuration from a file
  static Future<void> loadConfig() async {
    final directory = await getApplicationDocumentsDirectory();
    final file = File('${directory.path}/server.txt');

    // Check if the file exists
    if (await file.exists()) {
      final lines = await file.readAsLines();
      if (lines.length >= 2) {
        baseUrl = lines[0];
        wsUrl = lines[1];
      }
    } else {
      // If it does not exist, create the file with default values
      await file.writeAsString('$baseUrl\n$wsUrl');
    }
  }
}
