part of 'xo_game_cubit.dart';

class XoGameState {
  const XoGameState();

}

class XoGameWithListState implements XoGameState {
 late List<List<XO>> xoBoard;
   XoGameWithListState(List<List<XO>> currentXoBoardGame, {required List<List<XO>> xoBoard});
}

class XoGameInitial implements XoGameWithListState {
  @override
  late final List<List<XO>> xoBoard;
  XoGameInitial() {
    xoBoard =List.generate(3, (index) => List.generate(3, (index) => XO.non));
  }
}

class XoGameResetState extends XoGameInitial {}

class XoGameLoadingState implements XoGameState {
  const XoGameLoadingState();
}

 class XoGameLoadedState implements XoGameWithListState {

  @override
  final List<List<XO>> xoBoard;
  const XoGameLoadedState({required this.xoBoard});
  
  @override
  set xoBoard(List<List<XO>> xoBoard) {
  }
}
