// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'dart:html';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/foundation.dart';
import 'dart:typed_data';
import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:my_tor/main.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_email_sender/flutter_email_sender.dart';

class myDetails extends StatefulWidget {
  myDetails({Key? key}) : super(key: key);

  @override
  State<myDetails> createState() => _list();
}

class _list extends State<myDetails> {
  _list();
  String name = "",
      phone = "",
      bisName = "",
      steert = "",
      city = "",
      email = "",
      password = "";

  final myControllerFullName = TextEditingController();
  final myControllerPhone = TextEditingController();
  final myControllerNameBis = TextEditingController();
  final myControllerEmail = TextEditingController();
  final myControllerStreet = TextEditingController();
  final myControllerCity = TextEditingController();
  final myControllerPassword = TextEditingController();
  bool _passwordVisible = true;

  // remove() async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   setState(() {
  //     prefs.clear();
  //   });
  // }

  @override
  void initState() {
    // TODO: implement initState
    // remove();
    super.initState();
  }

  Widget build(BuildContext context) {
    return (Container(
        child: Column(
      mainAxisSize: MainAxisSize.min,
      // ignore: prefer_const_literals_to_create_immutables
      children: [
        ConstrainedBox(
          constraints: BoxConstraints(minHeight: 50, maxWidth: 500),
          child: nameStep(),
        ),

        // ignore: prefer_const_constructors
        ConstrainedBox(
          constraints: BoxConstraints(minHeight: 50, maxWidth: 500),
          child: Divider(
            height: 40,
            thickness: 3,
          ),
        ),

        SizedBox(
          height: 10,
        ),

        ConstrainedBox(
          constraints: BoxConstraints(minHeight: 50, maxWidth: 500),
          child: setDetatils(context),
        )
      ],
    )));
  }

  get() async {
    SharedPreferences prefsMyData = await SharedPreferences.getInstance();
    if (prefsMyData.getString("FullName").toString() != "null") {
      setState(() {
        name = prefsMyData.getString("FullName").toString();
        phone = prefsMyData.getString("Phone").toString();
        bisName = prefsMyData.getString("NameBis").toString();
        steert = prefsMyData.getString("Street").toString();
        email = prefsMyData.getString("Email").toString();
        password = prefsMyData.getString("Password").toString();
      });
    }

    print("ewfewfwefwef33 " + prefsMyData.getString("FullName").toString());
  }

  setDetatils(context) {
    get();
    return Container(
      decoration: BoxDecoration(
          border: Border.all(
            color: Color.fromARGB(255, 199, 195, 195),
          ),
          borderRadius: BorderRadius.all(Radius.circular(5))),
      //alignment: Alignment.topRight,
      child: Container(
        margin: EdgeInsets.only(right: 15, left: 15),
        child: Column(children: [
          SizedBox(
            height: 20,
            width: 20,
          ),

//שם מלא
          Container(
            alignment: Alignment.topRight,
            child: Column(
              children: [
                Container(
                  //margin: EdgeInsets.only(right: 10),
                  alignment: Alignment.topRight,
                  // ignore: prefer_const_constructors
                  child: Text("שם מלא",
                      // ignore: prefer_const_constructors
                      // textAlign: TextAlign.right,
                      // ignore: prefer_const_constructors
                      style: TextStyle(
                        color: Color.fromARGB(255, 0, 0, 0),
                        fontWeight: FontWeight.bold,
                        fontSize: 15.0,
                      )),
                ),
                SizedBox(
                  height: 5,
                ),
                Container(
                  width: 400,
                  child: Directionality(
                      textDirection: TextDirection.rtl,
                      child: TextField(
                        controller: myControllerFullName,
                        textDirection: TextDirection.ltr,
                        textAlign: TextAlign.right,
                        autofocus: true,
                        onChanged: (value) async {
                          print("eeedf " + myControllerFullName.text);
                          SharedPreferences prefsMyData =
                              await SharedPreferences.getInstance();

                          prefsMyData
                              .setString("FullName", myControllerFullName.text)
                              .toString();
                        },
                        // ignore: prefer_const_constructors
                        // ignore: unnecessary_new
                        decoration: new InputDecoration(
                          filled: true,
                          prefixIcon: Icon(Icons.account_circle_rounded),
                          labelStyle: TextStyle(
                            color: Color.fromARGB(255, 0, 0, 0),
                          ),
                          border: OutlineInputBorder(),
                          hintText: name != "null" ? name : "",
                        ),
                      )),
                ),
              ],
            ),
          ),
          // ignore: prefer_const_constructors
          SizedBox(
            height: 10,
          ),
          //פלאפון"
          Container(
              alignment: Alignment.topRight,
              // ignore: prefer_const_constructors
              child: Column(
                children: [
                  Container(
                      alignment: Alignment.topRight,
                      child: Column(children: [
                        // ignore: prefer_const_constructors
                        Container(
                          //margin: EdgeInsets.only(right: 10),
                          alignment: Alignment.topRight,
                          // ignore: prefer_const_constructors
                          child: Text("טלפון",
                              // ignore: prefer_const_constructors
                              textAlign: TextAlign.right,
                              // ignore: prefer_const_constructors
                              style: TextStyle(
                                color: Color.fromARGB(255, 0, 0, 0),
                                fontWeight: FontWeight.bold,
                                fontSize: 15.0,
                              )),
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        // ignore: prefer_const_constructors
                        Container(
                          width: 400,
                          child: Directionality(
                              textDirection: TextDirection.rtl,
                              child: TextField(
                                keyboardType: TextInputType.number,

                                onChanged: (value) async {
                                  SharedPreferences prefsMyData =
                                      await SharedPreferences.getInstance();

                                  prefsMyData
                                      .setString(
                                          "Phone", myControllerPhone.text)
                                      .toString();
                                },
                                controller: myControllerPhone,
                                textAlign: TextAlign.right,
                                autofocus: true,
                                // ignore: prefer_const_constructors
                                // ignore: unnecessary_new
                                decoration: new InputDecoration(
                                  filled: true,
                                  prefixIcon: Icon(Icons.phone_iphone_sharp),
                                  labelStyle: TextStyle(
                                    color: Color.fromARGB(255, 0, 0, 0),
                                  ),
                                  border: OutlineInputBorder(),
                                  hintText: phone != "null" ? phone : "",
                                ),
                              )),
                        ),
                      ])),
                ],
              )),
          // ignore: prefer_const_constructors
          SizedBox(
            height: 10,
          ),
          //שם עסק
          Container(
              alignment: Alignment.topRight,
              //width: MediaQuery.of(context).size.width * 0.6,
              // ignore: prefer_const_constructors
              child: Column(
                children: [
                  Container(
                      alignment: Alignment.topRight,
                      child: Column(children: [
                        // ignore: prefer_const_constructors
                        Container(
                          ///                        margin: EdgeInsets.only(right: 20),
                          alignment: Alignment.topRight,
                          // ignore: prefer_const_constructors
                          child: Text("שם העסק",
                              // ignore: prefer_const_constructors
                              textAlign: TextAlign.right,
                              // ignore: prefer_const_constructors
                              style: TextStyle(
                                color: Color.fromARGB(255, 0, 0, 0),
                                fontWeight: FontWeight.bold,
                                fontSize: 15.0,
                              )),
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        // ignore: prefer_const_constructors
                        Container(
                          width: 400,
                          child: Directionality(
                              textDirection: TextDirection.rtl,
                              child: TextField(
                                controller: myControllerNameBis,
                                textDirection: TextDirection.ltr,
                                textAlign: TextAlign.right,
                                autofocus: true,
                                // ignore: prefer_const_constructors
                                // ignore: unnecessary_new
                                onChanged: (value) async {
                                  SharedPreferences prefsMyData =
                                      await SharedPreferences.getInstance();

                                  prefsMyData
                                      .setString(
                                          "NameBis", myControllerNameBis.text)
                                      .toString();
                                },
                                // ignore: unnecessary_new
                                decoration: new InputDecoration(
                                  filled: true,
                                  prefixIcon: Icon(Icons.shopping_bag_outlined),
                                  labelStyle: TextStyle(
                                    color: Color.fromARGB(255, 0, 0, 0),
                                  ),
                                  border: OutlineInputBorder(),
                                  hintText: bisName != "null" ? bisName : "",
                                ),
                              )),
                        ),
                      ])),
                ],
              )),
          // ignore: prefer_const_constructors
          SizedBox(
            height: 10,
          ),
          //רחוב
          Container(
              alignment: Alignment.topRight,
              // ignore: prefer_const_constructors
              child: Column(
                children: [
                  // ignore: prefer_const_constructors
                  Container(
                    // margin: EdgeInsets.only(right: 20),

                    alignment: Alignment.topRight,
                    // ignore: prefer_const_constructors
                    child: Text("רחוב העסק",

                        // ignore: prefer_const_constructors
                        textAlign: TextAlign.right,
                        // ignore: prefer_const_constructors
                        style: TextStyle(
                          color: Color.fromARGB(255, 0, 0, 0),
                          fontWeight: FontWeight.bold,
                          fontSize: 15.0,
                        )),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  // ignore: prefer_const_constructors
                  Container(
                    width: 400,
                    child: Directionality(
                        textDirection: TextDirection.rtl,
                        child: TextField(
                          controller: myControllerStreet,
                          textAlign: TextAlign.right,
                          autofocus: true,
                          // ignore: prefer_const_constructors
                          onChanged: (value) async {
                            SharedPreferences prefsMyData =
                                await SharedPreferences.getInstance();

                            prefsMyData
                                .setString("Street", myControllerStreet.text)
                                .toString();
                          },
                          // ignore: unnecessary_new
                          decoration: new InputDecoration(
                            filled: true,
                            prefixIcon: Icon(Icons.location_city_outlined),
                            labelStyle: TextStyle(
                              color: Color.fromARGB(255, 0, 0, 0),
                            ),
                            border: OutlineInputBorder(),
                            hintText: steert != "null" ? steert : "",
                          ),
                        )),
                  ),
                ],
              )),
          SizedBox(
            height: 10,
          ),
          //עיר
          Container(
              alignment: Alignment.topRight,
              // ignore: prefer_const_constructors
              child: Column(
                children: [
                  // ignore: prefer_const_constructors
                  Container(
                    // margin: EdgeInsets.only(right: 20),

                    alignment: Alignment.topRight,
                    // ignore: prefer_const_constructors
                    child: Text("עיר",

                        // ignore: prefer_const_constructors
                        textAlign: TextAlign.right,
                        // ignore: prefer_const_constructors
                        style: TextStyle(
                          color: Color.fromARGB(255, 0, 0, 0),
                          fontWeight: FontWeight.bold,
                          fontSize: 15.0,
                        )),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  // ignore: prefer_const_constructors
                  Container(
                    width: 400,
                    child: Directionality(
                        textDirection: TextDirection.rtl,
                        child: TextField(
                          controller: myControllerCity,
                          textAlign: TextAlign.right,
                          autofocus: true,
                          // ignore: prefer_const_constructors
                          onChanged: (value) async {
                            SharedPreferences prefsMyData =
                                await SharedPreferences.getInstance();

                            prefsMyData
                                .setString("City", myControllerCity.text)
                                .toString();
                          },
                          // ignore: unnecessary_new
                          decoration: new InputDecoration(
                            filled: true,
                            prefixIcon: Icon(Icons.location_pin),
                            labelStyle: TextStyle(
                              color: Color.fromARGB(255, 0, 0, 0),
                            ),
                            border: OutlineInputBorder(),
                            hintText: city != "null" ? city : "",
                          ),
                        )),
                  ),
                ],
              )),
          SizedBox(
            height: 10,
          ),
          //איימל
          Container(
              alignment: Alignment.topRight,
              // ignore: prefer_const_constructors
              child: Column(
                children: [
                  // ignore: prefer_const_constructors
                  Container(
                    // margin: EdgeInsets.only(right: 20),

                    alignment: Alignment.topRight,
                    // ignore: prefer_const_constructors
                    child: Text("אימייל",

                        // ignore: prefer_const_constructors
                        textAlign: TextAlign.right,
                        // ignore: prefer_const_constructors
                        style: TextStyle(
                          color: Color.fromARGB(255, 0, 0, 0),
                          fontWeight: FontWeight.bold,
                          fontSize: 15.0,
                        )),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  // ignore: prefer_const_constructors
                  Container(
                    width: 400,
                    child: Directionality(
                        textDirection: TextDirection.rtl,
                        child: TextField(
                          controller: myControllerEmail,
                          textAlign: TextAlign.left,
                          autofocus: true,
                          // ignore: prefer_const_constructors
                          onChanged: (value) async {
                            SharedPreferences prefsMyData =
                                await SharedPreferences.getInstance();

                            prefsMyData
                                .setString("Email", myControllerEmail.text)
                                .toString();
                          },
                          // ignore: unnecessary_new
                          decoration: new InputDecoration(
                            filled: true,
                            prefixIcon: Icon(Icons.attach_email_rounded),
                            labelStyle: TextStyle(
                              color: Color.fromARGB(255, 0, 0, 0),
                            ),
                            border: OutlineInputBorder(),
                            hintText: email != "null" ? email : "",
                          ),
                        )),
                  ),
                ],
              )),
          // ignore: prefer_const_constructors
          SizedBox(
            height: 10,
          ),
          //סיסמה
          Container(
              // margin: EdgeInsets.all(10),
              alignment: Alignment.topRight,
              // ignore: prefer_const_constructors
              child: Column(
                children: [
                  // ignore: prefer_const_constructors
                  Container(
                    // margin: EdgeInsets.only(right: 10),

                    alignment: Alignment.topRight,
                    // ignore: prefer_const_constructors
                    child: Text("סיסמה",
                        // ignore: prefer_const_constructors
                        textAlign: TextAlign.right,
                        // ignore: prefer_const_constructors
                        style: TextStyle(
                          color: Color.fromARGB(255, 0, 0, 0),
                          fontWeight: FontWeight.bold,
                          fontSize: 15.0,
                        )),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  // ignore: prefer_const_constructors
                  Container(
                    width: 400,
                    child: Directionality(
                        textDirection: TextDirection.rtl,
                        child: TextFormField(
                          obscureText: _passwordVisible,
                          enableSuggestions: false,
                          autocorrect: false,
                          cursorColor: Colors.black,
                          controller: myControllerPassword,
                          textAlign: TextAlign.left,
                          autofocus: true,
                          // ignore: prefer_const_constructors
                          // ignore: unnecessary_new
                          onChanged: (value) async {
                            SharedPreferences prefsMyData =
                                await SharedPreferences.getInstance();

                            prefsMyData
                                .setString(
                                    "Password", myControllerPassword.text)
                                .toString();
                          },
                          // ignore: unnecessary_new
                          decoration: new InputDecoration(
                            filled: true,

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
                              color: Color.fromARGB(255, 0, 0, 0),
                            ),
                            border: OutlineInputBorder(),
                            hintText: password != "null" ? password : "",
                          ),
                        )),
                  ),
                ],
              )),

          SizedBox(
            height: 20,
          ),
        ]),
      ),
    );
  }
}

nameStep() {
  return Row(
    children: <Widget>[
      SizedBox(width: 15),
      Container(
        //margin: EdgeInsets.all(20),
        width: 55,
        height: 55,

        child: ClipRRect(
          borderRadius: BorderRadius.circular(50.0),
          child: Image.asset(
            "assets/details.jpg",
            width: 150.0,
            height: 150.0,
            fit: BoxFit.fill,
          ),
        ),
      ),
      SizedBox(width: 15),
      // ignore: prefer_const_constructors
      Text("פרטי העסק שלי",
          // ignore: prefer_const_constructors
          style: TextStyle(
            color: Color.fromARGB(255, 0, 0, 0),
            fontWeight: FontWeight.bold,
            fontSize: 30.0,
          ))
    ],
  );
}
