import 'package:flutter/material.dart';
import 'package:xo_game2/bussiness_logic/cubit/login_cubit.dart';
import 'package:xo_game2/bussiness_logic/cubit/xo_game_cubit.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

// playerName this is the value from login FormField
//playerNameControll this the controll catch the value of playerName

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  late final GlobalKey<FormState> _formkey;
  late final TextEditingController playerNameController;
  late LoginCubit loginCubit;
  late XoGameCubit xoGameCubit;
  @override
  void initState() {
    super.initState();
    playerNameController = TextEditingController();
    _formkey = GlobalKey<FormState>();
    loginCubit = LoginCubit();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => loginCubit,
      child: BlocConsumer<LoginCubit, LoginState>(
        builder: (context, state) {
          return Scaffold(
            extendBody: true,
            body: Padding(
              padding: const EdgeInsets.all(25.0),
              child: Center(
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            'X',
                            style: GoogleFonts.pressStart2p(
                              fontSize: 50.0,
                              fontWeight: FontWeight.bold,
                              color: const Color.fromARGB(255, 110, 29, 28),
                            ),
                          ),
                          Text(
                            'O',
                            style: GoogleFonts.pressStart2p(
                              fontSize: 50.0,
                              fontWeight: FontWeight.bold,
                              color: const Color.fromARGB(255, 2, 94, 168),
                            ),
                          ),
                          const SizedBox(
                            width: 8.0,
                          ),
                          Text('GAME',
                              style: GoogleFonts.pressStart2p(
                                fontSize: 50.0,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              )),
                        ],
                      ),
                      const SizedBox(
                        height: 40.0,
                      ),
                      Form(
                        key: _formkey,
                        child: TextFormField(
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Please enter the name ';
                            }
                            return null;
                          },
                          controller: playerNameController,
                          onFieldSubmitted: (value) {
                            print(value);
                          },
                          decoration: const InputDecoration(
                              labelText: 'plaese enter nick name ',
                              border: OutlineInputBorder(),
                              prefixIcon: Icon(
                                Icons.person,
                                color: Color.fromARGB(255, 110, 29, 28),
                              )),
                        ),
                      ),
                      const SizedBox(
                        height: 10.0,
                      ),

                      const SizedBox(
                        height: 10.0,
                      ),
                      Container(
                        width: double.infinity,
                        color: const Color.fromARGB(255, 110, 29, 28),
                        child: MaterialButton(
                          onPressed: () {
                            if (_formkey.currentState!.validate()) {
                              loginCubit.addItemToFirestore(
                                  context, playerNameController.text);
                            }
                          },
                          child: const Text(
                            'Enter',
                            style:
                                TextStyle(fontSize: 20.0, color: Colors.white),
                          ),
                        ),
                      ), //XO GAME
                    ],
                  ),
                ),
              ),
            ),
          );
        },
        listener: (context, state) {},
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}
