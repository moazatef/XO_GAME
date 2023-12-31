
import './firebase_options.dart';
import 'package:flutter/material.dart';
import 'package:xo_game2/presention/screens/login_screen.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp( const MyApp());
}

class MyApp extends StatelessWidget {
   const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        indicatorColor: const Color.fromARGB(255, 110, 29, 28),
        primaryColor: const Color.fromARGB(255, 110, 29, 28),
        textSelectionTheme: const TextSelectionThemeData(
          cursorColor: Color.fromARGB(255, 110, 29, 28),
          selectionColor: Color.fromRGBO(110, 29, 28, 0.392),
          selectionHandleColor: Color.fromARGB(255, 110, 29, 28),
        ),
        inputDecorationTheme: const InputDecorationTheme(
          labelStyle: TextStyle(color: Color.fromARGB(255, 110, 29, 28)),
          activeIndicatorBorder: BorderSide(
            color: Color.fromARGB(255, 110, 29, 28),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: Color.fromARGB(255, 110, 29, 28),
            ),
          ),
        ),
      ),
      home: const LoginScreen(),
    );
  }
}