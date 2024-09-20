import 'package:flutter/material.dart';
import 'package:libreria_app/config/status_bar_config.dart';
import 'package:libreria_app/config/theme_config.dart';
import 'package:libreria_app/pages/login_page.dart';
import 'package:libreria_app/widgets/custom_widgets.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  configureStatusBar(); 
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: appTheme(), 
      home: const KeyboardDismiss(
        child: LoginPage(), 
      ),
    );
  }
}
