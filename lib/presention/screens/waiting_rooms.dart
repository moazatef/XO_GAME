import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:xo_game2/bussiness_logic/cubit/waiting_rooms_cubit.dart';
import 'package:xo_game2/presention/widgets/list_tile.dart';

class WaitingRooms extends StatefulWidget {
  final String player;
   final String board;

  const WaitingRooms({
    super.key,
    required this.player,
        required this.board,


  });

  @override
  State<WaitingRooms> createState() => _WaitingRoomsState();
}

class _WaitingRoomsState extends State<WaitingRooms> {
  late final TextEditingController createRoomController;
      
  final Query<Map<String, dynamic>> _playerListQuery =
      FirebaseFirestore.instance.collection('rooms');
  late Stream<QuerySnapshot> _streamPlayerListShow;
  final _formKey = GlobalKey<FormState>();
  WaitingRoomsCubit waitingRoomsCubit = WaitingRoomsCubit();
  @override
  void initState() {
    super.initState();
    createRoomController =TextEditingController();
    // this return Stream and QuaryCollctions of items in this fun will listen in our
    //updates in real time connection
    _streamPlayerListShow = _playerListQuery.snapshots();
    
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: const Color.fromARGB(255, 110, 29, 28),
        title: Text(
          'ROOMS',
          style: GoogleFonts.orbitron(
            fontSize: 25.0,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: _streamPlayerListShow,
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return const Center(child: Text('No data'));
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CupertinoActivityIndicator());
          }

          var roomId = snapshot.data!.docs;

          return ListView.builder(
              itemCount: roomId.length,
              itemBuilder: (context, index) {
                final rooomName = roomId[index]['room_id'];
                final player2 =
                    (roomId[index].data() as Map).containsKey('player_2');
                if (player2) return const SizedBox.shrink();
                return BuildListTile(
                  roomName: rooomName,
                  playerName: widget.player,
                  roomId:roomId.toString(),
                  board: widget.board,
                );
              });
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
          icon: const Icon(
            Icons.gamepad,
          ),
          backgroundColor: Colors.black,
          onPressed: () async {
            showModalBottomSheet(
                context: context,
                builder: (BuildContext bc) {
                  return Padding(
                    padding: EdgeInsetsDirectional.only(
                      top: 10,
                      start: 10,
                      end: 10,
                      bottom: MediaQuery.of(context).viewInsets.bottom + 10,
                    ),
                    child: Form(
                      key: _formKey,
                      child: ListView(
                        shrinkWrap: true,
                        children: <Widget>[
                          TextFormField(
                            validator: (name) {
                              if (name == null || name.isEmpty) {
                                return "Please enter the room name";
                              } else {
                                return null;
                              }
                            },
                            controller: createRoomController,
                            decoration: const InputDecoration(
                              label: Text('Room Name'),
                              prefixIcon: Icon(
                                Icons.gamepad,
                              ),
                              border: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(9.0)),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                FloatingActionButton(
                                    onPressed: () {
                                      if (_formKey.currentState!.validate()) {

                                        waitingRoomsCubit.addItemToFirestore(
                                            context,
                                            createRoomController.text,
                                            widget.player,
                                            createRoomController,
                                           widget.board,
                                              );
                                      }
                                    },
                                    child: const Icon(
                                      Icons.done,
                                    )),
                                const SizedBox(
                                  width: 50.0,
                                ),
                                FloatingActionButton(
                                  onPressed: () {},
                                  child: IconButton(
                                      onPressed: () {
                                        createRoomController.clear();
                                        Navigator.pop(context);
                                      },
                                      icon: const Icon(
                                        Icons.cancel,
                                      )),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                });
          },
          label: Text(
            "Create Room",
            style: GoogleFonts.oswald(
              color: Colors.white,
              fontSize: 15.0,
            ),
          )),
    );
  }
}
