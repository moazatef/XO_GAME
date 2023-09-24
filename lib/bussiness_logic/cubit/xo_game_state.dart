part of 'xo_game_cubit.dart';

class XoGameState {
  const XoGameState();
}

class XoGameWithListState implements XoGameState {
  final List<List<XO>> xoBoard;
  const XoGameWithListState(this.xoBoard);
}

class XoGameInitial implements XoGameWithListState {
  @override
  late final List<List<XO>> xoBoard;
  XoGameInitial() {
    xoBoard = List.generate(
      3,
      (_) {
        final row = List.generate(3, (_) => XO.non, );
        return row;
      },
 
    );
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
}
