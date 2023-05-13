import 'dart:ui';

import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool _isTapped = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color.fromRGBO(191, 183, 143, 1),
      child: Column(children: [
        Expanded(
            flex: 5,
            child: Stack(
              //fit: StackFit.expand,
              children: [
                Container(
                  decoration: const BoxDecoration(
                      image: DecorationImage(
                          image: AssetImage('assets/images/old-dog.png'),
                          fit: BoxFit.cover)),
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 2.5, sigmaY: 2.5),
                    child: Center(
                      child: Card(
                        elevation: 10,
                        color: Colors.black.withOpacity(0.5),
                        child: const SizedBox(
                          width: 300,
                          height: 200,
                          child: Center(
                            child: Text(
                              'Logo y BarkBeat',
                              style: TextStyle(fontSize: 30, color: Colors.white),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                //Container(
                //color: Color.fromRGBO(0, 0, 0, 0.5),
                //),
              ],
            )),
        Expanded(
            flex: 5,
            child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 500),
                transitionBuilder: (Widget child, Animation<double> animation) {
                  return FadeTransition(
                  opacity: animation,
                  child: child,
                );
                },
                child: _isTapped ? _loginInputsWidget() : _presentationWidget())),
      ]),
    );
  }

  Widget _presentationWidget() {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      height: 500,
      child: Column(
        children: [
          Expanded(
              flex: 4,
              child: Container(
                color: const Color.fromRGBO(191, 183, 143, 1),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text(
                          "Supervisa su\nactividad cardiaca",
                          style: TextStyle(
                              fontSize: 34,
                              fontFamily: 'Europa',
                              fontWeight: FontWeight.w700,
                              height: 1.3,
                              color: Colors.black,
                              decoration: TextDecoration.none),
                        ),
                        SizedBox(height: 28),
                        SizedBox(
                          width: 64,
                          child: Divider(
                            height: 1,
                            thickness: 5,
                            color: Colors.black,
                          ),
                        ),
                        SizedBox(height: 28),
                        Text(
                          "Bajo el monitoreo de Wearables\ny con Machine Learning 🤖🧠",
                          style: TextStyle(
                              fontFamily: 'Europa',
                              color: Colors.black,
                              fontWeight: FontWeight.w500,
                              fontSize: 22,
                              decoration: TextDecoration.none),
                        )
                      ],
                    ),
                  ],
                ),
              )),
          Expanded(
              flex: 1,
              child: Material(
                child: InkWell(
                  onTap: () {
                    setState(() {
                      _isTapped = !_isTapped;
                    });
                  },

                  //splashColor: Colors.red,
                  //highlightColor: Colors.red,
                  child: Container(
                    color: const Color.fromRGBO(2, 94, 115, 1),
                    child: Row(children: [
                      const Expanded(
                        flex: 7,
                        child: Center(
                            child: Text(
                          "COMENCEMOS",
                          style: TextStyle(
                            fontFamily: 'Riftsoft',
                            fontWeight: FontWeight.w500,
                            decoration: TextDecoration.none,
                            fontSize: 18,
                            letterSpacing: 3.2,
                            color: Colors.white,
                          ),
                        )),
                      ),
                      Expanded(
                        flex: 2,
                        child: Container(
                            color: const Color.fromRGBO(2, 71, 85, 1),
                            child: const Center(
                              //color: Colors.red,
                              child: Text(
                                ">",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontFamily: 'Arial',
                                    fontWeight: FontWeight.w500,
                                    fontSize: 24,
                                    height: 2,
                                    decoration: TextDecoration.none),
                              ),
                            )),
                      )
                    ]),
                  ),
                ),
              )),
        ],
      ),
    );
  }

  Widget _loginInputsWidget() {
    return Container(
        color: const Color.fromRGBO(191, 183, 143, 1),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Material(
              child: TextFormField(
              // The validator receives the text that the user has entered.
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter some text';
                }
                return null;
              },
                      ),
            ),
          ]
          ),
    );
  }
}
