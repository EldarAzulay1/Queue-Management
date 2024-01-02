// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, prefer_interpolation_to_compose_strings, unnecessary_new, prefer_is_empty, unused_import, depend_on_referenced_packages, avoid_unnecessary_containers, non_constant_identifier_names
import 'dart:async';
import 'dart:io';
import 'dart:convert';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:my_tor/mengerBus/workerTeam/addWorker.dart';
import 'package:my_tor/mengerBus/ServiceNameTimeWork/menuHoursWork.dart';
import 'package:my_tor/mengerBus/menuAndReshi/showMeet.dart';
import 'package:my_tor/mengerBus/menuAndReshi/adminMenu.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:step_progress_indicator/step_progress_indicator.dart';
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
import '../ServiceNameTimeWork/menuServiceWork.dart';

class menuWorkerTeam extends StatelessWidget {
  final String nameClient;
  const menuWorkerTeam({Key? key, required this.nameClient}) : super(key: key);
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
              body: list(nameClient: nameClient),
              //ignore: prefer_const_constructors
            )));
  }
}

class list extends StatefulWidget {
  String nameClient;
  list({Key? key, required this.nameClient}) : super(key: key);
  @override
  State<list> createState() => _cancelTor(nameClient);
}

class _cancelTor extends State<list> {
  bool workHours = true;
  bool workersList = false;
  List<workerListModel> listWorker = [];
  String nameClient;
  _cancelTor(this.nameClient);
  @override
  void initState() {
    getCategoryDataWorker();
    //listWorker.add(new workerListModel("wdqwd", "ddd", "234234234"));
    //    // TODO: implement initState
    super.initState();
  }

  Future<List<workerListModel>> getCategoryDataWorker() async {
    final prefsListWorker = await SharedPreferences.getInstance();
    final category = prefsListWorker.getString("ListWorker");
    listWorker = List<workerListModel>.from(
        List<Map<String, dynamic>>.from(jsonDecode(category.toString()))
            .map((e) => workerListModel.fromJson(e))
            .toList());

    return listWorker;
  }

  Widget build(BuildContext context) {
    return SingleChildScrollView(
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
                      child: Text("ניהול צוות עובדים",
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
                      child: Text("הוסף נותני שירות",
                          // ignore: prefer_const_constructors
                          style: TextStyle(
                            color: Color.fromARGB(255, 101, 100, 100),
                            //fontWeight: FontWeight.bold,
                            fontSize: 15.0,
                          )),
                    ),
                    SizedBox(height: 10),
                    Row(
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
                                    top: 10, bottom: 10, left: 5, right: 10),
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
                                      textStyle: const TextStyle(fontSize: 16)),
                                  onPressed: () {
                                    setState(() {
                                      workersList = false;
                                      workHours = true;
                                    });
                                    // Your onPressed code here
                                  },
                                  icon: Icon(
                                      color: workHours == true
                                          ? Colors.blue
                                          : Colors.black,
                                      Icons.person_add),
                                  label: Text(
                                    "הוסף עובד",
                                    style: TextStyle(
                                        color: workHours == true
                                            ? Colors.blue
                                            : Colors.black),
                                  ),
                                )),
                          ),
                        ),
                        Expanded(
                          child: ConstrainedBox(
                            constraints:
                                BoxConstraints(minHeight: 10, maxWidth: 800),
                            child: Container(
                                decoration: BoxDecoration(
                                    border: Border.all(
                                      color: Color.fromARGB(255, 106, 105, 105),
                                    ),
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(6))),
                                margin: EdgeInsets.only(
                                    top: 10, bottom: 10, left: 10, right: 5),
                                alignment: Alignment.bottomRight,
                                child: ElevatedButton.icon(
                                  style: ElevatedButton.styleFrom(
                                      primary:
                                          Color.fromARGB(255, 224, 222, 222),
                                      elevation: 3,
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(5.0)),
                                      minimumSize: Size(double.infinity, 46),
                                      textStyle: const TextStyle(fontSize: 16)),
                                  onPressed: () {
                                    setState(() {
                                      workersList = true;
                                      workHours = false;
                                    });

                                    // Your onPressed code here
                                  },
                                  icon: Icon(
                                      color: workersList == true
                                          ? Colors.blue
                                          : Colors.black,
                                      Icons.groups),
                                  label: Text(
                                    "צוות עובדים",
                                    style: TextStyle(
                                        color: workersList == true
                                            ? Colors.blue
                                            : Colors.black),
                                  ),
                                )),
                          ),
                        ),
                      ],
                    ),
                    workHours == true
                        ? addWorker(nameClient: nameClient)
                        : Container(),
                    workersList == true ? WorkerList() : Container(),
                  ],
                ),
              ),
            ),
          )
        ]),
      ),
    );
  }

  test() {}

  WorkerList() {
    return FutureBuilder<List<workerListModel>>(
        future: getCategoryDataWorker(),
        builder: (context, snapshot) {
          return ConstrainedBox(
            constraints: BoxConstraints(minHeight: 50, maxWidth: 800),
            child: Container(
              margin: EdgeInsets.only(bottom: 10, left: 10, right: 5),
              child: Column(
                children: [
                  ConstrainedBox(
                    constraints: BoxConstraints(minHeight: 50, maxWidth: 800),
                    child: Divider(
                      height: 40,
                      thickness: 3,
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(right: 10),
                    alignment: Alignment.topRight,
                    // ignore: prefer_const_constructors
                    child: Text("צוות עובדים",
                        // ignore: prefer_const_constructors
                        textAlign: TextAlign.right,
                        // ignore: prefer_const_constructors
                        style: TextStyle(
                          color: Color.fromARGB(255, 0, 0, 0),
                          fontWeight: FontWeight.bold,
                          fontSize: 16.0,
                        )),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  ListView.separated(
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: listWorker.length,
                      separatorBuilder: (context, index) {
                        // ignore: prefer_const_constructors
                        return Divider(
                          height: 30,
                          thickness: 1,
                        );
                      },
                      shrinkWrap: true,
                      itemBuilder: (context, index) {
                        return Container(
                          child: Card(
                            shape: RoundedRectangleBorder(
                              side: BorderSide(
                                width: 1.0,
                                color: Color.fromARGB(255, 143, 141, 141),
                              ),
                              borderRadius:
                                  BorderRadius.circular(5.0), //<-- SEE HERE
                            ),
                            elevation: 10,
                            child: Dismissible(
                              direction: DismissDirection.none,
                              key: Key(listWorker[index].toString()),
                              onDismissed: (direction) {},
                              child: ListTile(
                                selectedTileColor: Color.fromARGB(255, 0, 0, 0),
                                textColor: Color.fromARGB(255, 0, 0, 0),
                                // ignore: prefer_const_constructors
                                title: Text(
                                  listWorker[index].nameWorker.toString(),
                                  // ignore: prefer_const_constructors
                                  style: TextStyle(
                                    color: Color.fromARGB(255, 0, 0, 0),
                                    fontWeight: FontWeight.bold,
                                    fontSize: 15.0,
                                  ),
                                ),
                                subtitle: Text(
                                  listWorker[index].phone.toString(),
                                  // ignore: prefer_const_constructors
                                  style: TextStyle(
                                    color: Color.fromARGB(255, 0, 0, 0),
                                    fontWeight: FontWeight.bold,
                                    fontSize: 15.0,
                                  ),
                                ),
                                trailing: IconButton(
                                  iconSize: 30,
                                  color: Colors.red,
                                  icon: const Icon(Icons.delete),
                                  onPressed: () {
                                    print("efefe222- " + index.toString());

                                    _showMyDialog(index);
                                  },
                                ),
                              ),
                            ),
                          ),
                        );
                      }),
                ],
              ),
            ),
          );
        });
  }

  Future<void> _showMyDialog(int index) async {
    String codeClick = "";
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (context) {
        return ScaffoldMessenger(child: Builder(builder: ((context) {
          return AlertDialog(
            title: Text(
              textDirection: TextDirection.rtl,
              style: TextStyle(
                //backgroundColor: Color.fromARGB(255, 178, 175, 175),
                color: Color.fromARGB(255, 53, 52, 52),
                fontWeight: FontWeight.bold,
                fontSize: 14.0,
              ),
              // ignore: prefer_interpolation_to_compose_strings
              // ignore: prefer_interpolation_to_compose_strings
              "בטוח שברצונך למחוק איש צוות ?",
              textAlign: TextAlign.right,
            ),
            content: SingleChildScrollView(
              child: ListBody(
                children: <Widget>[],
              ),
            ),
            actions: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextButton(
                    child: const Text('ביטול'),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                  TextButton(
                    child: const Text("אישור"),
                    onPressed: () {
                      DatabaseReference ref = FirebaseDatabase.instance.ref(
                          // ignore: prefer_interpolation_to_compose_strings
                          "$nameClient/עובדים/" +
                              listWorker[index].nameWorker.toString());
                      ref.remove();
                      DatabaseReference ref1 = FirebaseDatabase.instance.ref(
                          // ignore: prefer_interpolation_to_compose_strings
                          "$nameClient/פעילות/" +
                              listWorker[index].nameWorker.toString());
                      ref1.remove();
                      setState(() {
                        listWorker.removeAt(index);
                        listWorker;
                      });

                      Navigator.of(context).pop();
                    },
                  ),
                ],
              )
            ],
          );
        })));
      },
    );
  }
}

class workerListModel {
  String? nameWorker;
  String? email;
  String? phone;
  workerListModel(this.nameWorker, this.email, this.phone);

  Map<String, dynamic> toJson() {
    return {
      'nameWorker': nameWorker,
      'email': email,
      'phone': phone,
    };
  }

  workerListModel.fromJson(Map<String, dynamic> json) {
    nameWorker = json['nameWorker'];
    email = json['email'];
    phone = json['phone'];
  }
}
