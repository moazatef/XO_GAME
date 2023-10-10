// ignore_for_file: use_build_context_synchronously

import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:meta/meta.dart';
import 'package:xo_game2/data/remote_data/players_database.dart';
import 'package:xo_game2/presention/screens/login_screen.dart';
import 'package:xo_game2/presention/screens/waiting_playerslist.dart';

part 'login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  final TextEditingController playerNameController;
  LoginCubit(this.playerNameController) : super(LoginInitial());

  late final LoginCubit loginCubit = LoginCubit(playerNameController);
  Future<void> addItemToFirestore(
       BuildContext context,String playerName,) async {
    final firestoreInstance = FirebaseFirestore.instance;
    try{
       showDialog(
            context: context, 
            barrierDismissible: false,
            builder: (BuildContext context)=>const AlertDialog(
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children:[
                 CircularProgressIndicator(),
                 SizedBox(
                  height: 15.0,
                 ),
                 Text('Adding Player .....'),
               ]),
            ) ,

            );
    

    final existingItem = await firestoreInstance
        .collection('waitingPlayers')
        .doc(playerName)
        .get();
    if (existingItem.exists) {
      Navigator.pop(context);
      return showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) => AlertDialog(
          title: const Text(
            "The Player Is aleardy exist",
          ),
          actions: <Widget>[
            TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text("Close"))
          ],
        ),
      );
    } else {
      await firestoreInstance.collection('waitingPlayers').doc(playerName).set({
        'name': playerName,
      });
       Navigator.pop(context);
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => WaitingList(player_1: playerName),
        ),
      );
    }
    }catch(error){
      print('ERORR ADDING PLAYER : $error');
    }
         
  }


  
      
}

