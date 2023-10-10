import 'package:equatable/equatable.dart';
import '../../bussiness_logic/enums/xo.dart';

abstract class XoGameEvent extends Equatable {
  const XoGameEvent();

  @override
  List<Object> get props => [];
}

class UpdateXoGameEvent extends XoGameEvent {
  final List<List<XO>> xoBoard;

  const UpdateXoGameEvent({required  this.xoBoard});

  @override
  List<Object> get props => [xoBoard];
}
