// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors, unnecessary_new, prefer_interpolation_to_compose_strings

import 'dart:convert';
import 'dart:html';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/foundation.dart';
import 'dart:typed_data';
import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:my_tor/main.dart';
import 'package:my_tor/tableTor/give_Service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:step_progress_indicator/step_progress_indicator.dart';

class menuHoresWork extends StatefulWidget {
  final String nameClient, howUser;
  menuHoresWork({Key? key, required this.nameClient, required this.howUser})
      : super(key: key);

  @override
  State<menuHoresWork> createState() => _list(nameClient, howUser);
}

class MyWoresHores {
  String day = "";
  String start = "";
  String end = "";

  MyWoresHores(this.day, this.start, this.end);
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

class _list extends State<menuHoresWork> {
  String nameClient, howUser;
  _list(this.nameClient, this.howUser);
  List<bool> isSwitchedList = [];
  List<StartEndWork> StartEnd = [];

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
  List<MyWoresHores> dataWorks = [];
  List<StartEndWork> listStartEndWork = [];
  int step1 = 0, currentStep = 0;
  String nameGiveService = "";
  bool upFireBase = false;
  List<workerListModel> listGiveService = [];
  DatabaseReference refM = FirebaseDatabase.instance.ref();

  List<String> test = ["נותן שירות", "שעות פעילות"];

  Color back = Color.fromARGB(235, 235, 235, 235);

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

  @override
  void initState() {
    // getCategoryDat1();
    getCategoryDataGiveService().then((value) {
      getCategoryDataGiveService().then((value) {
        if (howUser != "m") {
          setState(() {
            currentStep = 1;
          });
          getCategoryDat1();
        }
      });
    });
    // listGiveService.add("יהודה אהרוני");
    // listGiveService.add("אלי מורדוך");
    // listGiveService.add("שימי גוזלן");

    // TODO: implement initState
    super.initState();
  }

  Future<List<StartEndWork>> getDataStartEndHores() async {
    listStartEndWork.clear();
    final ref = FirebaseDatabase.instance.ref();

    final snapshot =
        await ref.child("$nameClient/פעילות/$nameGiveService").get();
    if (snapshot.exists) {
      for (int i = 0; i < snapshot.children.length; i++) {
        listStartEndWork.add(new StartEndWork(
          snapshot.children.elementAt(i).key.toString().split(",").last,
          snapshot.children.elementAt(i).child("התחלה").value.toString(),
          snapshot.children.elementAt(i).child("סיום").value.toString(),
        ));
      }
      listStartEndWork.add(new StartEndWork(
        "יום שבת",
        "09:00",
        "23:55",
      ));
    }

    return listStartEndWork;
  }

  Future getCategoryDataGiveService() async {
    final prefsListWorker = await SharedPreferences.getInstance();
    final category = prefsListWorker.getString("ListWorker");
    listGiveService = List<workerListModel>.from(
        List<Map<String, dynamic>>.from(jsonDecode(category.toString()))
            .map((e) => workerListModel.fromJson(e))
            .toList());

    setState(() {
      listGiveService;
    });

    SharedPreferences UseremailPass = await SharedPreferences.getInstance();

    String EmailCurrnt = UseremailPass.getString("UseremailPass")
        .toString()
        .split("|")
        .first
        .toString();

    for (int i = 0; i < listGiveService.length; i++) {
      // ignore: prefer_interpolation_to_compose_strings
      print("ffttr33333" +
          listGiveService[i].email.toString() +
          " " +
          EmailCurrnt);
      if (EmailCurrnt == listGiveService[i].email) {
        setState(() {
          nameGiveService = listGiveService[i].nameWorker.toString();
        });
      }
    }

    return listGiveService;
  }

  // Future<List<StartEndWork>> getCategoryData() async {
  //   final prefsStartEndWork = await SharedPreferences.getInstance();
  //   print("sdsd " + prefsStartEndWork.getString("listStartEndWork").toString());
  //   final category = prefsStartEndWork.getString("listStartEndWork");
  //   listStartEndWork = List<StartEndWork>.from(
  //       List<Map<String, dynamic>>.from(jsonDecode(category.toString()))
  //           .map((e) => StartEndWork.fromJson(e))
  //           .toList());
  //   print("ffeefeef1 " + listStartEndWork[0].start.toString());

  //   return listStartEndWork;
  // }

  Future<List<StartEndWork>> getCategoryDat1() async {
    getDataStartEndHores().then((value) {
      StartEnd.clear();
      isSwitchedList.clear();
      for (int i = 0; i < 6; i++) {
        setState(() {
          isSwitchedList
              .add(listStartEndWork[i].start == " סגור " ? false : true);
          StartEnd.add(new StartEndWork(listStartEndWork[i].day,
              listStartEndWork[i].start, listStartEndWork[i].end));
        });
      }
      print("sdsd1 " + StartEnd[0].day.toString());
    });

    return StartEnd;
  }

  Widget build(BuildContext context) {
    return (Container(
        child: Column(
      // ignore: prefer_const_literals_to_create_immutables
      children: [
        ConstrainedBox(
          constraints: BoxConstraints(minHeight: 50, maxWidth: 800),
          child: Divider(
            height: 40,
            thickness: 3,
          ),
        ),
        SizedBox(
          height: 10,
        ),
        SizedBox(
          height: 5,
        ),
        step(),
        SizedBox(
          height: 5,
        ),
        SizedBox(
          height: 35,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          // ignore: prefer_const_literals_to_create_immutables
          children: [
            currentStep > 0 && howUser == "m"
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
            currentStep > 0
                ? ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        primary: Color.fromARGB(255, 41, 42, 43),
                        elevation: 3,
                        // shape: RoundedRectangleBorder(
                        //     borderRadius: BorderRadius.circular(32.0)),
                        minimumSize: Size(45, 40),
                        textStyle: const TextStyle(fontSize: 20)),
                    child: Text("עדכן שעות"),
                    onPressed: () async {
                      List<Future<void>> updateFutures = [];

                      for (int i = 0; i < 6; i++) {
                        // ignore: avoid_single_cascade_in_expression_statements
                        Future<void> updateFuture = refM
                            .child(nameClient)
                            .child("פעילות")
                            .child(nameGiveService)
                            .child(i.toString() + "," + StartEnd[i].day)
                            .update({
                          "התחלה": StartEnd[i].start,
                          "סיום": StartEnd[i].end,
                        }).then((value) {
                          if (i == 5) {
                            _showMyDialog();
                          }
                          // ignore: invalid_return_type_for_catch_error
                        }).catchError((error) {
                          print('All update operations reeoe');

                          Fluttertoast.showToast(
                              msg: error,
                              //toastLength: Toast.LENGTH_SHORT,
                              gravity: ToastGravity.TOP,
                              timeInSecForIosWeb: 3,
                              // backgroundColor: Color.fromARGB(
                              //     255, 74, 72, 72),
                              textColor: Colors.white,
                              fontSize: 16.0);
                        });
                        updateFutures.add(updateFuture);
                      }
                      //await Future.delayed(Duration(seconds: 1));
                      await Future.wait(updateFutures);
                      print('All update operations completed11');
                    },
                  )
                : Container(),
          ],
        ),
        SizedBox(
          height: 5,
        ),
      ],
    )));
  }

  Future<void> _showMyDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (context) {
        return ScaffoldMessenger(child: Builder(builder: ((context) {
          return AlertDialog(
            title: Text(
              style: TextStyle(
                //backgroundColor: Color.fromARGB(255, 178, 175, 175),
                color: Color.fromARGB(255, 53, 52, 52),
                fontWeight: FontWeight.bold,
                fontSize: 14.0,
              ),
              // ignore: prefer_interpolation_to_compose_strings
              // ignore: prefer_interpolation_to_compose_strings
              "הנתונים עודכנו בהצלחה",
              textAlign: TextAlign.right,
            ),
            actions: <Widget>[
              TextButton(
                child: const Text("אישור"),
                onPressed: () {
                  setState(() {
                    upFireBase = false;
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
                height: 15,
              ),
              if (currentStep == 0)
                Column(
                  // ignore: prefer_const_literals_to_create_immutables
                  children: [dataGive()],

                  // margin: EdgeInsets.all(10),
                ),
              if (currentStep == 1)
                // ignore: prefer_const_literals_to_create_immutables
                Column(
                  children: [
                    Container(
                      margin: EdgeInsets.only(right: 10),
                      alignment: Alignment.topRight,
                      child: Text(nameGiveService,
                          // ignore: prefer_const_constructors
                          style: TextStyle(
                            color: Color.fromARGB(255, 101, 100, 100),
                            //fontWeight: FontWeight.bold,
                            fontSize: 15.0,
                          )),
                    ),
                    SizedBox(
                      height: 5,
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

  dataGive() {
    return Container(
      padding: EdgeInsets.fromLTRB(5, 0, 5, 0),
      //width: double.maxFinite,
      child: ListView.separated(
          physics: const NeverScrollableScrollPhysics(),
          itemCount: listGiveService.length,
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
                  borderRadius: BorderRadius.circular(5.0), //<-- SEE HERE
                ),
                elevation: 10,
                child: Dismissible(
                  direction: DismissDirection.none,
                  key: Key(listGiveService[index].toString()),
                  onDismissed: (direction) {},
                  child: ListTile(
                    selectedTileColor: Color.fromARGB(255, 0, 0, 0),
                    textColor: Color.fromARGB(255, 0, 0, 0),
                    // ignore: prefer_const_constructors
                    title: Text(
                      listGiveService[index].nameWorker.toString(),
                      // ignore: prefer_const_constructors
                      style: TextStyle(
                        color: Color.fromARGB(255, 0, 0, 0),
                        fontWeight: FontWeight.bold,
                        fontSize: 15.0,
                      ),
                    ),
                    trailing:
                        // ignore: prefer_const_constructors
                        Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 0.0),
                      // ignore: prefer_const_constructors
                      child: Icon(
                        Icons.arrow_forward_sharp,
                        size: 20,
                      ),
                    ),

                    onTap: () {
                      setState(() {
                        nameGiveService =
                            listGiveService[index].nameWorker.toString();
                        getCategoryDat1();
                        //getCategoryDat1();
                        // getDataStartEndHores();

                        currentStep = 1;
                      });

                      // setPrefDataUser(listGiveService[index].toString());
                    },
                  ),
                ),
              ),
            );
          }),
    );
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
                                    SharedPreferences prefs =
                                        await SharedPreferences.getInstance();
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
                                        StartEnd.add(new StartEndWork(
                                            StartEnd[i].day,
                                            StartEnd[i].start,
                                            StartEnd[i].end));
                                        StartEnd[i].start;
                                      });
                                    }
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
                                                // SharedPreferences prefs =
                                                //     await SharedPreferences
                                                //         .getInstance();
                                                // prefs.setString(
                                                //     "1",
                                                //     StartEnd[i].start +
                                                //         "," +
                                                //         StartEnd[i].end +
                                                //         "," +
                                                //         StartEnd[i].day);
                                                print(value);
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
                                                // SharedPreferences prefs =
                                                //     await SharedPreferences
                                                //         .getInstance();
                                                // prefs
                                                //     .setString(
                                                //         "1",
                                                //         StartEnd[i].start +
                                                //             "," +
                                                //             StartEnd[i]
                                                //                 .end +
                                                //             "," +
                                                //             StartEnd[i].day)
                                                //     .toString();
                                                print(value);
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
