import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:heartdog/src/util/app_colors.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool _isTapped = false;
  bool _obscureText = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Container(
        color: AppColors.backgroundColor,
        child: Column(children: [
          Expanded(
              flex: _isTapped ? 4 : 5,
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
                                style: TextStyle(
                                    fontSize: 30, color: Colors.white),
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
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 500),
              curve: Curves.easeInOut,
              width: MediaQuery.of(context).size.width * 2,
              child: Stack(
                children: [
                  AnimatedPositioned(
                    duration: const Duration(milliseconds: 500),
                    curve: Curves.easeInOut,
                    left: _isTapped ? 0 : MediaQuery.of(context).size.width,
                    child: SizedBox(
                        width: MediaQuery.of(context).size.width,
                        height: MediaQuery.of(context).size.height / 10 * 5,
                        child: _loginInputsWidget()),
                  ),
                  AnimatedPositioned(
                    duration: const Duration(milliseconds: 500),
                    curve: Curves.easeInOut,
                    left: _isTapped ? -MediaQuery.of(context).size.width : 0,
                    child: SizedBox(
                        height: MediaQuery.of(context).size.height / 10 * 5,
                        width: MediaQuery.of(context).size.width,
                        //width: MediaQuery.of(context).size.width,
                        child: _presentationWidget()),
                  ),
                ],
              ),
            ),
            /*child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 500),
                  transitionBuilder:
                      (Widget child, Animation<double> animation) {
                    return FadeTransition(
                      opacity: animation,
                      child: child,
                    );
                  },
                  child: _isTapped
                      ? _loginInputsWidget()
                      : _presentationWidget())*/
          ),
        ]),
      ),
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
                color: AppColors.backgroundColor,
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
                              color: AppColors.textColor,
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
                              color: AppColors.textColor,
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
                            color: const Color.fromRGBO(2, 71, 85, 1), //primaryColor pero mas oscuro
                            child: const Center(
                                //color: Colors.red,
                                child: Icon(Icons.keyboard_arrow_right,
                                    color: Colors.white, size: 28)

                                /*Text(
                                ">",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontFamily: 'Arial',
                                    fontWeight: FontWeight.w500,
                                    fontSize: 24,
                                    height: 2,
                                    decoration: TextDecoration.none),
                              ),*/
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
      color: AppColors.backgroundColor,
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Container(
          margin: const EdgeInsets.only(left: 10),
          child: TextButton(
              style: TextButton.styleFrom(
                minimumSize: const Size(15, 0),
              ),
              onPressed: () => {
                    setState(() {
                      _isTapped = !_isTapped;
                    })
                  },
              child: const Icon(
                Icons.keyboard_arrow_left,
                color: Colors.white,
              )),
        ),
        Material(
          color: Colors.transparent,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Correo electrónico',
                      style: TextStyle(
                          color: AppColors.primaryColor,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Europa',
                          fontSize: 18),
                    ),
                    const SizedBox(height: 15),
                    TextFormField(
                      keyboardType: TextInputType.emailAddress,
                      cursorColor: AppColors.primaryColor,
                      style: const TextStyle(
                        color: AppColors.textColor,
                      ),
                      onTapOutside: (event) => {
                        //event.
                      },

                      decoration: const InputDecoration(
                        //filled: true,

                        //prefixText: '@sda',
                        //fillColor: Color.fromARGB(0, 0, 0, 0),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                              color: AppColors.primaryColor, width: 2.0),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: Colors.blueGrey, width: 2.0),
                        ),
                        hintText: 'email@example.com',
                        hintStyle: TextStyle(
                          color: Colors.grey,
                        ),
                        //counterText: "${_email.length.toString()}/40",
                        counterStyle: const TextStyle(color: Colors.white),
                        focusColor: Colors.white,
                        hoverColor: Colors.white,
                      ),
                      // The validator receives the text that the user has entered.
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter some text';
                        }
                        return null;
                      },
                    ),
                  ],
                ),
                SizedBox(height: 20),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Contraseña',
                      style: TextStyle(
                          color: AppColors.primaryColor,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Europa',
                          fontSize: 18),
                    ),
                    const SizedBox(height: 15),
                    TextFormField(
                      keyboardType: TextInputType.text,
                      cursorColor: AppColors.primaryColor,
                      style: const TextStyle(
                        color: AppColors.textColor,
                      ),
                      onTapOutside: (event) => {
                        //event.
                      },
                      obscureText: !_obscureText,

                      decoration: InputDecoration(
                        //filled: true,
                        suffixIcon: GestureDetector(
                          onTap: () {
                            setState(() {
                              _obscureText = !_obscureText;
                            });
                          },
                          child: Icon(
                              _obscureText
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                              color: Colors.blueGrey),
                        ),
                        //prefixText: '@sda',
                        //fillColor: Color.fromARGB(0, 0, 0, 0),
                        enabledBorder: const OutlineInputBorder(
                          borderSide: BorderSide(
                              color: AppColors.primaryColor, width: 2.0),
                        ),
                        focusedBorder: const OutlineInputBorder(
                          borderSide:
                              BorderSide(color: Colors.blueGrey, width: 2.0),
                        ),
                        hintText: '*****',
                        hintStyle: const TextStyle(
                          color: Colors.grey,
                        ),
                        //counterText: "${_email.length.toString()}/40",
                        counterStyle: const TextStyle(color: Colors.white),
                        focusColor: Colors.white,
                        hoverColor: Colors.white,
                      ),
                      // The validator receives the text that the user has entered.
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter some text';
                        }
                        return null;
                      },
                    ),
                  ],
                ),
                const SizedBox(
                  height: 35,
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30.0),
                      ),
                      minimumSize: const Size.fromHeight(50),
                      backgroundColor: const Color.fromRGBO(2, 71, 85, 1),
                      textStyle: const TextStyle(
                          color: Colors.white,
                          fontFamily: 'Riftsoft',
                          fontWeight: FontWeight.w500,
                          fontSize: 18,
                          letterSpacing: 2.0)),
                  onPressed: () {
                    Navigator.of(context).pushNamed('/controlpages');
                  },
                  child: const Text('Iniciar sesión'),
                ),
                /*const SizedBox(
                  height: 20,
                ),
                Center(
                  child: Text(
                    '¿Olvidaste tu contraseña?',
                    style: TextStyle(
                        fontFamily: 'Europa',
                        fontSize: 14,
                        fontWeight: FontWeight.w500),
                  ),
                ),*/
                const SizedBox(
                  height: 30,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Text(
                    '¿No tienes una cuenta? ',
                    style: TextStyle(
                        fontFamily: 'Europa',
                        fontSize: 16,
                        fontWeight: FontWeight.w500),
                  ),
                  Text(
                    'Registrate',
                    style: TextStyle(
                        fontFamily: 'Europa',
                        color: AppColors.primaryColor,
                        fontSize: 16,
                        fontWeight: FontWeight.w500),
                  ),
                ],)
              ],
            ),
          ),
        ),
      ]),
    );
  }
}
