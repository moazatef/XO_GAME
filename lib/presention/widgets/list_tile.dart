// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:xo_game2/bussiness_logic/cubit/waiting_rooms_cubit.dart';


class BuildListTile extends StatefulWidget {
  final String roomName;
  final String playerName;
  final String roomId;
    final String board;
  const BuildListTile(
      {super.key,
      required this.roomName,
      required this.playerName,
      required this.roomId,
       required this.board,
      });

  @override
  State<BuildListTile> createState() => _BuildListTileState();
}

class _BuildListTileState extends State<BuildListTile> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(context) {
    return ListTile(
      onTap: () {
        showDialog(
            context: context,
            builder: (context) {
               WaitingRoomsCubit waitingRoomsCubit = WaitingRoomsCubit();

              return AlertDialog(
                actions: [
                  TextButton(
                      onPressed: () {
                        waitingRoomsCubit.joinRoomAsPlayer2(
                            widget.roomName, context, widget.playerName,widget.board );
                      },
                      child: const Text('Confirm')),
                ],
                title: const Text("DO YOU WANT JOIN THE ROOM ?"),
                content: const Text("this room have a one player "),
              );
            });
      },
      leading: const Icon(
        Icons.meeting_room,
        color: Color.fromARGB(255, 110, 29, 28),
      ),
      title: Text(
        widget.roomName,
        style: GoogleFonts.rajdhani(
          fontSize: 15.0,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
