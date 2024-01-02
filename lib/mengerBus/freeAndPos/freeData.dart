// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, prefer_interpolation_to_compose_strings, unnecessary_new, prefer_is_empty, unused_import, depend_on_referenced_packages, prefer_adjacent_string_concatenation, avoid_single_cascade_in_expression_statements, curly_braces_in_flow_control_structures
import 'dart:async';
import 'dart:html';
import 'dart:io';
import 'dart:convert';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_clean_calendar/date_utils.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:my_tor/mengerBus/menuAndReshi/showMeet.dart';
import 'package:my_tor/mengerBus/menuAndReshi/adminMenu.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/date_symbol_data_file.dart';
import 'package:calendar_calendar/calendar_calendar.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import 'package:buttons_tabbar/buttons_tabbar.dart';
import 'package:url_launcher/url_launcher.dart';

class freeData extends StatefulWidget {
  final String nameGive, nameClient;

  final myControllerImage = TextEditingController();
  freeData({Key? key, required this.nameGive, required this.nameClient})
      : super(key: key);

  @override
  State<freeData> createState() => _freeDeys(nameGive, nameClient);
}

class dataMeet {
  final String? start;
  final String? end;
  final String? phone;
  final String? name;
  final String? data;

  //final String? city;
  dataMeet(
    this.start,
    this.end,
    this.phone,
    this.name,
    this.data,
  );
}

class _freeDeys extends State<freeData> {
  String give1, nameClient;
  _freeDeys(this.give1, this.nameClient);
  DateTime today = DateTime.now();
  DateTime todayPos = DateTime.now();
  DatabaseReference refM = FirebaseDatabase.instance.ref();
  int countMoth = 0, numYear = 0, numMonth = 0, numDay = 0, countDay = 26;

  String NameDay = "",
      NumberMunth = "",
      NameMonth = "",
      NameMonthForDate = "",
      dateNow = "",
      dateFreeCurrent = "";
  List<dataMeet> listDataMeet = [];
  int click = 0;
  late DateTime rangeStart = DateTime.utc(1992, 8, 2),
      rangeEnd = DateTime.utc(1992, 8, 2),
      test = DateTime.utc(1992, 8, 2),
      focuse = DateTime.now(),
      focusePos = DateTime.now();
  int freeDayCount = 0;
  bool listEmptyOrNo = false;
  List<DateTime> days = [];
  List<DateTime> daysRemove = [];
  final startWorkHores = [
    '07',
    '08',
    '09',
    '10',
    '11',
    '12',
    '13',
    '14',
    '15',
    '16',
    '17',
    '18',
    '19',
    '20',
    '21',
    '22',
    '23',
  ];

  final startWorkMin = [
    '00',
    '10',
    '15',
    '20',
    '25',
    '30',
    '35',
    '40',
    '45',
    '50',
    '55',
  ];

  @override
  void initState() {
    // TODO: implement initState
    DateTime now = new DateTime.now();
    DateTime day1 = new DateTime(now.year, now.month, now.day);
    getDay(now.weekday);
    getDate(now.month);
    getDateForDate(now.month);

    NumberMunth = now.toString().split("-").last.split(" ").first;
    setState(() {
      dateFreeCurrent = day1.toIso8601String().split("T").first +
          " - " +
          NameDay +
          " , " +
          NumberMunth +
          " " +
          NameMonth +
          " " +
          now.year.toString();
      numYear = now.year;
      numMonth = now.month;
      numDay = now.day;
    });
    //String locale = Localizations.localeOf(context).languageCode;
    super.initState();
  }

  Widget build(BuildContext context) {
    return Container(
        child: Column(children: [
      SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          // ignore: prefer_const_literals_to_create_immutables
          children: [
            Divider(
              height: 40,
              thickness: 3,
            ),
            Container(
              margin: EdgeInsets.all(10),
              alignment: Alignment.topRight,
              child: Text(
                "הגדר זמן חופשה",
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 17,
                    fontWeight: FontWeight.bold),
              ),
            ),
            calnder(),
            SizedBox(
              height: 10,
            ),
            Divider(
              height: 10,
              thickness: 3,
            ),
            finishFree()
          ],
        ),
      ),
    ]));
  }

  //לוח השנה
  calnder() {
    return Container(
        width: 450,
        margin: EdgeInsets.only(left: 10, right: 10),
        child: Card(
            elevation: 15,
            shape: RoundedRectangleBorder(
              // ignore: prefer_const_constructors
              side: BorderSide(
                width: 1.0,
                //color: Color.fromARGB(255, 143, 141, 141),
              ),
              borderRadius: BorderRadius.circular(15.0), //<-- SEE HERE
            ),
            // ignore: prefer_const_literals_to_create_immutables
            child: Column(
              children: [
                SizedBox(
                  height: 5,
                ),
                Stack(
                  // ignore: prefer_const_literals_to_create_immutables
                  children: [
                    Padding(
                        padding: EdgeInsets.only(left: 10),
                        child: Align(
                            alignment: Alignment.topLeft,
                            child: IconButton(
                              icon: Icon(Icons.arrow_forward_ios),
                              onPressed: () {
                                DateTime now = new DateTime.now();

                                var date = new DateTime(now.year, now.month);
                                var sumMoth = Utils.lastDayOfMonth(date);

                                print(" date now now " +
                                    (((int.parse(now.day.toString()) - 1) -
                                                    int.parse(
                                                        sumMoth.day.toString()))
                                                .toString() +
                                            " " +
                                            sumMoth.day.toString())
                                        .toString());

                                if ((int.parse(now.day.toString()) - 1) -
                                        int.parse(sumMoth.day.toString()) +
                                        countDay >
                                    0) {
                                  setState(() {
                                    countMoth++;
                                    print("dededed222  " +
                                        (numMonth + countMoth).toString());
                                    if (numMonth + countMoth < 13) {
                                      getDateForDate(numMonth + countMoth);
                                      numDay = 1;
                                    } else {
                                      setState(() {
                                        countMoth = 0;
                                        numYear++;
                                        numMonth = 1;
                                        getDateForDate(1);
                                        getDate(1);
                                      });
                                    }
                                  });
                                }
                              },
                            ))),
                    Container(
                      alignment: Alignment.center,
                      child: Text(NameMonthForDate,
                          style: TextStyle(
                            color: Color.fromARGB(255, 0, 0, 0),
                            fontWeight: FontWeight.bold,
                            fontSize: 22.0,
                          )),
                    ),
                    Padding(
                        padding: EdgeInsets.only(right: 10),
                        child: Align(
                            alignment: Alignment.topRight,
                            child: IconButton(
                              icon: Icon(Icons.arrow_back_ios),
                              onPressed: () {
                                DateTime now = new DateTime.now();
                                print("mon " + countMoth.toString());
                                DateTime day1 =
                                    new DateTime(now.year, now.month, now.day);
                                setState(() {
                                  if (countMoth >= 0) {
                                    if (numYear > now.year) {
                                      numMonth = now.month;
                                      numYear = now.year;
                                      countMoth = 0;
                                      getDateForDate(numMonth + countMoth);
                                    } else {
                                      if (countMoth > 0) {
                                        countMoth--;
                                        getDateForDate(numMonth + countMoth);
                                      }
                                    }
                                    if (numMonth + countMoth == now.month) {
                                      numDay = now.day;
                                    }
                                  }
                                });
                                if (now.month == 12) {
                                  getDate(12);
                                }
                              },
                            ))),
                  ],
                ),
                SizedBox(
                  height: 5,
                ),
                Container(
                    child: Directionality(
                  textDirection: TextDirection.rtl,
                  child: TableCalendar(
                    headerVisible: false,

                    locale: "he_IL",
                    rowHeight: 35,
                    rangeStartDay: rangeStart,
                    rangeEndDay: rangeEnd,
                    focusedDay:
                        DateTime.utc(numYear, numMonth + countMoth, numDay),
                    //availableCalendarFormats: const {CalendarFormat.twoWeeks : '2 weeks'},
                    headerStyle: HeaderStyle(
                        formatButtonVisible: false, titleCentered: false),
                    availableGestures: AvailableGestures.all,
                    selectedDayPredicate: ((day) => isSameDay(day, today)),
                    firstDay: DateTime.utc(DateTime.now().year,
                        DateTime.now().month, DateTime.now().day),
                    lastDay: DateTime.utc(DateTime.now().year + 50, 12, 0),
                    onDaySelected: _onDaySelected,
                  ),
                ))
              ],
            )));
  }

  calnder1() {
    return Container(
        margin: EdgeInsets.only(left: 10, right: 10),
        width: 450,
        child: Card(
            shape: RoundedRectangleBorder(
              // ignore: prefer_const_constructors
              side: BorderSide(
                width: 1.0,
                //color: Color.fromARGB(255, 143, 141, 141),
              ),
              borderRadius: BorderRadius.circular(15.0), //<-- SEE HERE
            ),
            // ignore: prefer_const_literals_to_create_immutables
            child: Column(
              children: [
                Container(
                    margin: EdgeInsets.only(left: 5, right: 5),
                    child: Directionality(
                      textDirection: TextDirection.rtl,
                      child: TableCalendar(
                        headerVisible: true,
                        locale: "he_IL",
                        rowHeight: 35,
                        rangeStartDay: rangeStart,
                        rangeEndDay: rangeEnd,
                        focusedDay: focuse,
                        //availableCalendarFormats: const {CalendarFormat.twoWeeks : '2 weeks'},
                        headerStyle: HeaderStyle(
                            formatButtonVisible: false, titleCentered: false),
                        availableGestures: AvailableGestures.all,
                        selectedDayPredicate: ((day) => isSameDay(day, today)),
                        firstDay: DateTime.utc(DateTime.now().year,
                            DateTime.now().month, DateTime.now().day),
                        lastDay: DateTime.utc(DateTime.now().year + 1, 12, 0),
                        onDaySelected: _onDaySelected,
                      ),
                    ))
              ],
            )));
  }

  _onDaySelected(DateTime day, DateTime focusedDay) {
    setState(() {
      click = 0;
    });
    if (isSameDay(rangeStart, test)) {
      print(day);
      setState(() {
        rangeStart = day;
        focuse = day;
      });
    }
    // ignore: curly_braces_in_flow_control_structures
    else {
      if (isSameDay(rangeEnd, test)) {
        setState(() {
          rangeEnd = day;
          focuse = day;
          freeDayCount = rangeEnd.day - rangeStart.day + 1;
          for (int i = 0; i <= rangeEnd.difference(rangeStart).inDays; i++) {
            click++;
          }
        });
      } else {
        setState(() {
          focuse = day;
          rangeStart = day;
          freeDayCount = 0;
          rangeEnd = DateTime.utc(1992, 8, 2);
        });
      }
    }
  }

  finishFree() {
    return SingleChildScrollView(
        child: LimitedBox(
            maxWidth: double.infinity,
            child: Column(
              children: [
                Container(
                  margin: EdgeInsets.all(10),
                  alignment: Alignment.topRight,
                  child: Text(
                    "טווח תארכי חופשה",
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 15,
                        fontWeight: FontWeight.bold),
                  ),
                ),
                rangeStart != test
                    ? ConstrainedBox(
                        constraints:
                            BoxConstraints(minHeight: 10, maxWidth: 450),
                        child: Container(
                          margin: EdgeInsets.only(left: 10, right: 10),
                          width: 450,
                          child: Card(
                            shape: RoundedRectangleBorder(
                              // ignore: prefer_const_constructors
                              side: BorderSide(
                                width: 1.0,
                                //color: Color.fromARGB(255, 143, 141, 141),
                              ),
                              borderRadius:
                                  BorderRadius.circular(5.0), //<-- SEE HERE
                            ),
                            child: Container(
                              alignment: Alignment.center,
                              width: MediaQuery.of(context).size.width,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Expanded(
                                      child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Container(
                                        alignment: Alignment.center,
                                        margin: EdgeInsets.only(right: 20),
                                        child: Text(
                                          rangeStart != test ? "התחל" : "",
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 12,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                      Container(
                                        margin: EdgeInsets.all(10),
                                        alignment: Alignment.center,
                                        child: rangeStart != test
                                            ? ElevatedButton(
                                                style: ElevatedButton.styleFrom(
                                                    backgroundColor:
                                                        Color.fromARGB(
                                                            255, 76, 76, 240),
                                                    elevation: 3,
                                                    shape:
                                                        RoundedRectangleBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        32.0)),
                                                    minimumSize: Size(10, 30),
                                                    textStyle: const TextStyle(
                                                        fontSize: 15)),
                                                child: Text(
                                                  rangeStart != test
                                                      ? rangeStart.day
                                                              .toString() +
                                                          "/" +
                                                          rangeStart.month
                                                              .toString() +
                                                          "/" +
                                                          rangeStart.year
                                                              .toString()
                                                      : "",
                                                ),
                                                onPressed: () {},
                                              )
                                            : Container(),
                                      ),
                                      Container(
                                        alignment: Alignment.center,
                                        margin: EdgeInsets.only(right: 5),
                                        child: Text(
                                          rangeEnd != test ? "עד" : "",
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 12,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                      Container(
                                        margin: EdgeInsets.all(10),
                                        alignment: Alignment.center,
                                        child: rangeEnd != test
                                            ? ElevatedButton(
                                                style: ElevatedButton.styleFrom(
                                                    backgroundColor:
                                                        Color.fromARGB(
                                                            255, 76, 76, 240),
                                                    elevation: 3,
                                                    shape:
                                                        RoundedRectangleBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        32.0)),
                                                    minimumSize: Size(10, 30),
                                                    textStyle: const TextStyle(
                                                        fontSize: 15)),
                                                child: Text(
                                                  rangeEnd != test
                                                      ? rangeEnd.day
                                                              .toString() +
                                                          "/" +
                                                          rangeEnd.month
                                                              .toString() +
                                                          "/" +
                                                          rangeEnd.year
                                                              .toString()
                                                      : "",
                                                ),
                                                onPressed: () {},
                                              )
                                            : Container(),
                                      ),
                                    ],
                                  ))
                                ],
                              ),
                            ),
                          ),
                        ),
                      )
                    : Container(),
                SizedBox(
                  height: 5,
                ),
                Container(
                  margin: EdgeInsets.all(10),
                  alignment: Alignment.topRight,
                  child: Text(
                    rangeEnd != test ? "סך הכל ימים  " + click.toString() : "",
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 20,
                        fontWeight: FontWeight.bold),
                  ),
                ),
                SizedBox(
                  height: 5,
                ),
                rangeEnd != test
                    ? Container(
                        alignment: Alignment.bottomCenter,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              backgroundColor: Color.fromARGB(255, 76, 76, 240),
                              elevation: 3,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(5.0)),
                              minimumSize: Size(50, 40),
                              textStyle: const TextStyle(fontSize: 20)),
                          child: Text(
                            rangeStart != test ? "עדכן יומן" : "",
                          ),
                          onPressed: () {
                            days.clear();
                            for (int i = 0;
                                i <= rangeEnd.difference(rangeStart).inDays;
                                i++) {
                              days.add(rangeStart.add(Duration(days: i)));
                            }
                            checkingIfHavaTor(days);
                          },
                        ),
                      )
                    : Container(),
                SizedBox(
                  height: 10,
                )
              ],
            )));
  }

  checkingIfHavaTor(List<DateTime> days) async {
    DatabaseReference refM = FirebaseDatabase.instance.ref();
    final event = await refM
        .child(nameClient)
        .child("תורים")
        .child("עובדים")
        .child(give1)
        .once(DatabaseEventType.value);
    for (int i = 0; i < days.length; i++) {
      getDay(days[i].weekday);
      getDate(days[i].month);
      NumberMunth = days[i].toString().split("-").last.split(" ").first;
      dateFreeCurrent = days[i].toIso8601String().split("T").first +
          " - " +
          NameDay +
          " , " +
          NumberMunth +
          " " +
          NameMonth +
          " " +
          days[i].year.toString();

      print("'קכ'קכק'כ" + dateFreeCurrent.toString());

      if (event.snapshot.hasChild(dateFreeCurrent)) {
        for (int j = 0;
            j < event.snapshot.child(dateFreeCurrent).children.length;
            j++) {
          int currentTimeEnd = int.parse(event.snapshot
              .child(dateFreeCurrent)
              .children
              .elementAt(j)
              .key
              .toString()
              .split(",")
              .last);
          int currentTimeStart = int.parse(event.snapshot
              .child(dateFreeCurrent)
              .children
              .elementAt(j)
              .key
              .toString()
              .split(",")
              .first);
          String start = event.snapshot
              .child(dateFreeCurrent)
              .children
              .elementAt(j)
              .child("התחלה")
              .value
              .toString();
          String end = event.snapshot
              .child(dateFreeCurrent)
              .children
              .elementAt(j)
              .child("סיום")
              .value
              .toString();
          String name = event.snapshot
              .child(dateFreeCurrent)
              .children
              .elementAt(j)
              .child("שם")
              .value
              .toString();
          String phone = event.snapshot
              .child(dateFreeCurrent)
              .children
              .elementAt(j)
              .child("פלאפון")
              .value
              .toString();
          print("ewewfwef2 = " + name.toString());
          if ((name == "חופשה")) {
            if (listDataMeet.length > 0) {
              if (listDataMeet[listDataMeet.length - 1].name.toString() ==
                  "חופשה") {
              } else {
                listDataMeet.add(
                    new dataMeet(start, end, phone, name, dateFreeCurrent));
              }
            } else {
              listDataMeet
                  .add(new dataMeet(start, end, phone, name, dateFreeCurrent));
            }
          } else {
            listDataMeet
                .add(new dataMeet(start, end, phone, name, dateFreeCurrent));
          }
        }
      }
      print(event.snapshot.hasChild(dateFreeCurrent));
    }
    if (listDataMeet.isNotEmpty) {
      _showMyDialogFullList();
      print(listDataMeet.first.name);
    } else {
      _showMyDialogEmptyList();
      print("not have");
    }
  }

  Future<void> _showMyDialogFullList() async {
    String codeClick = "";
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (context) {
        return AlertDialog(
          contentPadding: EdgeInsets.only(left: 25, right: 25),
          title: Text(
            style: TextStyle(
              //backgroundColor: Color.fromARGB(255, 178, 175, 175),
              color: Color.fromARGB(255, 53, 52, 52),
              fontWeight: FontWeight.bold,
              fontSize: 14.0,
            ),
            // ignore: prefer_interpolation_to_compose_strings
            // ignore: prefer_interpolation_to_compose_strings
            "התורים שנקבעו בזמן החופשה \n* החלק לצד למחוק תור ",
            textAlign: TextAlign.right,
            textDirection: TextDirection.rtl,
          ),
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(5.0))),
          content: SingleChildScrollView(
              child: Container(
            width: 300,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                SizedBox(
                  height: 20,
                ),
                ConstrainedBox(
                  constraints: BoxConstraints(
                    maxHeight: MediaQuery.of(context).size.height * 0.4,
                  ),
                  child: ListView.separated(
                    shrinkWrap: true,
                    itemCount: listDataMeet.length,
                    itemBuilder: (BuildContext context, int index) {
                      return Dismissible(
                          key: Key(listDataMeet[index].toString()),
                          background: Container(
                            color: Colors.red,
                          ),
                          onDismissed: (direction) {},
                          confirmDismiss: (DismissDirection direction) async {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: Text(
                                    "מחיקת תור",
                                    textDirection: TextDirection.rtl,
                                  ),
                                  content: Container(
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: <Widget>[
                                        Text(
                                          "בטוח שברצונך למחוק את התור ?",
                                          textDirection: TextDirection.rtl,
                                        ),
                                        SizedBox(
                                          height: 10,
                                        ),
                                        Text(
                                          "* מומלץ לעדכן את הלקוח לפני המחיקה ",
                                          style: TextStyle(fontSize: 13),
                                          textDirection: TextDirection.rtl,
                                        ),
                                        listDataMeet[index].name == "חופשה"
                                            ? Text(
                                                "* כל החופשה תמחק",
                                                style: TextStyle(fontSize: 13),
                                                textDirection:
                                                    TextDirection.rtl,
                                              )
                                            : Text(""),
                                      ],
                                    ),
                                  ),
                                  actions: <Widget>[
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        TextButton(
                                          child: const Text("לא"),
                                          onPressed: () {
                                            Navigator.of(context).pop(false);
                                          },
                                        ),
                                        TextButton(
                                          child: const Text("כן"),
                                          onPressed: () async {
                                            Navigator.of(context).pop(false);
                                            setState(() {
                                              listDataMeet;
                                              print(index);
                                            });
                                            if (listDataMeet[index].name !=
                                                "חופשה") {
                                              String phone = listDataMeet[index]
                                                  .phone
                                                  .toString();
                                              String dateCurrent =
                                                  listDataMeet[index]
                                                      .data
                                                      .toString();

                                              DatabaseReference ref1 =
                                                  FirebaseDatabase.instance
                                                      .ref(
                                                          "$nameClient/תורים/כללי/$dateCurrent" +
                                                              "/" +
                                                              listDataMeet[
                                                                      index]
                                                                  .start
                                                                  .toString() +
                                                              "," +
                                                              listDataMeet[
                                                                      index]
                                                                  .end
                                                                  .toString() +
                                                              " | " +
                                                              give1);

                                              DatabaseReference ref =
                                                  FirebaseDatabase.instance.ref(
                                                      "$nameClient/תורים/עובדים/$give1/$dateCurrent" +
                                                          "/" +
                                                          listDataMeet[index]
                                                              .start
                                                              .toString() +
                                                          "," +
                                                          listDataMeet[index]
                                                              .end
                                                              .toString());
                                              await ref1.remove();
                                              await ref.remove();

                                              DatabaseReference ref111 =
                                                  FirebaseDatabase.instance.ref(
                                                      "$nameClient/לקוחות/$phone/תורים" +
                                                          "/" +
                                                          dateCurrent +
                                                          "/" +
                                                          listDataMeet[index]
                                                              .start
                                                              .toString() +
                                                          "," +
                                                          listDataMeet[index]
                                                              .end
                                                              .toString());
                                              ref111.remove();

                                              if (listDataMeet[index].name !=
                                                  "חופשה") {
                                                remove(index);
                                              }
                                            } else {
                                              daysRemove.clear();
                                              DateTime start = DateTime.utc(
                                                  int.parse(listDataMeet[index]
                                                      .start!
                                                      .split("/")
                                                      .last),
                                                  int.parse(listDataMeet[index]
                                                      .start!
                                                      .split("/")[1]),
                                                  int.parse(listDataMeet[index]
                                                      .start!
                                                      .split("/")
                                                      .first));
                                              DateTime end = DateTime.utc(
                                                  int.parse(listDataMeet[index]
                                                      .end!
                                                      .split("/")
                                                      .last),
                                                  int.parse(listDataMeet[index]
                                                      .end!
                                                      .split("/")[1]),
                                                  int.parse(listDataMeet[index]
                                                      .end!
                                                      .split("/")
                                                      .first));

                                              for (int i = 0;
                                                  i <=
                                                      end
                                                          .difference(start)
                                                          .inDays;
                                                  i++) {
                                                daysRemove.add(start
                                                    .add(Duration(days: i)));
                                              }

                                              for (int i = 0;
                                                  i <= daysRemove.length;
                                                  i++) {
                                                getDay(daysRemove[i].weekday);
                                                getDate(daysRemove[i].month);

                                                NumberMunth = daysRemove[i]
                                                    .toString()
                                                    .split("-")
                                                    .last
                                                    .split(" ")
                                                    .first;
                                                dateFreeCurrent = daysRemove[i]
                                                        .toIso8601String()
                                                        .split("T")
                                                        .first +
                                                    " - " +
                                                    NameDay +
                                                    " , " +
                                                    NumberMunth +
                                                    " " +
                                                    NameMonth +
                                                    " " +
                                                    daysRemove[i]
                                                        .year
                                                        .toString();

                                                DatabaseReference ref1 =
                                                    FirebaseDatabase.instance.ref(
                                                        "$nameClient/תורים/כללי" +
                                                            "/" +
                                                            dateFreeCurrent +
                                                            "/" +
                                                            "0500" +
                                                            "," +
                                                            "2355" +
                                                            " | " +
                                                            give1);
                                                print("rwrwrr-- " +
                                                    "$nameClient/תורים/כללי" +
                                                    "/" +
                                                    dateFreeCurrent +
                                                    "/" +
                                                    "0500" +
                                                    "," +
                                                    "2300" +
                                                    " | " +
                                                    give1);
                                                DatabaseReference ref =
                                                    FirebaseDatabase.instance.ref(
                                                        "$nameClient/תורים/עובדים/$give1" +
                                                            "/" +
                                                            dateFreeCurrent +
                                                            "/" +
                                                            "0500" +
                                                            "," +
                                                            "2355");
                                                await ref1.remove();

                                                await ref.remove();
                                                if (listDataMeet.length > i &&
                                                    listDataMeet[i].name ==
                                                        "חופשה") {
                                                  remove(index);
                                                }
                                              }
                                            }
                                            //remove(index);
                                          },
                                        ),
                                      ],
                                    )
                                  ],
                                );
                              },
                            );
                          },
                          child: buildListTor(index));
                    },
                    separatorBuilder: (context, index) {
                      return Divider(
                        height: 10,
                        thickness: 1,
                      );
                    },
                  ),
                )
              ],
            ),
          )),
          actions: <Widget>[
            TextButton(
              child: const Text('ביטול'),
              onPressed: () {
                listDataMeet.clear();
                Navigator.of(context).pop();
              },
            ),
            // TextButton(
            //   child: const Text("קבע הפסקה"),
            //   onPressed: () {},
            // ),
          ],
        );
      },
    );
  }

  Widget buildListTor(int index) {
    return ListTile(
      title: Text(
        listDataMeet[index].name.toString(),
        textDirection: TextDirection.rtl,
        textAlign: TextAlign.right,
        textScaleFactor: 1.2,
      ),
      subtitle: listDataMeet[index].name != "חופשה"
          ? Text(
              listDataMeet[index].start!.substring(0, 2) +
                  ":" +
                  listDataMeet[index].start!.substring(2, 4) +
                  " - " +
                  listDataMeet[index].end!.substring(0, 2) +
                  ":" +
                  listDataMeet[index].end!.substring(2, 4) +
                  "\n" +
                  listDataMeet[index].data.toString().split(" - ").last,
              textDirection: TextDirection.rtl,
              textAlign: TextAlign.right,
            )
          : Text(
              listDataMeet[index].end.toString() +
                  " - " +
                  listDataMeet[index].start.toString(),

              // listDataMeet[index].data.toString(),
              textDirection: TextDirection.ltr,
              textAlign: TextAlign.right,
            ),
      leading: listDataMeet[index].name != "חופשה" &&
              listDataMeet[index].name != "הפסקה"
          ? IconButton(
              icon: const Icon(
                Icons.phone,
                size: 30,
                color: Color.fromARGB(255, 56, 171, 228),
              ),
              onPressed: () async {
                callPhone(listDataMeet[index].phone.toString());
              },
            )
          : Text(""),
    );
  }

  Future<void> _showMyDialogEmptyList() async {
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
            "אין תורים בימים האלה - ניתן לקבוע חופשה",
            textAlign: TextAlign.right,
          ),
          content: SingleChildScrollView(
              child: ListBody(
            children: <Widget>[
              Container(
                //height: 300.0, // Change as per your requirement
                width: 300.0, // Change as per your requirement
                child: Text(
                  "התחלת חופשה - " +
                      rangeStart.day.toString() +
                      "/" +
                      rangeStart.month.toString() +
                      "/" +
                      rangeStart.year.toString(),
                  textAlign: TextAlign.right,
                ),
              ),
              Container(
                //height: 300.0, // Change as per your requirement
                width: 300.0, // Change as per your requirement
                child: Text(
                  "סיום חופשה - " +
                      rangeEnd.day.toString() +
                      "/" +
                      rangeEnd.month.toString() +
                      "/" +
                      rangeEnd.year.toString(),
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
                    listDataMeet.clear();
                    Navigator.of(context).pop();
                  },
                ),
                TextButton(
                  child: const Text("קבע חופשה"),
                  onPressed: () {
                    // ignore: avoid_single_cascade_in_expression_statements
                    for (int i = 0; i < days.length; i++) {
                      getDay(days[i].weekday);
                      getDate(days[i].month);
                      NumberMunth =
                          days[i].toString().split("-").last.split(" ").first;
                      print(days[i]);
                      //ignore: avoid_single_cascade_in_expression_statements
                      refM
                        ..child(nameClient)
                            .child("תורים")
                            .child("עובדים")
                            .child(give1)
                            .child(days[i].toIso8601String().split("T").first +
                                " - " +
                                NameDay +
                                " , " +
                                NumberMunth +
                                " " +
                                NameMonth +
                                " " +
                                days[i].year.toString())
                            .child("0500" + "," + "2355")
                            .update({
                          "שם": "חופשה",
                          "פלאפון": "",
                          "התחלה": rangeStart.day.toString() +
                              "/" +
                              rangeStart.month.toString() +
                              "/" +
                              rangeStart.year.toString(),
                          "סיום": rangeEnd.day.toString() +
                              "/" +
                              rangeEnd.month.toString() +
                              "/" +
                              rangeEnd.year.toString(),
                          "טיפול": "",
                          "שירות": give1,
                          "מחיר": "0",
                          "זמן": days.length
                        });
                      refM
                        ..child(nameClient)
                            .child("תורים")
                            .child("כללי")
                            .child(days[i].toIso8601String().split("T").first +
                                " - " +
                                NameDay +
                                " , " +
                                NumberMunth +
                                " " +
                                NameMonth +
                                " " +
                                days[i].year.toString())
                            .child("0500" + "," + "2355" + " | " + give1)
                            .update({
                          "שם": "חופשה",
                          "פלאפון": "",
                          "התחלה": rangeStart.day.toString() +
                              "/" +
                              rangeStart.month.toString() +
                              "/" +
                              rangeStart.year.toString(),
                          "סיום": rangeEnd.day.toString() +
                              "/" +
                              rangeEnd.month.toString() +
                              "/" +
                              rangeEnd.year.toString(),
                          "טיפול": "",
                          "שירות": give1,
                          "מחיר": "0",
                          "זמן": days.length
                        }).then((value) {
                          if (i == days.length - 1) {
                            showelrat();
                          }
                        });
                    }

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
        "החופשה נקבעה בהצלחה",
        textAlign: TextAlign.right,
      ),
    ));
  }

  remove(int index) {
    if (listDataMeet.isNotEmpty) {
      setState(() {
        listDataMeet.removeAt(index);
      });
      print("jjj " + listDataMeet.toString());
      Navigator.of(context).pop();
      _showMyDialogFullList();
      if (listDataMeet.isEmpty) {
        Navigator.of(context).pop();
        _showMyDialogEmptyList();
      }
    }
  }

  Future<void> callPhone(String numberPhone) async {
    String url = 'tel:' + numberPhone;
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
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

  getDateForDate(int month) {
    switch (month) {
      case 1:
        setState(() {
          NameMonthForDate = "ינואר";
        });
        break;
      case 2:
        setState(() {
          NameMonthForDate = "פבואר";
        });
        break;
      case 3:
        setState(() {
          NameMonth = "מרץ";
          NameMonthForDate = "מרץ";
        });
        break;
      case 4:
        setState(() {
          NameMonthForDate = "אפריל";
        });
        break;
      case 5:
        setState(() {
          NameMonthForDate = "מאי";
        });
        break;
      case 6:
        setState(() {
          NameMonthForDate = "יוני";
        });
        break;
      case 7:
        setState(() {
          NameMonth = "יולי";
          NameMonthForDate = "יולי";
        });
        break;
      case 8:
        setState(() {
          NameMonthForDate = "אוגוסט";
        });
        break;
      case 9:
        setState(() {
          NameMonthForDate = "ספטמבר";
        });
        break;
      case 10:
        setState(() {
          NameMonthForDate = "אוקטובר";
        });
        break;
      case 11:
        setState(() {
          NameMonthForDate = "נובמבר";
        });
        break;
      case 12:
        setState(() {
          NameMonthForDate = "דצמבר";
        });
        break;
    }
  }
}
