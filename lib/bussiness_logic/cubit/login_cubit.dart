// ignore_for_file: use_build_context_synchronously

import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
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
      String playerName, BuildContext context) async {
    final firestoreInstance = FirebaseFirestore.instance;

    final existingItem = await firestoreInstance
        .collection('waitingPlayers')
        .doc(playerName)
        .get();
    if (existingItem.exists) {
      return showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) => AlertDialog(
          title: const Text(
            "WRONG!",
          ),
          actions: <Widget>[
            TextButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const LoginScreen(),
                      ));
                },
                child: const Text("The Player Is aleardy exist"))
          ],
        ),
      );
    } else {
      await firestoreInstance.collection('waitingPlayers').doc(playerName).set({
        'name': playerName,
      });
    }
  }

  void createPlayer({
    required String namePlayer,
  }) {
    final PlayersDB playersDB = PlayersDB(name: namePlayer);

    Map<String, dynamic> playerMap = {
      'name': playersDB.name,
    };

    FirebaseFirestore.instance
        .collection('waitingPlayers')
        .doc(namePlayer)
        .set(playerMap);
  }

  Future<bool> doesItemExist(String playerName) async {
    final CollectionReference playerCollection =
        FirebaseFirestore.instance.collection('waitingPlayers');

    final QuerySnapshot playerQuery =
        await playerCollection.where('name', isEqualTo: playerName).get();
    return playerQuery.docs.isNotEmpty;
  }

  // Future<void> checkItemExist(BuildContext context) async {
  //   bool itemExist = await doesItemExist('name');
  //   if (itemExist) {
  //     return showDialog(
  //       barrierDismissible: false,
  //       context: context,
  //       builder: (BuildContext context) => AlertDialog(
  //         title: const Text(
  //           "WRONG!",
  //         ),
  //         actions: <Widget>[
  //           TextButton(
  //               onPressed: () {
  //                 Navigator.pop(context);
  //               },
  //               child: const Text("The Player Is aleardy exist"))
  //         ],
  //       ),
  //     );
  //   } else {
  //     var name = playerNameController.text.trim();
  //     loginCubit.addItemToFirestore(name);
  //     playerNameController.clear();
  //     Navigator.push(
  //       context,
  //       MaterialPageRoute(
  //         builder: (context) => const WaitingList(),
  //       ),
  //     );
  //   }
  // }
}
