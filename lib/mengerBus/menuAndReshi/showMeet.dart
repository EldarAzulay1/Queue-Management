// ignore_for_file: camel_case_types, prefer_interpolation_to_compose_strings, prefer_const_constructors, avoid_single_cascade_in_expression_statements

import 'dart:convert';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:my_tor/mengerBus/menuAndReshi/adminMenu.dart';
import 'package:my_tor/tableTor/give_Service.dart';
import 'package:provider/single_child_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_sliding_up_panel/flutter_sliding_up_panel.dart';

class dataMeet {
  final String? start;
  final String? end;
  final String? typeTipol;
  final String? phone;
  final String? name;
  final String? price;
  final String? TypeTime;
  final String? giveTipol;
  //final String? city;
  dataMeet(this.start, this.end, this.typeTipol, this.phone, this.name,
      this.price, this.TypeTime, this.giveTipol);
}

class listMeet extends StatefulWidget {
  final dataCurrent data;
  final String nameClient, howUser;
  listMeet(
      {Key? key,
      required this.data,
      required this.nameClient,
      required this.howUser})
      : super(key: key);
  @override
  State<listMeet> createState() => _listMeet(data, nameClient, howUser);
}

class _listMeet extends State<listMeet> {
  final dataCurrent data;
  String nameClient, howUser;
  _listMeet(this.data, this.nameClient, this.howUser);
  String NameDay = "",
      NumberMunth = "",
      NameMonth = "",
      NameMonthForDate = "",
      dateNow = "",
      namePerson = "";
  int totalPrice = 0, totalMeet = 0;
  List<dataMeet> listDataMeet = [];
  int countListAfterClock = 0, countprice = 0, countMeets = 0;
  ScrollController _scrollController = ScrollController();
  String dateCancelCurrent = "";
  List<DateTime> days = [];
  bool ListDateEmpty = true;
  List<workerListModel> listGiveService = [];

  DateTime now = DateTime.now();
  late DateTime day1;
  String nowhours = "";
  int openCard = -1;
  DateTime rangeStart1 = new DateTime.now();

  late ScrollController scrollController;
  @override
  void initState() {
    print("now dd" + now.hour.toString() + now.minute.toString());
    now.hour;

    day1 = DateTime(now.year, now.month, now.day);
    NumberMunth = day1.toString().split("-").last.split(" ").first;
    getDay(day1.weekday);
    getDate(day1.month);
    String minut = now.minute.toString() == "0"
        ? "00"
        : now.minute < 10
            ? "0" + now.minute.toString()
            : now.minute.toString();
    setState(() {
      nowhours = now.hour.toString() + minut.toString();
      dateNow = data.dataCurrentNow.toString();
      // ignore: unnecessary_new
      day1 = DateTime(
          int.parse(dateNow.toString().split("-")[2]),
          int.parse(dateNow.toString().split("-")[1]),
          int.parse(dateNow.toString().split("-")[0]));

      print("wdwd" + day1.day.toString());
      getDay(day1.weekday);
      getDate(day1.month);
      NumberMunth = day1.toString().split("-").last.split(" ").first;

      dateNow = day1.toIso8601String().split("T").first +
          " - " +
          NameDay +
          " , " +
          NumberMunth +
          " " +
          NameMonth +
          " " +
          day1.year.toString();
      dateCancelCurrent = day1.toIso8601String().split("T").first +
          " - " +
          NameDay +
          " , " +
          NumberMunth +
          " " +
          NameMonth +
          " " +
          day1.year.toString();
      getName().then((value) {
        print('fffffffff == '+ namePerson.toString());
        getDataFirebaseOnChage();
      });
    });

    // TODO: implement initState
    super.initState();
  }

  Future getName() async {
    final prefsListWorker = await SharedPreferences.getInstance();
    final category = prefsListWorker.getString("ListWorker");
    listGiveService = List<workerListModel>.from(
        List<Map<String, dynamic>>.from(jsonDecode(category.toString()))
            .map((e) => workerListModel.fromJson(e))
            .toList());
    listGiveService.add(new workerListModel("כללי", "", ""));
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
     
      if (EmailCurrnt == listGiveService[i].email) {
        setState(() {
          namePerson = listGiveService[i].nameWorker.toString();
        });
      }
    }
     print("ffttr33333" +
          namePerson +
          " " +
          EmailCurrnt);

    return listGiveService;
  }

  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      child: ConstrainedBox(
          constraints: BoxConstraints(minHeight: 10, maxWidth: 800),
          child: Container(
            margin: EdgeInsets.all(10),
            decoration: BoxDecoration(
                border: Border.all(
                  color: Color.fromARGB(255, 190, 190, 190),
                ),
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(6), topRight: Radius.circular(6))),
            alignment: Alignment.center,
            child: Column(
              children: [
                // ignore: prefer_const_constructors
                SizedBox(
                  height: 15,
                ),
                // ignore: prefer_interpolation_to_compose_strings
                Text(
                    // ignore: prefer_interpolation_to_compose_strings
                    NameDay +
                        " , " +
                        NumberMunth +
                        " " +
                        NameMonth +
                        " " +
                        day1.year.toString(),
                    // ignore: prefer_const_constructors
                    style: TextStyle(
                      color: Color.fromARGB(255, 6, 6, 6),
                      fontWeight: FontWeight.bold,
                      fontSize: 22.0,
                    )),

                // ConstrainedBox(
                //   constraints: BoxConstraints(minHeight: 10, maxWidth: 600),
                //   child: dataOrder(),
                // ),
                ConstrainedBox(
                  constraints: BoxConstraints(minHeight: 10, maxWidth: 800),
                  child: Divider(
                    height: 10,
                    thickness: 3,
                  ),
                ),

                // ignore: prefer_interpolation_to_compose_strings

                ConstrainedBox(
                  constraints: BoxConstraints(minHeight: 50, maxWidth: 600),
                  child: Container(
                    margin: EdgeInsets.only(right: 10),
                    alignment: Alignment.centerRight,
                    // ignore: prefer_const_constructors
                    child: Text(
                        // ignore: prefer_interpolation_to_compose_strings
                        " רשימת תורים  - " + namePerson,
                        // ignore: prefer_const_constructors
                        style: TextStyle(
                          color: Color.fromARGB(255, 56, 55, 55),
                          fontWeight: FontWeight.bold,
                          fontSize: 19.0,
                        )),
                  ),
                ),
                ConstrainedBox(
                  constraints: BoxConstraints(minHeight: 10, maxWidth: 600),
                  child: show(),
                ),

                SizedBox(
                  height: 10,
                ),
              ],
            ),
          )),
    );
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

  Future<int> getDataMeet() async {
    DatabaseReference refM = FirebaseDatabase.instance.ref();
    final event = await refM
        .child(nameClient)
        .child("תורים")
        .child("עובדים")
        .child(namePerson)
        .once(DatabaseEventType.value);

    if (totalMeet > event.snapshot.child(dateNow).children.length) {
      totalMeet = 0;
      setState(() {
        totalPrice = 0;
      });
    }

    if (event.snapshot.child(dateNow).children.isNotEmpty &&
        event.snapshot.child(dateNow).children.length >
            listDataMeet.length + countMeets) {
      for (int i = 0; i < event.snapshot.child(dateNow).children.length; i++) {
        if (event.snapshot
                    .child(dateNow)
                    .children
                    .elementAt(i)
                    .child("שם")
                    .value
                    .toString() !=
                "חופשה" &&
            event.snapshot
                    .child(dateNow)
                    .children
                    .elementAt(i)
                    .child("שם")
                    .value
                    .toString() !=
                "הפסקה") {
          if (int.parse(nowhours) <
              int.parse(event.snapshot
                  .child(dateNow)
                  .children
                  .elementAt(i)
                  .child("התחלה")
                  .value
                  .toString())) {
            totalMeet++;
          } else {
            setState(() {
              countMeets++;
            });
          }
          // ignore: curly_braces_in_flow_control_structures

        }
      }
    }

    return totalMeet;
  }

  Future<int> getDataPrice() async {
    DatabaseReference refM = FirebaseDatabase.instance.ref();
    final event = await refM
        .child(nameClient)
        .child("תורים")
        .child("עובדים")
        .child(namePerson)
        .once(DatabaseEventType.value);

    if (event.snapshot.child(dateNow).children.isNotEmpty &&
        event.snapshot.child(dateNow).children.length >
            listDataMeet.length + countprice) {
      for (int i = 0; i < event.snapshot.child(dateNow).children.length; i++) {
        if (event.snapshot
                    .child(dateNow)
                    .children
                    .elementAt(i)
                    .child("שם")
                    .value
                    .toString() !=
                "חופשה" &&
            event.snapshot
                    .child(dateNow)
                    .children
                    .elementAt(i)
                    .child("שם")
                    .value
                    .toString() !=
                "הפסקה") {
          // ignore: curly_braces_in_flow_control_structures
          if (int.parse(nowhours) <
              int.parse(event.snapshot
                  .child(dateNow)
                  .children
                  .elementAt(i)
                  .child("התחלה")
                  .value
                  .toString())) {
            totalPrice += int.parse(event.snapshot
                .child(dateNow)
                .children
                .elementAt(i)
                .child("מחיר")
                .value
                .toString()
                .split(" ")
                .first);
          } else {
            setState(() {
              countprice++;
            });
          }
        }
      }
    }

    return totalPrice;
  }

  getDataFirebaseOnChage() async {
    DatabaseReference refM = FirebaseDatabase.instance.ref();
    final event = await refM
        .child(nameClient)
        .child("תורים")
        .child("עובדים")
        .child(namePerson)
        .onValue
        .listen((event) {
      setState(() {
        totalMeet = 0;
        totalPrice = 0;
        countListAfterClock = 0;
        listDataMeet.clear();
      });
      getDataPrice();
      getDataMeet();
      getDataFirebase();
    });
  }

  Future<List<dataMeet>> getDataFirebase() async {
    DatabaseReference refM = FirebaseDatabase.instance.ref();
    final event = await refM
        .child(nameClient)
        .child("תורים")
        .child("עובדים")
        .child(namePerson)
        .once(DatabaseEventType.value);
    if (event.snapshot.child(dateNow).children.isNotEmpty &&
        event.snapshot.child(dateNow).children.length >
            listDataMeet.length + countListAfterClock) {
      for (int i = 0; i < event.snapshot.child(dateNow).children.length; i++) {
        print("hhroos " + nowhours.toString());
        if (int.parse(nowhours) <
            int.parse(event.snapshot
                .child(dateNow)
                .children
                .elementAt(i)
                .child("התחלה")
                .value
                .toString())) {
          // ignore: unnecessary_new
          listDataMeet.add(
            // ignore: unnecessary_new
            new dataMeet(
                event.snapshot
                    .child(dateNow)
                    .children
                    .elementAt(i)
                    .child("התחלה")
                    .value
                    .toString(),
                event.snapshot
                    .child(dateNow)
                    .children
                    .elementAt(i)
                    .child("סיום")
                    .value
                    .toString(),
                event.snapshot
                    .child(dateNow)
                    .children
                    .elementAt(i)
                    .child("טיפול")
                    .value
                    .toString(),
                event.snapshot
                    .child(dateNow)
                    .children
                    .elementAt(i)
                    .child("פלאפון")
                    .value
                    .toString(),
                event.snapshot
                    .child(dateNow)
                    .children
                    .elementAt(i)
                    .child("שם")
                    .value
                    .toString(),
                event.snapshot
                    .child(dateNow)
                    .children
                    .elementAt(i)
                    .child("מחיר")
                    .value
                    .toString(),
                event.snapshot
                    .child(dateNow)
                    .children
                    .elementAt(i)
                    .child("זמן")
                    .value
                    .toString(),
                event.snapshot
                    .child(dateNow)
                    .children
                    .elementAt(i)
                    .child("שירות")
                    .value
                    .toString()),
          );
        } else {
          setState(() {
            countListAfterClock++;
          });
        }
      }
    }

    // setState(() {
    //   listDataMeet;
    // });
    return listDataMeet;
  }

  show() {
    return FutureBuilder<List<dataMeet>>(
        future: getDataFirebase(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return listDataMeet.isNotEmpty
                ? Column(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      LimitedBox(
                        maxHeight: double.infinity,
                        child: ListView.separated(
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            //controller: _scrollController,
                            scrollDirection: Axis.vertical,
                            separatorBuilder:
                                (BuildContext context, int index) {
                              return SizedBox(height: 8);
                            },
                            itemCount: listDataMeet.length,
                            itemBuilder: (BuildContext context, int index) {
                              return Container(
                                margin: EdgeInsets.only(left: 5, right: 5),
                                //width: 400,
                                child: Card(
                                  color: Color.fromARGB(255, 16, 16, 16),
                                  //margin: EdgeInsets.all(10),
                                  elevation: 25,
                                  child: SizedBox(
                                    height: (index == openCard &&
                                            listDataMeet[index].name !=
                                                "חופשה" &&
                                            listDataMeet[index].name != "הפסקה")
                                        ? 280
                                        : index == openCard &&
                                                (listDataMeet[index].name ==
                                                        "הפסקה" ||
                                                    listDataMeet[index].name ==
                                                        "חופשה")
                                            ? 130
                                            : 85,
                                    child: Column(
                                      // crossAxisAlignment:
                                      //     CrossAxisAlignment.stretch,

                                      children: <Widget>[
                                        Stack(
                                          children: [
                                            Container(
                                              margin: EdgeInsets.all(1),
                                              child: Align(
                                                alignment: Alignment.center,
                                                child: listDataMeet[index]
                                                            .name !=
                                                        "חופשה"
                                                    ? Text(
                                                        // ignore: prefer_interpolation_to_compose_strings
                                                        listDataMeet[index]
                                                                .end!
                                                                .substring(
                                                                    0, 2) +
                                                            ":" +
                                                            listDataMeet[index]
                                                                .end!
                                                                .substring(
                                                                    2, 4) +
                                                            " - " +
                                                            listDataMeet[index]
                                                                .start!
                                                                .substring(
                                                                    0, 2) +
                                                            ":" +
                                                            listDataMeet[index]
                                                                .start!
                                                                .substring(
                                                                    2, 4),
                                                        textDirection:
                                                            TextDirection.ltr,
                                                        // ignore: prefer_const_constructors
                                                        style: TextStyle(
                                                          color:
                                                              // ignore: prefer_const_constructors
                                                              Color.fromARGB(
                                                                  255,
                                                                  255,
                                                                  255,
                                                                  255),
                                                          //fontWeight: FontWeight.bold,
                                                          fontSize: 20.0,
                                                        ))
                                                    : Text(
                                                        // ignore: prefer_interpolation_to_compose_strings
                                                        listDataMeet[index]
                                                                .end
                                                                .toString() +
                                                            " - " +
                                                            listDataMeet[index]
                                                                .start
                                                                .toString(),
                                                        textDirection:
                                                            TextDirection.ltr,
                                                        // ignore: prefer_const_constructors
                                                        style: TextStyle(
                                                          color:
                                                              // ignore: prefer_const_constructors
                                                              Color.fromARGB(
                                                                  255,
                                                                  255,
                                                                  255,
                                                                  255),
                                                          //fontWeight: FontWeight.bold,
                                                          fontSize: 20.0,
                                                        )),
                                              ),
                                            ),
                                            listDataMeet[index].name != "חופשה"
                                                ? Container(
                                                    // ignore: prefer_const_constructors
                                                    margin: EdgeInsets.only(
                                                        left: 10, top: 4),
                                                    alignment:
                                                        Alignment.centerLeft,
                                                    child: Text(
                                                        listDataMeet[index]
                                                            .TypeTime
                                                            .toString(),
                                                        // ignore: prefer_const_constructors
                                                        style: TextStyle(
                                                          // ignore: prefer_const_constructors
                                                          color: Color.fromARGB(
                                                              255,
                                                              255,
                                                              255,
                                                              255),
                                                          //fontWeight: FontWeight.bold,
                                                          fontSize: 15.0,
                                                        )),
                                                  )
                                                : Container(),
                                            listDataMeet[index].name != "חופשה"
                                                ? Container(
                                                    child: listDataMeet[index]
                                                                .name !=
                                                            "הפסקה"
                                                        ? Container(
                                                            // ignore: prefer_const_constructors
                                                            margin:
                                                                EdgeInsets.only(
                                                                    left: 33,
                                                                    top: 6),
                                                            alignment: Alignment
                                                                .centerLeft,
                                                            // ignore: prefer_const_constructors
                                                            child: Icon(
                                                              Icons
                                                                  .alarm_outlined,
                                                              color:
                                                                  Colors.white,
                                                              size: 16,
                                                            ),
                                                          )
                                                        : Container(
                                                            // ignore: prefer_const_constructors
                                                            margin:
                                                                EdgeInsets.only(
                                                                    left: 53,
                                                                    top: 6),
                                                            alignment: Alignment
                                                                .centerLeft,
                                                            // ignore: prefer_const_constructors
                                                            child: Icon(
                                                              Icons
                                                                  .alarm_outlined,
                                                              color:
                                                                  Colors.white,
                                                              size: 16,
                                                            ),
                                                          ),
                                                  )
                                                : Container()
                                          ],
                                        ),
                                        Expanded(
                                          child: Container(
                                              // ignore: prefer_const_constructors
                                              decoration: BoxDecoration(
                                                color: Color.fromARGB(
                                                    255, 247, 247, 247),
                                                // ignore: prefer_const_constructors
                                              ),
                                              child: Column(
                                                children: [
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      Expanded(
                                                        child: Column(
                                                          children: [
                                                            Container(
                                                              alignment:
                                                                  Alignment
                                                                      .topRight,
                                                              margin: EdgeInsets
                                                                  .only(
                                                                top: 5,
                                                                right: 15,
                                                              ),
                                                              child: Text(
                                                                  listDataMeet[
                                                                          index]
                                                                      .name
                                                                      .toString(),

                                                                  // ignore: prefer_const_constructors
                                                                  style:
                                                                      TextStyle(
                                                                    // ignore: prefer_const_constructors
                                                                    color: Color
                                                                        .fromARGB(
                                                                            255,
                                                                            23,
                                                                            23,
                                                                            23),
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w700,
                                                                    fontSize:
                                                                        15.0,
                                                                  )),
                                                            ),
                                                            SizedBox(
                                                              height: 3,
                                                            ),
                                                            listDataMeet[index]
                                                                            .name !=
                                                                        "הפסקה" &&
                                                                    listDataMeet[index]
                                                                            .name !=
                                                                        "חופשה"
                                                                ? Container(
                                                                    margin: EdgeInsets.only(
                                                                        right:
                                                                            15,
                                                                        top: 1),
                                                                    alignment:
                                                                        Alignment
                                                                            .topRight,
                                                                    child: Text(
                                                                        listDataMeet[index]
                                                                            .typeTipol
                                                                            .toString(),
                                                                        // ignore: prefer_const_constructors
                                                                        style:
                                                                            // ignore: prefer_const_constructors
                                                                            TextStyle(
                                                                          color: Color.fromARGB(
                                                                              255,
                                                                              69,
                                                                              68,
                                                                              68),
                                                                          fontWeight:
                                                                              FontWeight.w500,
                                                                          fontSize:
                                                                              14.0,
                                                                        )),
                                                                  )
                                                                : Container(),
                                                          ],
                                                        ),
                                                      ),
                                                      Container(
                                                        margin: EdgeInsets.only(
                                                            left: 5),
                                                        alignment:
                                                            Alignment.topLeft,
                                                        child: IconButton(
                                                          icon: Icon(
                                                            openCard != -1 &&
                                                                    openCard ==
                                                                        index
                                                                ? Icons
                                                                    .arrow_upward
                                                                : Icons
                                                                    .arrow_downward_rounded,
                                                            size: 30,
                                                            color:
                                                                Color.fromARGB(
                                                                    255,
                                                                    19,
                                                                    18,
                                                                    18),
                                                          ),
                                                          onPressed: () async {
                                                            setState(() {
                                                              if (openCard !=
                                                                  -1) {
                                                                openCard = -1;
                                                              } else {
                                                                openCard =
                                                                    index;
                                                              }
                                                            });
                                                            print("press " +
                                                                openCard
                                                                    .toString());
                                                          },
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  Visibility(
                                                    visible: index == openCard,
                                                    child: Expanded(
                                                      child: Column(
                                                        children: [
                                                          SizedBox(
                                                            height: 5,
                                                          ),
                                                          ConstrainedBox(
                                                            constraints:
                                                                BoxConstraints(
                                                                    minHeight:
                                                                        10,
                                                                    maxWidth:
                                                                        600),
                                                            child: Divider(
                                                              height: 5,
                                                              thickness: 1,
                                                            ),
                                                          ),
                                                          listDataMeet[index]
                                                                          .name !=
                                                                      "הפסקה" &&
                                                                  listDataMeet[
                                                                              index]
                                                                          .name !=
                                                                      "חופשה"
                                                              ? Column(
                                                                  children: [
                                                                    Container(
                                                                      margin: EdgeInsets
                                                                          .all(
                                                                              5),
                                                                      alignment:
                                                                          Alignment
                                                                              .topRight,
                                                                      color: Color.fromARGB(
                                                                          255,
                                                                          199,
                                                                          199,
                                                                          198),
                                                                      child:
                                                                          Container(
                                                                        margin: EdgeInsets.only(
                                                                            right:
                                                                                15,
                                                                            top:
                                                                                5),
                                                                        alignment:
                                                                            Alignment.centerRight,
                                                                        child:
                                                                            RichText(
                                                                          text:
                                                                              TextSpan(
                                                                            // ignore: prefer_const_literals_to_create_immutables
                                                                            children: [
                                                                              // ignore: prefer_interpolation_to_compose_strings
                                                                              TextSpan(
                                                                                text: "נותן השירות -  ",
                                                                                style: TextStyle(
                                                                                  //backgroundColor: Color.fromARGB(255, 178, 175, 175),
                                                                                  color: Color.fromARGB(255, 0, 0, 0),
                                                                                  fontWeight: FontWeight.w600,
                                                                                  fontSize: 16.0,
                                                                                ),
                                                                              ),
                                                                              TextSpan(
                                                                                text: listDataMeet[index].giveTipol.toString(),
                                                                                style: TextStyle(
                                                                                  //backgroundColor: Color.fromARGB(255, 178, 175, 175),
                                                                                  color: Color.fromARGB(255, 0, 0, 0),
                                                                                  fontWeight: FontWeight.w500,
                                                                                  fontSize: 16.0,
                                                                                ),
                                                                              ),
                                                                            ],
                                                                          ),
                                                                        ),
                                                                      ),
                                                                    ),
                                                                    Container(
                                                                      margin: EdgeInsets
                                                                          .all(
                                                                              5),
                                                                      alignment:
                                                                          Alignment
                                                                              .topRight,
                                                                      width: double
                                                                          .infinity,
                                                                      color: Color.fromARGB(
                                                                          255,
                                                                          199,
                                                                          199,
                                                                          198),
                                                                      child:
                                                                          Container(
                                                                        margin: EdgeInsets.only(
                                                                            right:
                                                                                15,
                                                                            top:
                                                                                5),
                                                                        alignment:
                                                                            Alignment.topRight,
                                                                        child:
                                                                            RichText(
                                                                          text:
                                                                              TextSpan(
                                                                            // ignore: prefer_const_literals_to_create_immutables
                                                                            children: [
                                                                              // ignore: prefer_interpolation_to_compose_strings
                                                                              TextSpan(
                                                                                text: "מחיר השירות -  ",
                                                                                style: TextStyle(
                                                                                  //backgroundColor: Color.fromARGB(255, 178, 175, 175),
                                                                                  color: Color.fromARGB(255, 0, 0, 0),
                                                                                  fontWeight: FontWeight.w600,
                                                                                  fontSize: 16.0,
                                                                                ),
                                                                              ),

                                                                              TextSpan(
                                                                                text: listDataMeet[index].price.toString(),
                                                                                style: TextStyle(
                                                                                  //backgroundColor: Color.fromARGB(255, 178, 175, 175),
                                                                                  color: Color.fromARGB(255, 0, 0, 0),
                                                                                  fontWeight: FontWeight.w500,
                                                                                  fontSize: 16.0,
                                                                                ),
                                                                              ),
                                                                            ],
                                                                          ),
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  ],
                                                                )
                                                              : Container(),
                                                          listDataMeet[index]
                                                                          .name !=
                                                                      "הפסקה" &&
                                                                  listDataMeet[
                                                                              index]
                                                                          .name !=
                                                                      "חופשה"
                                                              ? Row(
                                                                  children: [
                                                                    Expanded(
                                                                      child: Container(
                                                                          decoration: BoxDecoration(
                                                                            border:
                                                                                Border.all(
                                                                              color: Color.fromARGB(255, 106, 105, 105),
                                                                            ),
                                                                            borderRadius:
                                                                                BorderRadius.circular(6.0),
                                                                          ),
                                                                          margin: EdgeInsets.only(top: 10, bottom: 10, left: 10, right: 10),
                                                                          alignment: Alignment.bottomLeft,
                                                                          child: ElevatedButton.icon(
                                                                            style: ElevatedButton.styleFrom(
                                                                                primary: Color.fromARGB(255, 224, 222, 222),
                                                                                elevation: 3,
                                                                                shape: RoundedRectangleBorder(
                                                                                  borderRadius: BorderRadius.circular(6.0),
                                                                                ),
                                                                                minimumSize: Size(double.infinity, 46),
                                                                                textStyle: const TextStyle(fontSize: 16)),
                                                                            onPressed:
                                                                                () {
                                                                              callPhone(listDataMeet[index].phone.toString());
                                                                              print("whatttsssss");
                                                                              // Your onPressed code here
                                                                            },
                                                                            icon:
                                                                                Icon(color: Colors.green, Icons.phone),
                                                                            label:
                                                                                Text(
                                                                              "להתקשר",
                                                                              style: TextStyle(color: Colors.black),
                                                                            ),
                                                                          )),
                                                                    ),
                                                                    Expanded(
                                                                      child: Container(
                                                                          decoration: BoxDecoration(
                                                                              border: Border.all(
                                                                                color: Color.fromARGB(255, 106, 105, 105),
                                                                              ),
                                                                              borderRadius: BorderRadius.all(Radius.circular(6))),
                                                                          margin: EdgeInsets.only(top: 10, bottom: 10, left: 10, right: 10),
                                                                          alignment: Alignment.bottomRight,
                                                                          child: ElevatedButton.icon(
                                                                            style: ElevatedButton.styleFrom(
                                                                                primary: Color.fromARGB(255, 224, 222, 222),
                                                                                elevation: 3,
                                                                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)),
                                                                                minimumSize: Size(double.infinity, 46),
                                                                                textStyle: const TextStyle(fontSize: 16)),
                                                                            onPressed:
                                                                                () {
                                                                              whatapp(listDataMeet[index].phone.toString());
                                                                              print("whatttsssss");
                                                                              // Your onPressed code here
                                                                            },
                                                                            icon:
                                                                                Icon(color: Colors.green, Icons.whatsapp),
                                                                            label:
                                                                                Text(
                                                                              "שלח ווצאפ",
                                                                              style: TextStyle(color: Colors.black),
                                                                            ),
                                                                          )),
                                                                    ),
                                                                  ],
                                                                )
                                                              : Container(),
                                                          Expanded(
                                                            child: Container(
                                                              margin: EdgeInsets
                                                                  .only(
                                                                      bottom: 5,
                                                                      left: 10,
                                                                      right:
                                                                          10),
                                                              alignment: Alignment
                                                                  .bottomCenter,
                                                              child:
                                                                  ElevatedButton(
                                                                      style: ElevatedButton.styleFrom(
                                                                          primary: Color.fromARGB(
                                                                              255,
                                                                              225,
                                                                              46,
                                                                              46),
                                                                          elevation:
                                                                              3,
                                                                          shape: RoundedRectangleBorder(
                                                                              borderRadius: BorderRadius.circular(
                                                                                  5.0)),
                                                                          minimumSize: Size(
                                                                              double
                                                                                  .infinity,
                                                                              35),
                                                                          maximumSize: Size(
                                                                              double
                                                                                  .infinity,
                                                                              55),
                                                                          textStyle: const TextStyle(
                                                                              fontSize:
                                                                                  20)),
                                                                      child:
                                                                          Text(
                                                                        listDataMeet[index].name ==
                                                                                "הפסקה"
                                                                            ? "מחק הפסקה"
                                                                            : listDataMeet[index].name == "חופשה"
                                                                                ? "מחק חופשה"
                                                                                : "מחק תור",
                                                                        style: TextStyle(
                                                                            fontWeight: FontWeight
                                                                                .w500,
                                                                            color: Color.fromARGB(
                                                                                255,
                                                                                2,
                                                                                2,
                                                                                2)),
                                                                      ),
                                                                      onPressed:
                                                                          () {
                                                                        _showMyDialogCancelList(
                                                                            index);
                                                                      }),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  )
                                                ],
                                              )),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            }),
                      ),
                    ],
                  )
                : ListDateEmpty
                    ? Container(
                        height: 150,
                        width: 320,
                        child: Card(
                            shape: RoundedRectangleBorder(
                              side: BorderSide(
                                width: 1.0,
                                color: Color.fromARGB(255, 143, 141, 141),
                              ),
                              borderRadius:
                                  BorderRadius.circular(15.0), //<-- SEE HERE
                            ),
                            elevation: 10,
                            // ignore: prefer_const_literals_to_create_immutables
                            child: Column(
                              children: [
                                Container(
                                  margin: EdgeInsets.all(16),
                                  child: Icon(
                                    Icons.perm_contact_calendar_rounded,
                                    color: Color.fromARGB(255, 247, 58, 58),
                                    size: 40,
                                  ),
                                ),
                                Container(
                                  margin: EdgeInsets.only(left: 5, right: 5),

                                  // ignore: prefer_const_literals_to_create_immutables
                                  child: Column(children: [
                                    // ignore: prefer_const_constructors
                                    Text(
                                      "בנתיים , לא נקבעו תורים להיום",
                                      textAlign: TextAlign.center,
                                      textDirection: TextDirection.ltr,
                                      // ignore: prefer_const_constructors
                                      style: TextStyle(
                                        color: Color.fromARGB(255, 0, 0, 0),
                                        fontWeight: FontWeight.w700,
                                        fontSize: 16.0,
                                      ),
                                    )
                                  ]),
                                )
                              ],
                            )))
                    : Container(
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

  Future<void> _showMyDialogCancelList(int index) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (context) {
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
            "? בטוח שברצונך למחוק",
            textAlign: TextAlign.right,
          ),
          content: SingleChildScrollView(
              child: ListBody(
            children: <Widget>[
              Container(
                //height: 300.0, // Change as per your requirement
                width: 300.0, // Change as per your requirement
                child: Text(
                  listDataMeet[index].name != "חופשה"
                      ? dateCancelCurrent.split(" - ").last
                      : "",
                  textAlign: TextAlign.right,
                ),
              ),
              Container(
                //height: 300.0, // Change as per your requirement
                width: 300.0, // Change as per your requirement
                child: listDataMeet[index].name != "חופשה"
                    ? Text(
                        listDataMeet[index].name.toString() == "הפסקה"
                            ? "שעת הפסקה " +
                                listDataMeet[index]
                                    .start
                                    .toString()
                                    .substring(0, 2) +
                                ":" +
                                listDataMeet[index]
                                    .start
                                    .toString()
                                    .substring(2, 4) +
                                " - " +
                                listDataMeet[index]
                                    .end
                                    .toString()
                                    .substring(0, 2) +
                                ":" +
                                listDataMeet[index]
                                    .end
                                    .toString()
                                    .substring(2, 4)
                            : "שעת התור " +
                                listDataMeet[index]
                                    .start
                                    .toString()
                                    .substring(0, 2) +
                                ":" +
                                listDataMeet[index]
                                    .start
                                    .toString()
                                    .substring(2, 4) +
                                " - " +
                                listDataMeet[index]
                                    .end
                                    .toString()
                                    .substring(0, 2) +
                                ":" +
                                listDataMeet[index]
                                    .end
                                    .toString()
                                    .substring(2, 4),
                        textAlign: TextAlign.right,
                      )
                    : Text(
                        " תאריכי חופשה " +
                            listDataMeet[index]
                                .start
                                .toString()
                                .split("/")
                                .first +
                            "/" +
                            listDataMeet[index].start.toString().split("/")[1] +
                            " - " +
                            listDataMeet[index]
                                .end
                                .toString()
                                .split("/")
                                .first +
                            "/" +
                            listDataMeet[index].end.toString().split("/")[1] +
                            "\n" +
                            "כל החופשה תמחק *",
                        textDirection: TextDirection.rtl,
                        textAlign: TextAlign.right,
                      ),
              )
            ],
          )),
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
                  child: Text(listDataMeet[index].name.toString() == "חופשה"
                      ? "מחק חופשה"
                      : listDataMeet[index].name.toString() == "הפסקה"
                          ? "מחק הפסקה"
                          : "מחק תור"),
                  onPressed: () {
                    String give = listDataMeet[index].giveTipol.toString();

                    String nowdateTorim = rangeStart1
                            .toIso8601String()
                            .split("T")
                            .first
                            .split("-")
                            .last +
                        rangeStart1
                            .toIso8601String()
                            .split("T")
                            .first
                            .split("-")[1] +
                        rangeStart1
                            .toIso8601String()
                            .split("T")
                            .first
                            .split("-")[0];

                    // ignore: avoid_single_cascade_in_expression_statements

                    if (listDataMeet[index].name != "חופשה") {
                      String phone = listDataMeet[index].phone.toString();
                      DatabaseReference ref1 = FirebaseDatabase.instance.ref(
                          "$nameClient/תורים/עובדים/$give" +
                              "/" +
                              dateCancelCurrent +
                              "/" +
                              listDataMeet[index].start.toString() +
                              "," +
                              listDataMeet[index].end.toString());
                      // listDataMeet.removeAt(index);
                      ref1.remove();
                      DatabaseReference ref = FirebaseDatabase.instance.ref(
                          "$nameClient/תורים/כללי/$dateCancelCurrent" +
                              "/" +
                              listDataMeet[index].start.toString() +
                              "," +
                              listDataMeet[index].end.toString() +
                              " | " +
                              give);

                      DatabaseReference ref111 = FirebaseDatabase.instance.ref(
                          "$nameClient/לקוחות/$phone/תורים" +
                              "/" +
                              dateCancelCurrent +
                              "/" +
                              listDataMeet[index].start.toString() +
                              "," +
                              listDataMeet[index].end.toString());
                      ref111.remove();

                      DatabaseReference ref2 = FirebaseDatabase.instance.ref(
                          "$nameClient/תורים/עובדים/$give" +
                              "/" +
                              dateCancelCurrent +
                              "/" +
                              listDataMeet[index].start.toString() +
                              "," +
                              listDataMeet[index].end.toString());

                      String phoneCurrent =
                          listDataMeet[index].phone.toString();

                      String StartTime = listDataMeet[index]
                              .start
                              .toString()
                              .substring(0, 2) +
                          ":" +
                          listDataMeet[index].start.toString().substring(2, 4);

                      DatabaseReference refRmoveTorim = FirebaseDatabase
                          .instance
                          .ref("torim/$nowdateTorim/$phoneCurrent/$StartTime");
                      refRmoveTorim.remove();

                      ref1.remove().then((value) {
                        ref.remove().then((value) {
                          showelrat();
                        });
                      });

                      listDataMeet.removeAt(index);
                      setState(() {
                        countListAfterClock = 0;
                        countMeets = 0;
                        countprice = 0;
                        openCard = -1;
                      });
                    } else {
                      DateTime start = DateTime.utc(
                          int.parse(listDataMeet[index].start!.split("/").last),
                          int.parse(listDataMeet[index].start!.split("/")[1]),
                          int.parse(
                              listDataMeet[index].start!.split("/").first));
                      DateTime end = DateTime.utc(
                          int.parse(listDataMeet[index].end!.split("/").last),
                          int.parse(listDataMeet[index].end!.split("/")[1]),
                          int.parse(listDataMeet[index].end!.split("/").first));
                      for (int i = 0; i <= end.difference(start).inDays; i++) {
                        days.add(start.add(Duration(days: i)));
                        getDay(days[i].weekday);
                        getDate(days[i].month);
                        NumberMunth =
                            days[i].toString().split("-").last.split(" ").first;
                        dateCancelCurrent =
                            days[i].toIso8601String().split("T").first +
                                " - " +
                                NameDay +
                                " , " +
                                NumberMunth +
                                " " +
                                NameMonth +
                                " " +
                                days[i].year.toString();

                        DatabaseReference ref1 = FirebaseDatabase.instance.ref(
                            "$nameClient/תורים/כללי" +
                                "/" +
                                dateCancelCurrent +
                                "/" +
                                "0500" +
                                "," +
                                "2355" +
                                " | " +
                                give);
                        DatabaseReference ref = FirebaseDatabase.instance.ref(
                            "$nameClient/תורים/עובדים/$give" +
                                "/" +
                                dateCancelCurrent +
                                "/" +
                                "0500" +
                                "," +
                                "2355");
                        ref1.remove();

                        ref.remove();
                      }
                      setState(() {
                        days.clear();
                        listDataMeet.removeAt(index);
                        //totalPrice = 0;
                      });
                      setState(() {
                        countListAfterClock = 0;
                        countMeets = 0;
                        countprice = 0;
                      });
                    }

                    setState(() {
                      if (listDataMeet.isEmpty) {
                        ListDateEmpty = true;
                      } else {
                        ListDateEmpty = false;
                      }
                      totalMeet = 0;
                      totalPrice = 0;
                      listDataMeet.clear();
                    });

                    Navigator.of(context).pop();
                  },
                ),
              ],
            )
          ],
        );
      },
    );
  }

  showelrat() {
    print("rrggggggggggggggggg");
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      // ignore: prefer_const_constructors
      content: Text(
        "נמחק בהצלחה מהיומן",
        textAlign: TextAlign.right,
      ),
    ));
  }

  Future<void> callPhone(String numberPhone) async {
    String url = 'tel:' + numberPhone;
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  Future<void> whatapp(String numberPhone) async {
    String url = 'https://wa.me/+972$numberPhone';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  dataOrder() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Expanded(
          child: Container(
              margin: EdgeInsets.all(20),
              width: 200,
              height: 100,
              child: Card(
                  elevation: 15,
                  color: Colors.white,
                  shape: RoundedRectangleBorder(
                    // ignore: prefer_const_constructors
                    side: BorderSide(
                      width: 1.0,
                      //color: Color.fromARGB(255, 143, 141, 141),
                    ),
                    borderRadius: BorderRadius.circular(10.0),
                    //<-- SEE HERE
                  ),
                  child: Stack(
                    children: [
                      Container(
                          margin: EdgeInsets.only(top: 20, left: 16),
                          child: Align(
                            widthFactor: 50,
                            alignment: Alignment.centerLeft,
                            child: Icon(
                              Icons.date_range_rounded,
                              color: Colors.blueGrey,
                              size: 30,
                            ),
                          )),
                      Container(
                          margin: EdgeInsets.all(10),
                          child: Align(
                            widthFactor: 50,
                            alignment: Alignment.topRight,
                            child: Text("תורים להיום",
                                style: TextStyle(
                                  color: Color.fromARGB(255, 81, 80, 80),
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15.0,
                                )),
                          )),
                      SizedBox(
                        height: 20,
                      ),
                      FutureBuilder(
                          future: getDataMeet(),
                          builder: (context, snapshot) {
                            if (snapshot.hasData) {
                              return Container(
                                child: Container(
                                    margin: EdgeInsets.only(top: 20, right: 16),
                                    child: Align(
                                      alignment: Alignment.centerRight,
                                      child: Text(totalMeet.toString(),
                                          // ignore: prefer_const_constructors
                                          style: TextStyle(
                                            color:
                                                Color.fromARGB(255, 51, 50, 50),
                                            fontWeight: FontWeight.bold,
                                            fontSize: 20.0,
                                          )),
                                    )),
                              );
                            } else {
                              return Container();
                            }
                          }),
                    ],
                  ))),
        ),
        Expanded(
          child: Container(
              margin: EdgeInsets.all(20),
              width: 200,
              height: 100,
              child: Card(
                  elevation: 15,
                  color: Colors.white,
                  shape: RoundedRectangleBorder(
                    // ignore: prefer_const_constructors
                    side: BorderSide(
                      width: 1.0,
                      //color: Color.fromARGB(255, 143, 141, 141),
                    ),
                    borderRadius: BorderRadius.circular(10.0),
                    //<-- SEE HERE
                  ),
                  child: Stack(
                    children: [
                      Container(
                          margin: EdgeInsets.only(top: 20, left: 16),
                          child: Align(
                            widthFactor: 50,
                            alignment: Alignment.centerLeft,
                            child: Icon(
                              Icons.moving_rounded,
                              color: Colors.blueGrey,
                              size: 30,
                            ),
                          )),
                      Container(
                          margin: EdgeInsets.all(10),
                          child: Align(
                            widthFactor: 50,
                            alignment: Alignment.topRight,
                            child: Text("הכנסות להיום",
                                style: TextStyle(
                                  color: Color.fromARGB(255, 81, 80, 80),
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15.0,
                                )),
                          )),
                      SizedBox(
                        height: 20,
                      ),
                      FutureBuilder(
                          future: getDataPrice(),
                          builder: (context, snapshot) {
                            if (snapshot.hasData) {
                              return Container(
                                  margin: EdgeInsets.only(top: 20, right: 16),
                                  child: Align(
                                    alignment: Alignment.centerRight,
                                    child: Text(totalPrice.toString() + " ₪",
                                        style: TextStyle(
                                          color:
                                              Color.fromARGB(255, 51, 50, 50),
                                          fontWeight: FontWeight.bold,
                                          fontSize: 20.0,
                                        )),
                                  ));
                            } else {
                              return Container();
                            }
                          }),
                    ],
                  ))),
        ),
      ],
    );
  }
}
