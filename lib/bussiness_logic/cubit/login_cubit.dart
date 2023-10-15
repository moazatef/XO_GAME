// ignore_for_file: use_build_context_synchronously

import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:xo_game2/presention/screens/waiting_rooms.dart';
part 'login_state.dart';

// playerName this is the value from login FormField
//playerNameControll this the controll catch the value of playerName 

class LoginCubit extends Cubit<LoginState> {
  LoginCubit() : super(LoginInitial());
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
          builder: (context) => WaitingRooms(player: playerName,),
        ),
      );
    }
    }catch(error){
      print('ERORR ADDING PLAYER : $error');
    }
         
  }  
}
