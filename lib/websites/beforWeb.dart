// ignore_for_file: prefer_const_constructors, use_build_context_synchronously, prefer_const_literals_to_create_immutables

import 'dart:convert';

import 'package:delayed_widget/delayed_widget.dart';
import 'package:easy_splash_screen/easy_splash_screen.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:my_tor/websites/web_sites.dart';
import 'package:my_tor/websites/web_sites_women.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashPage extends StatefulWidget {
  final String nameClient;

  SplashPage({Key? key, required this.nameClient}) : super(key: key);

  @override
  _SplashPageState createState() => _SplashPageState(nameClient);
}

class StartEndWork {
  String day = "";
  String start = "";
  String end = "";

  StartEndWork(this.day, this.start, this.end);

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

class typeServerModel {
  String? nameServer;
  String? time;
  String? price;
  String? subTitle;
  int? Distans;
  String? Timer;
  typeServerModel(
      this.nameServer, this.time, this.price, this.subTitle, this.Distans , this.Timer);

  Map<String, dynamic> toJson() {
    return {
      'name': nameServer,
      'time': time,
      'price': price,
      'subTitle': subTitle,
      'Distans': Distans,
      'Timer': Timer,
    };
  }

  typeServerModel.fromJson(Map<String, dynamic> json) {
    nameServer = json['name'];
    price = json['price'];
    time = json['time'];
    subTitle = json['subTitle'];
  }
}

class _SplashPageState extends State<SplashPage> {
  String nameClient;
  _SplashPageState(this.nameClient);
  List<typeServerModel> listTypeServer = [];
  List<StartEndWork> listStartEndWork = [];
  List<workerListModel> listWorker = [];
  String l1 = "l4", numberL = "0", nameBis = "", give = "";
  List<String> images = [];

  @override
  void initState() {
    print("ffef33333333=== " + nameClient.split("/")[1]);
    setState(() {
      l1 = nameClient.split("/")[1];
      numberL = nameClient.split("/").last;
    });
    loadData();

    // TODO: implement initState
    super.initState();
  }

  Future loadData() async {
    // Start loading data for the second page and introduce a delay for the splash page
    await Future.wait([
      Future.delayed(Duration(seconds: 6)), // Delay for the splash page
      loadSecondPageData(), // Load data for the second page
    ]);

    Navigator.push(
      context,
      PageRouteBuilder(
        transitionDuration: Duration(milliseconds: 500),
        pageBuilder: (context, animation, secondaryAnimation) {
          return webSites(
            nameClient: nameClient,
          );
        },
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(
            opacity: animation,
            child: child,
          );
        },
      ),
    );
  }

  Future loadSecondPageData() async {
    setClickNull().then((value) {
      getImage();
      getName();
      getDataStartEndHores();
      getDataListType();
      getDataListWorker();
    });
  }

  Future setClickNull() async {
    l1 = nameClient.split("/")[1];
    numberL = nameClient.split("/").last;
    final ref = FirebaseDatabase.instance.ref();
    final snapshot = await ref.child("$l1").get();
    setState(() {
      give = snapshot
          .child(numberL)
          .child("פרטי העסק")
          .child("שם מלא")
          .value
          .toString();
      numberL = snapshot.children.first.key.toString();
    });
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString("click", "null").toString();
    prefs.setInt("index", 0);
  }

  //נתוני העסק
  getName() async {
    SharedPreferences prefsMyData = await SharedPreferences.getInstance();
    SharedPreferences prefsMangTor = await SharedPreferences.getInstance();
    final ref = FirebaseDatabase.instance.ref();
    final snapshotM = await ref.child('$nameClient/פרטי העסק').get();
    final snapshotMess = await ref.child("$nameClient/הודעה").get();
    // prefsMangTor.setString("MangTor", "false");

    prefsMyData.setString(
        "FullName", snapshotM.child("שם מלא").value.toString());
    prefsMyData.setString(
        "NameBis", snapshotM.child("שם עסק").value.toString());
    prefsMyData.setString("Street", snapshotM.child("רחוב").value.toString());
    prefsMyData.setString("City", snapshotM.child("עיר").value.toString());
    prefsMyData.setString("Phone", snapshotM.child("טלפון").value.toString());
    prefsMyData.setString("Email", snapshotM.child("איימל").value.toString());
    prefsMyData.setString(
        "Password", snapshotM.child("סיסמה").value.toString());
    prefsMyData.setString("textMessage", snapshotMess.value.toString());
    // ignore: prefer_interpolation_to_compose_strings
    print("Fffffcc-- " + prefsMyData.getString("Phone").toString());
  }

  //לוקח סוגי שירות מהשרת
  getDataListType() async {
    SharedPreferences prefsListType1 = await SharedPreferences.getInstance();
    //prefsListType1.clear();
    DatabaseReference starCountRef =
        FirebaseDatabase.instance.ref('$nameClient/שירותים');
    starCountRef.onValue.listen((DatabaseEvent event) async {
      if (listTypeServer.isNotEmpty) {
        print("sdsd09 ");
        listTypeServer.clear();
      }
      if (event.snapshot.exists) {
        for (int i = 0; i < event.snapshot.children.length; i++) {
          // ignore: unnecessary_new
          listTypeServer.add(new typeServerModel(
            event.snapshot.children.elementAt(i).key.toString().split("~").last,
            event.snapshot.children.elementAt(i).child("זמן").value.toString(),
            event.snapshot.children.elementAt(i).child("עלות").value.toString(),
            event.snapshot.children
                .elementAt(i)
                .child("כותרת")
                .value
                .toString(),
            int.parse(event.snapshot.children
                .elementAt(i)
                .child("דיסטנס")
                .value
                .toString()),
              event.snapshot.children
                .elementAt(i)
                .child("טימר")
                .value
                .toString()
          ));
        }

        String json = jsonEncode(listTypeServer);
        prefsListType1.setString("ListService", json);
      }
    });
  }

  //לוקח זמיני עבודה מהשרת
  getDataStartEndHores() async {
    print("sdsd22 ");
    SharedPreferences prefsStartEndWork = await SharedPreferences.getInstance();
    //prefsStartEndWork.clear();
    DatabaseReference starCountRef =
        FirebaseDatabase.instance.ref('$nameClient/פעילות/$give');
    starCountRef.onValue.listen((DatabaseEvent event) async {
      final data = event.snapshot.value;
      if (listStartEndWork.isNotEmpty) {
        print("sdsd22 " + give);
        listStartEndWork.clear();
      }
      if (event.snapshot.exists) {
        print("sdsd22 ");
        for (int i = 0; i < event.snapshot.children.length; i++) {
          // ignore: unnecessary_new
          listStartEndWork.add(new StartEndWork(
            event.snapshot.children.elementAt(i).key.toString().split(",").last,
            event.snapshot.children
                .elementAt(i)
                .child("התחלה")
                .value
                .toString(),
            event.snapshot.children.elementAt(i).child("סיום").value.toString(),
          ));
        }
        // ignore: unnecessary_new
        listStartEndWork.add(new StartEndWork(
          "יום שבת",
          "09:00",
          "23:55",
        ));

        String json = jsonEncode(listStartEndWork);
        print("sdsd22 " + listStartEndWork.first.day);
        prefsStartEndWork.setString("listStartEndWork", json);
        print("wdwf = " + give);
      }
    });

    // final ref = FirebaseDatabase.instance.ref();
    // final snapshot = await ref.child('eldar/פעילות').get();
    // if (listStartEndWork.isNotEmpty) {
    //   print("sdsd ");
    //   listStartEndWork.clear();
    // }
    // if (snapshot.exists) {
    //   for (int i = 0; i < snapshot.children.length; i++) {
    //     listStartEndWork.add(new StartEndWork(
    //       snapshot.children.elementAt(i).key.toString().split(",").last,
    //       snapshot.children.elementAt(i).child("התחלה").value.toString(),
    //       snapshot.children.elementAt(i).child("סיום").value.toString(),
    //     ));
    //   }
    //   listStartEndWork.add(new StartEndWork(
    //     "יום שבת",
    //     "09:00",
    //     "23:55",
    //   ));

    // String json = jsonEncode(listStartEndWork);
    // SharedPreferences prefs = await SharedPreferences.getInstance();
    // prefs.setString("listStartEndWork", json);
    // }
  }

  //לוקח עובדים מהשרת
  getDataListWorker() async {
    SharedPreferences prefsListWorker = await SharedPreferences.getInstance();
    //prefsListWorker.clear();

    DatabaseReference starCountRef =
        // '$l1/$numberL/עובדים'
        FirebaseDatabase.instance.ref('$nameClient/עובדים');
    starCountRef.onValue.listen((DatabaseEvent event) async {
      if (listWorker.isNotEmpty) {
        listWorker.clear();
      }
      if (event.snapshot.exists) {
        for (int i = 0; i < event.snapshot.children.length; i++) {
          // ignore: unnecessary_new
          listWorker.add(new workerListModel(
              event.snapshot.children
                  .elementAt(i)
                  .child("שם מלא")
                  .value
                  .toString(),
              event.snapshot.children
                  .elementAt(i)
                  .child("איימל")
                  .value
                  .toString(),
              event.snapshot.children
                  .elementAt(i)
                  .child("טלפון")
                  .value
                  .toString()));
        }
        String json = jsonEncode(listWorker);

        prefsListWorker.setString("ListWorker", json);
        print(
            "ef3f3fefef " + prefsListWorker.getString("ListWorker").toString());
      }
    });
    starCountRef.onChildRemoved.listen((event) {
      if (listWorker.isNotEmpty) {
        listWorker.clear();
      }
      if (event.snapshot.exists) {
        for (int i = 0;
            i < event.snapshot.children.length &&
                event.snapshot.children
                        .elementAt(i)
                        .child("שם מלא")
                        .value
                        .toString() !=
                    "null";
            i++) {
          listWorker.add(new workerListModel(
              event.snapshot.children
                  .elementAt(i)
                  .child("שם מלא")
                  .value
                  .toString(),
              event.snapshot.children
                  .elementAt(i)
                  .child("איימל")
                  .value
                  .toString(),
              event.snapshot.children
                  .elementAt(i)
                  .child("טלפון")
                  .value
                  .toString()));
        }
        String json = jsonEncode(listWorker);

        prefsListWorker.setString("ListWorker", json);
        print(
            "ef3f3fefef " + prefsListWorker.getString("ListWorker").toString());
      }
    });
  }

  //תמונות העבודות שלנו
  getImage() async {
    final ref = FirebaseDatabase.instance.ref();
    final snapshot = await ref.child(nameClient + '/' + "תמונות").get();
    for (int i = 0; i < snapshot.children.length; i++) {
      images.add(snapshot.children.elementAt(i).value.toString());
    }
    SharedPreferences prefsListImageWork =
        await SharedPreferences.getInstance();
    String json = jsonEncode(images);

    prefsListImageWork.setString("ListImageWork", json);
    print("wdwdd " + images.first);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: double.infinity,
      color: Color.fromARGB(255, 0, 0, 0),
      child: Stack(
        children: [
          DelayedWidget(
            delayDuration: Duration(milliseconds: 600), // Not required
            animationDuration: Duration(seconds: 1), // Not required
            animation: DelayedAnimations.SLIDE_FROM_RIGHT,
            child: Center(
              child: DefaultTextStyle(
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 55,
                  fontWeight: FontWeight.bold,
                ),
                child: Text(
                  textAlign: TextAlign.center,
                  nameClient.split("/").last,
                ),
              ),
            ),
          ),
          Container(
            alignment: Alignment.bottomCenter,
            margin: EdgeInsets.only(bottom: 50),
            child: DelayedWidget(
              delayDuration: Duration(milliseconds: 550), // Not required
              animationDuration: Duration(seconds: 1), // Not required
              animation: DelayedAnimations.SLIDE_FROM_RIGHT,
              child: Container(
                child: Image.asset(
                  'assets/loadEneterScreen.gif',
                ),
                height: 100,
                width: 100,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
