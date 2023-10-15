part of 'waiting_rooms_cubit.dart';

sealed class WaitingRoomsState extends Equatable {
  const WaitingRoomsState();

  @override
  List<Object> get props => [];
}

final class WaitingRoomsInitial extends WaitingRoomsState {}
