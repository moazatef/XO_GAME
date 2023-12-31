// ignore_for_file: use_build_context_synchronously

import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../enums/xo.dart';
part 'xo_game_state.dart';

class XoGameCubit extends Cubit<XoGameState> {
  late List<List<XO>> _currentXoBoardGame;
  final XoGameInitial xoGameState;
  late final String roomId;
  var _previousPlayer = XO.o;
  XO get getPreviosPlayer => _previousPlayer;
  XO get getCurrentPlayer => _previousPlayer == XO.o ? XO.x : XO.o;
  var _scoreX = 0, _scoreO = 0;
  int get getScoreX => _scoreX;
  int get getScoreO => _scoreO;
  XoGameCubit(this.xoGameState, this.roomId) : super(xoGameState) {
    _currentXoBoardGame = xoGameState.xoBoard;
      listenForBoard(_currentXoBoardGame); 

  }

  void add(
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
    _updateGameInFirebase(_currentXoBoardGame, roomId);
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
      _resetBoardGame();
      return;
    }
    final isDraw = _currentXoBoardGame
        .every((element) => element.every((element) => element != XO.non));
    if (isDraw) {
      _showDraw(context);
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

  void lisnter(String player, String roomId, BuildContext context) {
    if (kDebugMode) {
      print("Listener called for room: $roomId");
    }

    late StreamSubscription<DocumentSnapshot<Object?>> subscription;

    subscription = FirebaseFirestore.instance
        .collection('rooms')
        .doc(roomId)
        .snapshots()
        .listen((event) {
      if (kDebugMode) {
        print("Document data: ${event.data()}");
      }
      if (player == event.data()!['player_2']) return;
      if (event.exists && event.data()!['player_2'] == null) {
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context) => const AlertDialog(
            content: Column(mainAxisSize: MainAxisSize.min, children: [
              CircularProgressIndicator(),
              SizedBox(
                height: 15.0,
              ),
              Text('Waiting For player 2 Join .....'),
            ]),
          ),
        );
      } else {
        Navigator.of(context, rootNavigator: true).pop();
        subscription.cancel();
      }
    });
  }

  Future<void> _updateGameInFirebase(
      List<List<XO>> updatedBoard, String roomId) async {
    final List<String> boardAsString = [];
    for (var element in updatedBoard) {
      boardAsString.addAll(element.map((e) => e.name));
    }
    FirebaseFirestore.instance.collection('rooms').doc(roomId).update({
      'board': boardAsString,
    });
  }


  Future<void> listenForBoard(List<List<XO>> board) async{
     FirebaseFirestore.instance
      .collection('rooms')
      .doc(roomId)
      .snapshots()
      .listen((event) {
    if (kDebugMode) {
      print("Document data: ${event.data()}");
    }if (event.data()!.containsKey('board')) {
        emit(XoGameLoadedState(xoBoard: _currentXoBoardGame));
  }
  });
}

}
