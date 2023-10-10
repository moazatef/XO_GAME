import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:xo_game2/bussiness_logic/cubit/xo_game_cubit.dart';
import 'package:xo_game2/presention/screens/board_screen.dart';
import 'package:xo_game2/presention/screens/waiting_playerslist.dart';

import './firebase_options.dart';
import 'package:flutter/material.dart';
import 'package:xo_game2/presention/screens/login_screen.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp( MyApp());
}

class MyApp extends StatelessWidget {
   MyApp({super.key});
    final TextEditingController playerNameController=TextEditingController() ;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => XoGameCubit(XoGameInitial(),playerNameController),
      child: MaterialApp(
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
      ),
    );
  }
}
