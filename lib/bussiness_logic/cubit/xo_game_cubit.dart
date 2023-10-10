// ignore_for_file: use_build_context_synchronously

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:xo_game2/bussiness_logic/cubit/update_game_event.dart';
import 'package:xo_game2/presention/screens/waiting_playerslist.dart';

import '../enums/xo.dart';

part 'xo_game_state.dart';

class XoGameCubit extends Cubit<XoGameState> {
  late String roomId;
  late List<List<XO>> _currentXoBoardGame;
  final XoGameInitial xoGameState;
  var _previousPlayer = XO.o;
  XO get getPreviosPlayer => _previousPlayer;
  XO get getCurrentPlayer => _previousPlayer == XO.o ? XO.x : XO.o;
  var _scoreX = 0, _scoreO = 0;
  int get getScoreX => _scoreX;
  int get getScoreO => _scoreO;
    late  TextEditingController playerNameController= TextEditingController();
  XoGameCubit(this.xoGameState,this.playerNameController) : super(xoGameState) {
    _currentXoBoardGame = xoGameState.xoBoard;
    _listenToGameInFirebase();

  }
  void add(UpdateXoGameEvent updateXoGameEvent,
      {required int indexRow,
      required int indexColumn,
      required XO playerValue,
      required BuildContext context}) async {
    emit(const XoGameLoadingState());
    final row = _currentXoBoardGame.elementAt(indexRow);
    final cellValue = row.elementAt(indexColumn);
    if (cellValue != XO.non) {
      emit(XoGameLoadedState(xoBoard: _currentXoBoardGame));
      return;
    }
    final replacements = <XO>[playerValue];
    row.replaceRange(indexColumn, indexColumn + 1, replacements);
    _previousPlayer = playerValue;
    final bool isWin =
        await _checkGameState(playerValue: playerValue, context: context);

    if (isWin) {
      if (getPreviosPlayer == XO.x) {
        _scoreX++;
      } else {
        _scoreO++;
      }
      _showWinnerUser(context);
      _updateGameInFirebase();
      _resetBoardGame();
      return;
    }
    final isDraw = _currentXoBoardGame
        .every((element) => element.every((element) => element != XO.non));
    if (isDraw) {
      _showDraw(context);
      _updateGameInFirebase();
      _resetBoardGame();
      return;
    }
    emit(XoGameLoadedState(xoBoard: _currentXoBoardGame));
  }

  Future<bool> _checkGameState(
      {required XO playerValue, required BuildContext context}) async {
    final isPlayerWinByRow = _currentXoBoardGame
        .firstWhere(
          (row) => row.every((cellValue) => cellValue == playerValue),
          orElse: () => [],
        )
        .isNotEmpty;
    if (isPlayerWinByRow) {
      return true;
    }
    for (int columnIndex = 0;
        columnIndex < _currentXoBoardGame.length;
        columnIndex++) {
      final first = _currentXoBoardGame.elementAt(0).elementAt(columnIndex);
      final second = _currentXoBoardGame.elementAt(1).elementAt(columnIndex);
      final third = _currentXoBoardGame.elementAt(2).elementAt(columnIndex);
      if (_isPlayerWinBuColumn(first, playerValue, second, third)) {
        return true;
      }
    }

    final middle = _currentXoBoardGame.elementAt(1).elementAt(1);

    final firstRowAndFirstColumn =
        _currentXoBoardGame.elementAt(0).elementAt(0);
    final lastRowAndLastColumn = _currentXoBoardGame.elementAt(2).elementAt(2);
    if (firstRowAndFirstColumn == playerValue &&
        middle == playerValue &&
        lastRowAndLastColumn == playerValue) {
      return true;
    }

    final lastRowAndfirstColumn = _currentXoBoardGame.elementAt(0).elementAt(2);
    final lastRowAndFirstColumn = _currentXoBoardGame.elementAt(2).elementAt(0);
    if (lastRowAndfirstColumn == playerValue &&
        middle == playerValue &&
        lastRowAndFirstColumn == playerValue) {
      return true;
    }
    return false;
  }

  void _showWinnerUser(BuildContext context) {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: Text(
          "Winner is :${_previousPlayer.name}",
        ),
        actions: <Widget>[
          TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text("Play Again"))
        ],
      ),
    );
  }

  void _showDraw(BuildContext context) {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: const Text(
          "Draw",
        ),
        actions: <Widget>[
          TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text("Play Again"))
        ],
      ),
    );
  }

  bool _isPlayerWinBuColumn(XO? first, XO playerValue, XO? second, XO? third) {
    return first == playerValue &&
        second == playerValue &&
        third == playerValue;
  }

  void _resetBoardGame() {
    emit(const XoGameLoadingState());
    final xoGameReset = XoGameResetState();
    _currentXoBoardGame = xoGameReset.xoBoard;
    emit(xoGameReset);
  }

  void _updateGameInFirebase() {
    final List<List<String>> boardAsString = _currentXoBoardGame
        .map((row) => row.map((cell) => cell.name).toList())
        .toList();
    FirebaseFirestore.instance.collection('games').doc().update({
      'board': boardAsString,
    });
  }

  void _listenToGameInFirebase() {
    FirebaseFirestore.instance
        .collection('games')
        .doc('gameId')
        .snapshots()
        .listen((DocumentSnapshot<Map<String, dynamic>> snapshot) {
      if (snapshot.exists) {
        final List<List<String>> boardAsString =
            List<List<String>>.from(snapshot.data()!['board']);

        final List<List<XO>> updatedBoard = boardAsString
            .map((row) => row
                .map((cell) => cell == XO.x.name
                    ? XO.x
                    : (cell == XO.o.name ? XO.o : XO.non))
                .toList())
            .toList();
        emit(XoGameLoadedState(xoBoard: updatedBoard));
      }
    });
  }

  Future<void> addItemToFirestore(
      BuildContext context, String roomName, String playerName) async {
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
            Text('room added.....'),
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
        await firestoreInstance.collection('rooms').doc().set({
          'room_id': roomName,
          'player_1': playerName,
        });
        Navigator.pop(context);
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => WaitingList(player_1: playerName),
          ),
        );
      }
    } catch (error) {
      print('ERORR ADDING PLAYER : $error');
    }
  }

  Future<bool> doesItemExist(String playerName) async {
    final CollectionReference playerCollection =
        FirebaseFirestore.instance.collection('waitingPlayers');

    final QuerySnapshot playerQuery =
        await playerCollection.where('name', isEqualTo: playerName).get();

    final filterPalyer =
        playerQuery.docs.where((doc) => doc['name'] != playerName).toList();
    return filterPalyer.isNotEmpty;
  }

  Future<void> joinRoomAsPlayer2(String roomName, BuildContext context) async {
    final firestoreInstance = FirebaseFirestore.instance;
      // Get the document reference for the specific room

      final roomReference = firestoreInstance.collection('rooms').doc(roomName);
      // Use a transaction to update the room with player_2

      await firestoreInstance.runTransaction((transaction) async {
        
          // Replace this with the actual logic to get the player's name
          String playerName =playerNameController.text;
          // Update the room with the second player
          transaction.update(roomReference, {
            'player_2': playerName,
          });
      });
  }
}
