// ignore_for_file: prefer_const_constructors, sized_box_for_whitespace, prefer_interpolation_to_compose_strings, unrelated_type_equality_checks, unnecessary_new, unused_element, non_constant_identifier_names

import 'dart:async';
import 'dart:convert';
import 'dart:math' as math;
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_clean_calendar/date_utils.dart';
//import 'package:my_tor/adminMenu.dart';
import 'package:my_tor/tableTor/tableSendTor.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:date_picker_timeline/date_picker_timeline.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

class times extends StatefulWidget {
  final myControllerImage = TextEditingController();
  final String nameClient;

  times({Key? key, required this.nameClient}) : super(key: key);

  @override
  State<times> createState() => _list(nameClient);
}

class _list extends State<times> {
  List<timeMeet> listtimeMeet = [];
  List<timeMeet> listTimeStartEnd = [];
  String nameClient;
  _list(this.nameClient);
  int currentStep = 0;
  List<String> listGiveService = [];
  int? selectedIndex;
  DateTime today = DateTime.now();
  DateTime todayFirst = DateTime.now();
  int hours = 1000,
      distans = 30,
      min = 0,
      startWork = 0,
      startWorkMin = 00,
      endWork = 20,
      endWorkMin = 00;
  DatabaseReference refM = FirebaseDatabase.instance.ref();
  final scrollDirection = Axis.vertical;
  static const double maxHeight = 1000;
  bool isFreeTime = false, isFullBook = false, firestApp = true;
  String NameDay = "",
      NumberMunth = "",
      NameMonth = "",
      NameMonthForDate = "",
      year = "",
      dateLast = "";
  int countMoth = 0,
      numYear = 0,
      numMonth = 0,
      numDay = 0,
      countDay = 14,
      numberDayGetData = 0;
  int sumMoth = 0, ifShabatDay = 0;
  int counterMeet = 0;
  String mess = "", give = "null";
  late DateTime focuse = DateTime.now();
  bool more = false;
  String dateNow = "", numberL = "";
  // ignore: prefer_final_fields
  final ScrollController _scrollController = ScrollController();
  List<StartEndWork> listStartEndWork = [];

  Widget build(BuildContext context) {
    return Container(
        child: Column(
      // ignore: prefer_const_literals_to_create_immutables
      children: [
        // ignore: prefer_const_constructors
        ConstrainedBox(
          constraints: BoxConstraints(minHeight: 50, maxWidth: 600),
          child: nameStep(),
        ),
        ConstrainedBox(
          constraints: BoxConstraints(minHeight: 50, maxWidth: 600),
          child: Divider(
            height: 40,
            thickness: 3,
          ),
        ),
        ConstrainedBox(
          constraints: BoxConstraints(minHeight: 50, maxWidth: 530),
          child: _getDate(),
        ),

        // ignore: prefer_const_constructors
        SizedBox(
          width: 560,
          child: Divider(
            height: 20,
            thickness: 2,
          ),
        ),

        SizedBox(height: 10),
        Text(NameDay + " , " + NumberMunth + " " + NameMonth + " " + year,
            style: TextStyle(
              color: Color.fromARGB(255, 0, 0, 0),
              fontWeight: FontWeight.bold,
              fontSize: 17.0,
            )),
        SizedBox(height: 5),
        SizedBox(
          width: 480,
          child: Divider(
            endIndent: 40,
            indent: 40,
            height: 20,
            thickness: 2,
          ),
        ),

        SizedBox(height: 15),
        // ignore: prefer_const_literals_to_create_immutables

        ConstrainedBox(
          constraints: BoxConstraints(minHeight: 50, maxWidth: 400),
          child: Container(
              //margin: EdgeInsets.only(left: 20, right: 20),
              decoration:
                  ifShabatDay != 6 && isFreeTime != true && isFullBook != true
                      ? BoxDecoration(
                          border: Border.all(
                            color: Color.fromARGB(255, 179, 178, 178),
                          ),
                          borderRadius: BorderRadius.all(Radius.circular(4)))
                      : BoxDecoration(),
              padding: EdgeInsets.all(5),
              child: Column(
                children: [
                  _show1(),
                  SizedBox(
                    height: 10,
                  ),
                  ifShabatDay != 6 &&
                          more != true &&
                          isFullBook != true &&
                          listtimeMeet.length > 9
                      ? ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              primary: Color.fromARGB(255, 41, 42, 43),
                              elevation: 3,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10.0)),
                              minimumSize: Size(250, 40),
                              textStyle: const TextStyle(fontSize: 18)),
                          child: Text("הצג תורים נוספים  +"),
                          onPressed: () {
                            setState(() {
                              more = true;
                            });
                          },
                        )
                      : Visibility(visible: false, child: Text("")),
                  SizedBox(
                    height: 10,
                  ),
                ],
              )),
        ),

        // ignore: prefer_const_constructors
      ],
    ));
  }

  //שעה ותאריך של התור הנבחר
  setPrefDataUser(String date, String start, String end) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString("userDate", date).toString();
    prefs.setString("userStart", start).toString();
    prefs.setString("userEnd", end).toString();
  }

  //תאריך בעברית
  setDateHebro(String date) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString("dateHebro", date).toString();
  }

  //משך זמן טיפול דיסטנס
  getTypeTime() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (distans != prefs.getInt("DistansTime") && distans != "null") {
      listtimeMeet.clear();
    }
    setState(() {
      print("dis " + prefs.getInt("DistansTime").toString());
      if (prefs.getInt("DistansTime").toString() != "null") {
        distans = prefs.getInt("DistansTime")!;
      }
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    DateTime now = new DateTime.now();
    DateTime day1 = new DateTime(now.year, now.month, now.day);
    getTypeTime();
    print("nameeee " + nameClient);
    setState(() {
      getDay(day1.weekday);
      getDate(day1.month);
      ifShabatDay = day1.weekday;
      getDateForDate(day1.month);
      NumberMunth = now.toString().split("-").last.split(" ").first;
      dateNow = day1.toIso8601String().split("T").first +
          " - " +
          NameDay +
          " , " +
          NumberMunth +
          " " +
          NameMonth +
          " " +
          now.year.toString();

      countMoth = 0;
      sumMoth = 0;
      numYear = now.year;
      numMonth = now.month;
      numDay = now.day;
      NumberMunth = day1.toString().split("-").last.split(" ").first;
      year = day1.year.toString();
      setDateHebro(
          NameDay + " , " + NumberMunth + " " + NameMonth + " " + year);
      getDataStartEndHores();
      //getTimesUser();
    });
    super.initState();
  }

  Future<List<StartEndWork>> getCategoryData() async {
    final prefsStartEndWork = await SharedPreferences.getInstance();
    final category = prefsStartEndWork.getString("listStartEndWork");
    listStartEndWork = List<StartEndWork>.from(
        List<Map<String, dynamic>>.from(jsonDecode(category.toString()))
            .map((e) => StartEndWork.fromJson(e))
            .toList());

    return listStartEndWork;
  }

  Future<List<StartEndWork>> getDataStartEndHores() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    give = prefs.getString("userGiveService").toString();
    print("nameeee " + "$nameClient/פעילות/$give");
    DatabaseReference starCountRef =
        FirebaseDatabase.instance.ref("$nameClient/פעילות/$give");

    starCountRef.onValue.listen((DatabaseEvent event) async {
      if (listStartEndWork.isNotEmpty) {
        listStartEndWork.clear();
      }
      if (event.snapshot.exists) {
        for (int i = 0; i < event.snapshot.children.length; i++) {
          setState(() {
            listStartEndWork.add(new StartEndWork(
              event.snapshot.children
                  .elementAt(i)
                  .key
                  .toString()
                  .split(",")
                  .last,
              event.snapshot.children
                  .elementAt(i)
                  .child("התחלה")
                  .value
                  .toString(),
              event.snapshot.children
                  .elementAt(i)
                  .child("סיום")
                  .value
                  .toString(),
            ));
          });
        }
        listStartEndWork.add(new StartEndWork(
          "יום שבת",
          "09:00",
          "23:55",
        ));
        setState(() {
          print("sdsd22gg " + numberDayGetData.toString());

          startWork = listStartEndWork[numberDayGetData]
                      .start
                      .split(":")
                      .first ==
                  " סגור "
              ? 9999
              : int.parse(
                  listStartEndWork[numberDayGetData].start.split(":").first);

          startWorkMin =
              listStartEndWork[numberDayGetData].start.split(":").last ==
                      " סגור "
                  ? 9999
                  : int.parse(
                      listStartEndWork[numberDayGetData].start.split(":").last);

          endWork = listStartEndWork[numberDayGetData].end.split(":").first ==
                  " סגור "
              ? 9999
              : int.parse(
                  listStartEndWork[numberDayGetData].end.split(":").first);

          endWorkMin =
              listStartEndWork[numberDayGetData].end.split(":").last == " סגור "
                  ? 9999
                  : int.parse(
                      listStartEndWork[numberDayGetData].end.split(":").last);
        });
      }
      getTimesUser();

      print("sdsd22r " + event.snapshot.children.length.toString());
    });
    return listStartEndWork;
  }

  //מכין רשימת שעות תורים
  Iterable<TimeOfDay> getTimeSlots1(
      TimeOfDay startTime, TimeOfDay endTime, Duration interval) sync* {
    var hour = startTime.hour;
    var minute = startTime.minute;
    var endH = endTime.hour;
    var endM = endTime.minute;

    do {
      yield TimeOfDay(hour: hour, minute: minute);
      minute += interval.inMinutes;
      while (minute >= 60) {
        minute -= 60;
        hour++;
      }
    } while (hour < endTime.hour ||
        (hour == endTime.hour && minute <= endTime.minute));
  }

  //מביא את הרשימה שעות תורים
  Future<List<timeMeet>> getTimesUser() async {
    DateTime now = DateTime.now();
    DateTime dayNow = DateTime(now.year, now.month, now.day);
    int year = int.parse(dateNow.split(" - ").first.split("-")[0]);
    int month = int.parse(dateNow.split(" - ").first.split("-")[1]);
    int day = int.parse(dateNow.split(" - ").first.split("-")[2]);
    DateTime dayClick = DateTime(year, month, day);
    String minut = now.minute.toString() == "0"
        ? "00"
        : now.minute < 10
            ? "0" + now.minute.toString()
            : now.minute.toString();
    String nowTime = now.hour.toString() + minut.toString();

    //String dateNow = date;
    if (listTimeStartEnd.isNotEmpty) {
      setState(() {
        listTimeStartEnd.clear();
      });
    }
    if (ifShabatDay != 6 && startWork != 9999) {
      DatabaseReference refM = FirebaseDatabase.instance.ref();
      final event = await refM
          .child("$nameClient")
          .child("תורים")
          .child("עובדים")
          .child(give)
          .once(DatabaseEventType.value);
      if (event.snapshot.child(dateNow).children.isNotEmpty) {
        if (listTimeStartEnd.isEmpty) {
          for (int i = 0;
              i < event.snapshot.child(dateNow).children.length;
              i++) {
            //בודק אם היום שנבחר זה יום חופש
            if (event.snapshot
                    .child(dateNow)
                    .children
                    .elementAt(i)
                    .child("שם")
                    .value
                    .toString() ==
                "חופשה") {
              setState(() {
                isFreeTime = true;
                mess = "העסק סגור היום , ניתן לבחור יום אחר";
              });
            }

            listTimeStartEnd.add(new timeMeet(
                event.snapshot
                    .child(dateNow)
                    .children
                    .elementAt(i)
                    .key
                    .toString()
                    .split(",")
                    .first,
                event.snapshot
                    .child(dateNow)
                    .children
                    .elementAt(i)
                    .key
                    .toString()
                    .split(",")
                    .last));
          }
        }
        // מעדכן את נתוני השעות
        if (listtimeMeet.isEmpty) {
          setState(() {
            startWork = listStartEndWork[numberDayGetData]
                        .start
                        .split(":")
                        .first ==
                    " סגור "
                ? 9999
                : int.parse(
                    listStartEndWork[numberDayGetData].start.split(":").first);

            startWorkMin = listStartEndWork[numberDayGetData]
                        .start
                        .split(":")
                        .last ==
                    " סגור "
                ? 9999
                : int.parse(
                    listStartEndWork[numberDayGetData].start.split(":").last);
            endWork =
                int.parse(listTimeStartEnd[0].start.toString().substring(0, 2));
            endWorkMin =
                int.parse(listTimeStartEnd[0].start.toString().substring(2, 4));
          });
        }

        do {
          final startTime = TimeOfDay(hour: startWork, minute: startWorkMin);
          final endTime = TimeOfDay(hour: endWork, minute: endWorkMin);
          final interval = Duration(minutes: distans);
          var times = getTimeSlots1(startTime, endTime, interval).toList();

          for (int i = 0; i < times.length - 1; i++) {
            if (dayNow.isAtSameMomentAs(dayClick)) {
              if (int.parse((times[i].hour.toString().length.toString() == "1"
                          ? "0" + times[i].hour.toString()
                          : times[i].hour.toString()) +
                      (times[i].minute.toString() == "0"
                          ? "00"
                          : times[i].minute > 0 && times[i].minute < 10
                              ? "0" + times[i].minute.toString()
                              : times[i].minute.toString())) >
                  int.parse(nowTime)) {
                listtimeMeet.add(new timeMeet(
                  (times[i].hour.toString().length.toString() == "1"
                          ? "0" + times[i].hour.toString()
                          : times[i].hour.toString()) +
                      ":" +
                      (times[i].minute.toString() == "0"
                          ? "00"
                          : times[i].minute > 0 && times[i].minute < 10
                              ? "0" + times[i].minute.toString()
                              : times[i].minute.toString()),
                  (times[i + 1].hour.toString().length.toString() == "1"
                          ? "0" + times[i + 1].hour.toString()
                          : times[i + 1].hour.toString()) +
                      ":" +
                      (times[i + 1].minute.toString() == "0"
                          ? "00"
                          : times[i + 1].minute > 0 && times[i + 1].minute < 10
                              ? "0" + times[i + 1].minute.toString()
                              : times[i + 1].minute.toString()),
                ));
              }     else {

                if(( int.parse(nowTime) > int.parse(( (endWork.toString().length.toString() == "1"
                          ? "0" + endWork.toString()
                          : endWork.toString()) + 
                           (endWorkMin.toString().length.toString() == "1"
                          ? "0" + endWorkMin.toString()
                          : endWorkMin.toString())
                          
                          )) )){
                  print("qfff222ww7 -" + ( int.parse(nowTime) ).toString() );
                  setState(() {
                  isFullBook = true;
                  mess = "מצטערים , לא נותרו תורים להיום ניתן לבחור יום אחר";
                });
                  
                }
   
                
              }
            } else {
              listtimeMeet.add(new timeMeet(
                (times[i].hour.toString().length.toString() == "1"
                        ? "0" + times[i].hour.toString()
                        : times[i].hour.toString()) +
                    ":" +
                    (times[i].minute.toString() == "0"
                        ? "00"
                        : times[i].minute > 0 && times[i].minute < 10
                            ? "0" + times[i].minute.toString()
                            : times[i].minute.toString()),
                (times[i + 1].hour.toString().length.toString() == "1"
                        ? "0" + times[i + 1].hour.toString()
                        : times[i + 1].hour.toString()) +
                    ":" +
                    (times[i + 1].minute.toString() == "0"
                        ? "00"
                        : times[i + 1].minute > 0 && times[i + 1].minute < 10
                            ? "0" + times[i + 1].minute.toString()
                            : times[i + 1].minute.toString()),
              ));
            }
          }

          print("feffffs11  = " + listtimeMeet.isEmpty.toString());
          //אם  לא נותר מקום לאותו יום
          if (listtimeMeet.isEmpty && isFreeTime == false ) {
            print("feffffs11  = " + listtimeMeet.isEmpty.toString());

            setState(() {
              isFullBook = true;
              mess = "מצטערים , לא נותרו תורים להיום ניתן לבחור יום אחר";
            });
          } else {
            setState(() {
              isFullBook = false;
            });
          }

          setState(() {
            startWork = int.parse(
                listTimeStartEnd[counterMeet].end.toString().substring(0, 2));
            startWorkMin = int.parse(
                listTimeStartEnd[counterMeet].end.toString().substring(2, 4));
            counterMeet++;
            if (counterMeet < listTimeStartEnd.length) {
              endWork = int.parse(listTimeStartEnd[counterMeet]
                  .start
                  .toString()
                  .substring(0, 2));
              endWorkMin = int.parse(listTimeStartEnd[counterMeet]
                  .start
                  .toString()
                  .substring(2, 4));
            } else {
              endWork = listStartEndWork[numberDayGetData]
                          .end
                          .split(":")
                          .first ==
                      " סגור "
                  ? 9999
                  : int.parse(
                      listStartEndWork[numberDayGetData].end.split(":").first);

              endWorkMin = listStartEndWork[numberDayGetData]
                          .end
                          .split(":")
                          .last ==
                      " סגור "
                  ? 9999
                  : int.parse(
                      listStartEndWork[numberDayGetData].end.split(":").last);
            }
          });
        } while (endWork <=
            int.parse(listStartEndWork[numberDayGetData].end.split(":").first));

        print("feffffs112  = ");
      }
      //אם אין שעות תורים בשרת
      else {
        setState(() {
          listtimeMeet.clear();
          startWork = listStartEndWork[numberDayGetData]
                      .start
                      .split(":")
                      .first ==
                  " סגור "
              ? 9999
              : int.parse(
                  listStartEndWork[numberDayGetData].start.split(":").first);

          startWorkMin =
              listStartEndWork[numberDayGetData].start.split(":").last ==
                      " סגור "
                  ? 9999
                  : int.parse(
                      listStartEndWork[numberDayGetData].start.split(":").last);

          endWork = listStartEndWork[numberDayGetData].end.split(":").first ==
                  " סגור "
              ? 9999
              : int.parse(
                  listStartEndWork[numberDayGetData].end.split(":").first);

          endWorkMin =
              listStartEndWork[numberDayGetData].end.split(":").last == " סגור "
                  ? 9999
                  : int.parse(
                      listStartEndWork[numberDayGetData].end.split(":").last);
        });
        final startTime = TimeOfDay(hour: startWork, minute: startWorkMin);
        final endTime = TimeOfDay(hour: endWork, minute: endWorkMin);
        final interval = Duration(minutes: distans);
        var hour = startTime.hour;
        var minute = startTime.minute;
        var times = getTimeSlots1(startTime, endTime, interval).toList();
        if (endWork <=
            int.parse(
                listStartEndWork[numberDayGetData].end.split(":").first)) {
          for (int i = 0; i < times.length - 1; i++) {
            if (dayNow.isAtSameMomentAs(dayClick)) {
              if (int.parse((times[i].hour.toString().length.toString() == "1"
                          ? "0" + times[i].hour.toString()
                          : times[i].hour.toString()) +
                      (times[i].minute.toString() == "0"
                          ? "00"
                          : times[i].minute > 0 && times[i].minute < 10
                              ? "0" + times[i].minute.toString()
                              : times[i].minute.toString())) >
                  int.parse(nowTime)) {
                listtimeMeet.add(new timeMeet(
                  (times[i].hour.toString().length.toString() == "1"
                          ? "0" + times[i].hour.toString()
                          : times[i].hour.toString()) +
                      ":" +
                      (times[i].minute.toString() == "0"
                          ? "00"
                          : times[i].minute > 0 && times[i].minute < 10
                              ? "0" + times[i].minute.toString()
                              : times[i].minute.toString()),
                  (times[i + 1].hour.toString().length.toString() == "1"
                          ? "0" + times[i + 1].hour.toString()
                          : times[i + 1].hour.toString()) +
                      ":" +
                      (times[i + 1].minute.toString() == "0"
                          ? "00"
                          : times[i + 1].minute > 0 && times[i + 1].minute < 10
                              ? "0" + times[i + 1].minute.toString()
                              : times[i + 1].minute.toString()),
                ));
              }

              else {

                if(( int.parse(nowTime) > int.parse(( (endWork.toString().length.toString() == "1"
                          ? "0" + endWork.toString()
                          : endWork.toString()) + 
                           (endWorkMin.toString().length.toString() == "1"
                          ? "0" + endWorkMin.toString()
                          : endWorkMin.toString())
                          
                          )) )){
                  print("qfff222ww7 -" + ( int.parse(nowTime) ).toString() );
                  setState(() {
                  isFullBook = true;
                  mess = "מצטערים , לא נותרו תורים להיום ניתן לבחור יום אחר";
                });
                  
                }
   
                
              }
            } else {
              listtimeMeet.add(new timeMeet(
                (times[i].hour.toString().length.toString() == "1"
                        ? "0" + times[i].hour.toString()
                        : times[i].hour.toString()) +
                    ":" +
                    (times[i].minute.toString() == "0"
                        ? "00"
                        : times[i].minute > 0 && times[i].minute < 10
                            ? "0" + times[i].minute.toString()
                            : times[i].minute.toString()),
                (times[i + 1].hour.toString().length.toString() == "1"
                        ? "0" + times[i + 1].hour.toString()
                        : times[i + 1].hour.toString()) +
                    ":" +
                    (times[i + 1].minute.toString() == "0"
                        ? "00"
                        : times[i + 1].minute > 0 && times[i + 1].minute < 10
                            ? "0" + times[i + 1].minute.toString()
                            : times[i + 1].minute.toString()),
              ));
            }
          }
        }
      }
    }
    //אם יום שבת או סגור
    else {
      setState(() {
        listtimeMeet.clear();
        isFreeTime = true;
        mess = "העסק סגור היום , ניתן לבחור יום אחר";
      });
    }

    return listtimeMeet;
  }

//לחיצה על תאריך חדש והבאת נתונים
  void _onDaySelected(DateTime day, DateTime focusedDay) {
    getDay(day.weekday);
    getDate(day.month);
    if (day.month > numMonth) {
      DateTime now = new DateTime.now();
      var date = new DateTime(now.year, now.month);
      var sumMoth = Utils.lastDayOfMonth(date);
      getTypeTime();
      setState(() {
        if (countMoth < 1) {
          countMoth++;
          numYear = now.year;
          numMonth = now.month;
          NumberMunth = focusedDay.day.toString();
          getDateForDate(numMonth + 1);
          numDay = 1;
          countDay = (int.parse(now.day.toString()) - 1) -
              int.parse(sumMoth.day.toString()) +
              countDay;

          countDay = countDay - 1;
        }
      });
    }
    setState(() {
      more = false;
      listtimeMeet.clear();
      mess = "";
      firestApp = false;
      counterMeet = 0;

      startWork =
          listStartEndWork[numberDayGetData].start.split(":").first == " סגור "
              ? 9999
              : int.parse(
                  listStartEndWork[numberDayGetData].start.split(":").first);

      startWorkMin = listStartEndWork[numberDayGetData].start.split(":").last ==
              " סגור "
          ? 9999
          : int.parse(listStartEndWork[numberDayGetData].start.split(":").last);

      endWork = listStartEndWork[numberDayGetData].end.split(":").first ==
              " סגור "
          ? 9999
          : int.parse(listStartEndWork[numberDayGetData].end.split(":").first);

      endWorkMin = listStartEndWork[numberDayGetData].end.split(":").last ==
              " סגור "
          ? 9999
          : int.parse(listStartEndWork[numberDayGetData].end.split(":").last);

      isFreeTime = false;
      isFullBook = false;
      ifShabatDay = day.weekday;
      NumberMunth = day.toString().split("-").last.split(" ").first;
      year = day.year.toString();
      today = day;
    });
    dateNow = day.toIso8601String().split("T").first +
        " - " +
        NameDay +
        " , " +
        NumberMunth +
        " " +
        NameMonth +
        " " +
        day.year.toString();
    setDateHebro(NameDay + " , " + NumberMunth + " " + NameMonth + " " + year);
    print(" date now now " + dateNow.toString());
    getTimesUser();
  }

  //כותרת ותמונה של השלב
  nameStep() {
    return Row(
      children: <Widget>[
        SizedBox(width: 15),
        Container(
          //margin: EdgeInsets.all(20),
          width: 55,
          height: 55,
          // ignore: prefer_const_constructors
          child: ClipRRect(
            borderRadius: BorderRadius.circular(50.0),
            child: Image.asset(
              "assets/date.jpg",
              width: 110.0,
              height: 110.0,
              fit: BoxFit.fill,
            ),
          ),
        ),
        SizedBox(width: 15),
        // ignore: prefer_const_constructors
        Text("בחר שעה ותאריך",
            // ignore: prefer_const_constructors
            style: TextStyle(
              color: Color.fromARGB(255, 0, 0, 0),
              fontWeight: FontWeight.bold,
              fontSize: 27.0,
            ))
      ],
    );
  }

  //לוח השנה
  _getDate() {
    return Container(
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

                                // var i = int.parse(now.day.toString()) -
                                //     1 -
                                //     int.parse(sumMoth.toString()) +
                                //     countDay;

                                // print(" date now now " +
                                //     (int.parse(now.day.toString()) - 1)
                                //         .toString());

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
                                  print(" date now now " + "ss");
                                  setState(() {
                                    if (countMoth < 1) {
                                      countMoth++;
                                      numYear = now.year;
                                      numMonth = now.month;
                                      getDateForDate(numMonth + 1);
                                      numDay = 1;
                                      countDay =
                                          (int.parse(now.day.toString()) - 1) -
                                              int.parse(
                                                  sumMoth.day.toString()) +
                                              countDay;
                                      print(" date now now " +
                                          countDay.toString());
                                      countDay = countDay - 1;
                                    }
                                  });
                                }
                                if (now.month == 12) {
                                  getDate(1);
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
                                  if (countMoth == 1) {
                                    countMoth--;
                                    numYear = now.year;
                                    numMonth = now.month;
                                    getDateForDate(numMonth);
                                    numDay = now.day;
                                    countDay = 14;
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
                    //width: 350,
                    margin: EdgeInsets.only(left: 5, right: 5 ,bottom: 10),
                    //padding: EdgeInsets.all(5),
                    child: Directionality(
                      textDirection: TextDirection.rtl,
                      child: TableCalendar(
                        headerVisible: false,
                        locale: "he_IL",
                        rowHeight: 35,
                        focusedDay:
                            DateTime.utc(numYear, numMonth + countMoth, numDay),
                        //availableCalendarFormats: const {CalendarFormat.twoWeeks : '2 weeks'},
                        headerStyle: HeaderStyle(
                            formatButtonVisible: false, titleCentered: false),
                        availableGestures: AvailableGestures.all,
                        selectedDayPredicate: ((day) => isSameDay(day, today)),
                        firstDay:
                            DateTime.utc(numYear, numMonth + countMoth, numDay),
                        lastDay: DateTime.utc(
                            numYear, numMonth + countMoth, numDay + countDay),
                        onDaySelected: _onDaySelected,
                      ),
                    ))
              ],
            )));
  }

  //מציג תוצאות שעות פנויות
  _show1() {
    return FutureBuilder(
        // future: getTimesUser(),
        builder: (context, snapshot) {
      if (listtimeMeet.isNotEmpty) {
        return Container(
            width: 390,
            // ignore: prefer_const_constructors
            child: LimitedBox(
                maxHeight: more == true ? double.infinity : 210,
                // ignore: unnecessary_new
                child: listtimeMeet.isNotEmpty &&
                            isFreeTime == false &&
                            ifShabatDay != 6 ||
                        firestApp == true
                    ? GridView.builder(
                        controller: _scrollController,
                        scrollDirection: Axis.vertical,
                        //physics: NeverScrollableScrollPhysics(),
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 3,
                                crossAxisSpacing: 5.0,
                                mainAxisSpacing: 5.0,
                                mainAxisExtent: 65),
                        itemCount: listtimeMeet.length,
                        physics: NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemBuilder: (context, index) {
                          return Card(
                            elevation: 5,
                            color: Colors.white,
                            shape: RoundedRectangleBorder(
                              // ignore: prefer_const_constructors
                              side: BorderSide(
                                color: Color.fromARGB(255, 132, 130, 130),
                                width: 1.0,
                                //color: Color.fromARGB(255, 143, 141, 141),
                              ),
                              borderRadius: BorderRadius.circular(7.0),

                              //<-- SEE HERE
                            ),
                            child: Dismissible(
                              direction: DismissDirection.none,
                              key: Key(listtimeMeet[index].start.toString()),
                              onDismissed: (direction) {
                                setState(() {
                                  selectedIndex = index;
                                });
                              },
                              child: ListTile(
                                selectedTileColor: Color.fromARGB(255, 0, 0, 0),
                                textColor: Color.fromARGB(255, 0, 0, 0),
                                title: Text(
                                  listtimeMeet[index].start.toString(),
                                  textAlign: TextAlign.center,
                                  // ignore: prefer_const_constructors
                                  style: TextStyle(
                                    color: Color.fromARGB(255, 0, 0, 0),
                                    fontWeight: FontWeight.bold,
                                    fontSize: 15.0,
                                  ),
                                ),
                                subtitle: Text(
                                  "עד " + listtimeMeet[index].end.toString(),
                                  textAlign: TextAlign.center,

                                  // textAlign: TextAlign.right,
                                  // ignore: prefer_const_constructors
                                  style: TextStyle(
                                    color: Color.fromARGB(255, 81, 79, 79),
                                    //fontWeight: FontWeight.bold,
                                    fontSize: 14.0,
                                  ),
                                ),
                                onTap: () {
                                  setPrefDataUser(
                                      // ignore: prefer_interpolation_to_compose_strings
                                      today.day.toString() +
                                          "-" +
                                          today.month.toString() +
                                          "-" +
                                          today.year.toString(),
                                      listtimeMeet[index]
                                              .start
                                              .toString()
                                              .split(":")
                                              .first +
                                          listtimeMeet[index]
                                              .start
                                              .toString()
                                              .split(":")
                                              .last,
                                      listtimeMeet[index]
                                              .end
                                              .toString()
                                              .split(":")
                                              .first +
                                          listtimeMeet[index]
                                              .end
                                              .toString()
                                              .split(":")
                                              .last);

                                  setIndex();
                                  setState(() {
                                    selectedIndex = index;
                                  });
                                },
                              ),
                            ),
                          );
                        })
                    : Container(
                        width: 400,
                        height: 250,
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
                                    Icons.edit_calendar_sharp,
                                    color: Color.fromARGB(255, 247, 58, 58),
                                    size: 40,
                                  ),
                                ),
                                Container(
                                  margin: EdgeInsets.only(left: 5, right: 5),

                                  // ignore: prefer_const_literals_to_create_immutables
                                  child: Column(children: [
                                    isFreeTime == true || ifShabatDay == 6
                                        ? Text(
                                            mess,
                                            textAlign: TextAlign.center,
                                            textDirection: TextDirection.ltr,
                                            // ignore: prefer_const_constructors
                                            style: TextStyle(
                                              color:
                                                  Color.fromARGB(255, 0, 0, 0),
                                              fontWeight: FontWeight.bold,
                                              fontSize: 18.0,
                                            ),
                                          )
                                        : Text(
                                            mess,
                                            textAlign: TextAlign.center,
                                            textDirection: TextDirection.ltr,
                                            // ignore: prefer_const_constructors
                                            style: TextStyle(
                                              color:
                                                  Color.fromARGB(255, 0, 0, 0),
                                              fontWeight: FontWeight.bold,
                                              fontSize: 18.0,
                                            ),
                                          )
                                  ]),
                                )
                              ],
                            )))));
      } else {
        return ifShabatDay != 6 && isFreeTime == false && isFullBook == false
            ? Container(
                margin: EdgeInsets.only(top: 10),
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
              )
            : Container(
                width: 400,
                height: 150,
                child: Card(
                    shape: RoundedRectangleBorder(
                      side: BorderSide(
                        width: 1.0,
                        color: Color.fromARGB(255, 143, 141, 141),
                      ),
                      borderRadius: BorderRadius.circular(15.0), //<-- SEE HERE
                    ),
                    elevation: 10,
                    // ignore: prefer_const_literals_to_create_immutables
                    child: Column(
                      children: [
                        Container(
                          margin: EdgeInsets.all(16),
                          child: Icon(
                            Icons.edit_calendar_sharp,
                            color: Color.fromARGB(255, 247, 58, 58),
                            size: 40,
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(left: 5, right: 5),

                          // ignore: prefer_const_literals_to_create_immutables
                          child: Column(children: [
                            isFreeTime == true ||
                                    ifShabatDay == 6 && isFullBook == true
                                ? Text(
                                    mess,
                                    textAlign: TextAlign.center,
                                    textDirection: TextDirection.ltr,
                                    // ignore: prefer_const_constructors
                                    style: TextStyle(
                                      color: Color.fromARGB(255, 0, 0, 0),
                                      fontWeight: FontWeight.w700,
                                      fontSize: 16.0,
                                    ),
                                  )
                                : Text(
                                    mess,
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
                    )));
      }
    });
  }

  //מעדכן את אינדקס של המסך ההרשמה
  setIndex() async {
    final prefsIndex = await SharedPreferences.getInstance();
    setState(() {
      prefsIndex.setString("scrollTop", "true");
      prefsIndex.setString("indexTor", "3");
    });
  }

  // תאריכים בעברית
  Future<int> getDay(int day) async {
    switch (day) {
      case 1:
        setState(() {
          NameDay = "יום שני";
          numberDayGetData = 1;
        });
        break;
      case 2:
        setState(() {
          NameDay = "יום שלישי";
          numberDayGetData = 2;
        });
        break;
      case 3:
        setState(() {
          NameDay = "יום רבעי";
          numberDayGetData = 3;
        });
        break;
      case 4:
        setState(() {
          NameDay = "יום חמישי";
          numberDayGetData = 4;
        });
        break;
      case 5:
        setState(() {
          NameDay = "יום שישי";
          numberDayGetData = 5;
        });
        break;
      case 6:
        setState(() {
          NameDay = "יום שבת";
          numberDayGetData = 6;
        });
        break;
      case 7:
        setState(() {
          NameDay = "יום ראשון";
          numberDayGetData = 0;
        });
        break;
    }
    return numberDayGetData;
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

class timeMeet {
  final String? start;
  final String? end;
  timeMeet(this.start, this.end);
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
