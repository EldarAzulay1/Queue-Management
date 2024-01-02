// ignore_for_file: unnecessary_null_comparison, prefer_const_constructors, use_build_context_synchronously, unnecessary_new

import 'dart:convert';
import 'package:firebase_auth_platform_interface/firebase_auth_platform_interface.dart'
    show FirebaseAuthPlatform;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_auth_web/firebase_auth_web.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:my_tor/mengerBus/menuAndReshi/adminMenu.dart';
import 'package:my_tor/tableTor/tableSendTor.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'firebase_options.dart';

class Login extends StatefulWidget {
  final String nameClient;
  const Login({super.key, required this.nameClient});
  State<Login> createState() => _MyHomePageState(nameClient);
}

class _MyHomePageState extends State<Login> {
  final myControllerEmail = TextEditingController();
  final myControllerPassword = TextEditingController();
  String nameClient;
  _MyHomePageState(this.nameClient);
  bool _passwordVisible = true;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(235, 235, 235, 235),
      body: Center(
        child: Column(
          // mainAxisAlignment: MainAxisAlignment.center,
          // ignore: prefer_const_literals_to_create_immutables
          children: <Widget>[
            // ignore: prefer_const_constructors
            SizedBox(
              height: 30,
            ),
            ClipRRect(
              borderRadius: BorderRadius.circular(50.0),
              child: Image.asset(
                "assets/login.jpg",
                width: 110.0,
                height: 110.0,
                fit: BoxFit.fill,
              ),
            ),
            // ignore: prefer_const_constructors
            SizedBox(
              height: 20,
            ),
            // ignore: prefer_const_constructors
            Text("התחבר למערכת",
                // ignore: prefer_const_constructors
                style: TextStyle(
                  color: Color.fromARGB(255, 0, 0, 0),
                  fontWeight: FontWeight.bold,
                  fontSize: 30.0,
                )),
            SizedBox(
              height: 50,
            ),
            Container(
              margin: EdgeInsets.only(left: 10, right: 10),
              width: 400,
              child: Directionality(
                  textDirection: TextDirection.rtl,
                  child: TextField(
                    controller: myControllerEmail,
                    textAlign: TextAlign.left,
                    autofocus: true,
                    // ignore: prefer_const_constructors
                    decoration: new InputDecoration(
                      prefixIcon: Icon(Icons.attach_email_rounded),
                      labelStyle: TextStyle(
                        color: Color.fromARGB(255, 0, 0, 0),
                      ),
                      border: OutlineInputBorder(),
                      labelText: "אימייל",
                    ),
                  )),
            ),
            // ignore: prefer_const_constructors
            SizedBox(
              height: 20,
            ),
            Container(
              margin: EdgeInsets.only(left: 10, right: 10),
              width: 400,
              child: Directionality(
                  textDirection: TextDirection.rtl,
                  child: TextField(
                    obscureText: _passwordVisible,
                    enableSuggestions: false,
                    autocorrect: false,
                    cursorColor: Colors.black,
                    controller: myControllerPassword,
                    textAlign: TextAlign.left,
                    autofocus: true,
                    // ignore: prefer_const_constructors
                    // ignore: unnecessary_new
                    decoration: new InputDecoration(
                      suffixIcon: IconButton(
                        icon: Icon(
                          // Based on passwordVisible state choose the icon
                          _passwordVisible
                              ? Icons.visibility
                              : Icons.visibility_off,
                          color: Theme.of(context).primaryColorDark,
                        ),
                        onPressed: () {
                          // Update the state i.e. toogle the state of passwordVisible variable
                          setState(() {
                            _passwordVisible = !_passwordVisible;
                          });
                        },
                      ),
                      prefixIcon: Icon(Icons.lock_outline_sharp),
                      // ignore: prefer_const_constructors
                      labelStyle: TextStyle(
                        color: Color.fromARGB(255, 6, 6, 6),
                      ),
                      border: OutlineInputBorder(),
                      labelText: "סיסמה",
                    ),
                  )),
            ),
            // ignore: prefer_const_constructors
            SizedBox(
              height: 50,
            ),
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                  primary: Color.fromARGB(255, 27, 178, 247),
                  elevation: 3,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0)),
                  minimumSize: Size(250, 50),
                  textStyle: const TextStyle(fontSize: 23)),
              // ignore: prefer_const_constructors
              icon: Icon(
                Icons.lock_open,
                size: 20,
              ),
              label: Text('התחבר'),
              onPressed: () {
                if (myControllerEmail.text.isEmpty ||
                    myControllerPassword.text.isEmpty) {
                  // ignore: prefer_const_constructors
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    // ignore: prefer_const_constructors
                    content: Text(
                      "הכנס פרטים",
                      textAlign: TextAlign.right,
                    ),
                  ));
                } else if (myControllerEmail.text.isNotEmpty &&
                    myControllerPassword.text.isNotEmpty) {
                  singeIn();
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  Future singeIn() async {
    SharedPreferences prefsMyData = await SharedPreferences.getInstance();
    String Email = prefsMyData.getString("Email").toString();
    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(
              email: myControllerEmail.text.trim(),
              password: myControllerPassword.text.trim());
      if (userCredential != null) {
        if (Email == myControllerEmail.text) {
          SharedPreferences UseremailPass =
              await SharedPreferences.getInstance();
          UseremailPass.setString(
              "UseremailPass",
              // ignore: prefer_interpolation_to_compose_strings
              myControllerEmail.text.toString() +
                  "|" +
                  myControllerPassword.text +
                  "|" +
                  "m");
        } else {
          SharedPreferences UseremailPass =
              await SharedPreferences.getInstance();
          UseremailPass.setString(
              "UseremailPass",
              // ignore: prefer_interpolation_to_compose_strings
              myControllerEmail.text.toString() +
                  "|" +
                  myControllerPassword.text +
                  "|" +
                  "r");
        }
        SharedPreferences UseremailPass = await SharedPreferences.getInstance();

        //   // ignore: prefer_const_constructors
        // ignore: prefer_const_constructors
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          // ignore: prefer_const_constructors
          content: Text(
            "מתחבר",
            textAlign: TextAlign.right,
          ),
        ));
        Navigator.push(
          context,
          PageRouteBuilder(
            transitionDuration: Duration(milliseconds: 500),
            pageBuilder: (context, animation, secondaryAnimation) {
              return adminMenu(
                  nameClient: nameClient,
                  howUser: UseremailPass.getString("UseremailPass")
                      .toString()
                      .split("|")
                      .last
                      .toString());
            },
            transitionsBuilder:
                (context, animation, secondaryAnimation, child) {
              return FadeTransition(
                opacity: animation,
                child: child,
              );
            },
          ),
        );
      }
    } catch (e) {
      // ignore: prefer_const_constructors
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        // ignore: prefer_const_constructors
        content: Text(
          "נסה שנית",
          textAlign: TextAlign.right,
        ),
      ));
    }
  }
}
