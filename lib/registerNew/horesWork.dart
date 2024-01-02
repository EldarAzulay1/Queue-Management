// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors, avoid_print, prefer_interpolation_to_compose_strings

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

class horesWork extends StatefulWidget {
  horesWork({Key? key}) : super(key: key);

  @override
  State<horesWork> createState() => _list();
}

class _list extends State<horesWork> {
  _list();
  List<String> deys = [
    "יום ראשון",
    "יום שני",
    "יום שלישי",
    "יום רביעי",
    "יום חמישי",
    "יום שישי"
  ];
  bool isSwitched = false,
      isSwitched2 = false,
      isSwitched3 = false,
      isSwitched4 = false,
      isSwitched5 = false,
      isSwitched6 = false;
  String StartWork1 = " 07:00 ", EndWork1 = " 17:00 ";
  String StartWork2 = " 07:00 ", EndWork2 = " 17:00 ";
  String StartWork3 = " 07:00 ", EndWork3 = " 17:00 ";
  String StartWork4 = " 07:00 ", EndWork4 = " 17:00 ";
  String StartWork5 = " 07:00 ", EndWork5 = " 17:00 ";
  String StartWork6 = " 07:00 ", EndWork6 = " 17:00 ";
  List<bool> isSwitchedList = [];
  List<StartEndWork> StartEnd = [];

  final WorkHores = [
    ' 07:00 ',
    ' 07:30 ',
    ' 08:00 ',
    ' 08:30 ',
    ' 09:00 ',
    ' 09:30 ',
    ' 10:00 ',
    ' 10:30 ',
    ' 11:00 ',
    ' 11:30 ',
    ' 12:00 ',
    ' 12:30 ',
    ' 13:00 ',
    ' 13:30 ',
    ' 14:00 ',
    ' 14:30 ',
    ' 15:00 ',
    ' 15:30 ',
    ' 16:00 ',
    ' 16:30 ',
    ' 17:00 ',
    ' 17:30 ',
    ' 18:00 ',
    ' 18:30 ',
    ' 19:00 ',
    ' 19:30 ',
    ' 20:00 ',
    ' 20:30 ',
    ' 21:00 ',
    ' 21:30 ',
    ' 22:00 ',
    ' 22:30 ',
    ' 23:00 ',
  ];

  setDefultHoers() async {
    print("dayyyyyyy " + "cc");
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs
        .setString(
            "1",
            // ignore: prefer_interpolation_to_compose_strings
            "סגור" + "," + "סגור" + "," + "יום ראשון")
        .toString();
    prefs
        .setString(
            "2",
            // ignore: prefer_interpolation_to_compose_strings
            "סגור" + "," + "סגור" + "," + "יום שני")
        .toString();
    prefs
        .setString(
            "3",
            // ignore: prefer_interpolation_to_compose_strings
            "סגור" + "," + "סגור" + "," + "יום שלישי")
        .toString();
    prefs
        .setString(
            "4",
            // ignore: prefer_interpolation_to_compose_strings
            "סגור" + "," + "סגור" + "," + "יום רביעי")
        .toString();
    prefs
        .setString(
            "5",
            // ignore: prefer_interpolation_to_compose_strings
            "סגור" + "," + "סגור" + "," + "יום חמישי")
        .toString();
    prefs
        .setString(
            "6",
            // ignore: prefer_interpolation_to_compose_strings
            "סגור" + "," + "סגור" + "," + "יום שישי")
        .toString();

    print("dayyyyyyy " + prefs.getString("1").toString());
  }

  @override
  void initState() {
    //setDefultHoers();
    getCategoryDat1();
    // TODO: implement initState
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
          child: tableTitle(),
        ),
        SizedBox(
          height: 5,
        ),
        ConstrainedBox(
          constraints: BoxConstraints(minHeight: 50, maxWidth: 500),
          child: table1(),
        ),
        SizedBox(
          height: 5,
        ),
      ],
    )));
  }

  Future<List<StartEndWork>> getCategoryDat1() async {
    isSwitchedList.clear();
    SharedPreferences prefsMyData = await SharedPreferences.getInstance();

    for (int i = 0; i < 6; i++) {
      if (prefsMyData.getString(deys[i]).toString() == "null") {
        setState(() {
          isSwitchedList.add(false);
          // ignore: unnecessary_new
          StartEnd.add(new StartEndWork(deys[i], " סגור ", " סגור "));
        });
        prefsMyData
            .setString(
                deys[i],
                StartEnd[i].start +
                    "," +
                    StartEnd[i].end +
                    "," +
                    StartEnd[i].day)
            .toString();
      } else {
        print("wdwfff" + prefsMyData.getString(deys[0]).toString());

        setState(() {
          prefsMyData.getString(deys[i]).toString().split(",")[0] == " סגור "
              ? isSwitchedList.add(false)
              : isSwitchedList.add(true);
          // ignore: unnecessary_new
          StartEnd.add(new StartEndWork(
              deys[i],
              prefsMyData.getString(deys[i]).toString().split(",")[0],
              prefsMyData.getString(deys[i]).toString().split(",")[1]));
        });
      }
    }

    return StartEnd;
  }

  table1() {
    return FutureBuilder(
        // future: getCategoryDat1(),
        builder: (context, snapshot) {
      if (StartEnd.isNotEmpty) {
        return Container(
          color: Color.fromARGB(235, 235, 235, 235),
          child: Column(
            children: <Widget>[
              for (int i = 0; i < 6; i++)
                Column(
                  children: [
                    Container(
                      color: i.isOdd
                          ? Color.fromARGB(255, 225, 222, 222)
                          : Color.fromARGB(255, 215, 212, 212),
                      padding: EdgeInsets.all(3),
                      child: Table(
                        children: [
                          //This table row is for the table header which is static
                          TableRow(children: [
                            //שם יום
                            Center(
                              child: Padding(
                                padding: const EdgeInsets.only(top: 15),
                                child: Text(
                                  StartEnd[i].day,
                                  style: TextStyle(
                                      fontSize: 17,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.black87),
                                ),
                              ),
                            ),
                            Center(
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 10),
                                child: Switch(
                                  value: isSwitchedList[i],
                                  onChanged: (value) async {
                                    setState(() {
                                      isSwitchedList[i] = value;
                                      StartEnd[i].start;
                                    });

                                    if (isSwitchedList[i] == false) {
                                      setState(() {
                                        StartEnd[i].start = " סגור ";
                                        StartEnd[i].end = " סגור ";
                                      });
                                    } else {
                                      setState(() {
                                        // ignore: unnecessary_new
                                        StartEnd.add(new StartEndWork(
                                            StartEnd[i].day,
                                            StartEnd[i].start,
                                            StartEnd[i].end));
                                        StartEnd[i].start;
                                      });
                                    }

                                    SharedPreferences prefsMyData =
                                        await SharedPreferences.getInstance();
                                    prefsMyData
                                        .setString(
                                            deys[i],
                                            StartEnd[i].start +
                                                "," +
                                                StartEnd[i].end +
                                                "," +
                                                StartEnd[i].day)
                                        .toString();
                                  },
                                  activeTrackColor:
                                      Color.fromARGB(255, 33, 150, 243),
                                  activeColor:
                                      Color.fromARGB(255, 33, 150, 243),
                                ),
                              ),
                            ),
                            Center(
                              child: isSwitchedList[i]
                                  ? Container(
                                      margin: EdgeInsets.only(top: 10),
                                      decoration: BoxDecoration(
                                        border: Border.all(
                                          color:
                                              Color.fromARGB(255, 74, 74, 74),
                                        ),
                                      ),
                                      //padding: const EdgeInsets.symmetric(vertical: 10),
                                      child: Directionality(
                                        textDirection: TextDirection.rtl,
                                        child: Container(
                                          color: Color.fromARGB(
                                              255, 255, 255, 255),
                                          width: 70,
                                          height: 33,
                                          child: DropdownButton<String>(
                                              isExpanded: true,
                                              underline: Container(),
                                              hint: Text(
                                                // textAlign: TextAlign.center,
                                                StartEnd[i].start,
                                                style: TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                              items: WorkHores.map<
                                                      DropdownMenuItem<String>>(
                                                  (item) {
                                                return DropdownMenuItem<String>(
                                                    //alignment: Alignment.center,
                                                    value: item,
                                                    child: Center(
                                                      child: Text(
                                                        // textAlign: TextAlign.center,
                                                        item,
                                                      ),
                                                    ));
                                              }).toList(),
                                              onChanged: (value) async {
                                                print("efefefvvvv " +
                                                    value.toString());
                                                setState(() {
                                                  StartEnd[i].start =
                                                      value.toString();

                                                  // ignore: unnecessary_new
                                                  StartEnd.add(new StartEndWork(
                                                      StartEnd[i].day,
                                                      value.toString(),
                                                      StartEnd[i].end));
                                                  StartEnd[i].start;
                                                });
                                                SharedPreferences prefsMyData =
                                                    await SharedPreferences
                                                        .getInstance();
                                                prefsMyData.setString(
                                                    deys[i],
                                                    StartEnd[i].start +
                                                        "," +
                                                        StartEnd[i].end +
                                                        "," +
                                                        StartEnd[i].day);
                                              }),
                                        ),
                                      ),
                                    )
                                  : Container(
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 10),
                                        child: Text(
                                          " סגור ",
                                          style: TextStyle(
                                              fontSize: 17,
                                              fontWeight: FontWeight.w600,
                                              color: Colors.black87),
                                        ),
                                      ),
                                    ),
                            ),
                            Center(
                              child: isSwitchedList[i]
                                  ? Container(
                                      margin: EdgeInsets.only(top: 10),
                                      decoration: BoxDecoration(
                                        border: Border.all(
                                          color:
                                              Color.fromARGB(255, 74, 74, 74),
                                        ),
                                      ),
                                      //padding: const EdgeInsets.symmetric(vertical: 10),
                                      child: Directionality(
                                        textDirection: TextDirection.rtl,
                                        child: Container(
                                          color: Color.fromARGB(
                                              255, 255, 255, 255),
                                          width: 70,
                                          height: 33,
                                          child: DropdownButton<String>(
                                              isExpanded: true,
                                              underline: Container(),
                                              hint: Text(
                                                textAlign: TextAlign.center,
                                                StartEnd[i].end,
                                                style: TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                              items: WorkHores.map<
                                                      DropdownMenuItem<String>>(
                                                  (item) {
                                                return DropdownMenuItem<String>(
                                                    alignment: Alignment.center,
                                                    value: item,
                                                    child: Text(
                                                      textAlign:
                                                          TextAlign.center,
                                                      item,
                                                    ));
                                              }).toList(),
                                              onChanged: (value) async {
                                                setState(() {
                                                  StartEnd[i].end =
                                                      value.toString();
                                                });
                                                SharedPreferences prefsMyData =
                                                    await SharedPreferences
                                                        .getInstance();
                                                prefsMyData
                                                    .setString(
                                                        deys[i],
                                                        // ignore: prefer_interpolation_to_compose_strings
                                                        StartEnd[i].start +
                                                            "," +
                                                            StartEnd[i].end +
                                                            "," +
                                                            StartEnd[i].day)
                                                    .toString();
                                                // ignore: prefer_interpolation_to_compose_strings
                                              }),
                                        ),
                                      ),
                                    )
                                  : Container(
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 10),
                                        child: Text(
                                          "סגור",
                                          style: TextStyle(
                                              fontSize: 17,
                                              fontWeight: FontWeight.w600,
                                              color: Colors.black87),
                                        ),
                                      ),
                                    ),
                            ),
                          ]),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 5,
                    )
                  ],
                ),
            ],
          ),
        );
      } else {
        return Container(
          margin: EdgeInsets.only(top: 40),
          child: Column(
            // ignore: prefer_const_literals_to_create_immutables
            children: [
              CircularProgressIndicator(color: Colors.black),
              Container(
                child: Center(
                  child: Text("טוען נתונים...",
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

tableTitle() {
  return Container(
    color: Color.fromARGB(214, 191, 190, 192),
    child: Table(
      border: TableBorder(
          horizontalInside:
              BorderSide(color: Color.fromARGB(255, 187, 69, 69), width: 10.0)),
      children: [
        //This table row is for the table header which is static
        TableRow(children: [
          Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: Text("יום",
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87)),
            ),
          ),
          Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: Text("פתוח/סגור",
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87)),
            ),
          ),
          Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: Text("פתיחה",
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87)),
            ),
          ),
          Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: Text("סגירה",
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87)),
            ),
          ),
        ]),
      ],
    ),
  );
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
            "assets/timer.png",
            width: 150.0,
            height: 150.0,
            fit: BoxFit.fill,
          ),
        ),
      ),
      SizedBox(width: 15),
      // ignore: prefer_const_constructors
      Text("שעות פעילות",
          // ignore: prefer_const_constructors
          style: TextStyle(
            color: Color.fromARGB(255, 0, 0, 0),
            fontWeight: FontWeight.bold,
            fontSize: 30.0,
          ))
    ],
  );
}

class StartEndWork {
  String day = "";
  String start = "";
  String end = "";

  StartEndWork(this.day, this.start, this.end);

  StartEndWork.fromJson(Map<String, dynamic> json) {
    day = json['day'];
    start = json['start'];
    end = json['end'];
  }

  Map<String, dynamic> toJson() {
    return {
      'day': day,
      'start': start,
      'end': end,
    };
  }
}
