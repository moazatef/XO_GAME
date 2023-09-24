import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:xo_game2/bussiness_logic/cubit/xo_game_cubit.dart';
import 'package:xo_game2/data/remote_data/players_database.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:xo_game2/presention/screens/waiting_playerslist.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var playerName = TextEditingController();
    return BlocProvider(
      create: (BuildContext context) => XoGameCubit(XoGameInitial()),
      child: BlocConsumer<XoGameCubit, XoGameState>(
        builder: (context, state) {
          return Scaffold(
            extendBody: true,
            body: Padding(
              padding: const EdgeInsets.all(25.0),
              child: Center(
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            'X',
                            style: GoogleFonts.pressStart2p(
                              fontSize: 50.0,
                              fontWeight: FontWeight.bold,
                              color: const Color.fromARGB(255, 110, 29, 28),
                            ),
                          ),
                          Text(
                            'O',
                            style: GoogleFonts.pressStart2p(
                              fontSize: 50.0,
                              fontWeight: FontWeight.bold,
                              color: const Color.fromARGB(255, 2, 94, 168),
                            ),
                          ),
                          const SizedBox(
                            width: 8.0,
                          ),
                          Text('GAME',
                              style: GoogleFonts.pressStart2p(
                                fontSize: 50.0,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              )),
                        ],
                      ), //login text
                      const SizedBox(
                        height: 40.0,
                      ),
                      TextFormField(
                        controller: playerName,
                        onFieldSubmitted: (value) {
                          print(value);
                        },
                        decoration: const InputDecoration(
                            labelText: 'Player Name',
                            border: OutlineInputBorder(),
                            prefixIcon: Icon(
                              Icons.person,
                              color: Color.fromARGB(255, 110, 29, 28),
                            )),
                      ), //email
                      const SizedBox(
                        height: 10.0,
                      ),

                      const SizedBox(
                        height: 10.0,
                      ),
                      Container(
                        width: double.infinity,
                        color: const Color.fromARGB(255, 110, 29, 28),
                        child: MaterialButton(
                          onPressed: () {
                            createPlayer(namePlayer: playerName.text);
                            print(playerName.text);
                            Navigator.push(context,
                            MaterialPageRoute(
                                    builder: (context) => const WaitingList()));
                          },
                          child: const Text(
                            'Search',
                            style:
                                TextStyle(fontSize: 20.0, color: Colors.white),
                          ),
                        ),
                      ), //XO GAME
                    ],
                  ),
                ),
              ),
            ),
          );
        },
        listener: (context, state) {},
      ),
    );
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
        .doc()
        .set(playerMap);
  }
}
