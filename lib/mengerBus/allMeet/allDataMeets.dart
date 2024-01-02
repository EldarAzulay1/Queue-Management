// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, unused_element, prefer_interpolation_to_compose_strings, unnecessary_new, unrelated_type_equality_checks

import 'dart:convert';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:my_tor/mengerBus/menuAndReshi/showMeet.dart';
import 'package:my_tor/mengerBus/menuAndReshi/adminMenu.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:step_progress_indicator/step_progress_indicator.dart';
import 'package:url_launcher/url_launcher.dart';

class allDataMeets extends StatelessWidget {
  final String nameClient, howUser;
  const allDataMeets(
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
              body: list(nameClient: nameClient, howUser: howUser),
              //ignore: prefer_const_constructors
            )));
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

class list extends StatefulWidget {
  String nameClient, howUser;
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
  String nameClient, howUser;
  DateTime rangeStart1 = new DateTime.now();
  _list(this.nameClient, this.howUser);
  int totalPrice = 0, totalMeet = 0;
  int openCard = -1, currentStep = 0;
  List<DateTime> days = [];
  List<workerListModel> listGiveService = [];
  List<String> test = ["נותן שירות", "תורים מתוכננים"];
  String nameGiveService = "";

  bool nameWorker = false, showTor = false;
  String _chosenValue = "";
  String dropdownvalue = 'בחר תאריך',
      dropdownvalueWorker = "נותן שירות",
      currentData = '';

  List<dataMeet> listDataMeet = [];
  List<String> listDatas = [];
  List<String> listNameWorker = [];

  late dataCurrent data;
  @override
  void initState() {
    getCategoryDataGiveService().then((value) {
      if (howUser != "m") {
        setState(() {
          currentStep = 1;
        });
      }
    });

    // TODO: implement initState
    super.initState();
  }

  Future getCategoryDataGiveService() async {
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

  Widget build(BuildContext context) {
    DateTime now = new DateTime.now();
    DateTime day = new DateTime(now.year, now.month, now.day);
    if (dateNow.isEmpty) {
      dateNow = day.day.toString() +
          "-" +
          day.month.toString() +
          "-" +
          day.year.toString();

      getDay(day.weekday);
      getDate(day.month);

      NumberMunth = day.toString().split("-").last.split(" ").first;
      dateNow = NameDay +
          " , " +
          NumberMunth +
          " " +
          NameMonth +
          " " +
          day.year.toString();
      currentData = dateNow;
      dropdownvalue = dateNow;
    }

    return SingleChildScrollView(
      child: Container(
        alignment: Alignment.center,
        child: ConstrainedBox(
          constraints: BoxConstraints(minHeight: 10, maxWidth: 800),
          child: Container(
            alignment: Alignment.center,
            margin: EdgeInsets.all(10),
            decoration: BoxDecoration(
                border: Border.all(
                  color: Color.fromARGB(255, 190, 190, 190),
                ),
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(6), topRight: Radius.circular(6))),
            child: ConstrainedBox(
              constraints: BoxConstraints(minHeight: 3, maxWidth: 800),
              child: Container(
                  alignment: Alignment.center,
                  child: Column(
                    children: <Widget>[
                      SizedBox(
                        height: 15,
                      ),
                      step(),
                      SizedBox(
                        height: 20,
                      ),
                      currentStep > 0 && howUser == "m"
                          ? Container(
                              margin: EdgeInsets.all(10),
                              alignment: Alignment.topRight,
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                    primary: Color.fromARGB(255, 41, 42, 43),
                                    elevation: 3,
                                    // shape: RoundedRectangleBorder(
                                    //     borderRadius: BorderRadius.circular(32.0)),
                                    minimumSize: Size(20, 40),
                                    textStyle: const TextStyle(fontSize: 23)),
                                child: Icon(Icons.arrow_back_outlined),
                                onPressed: () {
                                  setState(() {
                                    dropdownvalue = dateNow;

                                    listDatas.clear();
                                    listDataMeet.clear();
                                    totalMeet = 0;
                                    totalPrice = 0;
                                    nameGiveService = "";
                                    currentStep--;
                                  });
                                },
                              ),
                            )
                          : Container(),
                    ],
                  )),
            ),
          ),
        ),
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
                margin: EdgeInsets.only(right: 15, top: 10),
                alignment: Alignment.topRight,
                child: Text("תורים מתוכננים",
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
                child: Text("בחר נותן שירות וצפה בתורים",
                    // ignore: prefer_const_constructors
                    style: TextStyle(
                      color: Color.fromARGB(255, 101, 100, 100),
                      //fontWeight: FontWeight.bold,
                      fontSize: 15.0,
                    )),
              ),
              SizedBox(
                height: 10,
              ),
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
                Container(
                  child: dataGive(),
                  margin: EdgeInsets.all(10),
                ),
              if (currentStep == 1) showTor1()
            ],
          ),
        ),
      ),
    );
  }

  showTor1() {
    return Column(
      children: [
        Container(
          margin: EdgeInsets.only(right: 16),
          alignment: Alignment.topRight,
          child: Text(
              // ignore: prefer_interpolation_to_compose_strings
              "בחר תאריך לצפייה בתורים",
              // ignore: prefer_const_constructors
              style: TextStyle(
                color: Color.fromARGB(255, 56, 55, 55),
                fontWeight: FontWeight.bold,
                fontSize: 18.0,
              )),
        ),

        SizedBox(
          height: 5,
        ),

        getData(),
        SizedBox(
          height: 5,
        ),
        SizedBox(
          height: 5,
        ),
        ConstrainedBox(
          constraints: BoxConstraints(minHeight: 10, maxWidth: 800),
          child: Divider(
            height: 10,
            thickness: 3,
          ),
        ),
        SizedBox(
          height: 15,
        ),
        // Text(
        //     // ignore: prefer_interpolation_to_compose_strings
        //     currentData,
        //     // ignore: prefer_const_constructors
        //     style: TextStyle(
        //       color: Color.fromARGB(255, 6, 6, 6),
        //       fontWeight: FontWeight.bold,
        //       fontSize: 17.0,
        //     )),

        ConstrainedBox(
          constraints: BoxConstraints(minHeight: 10, maxWidth: 600),
          child: dataOrder(context),
        ),

        //ignore: prefer_interpolation_to_compose_strings
        Container(
          margin: EdgeInsets.only(right: 16),
          alignment: Alignment.centerRight,
          // ignore: prefer_const_constructors
          child: Text(
              textDirection: TextDirection.ltr,
              // ignore: prefer_interpolation_to_compose_strings
              " רשימת תורים  -  $nameGiveService",
              // ignore: prefer_const_constructors
              style: TextStyle(
                color: Color.fromARGB(255, 56, 55, 55),
                fontWeight: FontWeight.bold,
                fontSize: 18.0,
              )),
        ),
        // ignore: prefer_const_constructors
        SizedBox(
          height: 25,
        ),
        ConstrainedBox(
          constraints: BoxConstraints(minHeight: 3, maxWidth: 600),
          child: show(),
        ),
      ],
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
                  key: Key(listGiveService[index].nameWorker.toString()),
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
                        currentStep++;
                      });
                    },
                  ),
                ),
              ),
            );
          }),
    );
  }

  Future<List<String>> getDataPrice1() async {
    DatabaseReference refM = FirebaseDatabase.instance.ref();
    final event = await refM
        .child(nameClient)
        .child("תורים")
        .child(nameGiveService == "כללי" ? "כללי" : "עובדים/$nameGiveService")
        .once(DatabaseEventType.value);

    if (event.snapshot.children.isNotEmpty && listDatas.isEmpty) {
      int count = event.snapshot.children.length > 14
          ? event.snapshot.children.length - 14
          : 0;
      for (int i = count; i < event.snapshot.children.length; i++) {
        listDatas.add(event.snapshot.children.elementAt(i).key.toString());
        print("len " + event.snapshot.children.length.toString());
      }
      if (!event.snapshot.hasChild(dateNow)) {
        setState(() {
          dropdownvalue = "בחר תאריך";
        });
      }
    }
    if (!event.snapshot.hasChild(dateNow)) {
      setState(() {
        dropdownvalue = "בחר תאריך";
      });
    } else {
      dropdownvalue = dateNow;
    }

    return listDatas;
  }

  getData() {
    return FutureBuilder(
      future: getDataPrice1(),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        return snapshot.hasData
            ? Container(
                child: DropdownButton<String>(
                  hint: Text(
                    dropdownvalue.toString().split(" - ").last,
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 16,
                        fontWeight: FontWeight.w500),
                  ),
                  items: snapshot.data.map<DropdownMenuItem<String>>((item) {
                    return DropdownMenuItem<String>(
                      value: item,
                      child: Text(item.toString().split(" - ").last),
                    );
                  }).toList(),
                  onChanged: (value) {
                    currentData = dropdownvalue;
                    setState(() {
                      dropdownvalue = value.toString();
                      listDataMeet.clear();
                      totalPrice = 0;
                      totalMeet = 0;
                      dateNow = dropdownvalue.toString();
                      currentData = dropdownvalue;
                      print(value);
                    });
                  },
                ),
              )
            : Container();
      },
    );
  }

  showDataMeets() {
    DateTime now = new DateTime.now();
    DateTime day1 = new DateTime(now.year, now.month, now.day);
    return Container(
        alignment: Alignment.center,
        child: Column(
          children: [
            // ignore: prefer_const_constructors
            SizedBox(
              height: 120,
            ),
            // ignore: prefer_interpolation_to_compose_strings
            Text(
                // ignore: prefer_interpolation_to_compose_strings
                currentData,
                // ignore: prefer_const_constructors
                style: TextStyle(
                  color: Color.fromARGB(255, 6, 6, 6),
                  fontWeight: FontWeight.bold,
                  fontSize: 22.0,
                )),

            dataOrder(context),
            // ignore: prefer_interpolation_to_compose_strings
            Container(
              margin: EdgeInsets.only(right: 16),
              alignment: Alignment.centerRight,
              // ignore: prefer_const_constructors
              child: Text(
                  // ignore: prefer_interpolation_to_compose_strings
                  "רשימת תורים",
                  // ignore: prefer_const_constructors
                  style: TextStyle(
                    color: Color.fromARGB(255, 56, 55, 55),
                    fontWeight: FontWeight.bold,
                    fontSize: 19.0,
                  )),
            ),
            // ignore: prefer_const_constructors
            SizedBox(
              height: 10,
            ),
            show(),
          ],
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

  Future<int> getDataMeet() async {
    // setState(() {
    //   totalMeet = 0;
    // });
    DatabaseReference refM = FirebaseDatabase.instance.ref();
    final event = await refM
        .child(nameClient)
        .child("תורים")
        .child(nameGiveService == "כללי" ? "כללי" : "עובדים/$nameGiveService")
        .once(DatabaseEventType.value);

    if (totalMeet > event.snapshot.child(dateNow).children.length) {
      setState(() {
        totalMeet = 0;
      });
    }

    if (event.snapshot.child(dateNow).children.isNotEmpty &&
        event.snapshot.child(dateNow).children.length > listDataMeet.length) {
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
          totalMeet++;
        }
      }
    }
    return totalMeet;
  }

  Future<List<dataMeet>> getDataFirebase() async {
    DateTime now = new DateTime.now();
    DateTime day = new DateTime(now.year, now.month, now.day);
    // ignore: prefer_interpolation_to_compose_strings
    // dateNow = day.day.toString() +
    //     "-" +
    //     day.month.toString() +
    //     "-" +
    //     day.year.toString();
    DatabaseReference refM = FirebaseDatabase.instance.ref();
    final event = await refM
        .child(nameClient)
        .child("תורים")
        .child(nameGiveService == "כללי" ? "כללי" : "עובדים/$nameGiveService")
        .once(DatabaseEventType.value);
    if (event.snapshot.child(dateNow).children.isNotEmpty &&
        event.snapshot.child(dateNow).children.length > listDataMeet.length) {
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

        }

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
      }
    }
    return listDataMeet;
  }

  show() {
    print("datt " + dropdownvalue.toString());
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
                                    height: index == openCard &&
                                            listDataMeet[index].name !=
                                                "חופשה" &&
                                            listDataMeet[index].name != "הפסקה"
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
                                                          fontSize: 22.0,
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
                                                                  nameGiveService ==
                                                                              "כללי" &&
                                                                          (listDataMeet[index].name == "חופשה" ||
                                                                              listDataMeet[index].name ==
                                                                                  "הפסקה")
                                                                      ? listDataMeet[index]
                                                                              .name
                                                                              .toString() +
                                                                          "  |  " +
                                                                          listDataMeet[index]
                                                                              .giveTipol
                                                                              .toString()
                                                                      : listDataMeet[
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
                                                                              FontWeight.bold,
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
                                                                            index,
                                                                            dropdownvalue);
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
                : dropdownvalue == "בחר תאריך"
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
                                      "אין תורים להיום , ניתן לבחור תאריך אחר",
                                      textAlign: TextAlign.center,
                                      textDirection: TextDirection.ltr,
                                      // ignore: prefer_const_constructors
                                      style: TextStyle(
                                        color: Color.fromARGB(255, 0, 0, 0),
                                        fontWeight: FontWeight.bold,
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

  Future<void> _showMyDialogCancelList(int index, String date) async {
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
                      ? date.split(" - ").last
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
                            listDataMeet[index].end.toString().split("/")[1] +
                            " - " +
                            listDataMeet[index]
                                .end
                                .toString()
                                .split("/")
                                .first +
                            "/" +
                            listDataMeet[index].start.toString().split("/")[1] +
                            "\n" +
                            "כל החופשה תמחק *",
                        textDirection: TextDirection.ltr,
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
                              date +
                              "/" +
                              listDataMeet[index].start.toString() +
                              "," +
                              listDataMeet[index].end.toString());
                      ref1.remove();
                      DatabaseReference ref = FirebaseDatabase.instance.ref(
                          "$nameClient/תורים/כללי/$date" +
                              "/" +
                              listDataMeet[index].start.toString() +
                              "," +
                              listDataMeet[index].end.toString() +
                              " | " +
                              give);

                      DatabaseReference ref111 = FirebaseDatabase.instance.ref(
                          "$nameClient/לקוחות/$phone/תורים" +
                              "/" +
                              date +
                              "/" +
                              listDataMeet[index].start.toString() +
                              "," +
                              listDataMeet[index].end.toString());
                      ref111.remove();

                      String StartTime = listDataMeet[index]
                              .start
                              .toString()
                              .substring(0, 2) +
                          ":" +
                          listDataMeet[index].start.toString().substring(2, 4);

                      String phoneCurrent =
                          listDataMeet[index].phone.toString();
                      DatabaseReference refRmoveTorim = FirebaseDatabase
                          .instance
                          .ref("torim/$nowdateTorim/$phoneCurrent/$StartTime");
                      refRmoveTorim.remove();

                      ref.remove().then((value) => showelrat());
                      setState(() {
                        listDataMeet.removeAt(index);
                        totalPrice = 0;
                        if (listDataMeet.isEmpty) {
                          dropdownvalue = "בחר תאריך";
                        }
                        listDatas.clear();
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
                        date = days[i].toIso8601String().split("T").first +
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
                                date +
                                "/" +
                                "0500" +
                                "," +
                                "2355" +
                                " | " +
                                give);

                        DatabaseReference ref = FirebaseDatabase.instance.ref(
                            "$nameClient/תורים/עובדים/$give" +
                                "/" +
                                date +
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

                        if (listDataMeet.isEmpty) {
                          dropdownvalue = "בחר תאריך";
                        }
                        listDatas.clear();
                      });
                    }
                    setState(() {
                      openCard = -1;
                      totalPrice = 0;
                      totalMeet = 0;
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

  Future<int> getDataPrice() async {
    DatabaseReference refM = FirebaseDatabase.instance.ref();
    final event = await refM
        .child(nameClient)
        .child("תורים")
        .child(nameGiveService == "כללי" ? "כללי" : "עובדים/$nameGiveService")
        .once(DatabaseEventType.value);

    if (event.snapshot.child(dateNow).children.isNotEmpty &&
        event.snapshot.child(dateNow).children.length > listDataMeet.length) {
      for (int i = 0; i < event.snapshot.child(dateNow).children.length; i++) {
        totalPrice += int.parse(event.snapshot
            .child(dateNow)
            .children
            .elementAt(i)
            .child("מחיר")
            .value
            .toString()
            .split(" ")
            .first);
      }
    }
    return totalPrice;
  }

  dataOrder(BuildContext context) {
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
                                      child: Text(snapshot.data.toString(),
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
                                    child: Text(snapshot.data.toString() + " ₪",
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
