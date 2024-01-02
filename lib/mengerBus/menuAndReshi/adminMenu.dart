// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, unused_element, prefer_interpolation_to_compose_strings, unnecessary_new, unused_import, use_build_context_synchronously

import 'dart:convert';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:my_tor/main.dart';
import 'package:my_tor/mengerBus/ServiceNameTimeWork/menuService.dart';
import 'package:my_tor/mengerBus/freeAndPos/managerTime.dart';
import 'package:my_tor/mengerBus/menuAndReshi/showMeet.dart';
import 'package:my_tor/mengerBus/allMeet/allDataMeets.dart';
import 'package:my_tor/mengerBus/workerTeam/worker_team.dart';
import 'package:my_tor/tableTor/tableSendTor.dart';
import 'package:my_tor/websites/web_sites.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../Login.dart';
import '../messageForCustum/messgea.dart';

class adminMenu extends StatelessWidget {
  final String nameClient, howUser;
  const adminMenu({Key? key, required this.nameClient, required this.howUser})
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
              drawer:
                  NavigationDrawer(nameClient: nameClient, howUser: howUser),
              body: list(nameClient: nameClient, howUser: howUser),
              //ignore: prefer_const_constructors
            )));
  }
}

class NavigationDrawer extends StatelessWidget {
  final String nameClient, howUser;
  const NavigationDrawer(
      {Key? key, required this.nameClient, required this.howUser})
      : super(key: key);
  Widget build(BuildContext context) {
    return Drawer(
      //backgroundColor: Color.fromARGB(235, 235, 235, 235),
      child: SingleChildScrollView(
          // ignore: prefer_const_literals_to_create_immutables
          child: Column(
        children: [
          buildHeader(context),
          buildMenuItmes(context, nameClient, howUser),
        ],
      )),
    );
  }
}

Widget buildHeader(BuildContext context) => Container(
      //color: Color.fromARGB(235, 235, 235, 235),
      //color: Color.fromARGB(235, 210, 25, 25),
      padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top + 20),
      child: Column(
        children: [
          Container(
            //margin: EdgeInsets.all(20),
            width: 70,
            height: 70,
            // ignore: prefer_const_constructors
            child: ClipRRect(
              borderRadius: BorderRadius.circular(50.0),
              child: Image.asset(
                "menu1.png",
                width: 110.0,
                height: 110.0,
                fit: BoxFit.cover,
              ),
            ),
          ),
          SizedBox(height: 15),
          Text("תפריט ניהול",
              style: TextStyle(
                color: Color.fromARGB(255, 0, 0, 0),
                fontWeight: FontWeight.bold,
                fontSize: 17.0,
              )),
          //const Divider(color: Colors.black54),
        ],
      ),
    );

Widget buildMenuItmes(
        BuildContext context, String nameClient, String howUser) =>
    Container(
        padding: const EdgeInsets.all(10),
        child: Wrap(
          runSpacing: 6,
          children: [
            ListTile(
              leading: const Icon(Icons.home_outlined, color: Colors.black),
              title: const Text("דף ראשי",
                  style: TextStyle(
                    color: Color.fromARGB(255, 0, 0, 0),
                    //fontWeight: FontWeight.bold,
                    fontSize: 16.0,
                  )),
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => adminMenu(
                          nameClient: nameClient,
                          howUser: howUser,
                        )));
              },
            ),
            Divider(
              color: Colors.black54,
              height: 10,
              thickness: 1,
            ),
            ListTile(
              leading: const Icon(Icons.event_available, color: Colors.black),
              title: const Text('תורים מתוכננים',
                  style: TextStyle(
                    color: Color.fromARGB(255, 0, 0, 0),
                    //fontWeight: FontWeight.bold,
                    fontSize: 16.0,
                  )),
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => allDataMeets(
                          nameClient: nameClient,
                          howUser: howUser,
                        )));
              },
            ),
            Visibility(
              visible: true,
              child: ListTile(
                enabled: true,
                leading: const Icon(
                  Icons.more_time,
                  color: Colors.black,
                ),
                title: const Text("חופשה והפסקה",
                    style: TextStyle(
                      color: Color.fromARGB(255, 0, 0, 0),
                      //fontWeight: FontWeight.w500,
                      fontSize: 16.0,
                    )),
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => Container(
                              child: magaerTimer(
                            nameClient: nameClient,
                            howUser: howUser,
                          ))));
                },
              ),
            ),
            Visibility(
              visible: howUser == "m" ? true : false,
              child: ListTile(
                enabled: howUser == "m" ? true : false,
                leading: const Icon(Icons.mail_outline, color: Colors.black),
                title: const Text("הודעה ללקוחות",
                    style: TextStyle(
                      color: Color.fromARGB(255, 0, 0, 0),
                      //fontWeight: FontWeight.bold,
                      fontSize: 16.0,
                    )),
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => messgea(nameClient: nameClient)));
                },
              ),
            ),
            Visibility(
              visible: true,
              child: ListTile(
                enabled: true,
                leading: const Icon(Icons.menu, color: Colors.black),
                title: const Text("שירותים",
                    style: TextStyle(
                      color: Color.fromARGB(255, 0, 0, 0),
                      //fontWeight: FontWeight.bold,
                      fontSize: 17.0,
                    )),
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => menuHoursService(
                          nameClient: nameClient, howUser: howUser)));
                },
              ),
            ),
            Visibility(
              visible: howUser == "m" ? true : false,
              child: ListTile(
                enabled: howUser == "m" ? true : false,
                leading: const Icon(Icons.people_rounded, color: Colors.black),
                title: const Text("צוות עובדים",
                    style: TextStyle(
                      color: Color.fromARGB(255, 0, 0, 0),
                      //fontWeight: FontWeight.bold,
                      fontSize: 17.0,
                    )),
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) =>
                          menuWorkerTeam(nameClient: nameClient)));
                },
              ),
            ),
            Visibility(
              visible: howUser == "m" ? true : false,
              child: ListTile(
                enabled: howUser == "m" ? true : false,
                leading: const Icon(Icons.add_business_sharp, color: Colors.black),
                title: const Text("קבע תור",
                    style: TextStyle(
                      color: Color.fromARGB(255, 0, 0, 0),
                      //fontWeight: FontWeight.bold,
                      fontSize: 17.0,
                    )),
                onTap: () async {
                  SharedPreferences prefsMangTor = await SharedPreferences.getInstance();
                  prefsMangTor.setString("MangTor", "true");

                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) =>
                          tableSendTor(nameClient: nameClient)));
                },
              ),
            ),
            Divider(
              color: Colors.black54,
              height: 10,
              thickness: 1,
            ),
            ListTile(
              leading: const Icon(Icons.arrow_back, color: Colors.black),
              title: const Text("חזור לאתר",
                  style: TextStyle(
                    color: Color.fromARGB(255, 0, 0, 0),
                    //fontWeight: FontWeight.bold,
                    fontSize: 17.0,
                  )),
              onTap: () {
                Navigator.push(
                  context,
                  PageRouteBuilder(
                    transitionDuration: Duration(milliseconds: 500),
                    pageBuilder: (context, animation, secondaryAnimation) {
                      return MyApp();
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
              },
            ),
            ListTile(),
            ListTile(
              leading: const Icon(Icons.close,
                  color: Color.fromARGB(255, 245, 11, 11)),
              title: const Text("התנתק",
                  style: TextStyle(
                    color: Color.fromARGB(255, 0, 0, 0),
                    //fontWeight: FontWeight.bold,
                    fontSize: 17.0,
                  )),
              onTap: () async {
                SharedPreferences UseremailPass =
                    await SharedPreferences.getInstance();
                UseremailPass.remove("UseremailPass");

                Navigator.push(
                  context,
                  PageRouteBuilder(
                    transitionDuration: Duration(milliseconds: 500),
                    pageBuilder: (context, animation, secondaryAnimation) {
                      return Login(
                        nameClient: nameClient,
                      );
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
              },
            ),
          ],
        ));

class dataMeet {
  final String? start;
  final String? end;
  final String? typeTipol;
  final String? phone;
  final String? name;
  final String? price;
  final String? TypeTime;
  //final String? city;
  dataMeet(
    this.start,
    this.end,
    this.typeTipol,
    this.phone,
    this.name,
    this.price,
    this.TypeTime,
  );
}

class dataCurrent {
  String? dataCurrentNow;
  //final String? city;
  dataCurrent({
    this.dataCurrentNow,
  });
}

class list extends StatefulWidget {
  final String nameClient, howUser;
  list({Key? key, required this.nameClient, required this.howUser})
      : super(key: key);
  @override
  State<list> createState() => _list(nameClient, howUser);
}

class _list extends State<list> {
  String NameDay = "",
      NumberMunth = "",
      NameMonth = "",
      NameMonthForDate = "",
      dateNow = "";
  int totalPrice = 0, totalMeet = 0;
  List<dataMeet> listDataMeet = [];
  String nameClient, howUser;
  _list(this.nameClient, this.howUser);
  Widget build(BuildContext context) {
    DateTime now = DateTime.now();
    DateTime day = DateTime(now.year, now.month, now.day);
    dataCurrent data = dataCurrent(
        dataCurrentNow: day.day.toString() +
            "-" +
            day.month.toString() +
            "-" +
            day.year.toString());

    return SingleChildScrollView(
        child: listMeet(
      data: data,
      nameClient: nameClient,
      howUser: howUser,
    ));
  }

  getDay(int day) {
    switch (day) {
      case 1:
        setState(() {
          NameDay = "יום שני";
        });
        break;
      case 2:
        setState(() {
          NameDay = "יום שלישי";
        });
        break;
      case 3:
        setState(() {
          NameDay = "יום רבעי";
        });
        break;
      case 4:
        setState(() {
          NameDay = "יום חמישי";
        });
        break;
      case 5:
        setState(() {
          NameDay = "יום שישי";
        });
        break;
      case 6:
        setState(() {
          NameDay = "יום שבת";
        });
        break;
      case 7:
        setState(() {
          NameDay = "יום ראשון";
        });
        break;
    }
  }

  getDate(int month) {
    switch (month) {
      case 1:
        setState(() {
          NameMonth = "ינואר";
        });
        break;
      case 2:
        setState(() {
          NameMonth = "פבואר";
        });
        break;
      case 3:
        setState(() {
          NameMonth = "מרץ";
        });
        break;
      case 4:
        setState(() {
          NameMonth = "אפריל";
        });
        break;
      case 5:
        setState(() {
          NameMonth = "מאי";
        });
        break;
      case 6:
        setState(() {
          NameMonth = "יוני";
        });
        break;
      case 7:
        setState(() {
          NameMonth = "יולי";
        });
        break;
      case 8:
        setState(() {
          NameMonth = "אוגוסט";
        });
        break;
      case 9:
        setState(() {
          NameMonth = "ספטמבר";
        });
        break;
      case 10:
        setState(() {
          NameMonth = "אוקטובר";
        });
        break;
      case 11:
        setState(() {
          NameMonth = "נובמבר";
        });
        break;
      case 12:
        setState(() {
          NameMonth = "דצמבר";
        });
        break;
    }
  }
}
