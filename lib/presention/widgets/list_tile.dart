import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:xo_game2/bussiness_logic/cubit/login_cubit.dart';
import 'package:xo_game2/bussiness_logic/cubit/xo_game_cubit.dart';
import 'package:xo_game2/presention/screens/waiting_playerslist.dart';

class BuildListTile extends StatefulWidget {
  final String roomName;
  const BuildListTile({super.key, required this.roomName});

  @override
  State<BuildListTile> createState() => _BuildListTileState();
}

class _BuildListTileState extends State<BuildListTile> {
  late XoGameCubit xoGameCubit;
  @override
  void initState() {
    super.initState();
    xoGameCubit = BlocProvider.of<XoGameCubit>(context);
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () {
        showDialog(
            context: context,
            builder: (ctx) => AlertDialog(
                  actions: [
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: const Text('cancle'),
                    ),
                    TextButton(onPressed: ()async {
                        await xoGameCubit.joinRoomAsPlayer2(widget.roomName, context);
                    }, child: const Text('Confirm')),
                  ],
                  title: const Text("DO YOU WANT JOIN THE ROOM ?"),
                  content: const Text("this room have a one player "),
                ));
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
