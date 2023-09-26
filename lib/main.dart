import 'package:xo_game2/presention/screens/board_screen.dart';
import 'package:xo_game2/presention/screens/waiting_playerslist.dart';

import './firebase_options.dart';
import 'package:flutter/material.dart';
import 'package:xo_game2/presention/screens/login_screen.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async{
    WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,

  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return  MaterialApp( 
      home:LoginScreen(),
    );
  }
}

