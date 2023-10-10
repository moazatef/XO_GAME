import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:xo_game2/bussiness_logic/cubit/update_game_event.dart';

import '../../bussiness_logic/cubit/xo_game_cubit.dart';
import '../../bussiness_logic/enums/xo.dart';

class BoardScreen extends StatefulWidget {
  final String currentUser;

  const BoardScreen({super.key, required this.currentUser});

  @override
  State<BoardScreen> createState() => _BoardScreenState();
}

class _BoardScreenState extends State<BoardScreen> {
     final TextEditingController playerNameController =TextEditingController();
 List<List<XO>> xoBoard =[];
  @override
void initState() {
    super.initState();
    List<List<XO>> xoBoard =[];
    FirebaseFirestore.instance
        .collection('games')
        .snapshots()
        .listen((QuerySnapshot<Map<String, dynamic>> snapshot) {
      if (snapshot.docs.isNotEmpty) {
        final gameDoc = snapshot.docs.first;
        final Map<String, dynamic> data = gameDoc.data();
         xoBoard = (data['board'] as List)
            .map((row) => (row as List)
                .map((cell) => (cell != null ? XO.values[cell] : null) ?? XO.non
)
                .toList())
            .toList();
            _xoGameCubit.add(UpdateXoGameEvent(xoBoard: xoBoard), indexRow: 0, indexColumn: 0, playerValue: XO.o, context: context);

      }
    });
  }

  late final  XoGameCubit _xoGameCubit = XoGameCubit(XoGameInitial(),playerNameController);
  
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 28, 58, 72),
      body: BlocProvider(
        create: (context) {
          return _xoGameCubit;
        },
        child: BlocConsumer<XoGameCubit, XoGameState>(
          listener: (context, state) {
            if (state is XoGameLoadedState) {
              // Update the game board in Firestore
              FirebaseFirestore.instance
                  .collection('games')
                  .doc()
                  .update({'board': state.xoBoard});
            }
          },
          builder: (context, state) {
            if (state is XoGameLoadingState) {
              return const CircularProgressIndicator.adaptive();
            }
            late final List<List<XO>> xoBorad;
            if (state is XoGameWithListState) {
              xoBorad = state.xoBoard;
            }
            final rowsLength = xoBorad.length;
            final columnsLength = xoBorad.elementAt(0).length;
            final list = List.generate(rowsLength * columnsLength, (index) {
              final rowIndex = index ~/ 3;
              final columnIndex = index % 3;
              var cellValue =
                  xoBorad.elementAt(rowIndex).elementAt(columnIndex);
              return cellValue;
            });
            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(child: Container()),
                GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: list.length,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: columnsLength),
                  itemBuilder: (context, index) {
                    final cellValue = list.elementAt(index);
                    return GestureDetector(
                      onTap: () {
                        print("Cell tapped!");
                        final indexRow = index ~/ 3;
                        final indexColumn = index % 3;
                        final nextPlayerValue = _xoGameCubit.getCurrentPlayer;

                        _xoGameCubit.add(
                            UpdateXoGameEvent(xoBoard: xoBorad),
                            context:  context,
                            indexRow: indexRow,
                            indexColumn: indexColumn,
                            playerValue: nextPlayerValue,
                            );
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border.all(
                              color: const Color.fromARGB(255, 164, 148, 0)),
                        ),
                        child: Center(
                            child: Text(
                          cellValue == XO.non ? '' : cellValue.name,
                          style: TextStyle(
                            color: XO.o == cellValue ? Colors.blue : Colors.red,
                            fontSize: 40.0,
                            fontWeight: FontWeight.bold,
                          ),
                        )),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 4),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('score:',
                        style: GoogleFonts.pressStart2p(
                          fontSize: 15.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        )),
                    Text(
                      _xoGameCubit.getScoreX.toString(),
                      style: const TextStyle(
                        color: Colors.red,
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Text(
                      ' : ',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      _xoGameCubit.getScoreO.toString(),
                      style: const TextStyle(
                        color: Colors.blue,
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'UserTurn:',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.pressStart2p(
                        fontSize: 15.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    Text(
                      _xoGameCubit.getCurrentPlayer.name,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: _xoGameCubit.getCurrentPlayer == XO.o
                            ? Colors.blue
                            : Colors.red,
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                Expanded(child: Container()),
              ],
            );
          },
        ),
      ),
    );
  }
}
