// ignore_for_file: prefer_const_constructors, sort_child_properties_last, prefer_const_literals_to_create_immutables, non_constant_identifier_names, prefer_interpolation_to_compose_strings, avoid_single_cascade_in_expression_statements

import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:step_progress_indicator/step_progress_indicator.dart';

class addWorker extends StatefulWidget {
  final String nameClient;
  addWorker({Key? key, required this.nameClient}) : super(key: key);

  @override
  State<addWorker> createState() => _list(nameClient);
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

class _list extends State<addWorker> {
  String nameClient;
  _list(this.nameClient);
  DatabaseReference refM = FirebaseDatabase.instance.ref();
  int step1 = 0, currentStep = 0;
  List<String> test = ["פרטי עובד", "שעות עבודה"];
  List<String> ListDeys = [
    "יום ראשון",
    " יום שני",
    "יום שלישי",
    "יום רביעי",
    "יום חמישי",
    "יום שישי"
  ];
  List<StartEndWork> listStartEndWork = [];
  List<StartEndWork> StartEnd = [];
  List<bool> isSwitchedList = [];
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
    ' 23:30 ',
  ];
  final myControllerName = TextEditingController();
  final myControllerFmaliyName = TextEditingController();
  final myControllerEmail = TextEditingController();
  final myControllerPhone = TextEditingController();
  final myControllerPassword = TextEditingController();
  bool clickOpen = false;
  @override
  void initState() {
    //getCategoryDat1();

    setState(() {
      for (int i = 0; i < 6; i++) {
        StartEnd.add(new StartEndWork(ListDeys[i], " סגור ", " סגור "));
        isSwitchedList.add(false);
      }
    });
    // TODO: implement initState
    super.initState();
  }

  Widget build(BuildContext context) {
    return Column(
      // ignore: prefer_const_literals_to_create_immutables
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
          child: Text("הוסף עובד לצוות",
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
        step(),
        SizedBox(
          height: 5,
        ),
        ConstrainedBox(
          constraints: BoxConstraints(minHeight: 10, maxWidth: 600),
          //margin: EdgeInsets.only(left: 10, right: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            // ignore: prefer_const_literals_to_create_immutables
            children: [
              currentStep > 0
                  ? ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          primary: Color.fromARGB(255, 41, 42, 43),
                          elevation: 3,
                          // shape: RoundedRectangleBorder(
                          //     borderRadius: BorderRadius.circular(32.0)),
                          minimumSize: Size(45, 40),
                          textStyle: const TextStyle(fontSize: 20)),
                      child: Icon(
                        Icons.arrow_back,
                      ),
                      onPressed: () {
                        setState(() {
                          currentStep--;
                        });
                      },
                    )
                  : Container(),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                    primary: Color.fromARGB(255, 41, 42, 43),
                    elevation: 3,
                    // shape: RoundedRectangleBorder(
                    //     borderRadius: BorderRadius.circular(32.0)),
                    minimumSize: Size(45, 40),
                    textStyle: const TextStyle(fontSize: 20)),
                child: currentStep == 0 ? Text("לשלב הבא") : Text("סיום"),
                onPressed: () {
                  if (currentStep == 0 &&
                      myControllerEmail.text.isNotEmpty &&
                      myControllerName.text.isNotEmpty &&
                      myControllerFmaliyName.text.isNotEmpty &&
                      myControllerPhone.text.isNotEmpty) {
                    setState(() {
                      currentStep++;
                    });
                  } else {
                    if (currentStep == 0) {
                      showelrat();
                    }
                  }
                  if (currentStep == 1 && clickOpen == true) {
                    FireBaseDetailsWorker();
                    setState(() {
                      clickOpen = false;
                    });
                  }
                },
              ),
            ],
          ),
        )
      ],
    );
  }

  showelrat() {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      // ignore: prefer_const_constructors
      content: Text(
        "בבקשה מלא את כל הפרטים",
        textAlign: TextAlign.right,
      ),
    ));
  }

  Future<void> _showMyDialog() async {
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
              "איש צוות נוסף בהצלחה",
              textAlign: TextAlign.right,
            ),
            content: SingleChildScrollView(
              child: ListBody(
                children: <Widget>[],
              ),
            ),
            actions: <Widget>[
              TextButton(
                child: const Text("אישור"),
                onPressed: () {
                  myControllerName.text = "";
                  myControllerFmaliyName.text = "";
                  myControllerEmail.text = "";
                  myControllerPhone.text = "";
                  setState(() {
                    StartEnd.clear();
                    isSwitchedList.clear();
                    for (int i = 0; i < 6; i++) {
                      StartEnd.add(
                          new StartEndWork(ListDeys[i], " 07:00 ", " 20:00 "));
                      isSwitchedList.add(false);
                    }
                    currentStep = 0;
                  });
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        })));
      },
    );
  }

  tableTitle() {
    return Container(
      color: Color.fromARGB(214, 191, 190, 192),
      child: Table(
        border: TableBorder(
            horizontalInside: BorderSide(
                color: Color.fromARGB(255, 187, 69, 69), width: 10.0)),
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

  step() {
    return Container(
      alignment: Alignment.center,
      child: ConstrainedBox(
        constraints: BoxConstraints(minHeight: 10, maxWidth: 800),
        child: Container(
          alignment: Alignment.center,
          child: Column(
            children: [
              Container(
                  color: Color.fromARGB(255, 179, 178, 178),
                  child: Container(
                    // decoration: BoxDecoration(
                    //     border: Border.all(
                    //       color: Color.fromARGB(255, 189, 189, 190),
                    //     ),
                    //     borderRadius: BorderRadius.only(
                    //         topLeft: Radius.circular(6),
                    //         topRight: Radius.circular(6))),
                    // width: double.infinity,
                    child: StepProgressIndicator(
                        padding: 0.5,
                        totalSteps: 2,
                        currentStep: currentStep,
                        size: 57,
                        selectedColor: Color.fromARGB(255, 101, 101, 176),
                        unselectedColor: Color.fromARGB(255, 210, 210, 210),
                        customStep: (index, color, _) {
                          return Container(
                            color: index == currentStep
                                ? Color.fromARGB(255, 205, 205, 205)
                                : Color.fromARGB(255, 220, 220, 220),
                            child: Center(
                                child: Text(
                              test[index],
                              style: index == currentStep
                                  ? TextStyle(
                                      fontSize: 14,
                                      color: Color.fromARGB(255, 6, 6, 6),
                                      fontWeight: FontWeight.w600,
                                    )
                                  : TextStyle(
                                      fontSize: 12.5,
                                      color: Color.fromARGB(255, 118, 117, 117),
                                    ),
                            )),
                          );
                        }),
                  )),
              SizedBox(
                height: 20,
              ),
              if (currentStep == 0)
                Column(
                  // ignore: prefer_const_literals_to_create_immutables
                  children: [
                    ConstrainedBox(
                      constraints: BoxConstraints(minHeight: 10, maxWidth: 600),
                      child: Container(
                        margin: EdgeInsets.only(right: 10),
                        alignment: Alignment.topRight,
                        // ignore: prefer_const_constructors
                        child: Text("פרטי העובד",
                            // ignore: prefer_const_constructors
                            textAlign: TextAlign.right,
                            // ignore: prefer_const_constructors
                            style: TextStyle(
                              color: Color.fromARGB(255, 0, 0, 0),
                              fontWeight: FontWeight.bold,
                              fontSize: 15.0,
                            )),
                      ),
                    ),
                    addDetailsWorker(),
                  ],

                  // margin: EdgeInsets.all(10),
                ),
              if (currentStep == 1)
                // ignore: prefer_const_literals_to_create_immutables
                Column(
                  children: [
                    ConstrainedBox(
                      constraints: BoxConstraints(minHeight: 10, maxWidth: 600),
                      child: Container(
                        margin: EdgeInsets.only(right: 10),
                        alignment: Alignment.topRight,
                        // ignore: prefer_const_constructors
                        child: Text("שעות עבודה",
                            // ignore: prefer_const_constructors
                            textAlign: TextAlign.right,
                            // ignore: prefer_const_constructors
                            style: TextStyle(
                              color: Color.fromARGB(255, 0, 0, 0),
                              fontWeight: FontWeight.bold,
                              fontSize: 15.0,
                            )),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    ConstrainedBox(
                      constraints: BoxConstraints(minHeight: 50, maxWidth: 600),
                      child: tableTitle(),
                    ),
                    ConstrainedBox(
                      constraints: BoxConstraints(minHeight: 10, maxWidth: 600),
                      child: table1(),
                    )
                  ],
                )
            ],
          ),
        ),
      ),
    );
  }

  addDetailsWorker() {
    return ConstrainedBox(
      constraints: BoxConstraints(minHeight: 10, maxWidth: 600),
      child: Container(
        margin: EdgeInsets.only(top: 10, bottom: 10),
        decoration: BoxDecoration(
            border: Border.all(
              color: Color.fromARGB(255, 190, 190, 190),
            ),
            borderRadius: BorderRadius.all(Radius.circular(6))),
        // ignore: prefer_const_literals_to_create_immutables
        child: Column(
          children: [
            // ignore: prefer_const_literals_to_create_immutables

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              // ignore: prefer_const_literals_to_create_immutables
              children: [
                Expanded(
                  child: Container(
                    margin: EdgeInsets.only(
                        right: 10, left: 3, top: 10, bottom: 10),
                    alignment: Alignment.topRight,
                    child: Column(
                      children: [
                        Container(
                          //margin: EdgeInsets.only(right: 10),
                          alignment: Alignment.topRight,
                          // ignore: prefer_const_constructors
                          child: Text("שם פרטי",
                              // ignore: prefer_const_constructors
                              // textAlign: TextAlign.right,
                              // ignore: prefer_const_constructors
                              style: TextStyle(
                                color: Color.fromARGB(255, 0, 0, 0),
                                fontWeight: FontWeight.bold,
                                fontSize: 13.0,
                              )),
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Container(
                          //width: 100,
                          child: Directionality(
                              textDirection: TextDirection.rtl,
                              child: TextField(
                                controller: myControllerName,
                                textDirection: TextDirection.ltr,
                                textAlign: TextAlign.right,
                                autofocus: true,
                                onChanged: (value) async {},
                                // ignore: prefer_const_constructors
                                // ignore: unnecessary_new
                                decoration: new InputDecoration(
                                  //filled: true,

                                  prefixIcon:
                                      Icon(Icons.account_circle_rounded),
                                  labelStyle: TextStyle(
                                    color: Color.fromARGB(255, 0, 0, 0),
                                  ),
                                  border: OutlineInputBorder(),
                                ),
                              )),
                        ),
                      ],
                    ),
                  ),
                ),
                // ignore: prefer_const_constructors
                SizedBox(
                  height: 10,
                ),

                //פלאפון"
                Expanded(
                  child: Container(
                      margin: EdgeInsets.only(
                          left: 10, right: 3, top: 10, bottom: 10),
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
                                  child: Text("שם משפחה",
                                      // ignore: prefer_const_constructors
                                      textAlign: TextAlign.right,
                                      // ignore: prefer_const_constructors
                                      style: TextStyle(
                                        color: Color.fromARGB(255, 0, 0, 0),
                                        fontWeight: FontWeight.bold,
                                        fontSize: 13.0,
                                      )),
                                ),
                                SizedBox(
                                  height: 5,
                                ),
                                // ignore: prefer_const_constructors
                                Container(
                                  // width: 100,
                                  child: Directionality(
                                      textDirection: TextDirection.rtl,
                                      child: TextField(
                                        onChanged: (value) async {},
                                        controller: myControllerFmaliyName,
                                        textAlign: TextAlign.right,
                                        autofocus: true,
                                        // ignore: prefer_const_constructors
                                        // ignore: unnecessary_new
                                        decoration: new InputDecoration(
                                          //filled: true,

                                          prefixIcon: Icon(Icons.badge),
                                          labelStyle: TextStyle(
                                            color: Color.fromARGB(255, 0, 0, 0),
                                          ),
                                          border: OutlineInputBorder(),
                                          //labelText: "איימל",
                                        ),
                                      )),
                                ),
                              ])),
                        ],
                      )),
                ),
              ],
            ),

            Container(
                margin: EdgeInsets.only(left: 10, right: 10),
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
                            child: Text("אימייל",
                                // ignore: prefer_const_constructors
                                textAlign: TextAlign.right,
                                // ignore: prefer_const_constructors
                                style: TextStyle(
                                  color: Color.fromARGB(255, 0, 0, 0),
                                  fontWeight: FontWeight.bold,
                                  fontSize: 13.0,
                                )),
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          // ignore: prefer_const_constructors
                          Container(
                            // width: 100,
                            child: Directionality(
                                textDirection: TextDirection.rtl,
                                child: TextField(
                                  onChanged: (value) async {},
                                  controller: myControllerEmail,
                                  textAlign: TextAlign.right,
                                  autofocus: true,
                                  // ignore: prefer_const_constructors
                                  // ignore: unnecessary_new
                                  decoration: new InputDecoration(
                                    //filled: true,

                                    prefixIcon: Icon(Icons.email),
                                    labelStyle: TextStyle(
                                      color: Color.fromARGB(255, 0, 0, 0),
                                    ),
                                    border: OutlineInputBorder(),
                                    //labelText: "איימל",
                                  ),
                                )),
                          ),
                        ])),
                  ],
                )),
            //סיסמה
            Container(
                margin: EdgeInsets.only(left: 10, right: 10),
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
                            child: Text("סיסמה",
                                // ignore: prefer_const_constructors
                                textAlign: TextAlign.right,
                                // ignore: prefer_const_constructors
                                style: TextStyle(
                                  color: Color.fromARGB(255, 0, 0, 0),
                                  fontWeight: FontWeight.bold,
                                  fontSize: 13.0,
                                )),
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          // ignore: prefer_const_constructors
                          Container(
                            // width: 100,
                            child: Directionality(
                                textDirection: TextDirection.rtl,
                                child: TextField(
                                  onChanged: (value) async {},
                                  controller: myControllerPassword,
                                  textAlign: TextAlign.right,
                                  autofocus: true,
                                  // ignore: prefer_const_constructors
                                  // ignore: unnecessary_new
                                  decoration: new InputDecoration(
                                    //filled: true,

                                    prefixIcon: Icon(Icons.password),
                                    labelStyle: TextStyle(
                                      color: Color.fromARGB(255, 0, 0, 0),
                                    ),
                                    border: OutlineInputBorder(),
                                  ),
                                )),
                          ),
                        ])),
                  ],
                )),
            Container(
                margin: EdgeInsets.only(left: 10, right: 10, top: 10),
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
                            child: Text("פלאפון",
                                // ignore: prefer_const_constructors
                                textAlign: TextAlign.right,
                                // ignore: prefer_const_constructors
                                style: TextStyle(
                                  color: Color.fromARGB(255, 0, 0, 0),
                                  fontWeight: FontWeight.bold,
                                  fontSize: 13.0,
                                )),
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          // ignore: prefer_const_constructors
                          Container(
                            // width: 100,
                            child: Directionality(
                                textDirection: TextDirection.rtl,
                                child: TextField(
                                  keyboardType: TextInputType.number,

                                  onChanged: (value) async {},
                                  controller: myControllerPhone,
                                  textAlign: TextAlign.right,
                                  autofocus: true,
                                  // ignore: prefer_const_constructors
                                  // ignore: unnecessary_new
                                  decoration: new InputDecoration(
                                    //filled: true,

                                    prefixIcon: Icon(Icons.phone_android),
                                    labelStyle: TextStyle(
                                      color: Color.fromARGB(255, 0, 0, 0),
                                    ),
                                    border: OutlineInputBorder(),
                                    //labelText: "איימל",
                                  ),
                                )),
                          ),
                        ])),
                  ],
                )),
            SizedBox(
              height: 10,
            )
          ],
        ),
      ),
    );
  }

  table1() {
    return Column(
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
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          child: Switch(
                            value: isSwitchedList[i],
                            onChanged: (value) async {
                              // setState(() {
                              //   isSwitchedList[i] = value;
                              //   StartEnd[i].start;
                              // });

                              if (isSwitchedList[i] == false) {
                                setState(() {
                                  isSwitchedList[i] = true;
                                  StartEnd[i].start = " 07:00 ";
                                  StartEnd[i].end = " 20:00 ";
                                  clickOpen = true;
                                });
                              } else {
                                setState(() {
                                  isSwitchedList[i] = false;

                                  clickOpen = false;
                                });
                              }
                              // if (isSwitchedList[i] == true)
                              //   // ignore: curly_braces_in_flow_control_structures
                              //   setState(() {
                              //     isSwitchedList[i] = false;
                              //   });
                            },
                            activeTrackColor: Color.fromARGB(255, 33, 150, 243),
                            activeColor: Color.fromARGB(255, 33, 150, 243),
                          ),
                        ),
                      ),
                      Center(
                        child: isSwitchedList[i]
                            ? Container(
                                margin: EdgeInsets.only(top: 10),
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: Color.fromARGB(255, 74, 74, 74),
                                  ),
                                ),
                                //padding: const EdgeInsets.symmetric(vertical: 10),
                                child: Directionality(
                                  textDirection: TextDirection.rtl,
                                  child: Container(
                                    color: Color.fromARGB(255, 255, 255, 255),
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
                                            DropdownMenuItem<String>>((item) {
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
                                          print("efefeqq112 " +
                                              isSwitchedList[i].toString());
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

                                          print(value);
                                        }),
                                  ),
                                ),
                              )
                            : Container(
                                child: Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 10),
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
                      Center(
                        child: isSwitchedList[i]
                            ? Container(
                                margin: EdgeInsets.only(top: 10),
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: Color.fromARGB(255, 74, 74, 74),
                                  ),
                                ),
                                //padding: const EdgeInsets.symmetric(vertical: 10),
                                child: Directionality(
                                  textDirection: TextDirection.rtl,
                                  child: Container(
                                    color: Color.fromARGB(255, 255, 255, 255),
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
                                            DropdownMenuItem<String>>((item) {
                                          return DropdownMenuItem<String>(
                                              alignment: Alignment.center,
                                              value: item,
                                              child: Text(
                                                textAlign: TextAlign.center,
                                                item,
                                              ));
                                        }).toList(),
                                        onChanged: (value) async {
                                          setState(() {
                                            StartEnd[i].end = value.toString();
                                          });

                                          print(value);
                                        }),
                                  ),
                                ),
                              )
                            : Container(
                                child: Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 10),
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
    );
  }

  FireBaseDetailsWorker() async {
    UserCredential userCredential =
        await FirebaseAuth.instance.createUserWithEmailAndPassword(
      email: myControllerEmail.text,
      password: myControllerPassword.text,
    );
    // ignore: avoid_single_cascade_in_expression_statements
    refM
      ..child(nameClient)
          .child("עובדים")
          .child(myControllerName.text + " " + myControllerFmaliyName.text)
          .update({
        "שם מלא": myControllerName.text + " " + myControllerFmaliyName.text,
        "איימל": myControllerEmail.text,
        "סיסמה": myControllerPassword.text,
        "טלפון": myControllerPhone.text,
      });
    FireBaseHoursWorker();
  }

  FireBaseHoursWorker() {
    if (StartEnd.isNotEmpty) {
      for (int i = 0; i < 6; i++) {
        refM
          ..child(nameClient)
              .child("פעילות")
              .child(myControllerName.text + " " + myControllerFmaliyName.text)
              .child(i.toString() + "," + StartEnd[i].day)
              .update({
            "התחלה": StartEnd[i].start,
            "סיום": StartEnd[i].end,
          });
      }
      _showMyDialog();
    }
  }
}
