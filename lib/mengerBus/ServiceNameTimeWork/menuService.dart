// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, prefer_interpolation_to_compose_strings, unnecessary_new, prefer_is_empty, unused_import, depend_on_referenced_packages
import 'dart:async';
import 'dart:io';
import 'dart:convert';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:my_tor/main.dart';
import 'package:my_tor/mengerBus/ServiceNameTimeWork/menuHoursWork.dart';
import 'package:my_tor/mengerBus/menuAndReshi/showMeet.dart';
import 'package:my_tor/mengerBus/menuAndReshi/adminMenu.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/date_symbol_data_file.dart';
import 'package:calendar_calendar/calendar_calendar.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import 'package:buttons_tabbar/buttons_tabbar.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../registerNew/horesWork.dart';
import 'menuServiceWork.dart';

class menuHoursService extends StatelessWidget {
  final String nameClient, howUser;
  const menuHoursService(
      {Key? key, required this.nameClient, required this.howUser})
      : super(key: key);
  Widget build(BuildContext context) {
    // ignore: prefer_const_constructors
    return Scaffold(
        body: Directionality(
            textDirection: TextDirection.rtl,
            // ignore: sort_child_properties_last
            child: Scaffold(
              backgroundColor: Color.fromARGB(235, 235, 235, 235),
              appBar: AppBar(
                centerTitle: true,
                // ignore: prefer_const_constructors
                title: Text(
                    // ignore: prefer_const_constructors
                    "ניהול העסק",
                    // ignore: prefer_const_constructors
                    style: TextStyle(
                      color: Color.fromARGB(255, 0, 0, 0),
                      fontWeight: FontWeight.bold,
                      fontSize: 17.0,
                    )),
                iconTheme: IconThemeData(color: Colors.black),
                backgroundColor: Color.fromARGB(230, 230, 230, 230),
              ),
              body: list(
                nameClient: nameClient,
                howUser: howUser,
              ),
              //ignore: prefer_const_constructors
            )));
  }
}

class list extends StatefulWidget {
  String nameClient, howUser;
  list({Key? key, required this.nameClient, required this.howUser})
      : super(key: key);
  @override
  State<list> createState() => _cancelTor(nameClient, howUser);
}

class _cancelTor extends State<list> {
  ScrollController _scrollController = ScrollController();
  late Timer _timer;

  bool workHours = true;
  bool serviceList = false;
  bool myDetails = false;
  final myControllerFullName = TextEditingController();
  final myControllerPhone = TextEditingController();
  final myControllerNameBis = TextEditingController();
  final myControllerEmail = TextEditingController();
  final myControllerStreet = TextEditingController();
  final myControllerPassword = TextEditingController();
  String nameClient, howUser;
  List<workerListModel> listGiveService = [];
  String nameGiveService = "";

  _cancelTor(this.nameClient, this.howUser);
  String name = "",
      phone = "",
      bisName = "",
      steert = "",
      email = "",
      password = "";
  bool _passwordVisible = true;
  @override
  void initState() {
    scrollToBottun();
    if (howUser != "m") {
      setState(() {
        workHours = true;
      });
    }

    // TODO: implement initState
    super.initState();
  }

  Widget build(BuildContext context) {
    return SingleChildScrollView(
      controller: _scrollController,
      child: Container(
        child: Column(children: [
          Center(
            child: ConstrainedBox(
              constraints: BoxConstraints(minHeight: 50, maxWidth: 800),
              child: Container(
                padding: EdgeInsets.all(10),
                margin: EdgeInsets.all(10),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                    border: Border.all(
                      color: Color.fromARGB(255, 190, 190, 190),
                    ),
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(6),
                        topRight: Radius.circular(6))),
                child: Column(
                  children: [
                    Container(
                      margin: EdgeInsets.only(right: 15, top: 10),
                      alignment: Alignment.topRight,
                      child: Text("ניהול שירותי העסק",
                          // ignore: prefer_const_constructors
                          style: TextStyle(
                            color: Color.fromARGB(255, 0, 0, 0),
                            fontWeight: FontWeight.bold,
                            fontSize: 24.0,
                          )),
                    ),
                    Container(
                      margin: EdgeInsets.only(right: 15, top: 3),
                      alignment: Alignment.topRight,
                      child: Text("נהל שעות פעילות סוגי שירות ופרטים אישיים",
                          // ignore: prefer_const_constructors
                          style: TextStyle(
                            color: Color.fromARGB(255, 101, 100, 100),
                            //fontWeight: FontWeight.bold,
                            fontSize: 15.0,
                          )),
                    ),
                    SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: ConstrainedBox(
                            constraints:
                                BoxConstraints(minHeight: 10, maxWidth: 800),
                            child: Container(
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: Color.fromARGB(255, 106, 105, 105),
                                  ),
                                  borderRadius: BorderRadius.circular(6.0),
                                ),
                                margin: EdgeInsets.only(
                                    top: 10, bottom: 10, left: 5),
                                alignment: Alignment.bottomLeft,
                                child: ElevatedButton.icon(
                                    style: ElevatedButton.styleFrom(
                                        primary:
                                            Color.fromARGB(255, 224, 222, 222),
                                        elevation: 3,
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(6.0),
                                        ),
                                        minimumSize: Size(double.infinity, 46),
                                        textStyle:
                                            const TextStyle(fontSize: 14)),
                                    onPressed: () {
                                      setState(() {
                                        serviceList = false;
                                        myDetails = false;
                                        workHours = true;
                                      });
                                      // Your onPressed code here
                                    },
                                    icon: Icon(
                                        size: 20,
                                        color: workHours == true
                                            ? Colors.blue
                                            : Colors.black,
                                        Icons.alarm),
                                    label: FittedBox(
                                      fit: BoxFit.cover,
                                      child: Text(
                                        "פעילות",
                                        style: TextStyle(
                                            fontSize: 16,
                                            color: workHours == true
                                                ? Colors.blue
                                                : Colors.black),
                                      ),
                                    ))),
                          ),
                        ),
                        howUser == "m"
                            ? Expanded(
                                child: ConstrainedBox(
                                  constraints: BoxConstraints(
                                      minHeight: 10, maxWidth: 800),
                                  child: Container(
                                      decoration: BoxDecoration(
                                          border: Border.all(
                                            color: Color.fromARGB(
                                                255, 106, 105, 105),
                                          ),
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(6))),
                                      margin: EdgeInsets.only(
                                          top: 10,
                                          bottom: 10,
                                          left: 5,
                                          right: 5),
                                      alignment: Alignment.bottomRight,
                                      child: ElevatedButton.icon(
                                          style: ElevatedButton.styleFrom(
                                              primary: Color.fromARGB(
                                                  255, 224, 222, 222),
                                              elevation: 3,
                                              shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          5.0)),
                                              minimumSize:
                                                  Size(double.infinity, 46),
                                              textStyle: const TextStyle(
                                                  fontSize: 14)),
                                          onPressed: () {
                                            setState(() {
                                              serviceList = true;
                                              myDetails = false;
                                              workHours = false;
                                            });

                                            // Your onPressed code here
                                          },
                                          icon: Icon(
                                              size: 20,
                                              color: serviceList == true
                                                  ? Colors.blue
                                                  : Colors.black,
                                              Icons.room_service),
                                          label: FittedBox(
                                            fit: BoxFit.cover,
                                            child: Text(
                                              "שירות",
                                              style: TextStyle(
                                                  fontSize: 16,
                                                  color: serviceList == true
                                                      ? Colors.blue
                                                      : Colors.black),
                                            ),
                                          ))),
                                ),
                              )
                            : Container(),
                        howUser == "m"
                            ? Expanded(
                                child: ConstrainedBox(
                                  constraints: BoxConstraints(
                                      minHeight: 10, maxWidth: 800),
                                  child: Container(
                                      decoration: BoxDecoration(
                                          border: Border.all(
                                            color: Color.fromARGB(
                                                255, 106, 105, 105),
                                          ),
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(6))),
                                      margin: EdgeInsets.only(
                                          top: 10, bottom: 10, right: 5),
                                      alignment: Alignment.bottomRight,
                                      child: ElevatedButton.icon(
                                          style: ElevatedButton.styleFrom(
                                              primary: Color.fromARGB(
                                                  255, 224, 222, 222),
                                              elevation: 3,
                                              shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          5.0)),
                                              minimumSize:
                                                  Size(double.infinity, 46),
                                              textStyle: const TextStyle(
                                                  fontSize: 14)),
                                          onPressed: () {
                                            setState(() {
                                              myDetails = true;
                                              serviceList = false;
                                              workHours = false;
                                            });

                                            // Your onPressed code here
                                          },
                                          icon: Icon(
                                              size: 20,
                                              color: myDetails == true
                                                  ? Colors.blue
                                                  : Colors.black,
                                              Icons.bookmark),
                                          label: FittedBox(
                                            fit: BoxFit.cover,
                                            child: Text(
                                              "פרטים",
                                              style: TextStyle(
                                                  fontSize: 16,
                                                  color: myDetails == true
                                                      ? Colors.blue
                                                      : Colors.black),
                                            ),
                                          ))),
                                ),
                              )
                            : Container(),
                      ],
                    ),
                    workHours == true
                        ? menuHoresWork(
                            nameClient: nameClient, howUser: howUser)
                        : Container(),
                    serviceList == true
                        ? menuServiceWork(nameClient: nameClient)
                        : Container(),
                    myDetails == true
                        ? Column(
                            children: [
                              ConstrainedBox(
                                constraints: BoxConstraints(
                                    minHeight: 50, maxWidth: 800),
                                child: Divider(
                                  height: 40,
                                  thickness: 3,
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.only(top: 10),
                                child: ConstrainedBox(
                                  constraints: BoxConstraints(
                                      minHeight: 50, maxWidth: 500),
                                  child: setDetatils(context),
                                ),
                              ),
                              SizedBox(
                                height: 15,
                              ),
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                    primary: Color.fromARGB(255, 41, 42, 43),
                                    elevation: 3,
                                    // shape: RoundedRectangleBorder(
                                    //     borderRadius: BorderRadius.circular(32.0)),
                                    minimumSize: Size(20, 40),
                                    textStyle: const TextStyle(fontSize: 20)),
                                child: Text("עדכן נתונים"),
                                onPressed: () async {
                                  String name;
                                  SharedPreferences prefsMyData =
                                      await SharedPreferences.getInstance();
                                  name = prefsMyData
                                      .getString("FullName")
                                      .toString();

                                  final refM = FirebaseDatabase.instance.ref();
                                  refM
                                      .child(nameClient)
                                      .child("פרטי העסק")
                                      .update({
                                    "שם מלא": prefsMyData
                                        .getString("FullName")
                                        .toString(),
                                    "טלפון": prefsMyData
                                        .getString("Phone")
                                        .toString(),
                                    "רחוב": prefsMyData
                                        .getString("Street")
                                        .toString(),
                                    "שם עסק": prefsMyData
                                        .getString("NameBis")
                                        .toString(),
                                    "איימל": prefsMyData
                                        .getString("Email")
                                        .toString(),
                                    "סיסמה": prefsMyData
                                        .getString("Password")
                                        .toString(),
                                  });

                                  final refMWork =
                                      FirebaseDatabase.instance.ref();
                                  refMWork
                                      .child(nameClient)
                                      .child("עובדים")
                                      .child(name)
                                      .update({
                                    "טלפון": prefsMyData
                                        .getString("Phone")
                                        .toString(),
                                  }).then((value) {
                                    showelrat();
                                  });
                                },
                              ),
                            ],
                          )
                        : Container()
                  ],
                ),
              ),
            ),
          )
        ]),
      ),
    );
  }

  showelrat() {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      // ignore: prefer_const_constructors
      content: Text(
        "הנתונים עדכנו בהצלחה",
        textAlign: TextAlign.right,
      ),
    ));
  }

  scrollToBottun() {
    _timer = Timer.periodic(Duration(seconds: 1), (timer) async {
      SharedPreferences prefsScrollButton =
          await SharedPreferences.getInstance();
      if (prefsScrollButton.getString("ScrollBottonMenu").toString() ==
          "true") {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: Duration(milliseconds: 500),
          curve: Curves.easeInOut,
        );
        SharedPreferences prefsScrollButton =
            await SharedPreferences.getInstance();
        prefsScrollButton.setString("ScrollBottonMenu", "false");
      }
    });
  }

  Future<int> get() async {
    final ref = FirebaseDatabase.instance.ref();
    final snapshot = await ref.child('$nameClient/פרטי העסק').get();
    setState(() {
      name = snapshot.child("שם מלא").value.toString();
      phone = snapshot.child("טלפון").value.toString();
      steert = snapshot.child("רחוב").value.toString();
      bisName = snapshot.child("שם עסק").value.toString();
      email = snapshot.child("איימל").value.toString();
      password = snapshot.child("סיסמה").value.toString();
    });
    return 1;
  }

  setDetatils(context) {
    return FutureBuilder(
        future: get(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
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
                  Container(
                    //margin: EdgeInsets.only(right: 10),
                    alignment: Alignment.topRight,
                    // ignore: prefer_const_constructors
                    child: Text("* ניתן לערוך מה שבכוכבית",
                        // ignore: prefer_const_constructors
                        textAlign: TextAlign.right,
                        // ignore: prefer_const_constructors
                        style: TextStyle(
                          color: Color.fromARGB(255, 120, 119, 119),
                          fontWeight: FontWeight.w500,
                          fontSize: 14.0,
                        )),
                  ),
                  SizedBox(
                    height: 15,
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
                                readOnly: true,

                                controller: myControllerFullName,
                                textDirection: TextDirection.ltr,
                                textAlign: TextAlign.right,
                                autofocus: true,
                                onChanged: (value) async {
                                  SharedPreferences prefsMyData =
                                      await SharedPreferences.getInstance();

                                  prefsMyData
                                      .setString(
                                          "FullName", myControllerFullName.text)
                                      .toString();
                                },
                                // ignore: prefer_const_constructors
                                // ignore: unnecessary_new
                                decoration: new InputDecoration(
                                  filled: true,
                                  prefixIcon:
                                      Icon(Icons.account_circle_rounded),
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
                                  child: Text("* טלפון",
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
                                              await SharedPreferences
                                                  .getInstance();

                                          prefsMyData
                                              .setString("Phone",
                                                  myControllerPhone.text)
                                              .toString();
                                        },
                                        controller: myControllerPhone,
                                        textAlign: TextAlign.right,
                                        autofocus: true,
                                        // ignore: prefer_const_constructors
                                        // ignore: unnecessary_new
                                        decoration: new InputDecoration(
                                          filled: true,
                                          prefixIcon:
                                              Icon(Icons.phone_iphone_sharp),
                                          labelStyle: TextStyle(
                                            color: Color.fromARGB(255, 0, 0, 0),
                                          ),
                                          border: OutlineInputBorder(),
                                          hintText:
                                              phone != "null" ? phone : "",
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
                                        readOnly: true,

                                        controller: myControllerNameBis,
                                        textDirection: TextDirection.ltr,
                                        textAlign: TextAlign.right,
                                        autofocus: true,
                                        // ignore: prefer_const_constructors
                                        // ignore: unnecessary_new
                                        onChanged: (value) async {
                                          SharedPreferences prefsMyData =
                                              await SharedPreferences
                                                  .getInstance();

                                          prefsMyData
                                              .setString("NameBis",
                                                  myControllerNameBis.text)
                                              .toString();
                                        },
                                        // ignore: unnecessary_new
                                        decoration: new InputDecoration(
                                          filled: true,
                                          prefixIcon:
                                              Icon(Icons.shopping_bag_outlined),
                                          labelStyle: TextStyle(
                                            color: Color.fromARGB(255, 0, 0, 0),
                                          ),
                                          border: OutlineInputBorder(),
                                          hintText:
                                              bisName != "null" ? bisName : "",
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
                            child: Text("* רחוב העסק",

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
                                        .setString(
                                            "Street", myControllerStreet.text)
                                        .toString();
                                  },
                                  // ignore: unnecessary_new
                                  decoration: new InputDecoration(
                                    filled: true,
                                    prefixIcon:
                                        Icon(Icons.location_city_outlined),
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
                                  readOnly: true,

                                  controller: myControllerEmail,
                                  textAlign: TextAlign.left,
                                  autofocus: true,
                                  // ignore: prefer_const_constructors
                                  onChanged: (value) async {
                                    SharedPreferences prefsMyData =
                                        await SharedPreferences.getInstance();

                                    prefsMyData
                                        .setString(
                                            "Email", myControllerEmail.text)
                                        .toString();
                                  },
                                  // ignore: unnecessary_new
                                  decoration: new InputDecoration(
                                    filled: true,
                                    prefixIcon:
                                        Icon(Icons.attach_email_rounded),
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
                                  readOnly: true,

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
                                        .setString("Password",
                                            myControllerPassword.text)
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
                                        color:
                                            Theme.of(context).primaryColorDark,
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
                                    hintText:
                                        password != "null" ? password : "",
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
          } else {
            return Container(
              child: Column(
                // ignore: prefer_const_literals_to_create_immutables
                children: [
                  CircularProgressIndicator(color: Colors.black),
                  Container(
                    child: Center(
                      child: Text("טעון נתונים...",
                          textDirection: TextDirection.rtl,
                          style: TextStyle(
                            color: Color.fromARGB(255, 0, 0, 0),
                            //fontWeight: FontWeight.bold,
                            fontSize: 15.0,
                          )),
                    ),
                  )
                ],
              ),
            );
          }
        });
  }
}
