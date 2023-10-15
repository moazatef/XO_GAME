// ignore_for_file: use_build_context_synchronously

import 'package:xo_game2/presention/screens/board_screen.dart';

import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

part 'waiting_rooms_state.dart';

class WaitingRoomsCubit extends Cubit<WaitingRoomsState> {
  WaitingRoomsCubit() : super(WaitingRoomsInitial());

  Future<void> addItemToFirestore(BuildContext context, String roomName,
      String playerName, TextEditingController createRoomController) async {
    final firestoreInstance = FirebaseFirestore.instance;
    try {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) => const AlertDialog(
          content: Column(mainAxisSize: MainAxisSize.min, children: [
            CircularProgressIndicator(),
            SizedBox(
              height: 15.0,
            ),
            Text('Adding Room.....'),
          ]),
        ),
      );
      final existingItem =
          await firestoreInstance.collection('rooms').doc(roomName).get();
      if (existingItem.exists) {
        Navigator.pop(context);
        return showDialog(
          barrierDismissible: false,
          context: context,
          builder: (BuildContext context) => AlertDialog(
            title: const Text(
              "the room id is aleardy exist",
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
        await firestoreInstance.collection('rooms').doc(roomName).set({
          'room_id': roomName,
          'player_1': playerName,
        });
        createRoomController.clear();
        Navigator.pop(context);
        Navigator.pop(context);
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => BoardScreen(
                      player: playerName,
                      roomId: roomName,
                    )));
      }
    } catch (error) {
      print('ERORR ADDING PLAYER : $error');
    }
  }

  Future<void> joinRoomAsPlayer2(
      String roomName, BuildContext context, String playerName) async {
    final firestoreInstance = FirebaseFirestore.instance;

    await firestoreInstance.collection('rooms').doc(roomName).update({
      'player_2': playerName,
    });
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) =>
              BoardScreen(player: playerName, roomId: roomName)),
    );
  }
}
