import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:xo_game2/presention/screens/board_screen.dart';

class WaitingList extends StatefulWidget {
  const WaitingList({super.key});

  @override
  State<WaitingList> createState() => _WaitingListState();
}

class _WaitingListState extends State<WaitingList> {
  final CollectionReference _playerListReference =
      FirebaseFirestore.instance.collection('waitingPlayers');
  late Stream<QuerySnapshot> _streamPlayerListShow;

  @override
  void initState() {
    super.initState();

    // this return Stream and QuaryCollctions of items in this fun will listen in our
    //updates in real time connection
    _streamPlayerListShow = _playerListReference.snapshots();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: const Color.fromARGB(255, 110, 29, 28),
        title: Text(
          'Waiting Players',
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

          var playerdocs = snapshot.data!.docs;
          
          return ListView.builder(
            itemCount: playerdocs.length,
            itemBuilder: (context, index) {
              return ListTile(
                leading: const Icon(
                  Icons.person,
                  color: Color.fromARGB(255, 110, 29, 28),
                ),
                title: Text(
                  playerdocs[index]['name'],
                  style: GoogleFonts.rajdhani(
                    fontSize: 15.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                subtitle: Text('Player ${playerdocs[index]['name']}'),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
          icon: const Icon(
            Icons.gamepad,
          ),
          backgroundColor: Colors.black,
          onPressed: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => const BoardScreen()));
          },
          label: Text(
            "START GAME",
            style: GoogleFonts.oswald(
              color: Colors.white,
              fontSize: 15.0,
            ),
          )),
    );
  }

Future<void> addItemToFirestore(String itemName) async{

final firestoreInstance = FirebaseFirestore.instance;

final existingItem = await firestoreInstance.collection('waitingPlayers').doc(itemName).get();
if(existingItem.exists){
  print('this player is already exist');
}else{
  await firestoreInstance.collection('waitingPlayers').doc(itemName).set({
    'name':itemName,
  });
  print('player added ');
}

}


}
