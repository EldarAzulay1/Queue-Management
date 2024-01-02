// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors, avoid_print, avoid_single_cascade_in_expression_statements, use_build_context_synchronously

import 'dart:async';
import 'dart:convert';
import 'package:flutter_midi_command/flutter_midi_command.dart';
import 'package:http/http.dart' as http;

import 'package:delayed_widget/delayed_widget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:my_tor/main.dart';
import 'package:my_tor/tableTor/finish.dart';
import 'package:my_tor/tableTor/times.dart';
import 'package:my_tor/tableTor/type_server.dart';
import 'package:my_tor/websites/web_sites.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:step_progress_indicator/step_progress_indicator.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:io' show Platform;

import '../tableTor/tableSendTor.dart';
import '../websites/beforWeb.dart';
import 'finishRegister.dart';
import 'horesWork.dart';
import 'myDetails.dart';
import 'myServices.dart';
import 'dart:html' as html;

class tableRegisterUser extends StatefulWidget {
  final myControllerImage = TextEditingController();
  final String nameClient;

  tableRegisterUser({Key? key, required this.nameClient}) : super(key: key);

  @override
  State<tableRegisterUser> createState() => list(nameClient);
  test1() {
    print("efefefeffffffff");
  }
}

riestIndex() async {
  final prefsIndex = await SharedPreferences.getInstance();
  prefsIndex.setString("indexRgister", "0");
  SharedPreferences prefsScrollButton = await SharedPreferences.getInstance();
  prefsScrollButton.setString("ScrollButton", "false");
}

class list extends State<tableRegisterUser> {
  String nameClient;
  list(this.nameClient);

  int step1 = 0, currentStep = 0;
  List<String> test = ["פרטי העסק", "זמני פעילות", "שירותים", "סיום"];
  List<String> listTor = ["סוג שירות", "תאריך ושעה", "סיום"];
  late MyData dataBis = new MyData();
  List<MyWoresHores> dataWorks = [];
  List<String> imageWork = [
    "https://ibb.co/pyymQL6",
    "https://ibb.co/QN9nNJm",
    "https://ibb.co/ph13sy1",
    "https://ibb.co/BzJtBnL",
  ];
  List<typeServerModel> listTypeServer = [];
  List<String> deys = [
    "יום ראשון",
    "יום שני",
    "יום שלישי",
    "יום רביעי",
    "יום חמישי",
    "יום שישי"
  ];
  ScrollController _scrollController = ScrollController();
  int index = 0;
  //final isWindows = Platform.operatingSystem;
  DatabaseReference refM = FirebaseDatabase.instance.ref();

  @override
  void initState() {
    riestIndex();
    scrollToBottun();
    super.initState();
  }

  late Timer _timer;

  scrollToTop() {
    _scrollController.jumpTo(0);
  }

  scrollToBottun() {
    _timer = Timer.periodic(Duration(seconds: 1), (timer) async {
      SharedPreferences prefsScrollButton =
          await SharedPreferences.getInstance();
      if (prefsScrollButton.getString("ScrollButton").toString() == "true") {
        print("lll1122222222" + nameClient.toString());

        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: Duration(milliseconds: 500),
          curve: Curves.easeInOut,
        );
        SharedPreferences prefsScrollButton =
            await SharedPreferences.getInstance();
        prefsScrollButton.setString("ScrollButton", "false");
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    bool web = Theme.of(context).platform == TargetPlatform.windows;
    setState(() {
      currentStep;
      //getIndex();
    });
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        //backgroundColor: Color.fromARGB(235, 235, 235, 235),
        backgroundColor: Color.fromARGB(255, 240, 240, 240),
        body: SingleChildScrollView(
          controller: _scrollController,
          child: Container(
            alignment: Alignment.center,
            child: ConstrainedBox(
              constraints: BoxConstraints(minHeight: 10, maxWidth: 800),
              child: Container(
                child: Stack(
                  //controller: _scrollController,
                  children: [
                    if (web == true)
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            flex: 1,
                            child: Container(
                              child: Column(
                                //controller: _scrollController,
                                children: [
                                  Container(
                                    child: Directionality(
                                      textDirection: TextDirection.rtl,
                                      child: Container(
                                          decoration: BoxDecoration(
                                              border: Border.all(
                                                // ignore: prefer_const_constructors
                                                color: Color.fromARGB(
                                                    255, 190, 190, 190),
                                              ),
                                              // ignore: prefer_const_constructors
                                              borderRadius: BorderRadius.only(
                                                  topLeft: Radius.circular(6),
                                                  topRight:
                                                      Radius.circular(6))),
                                          margin: EdgeInsets.all(10),
                                          child: Column(
                                            children: [
                                              step(),
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  currentStep != 0
                                                      ? Container(
                                                          margin:
                                                              EdgeInsets.all(
                                                                  15),
                                                          alignment: Alignment
                                                              .bottomRight,
                                                          child: ElevatedButton(
                                                            style: ElevatedButton
                                                                .styleFrom(
                                                                    primary: Color
                                                                        .fromARGB(
                                                                            255,
                                                                            41,
                                                                            42,
                                                                            43),
                                                                    elevation:
                                                                        3,
                                                                    // shape: RoundedRectangleBorder(
                                                                    //     borderRadius: BorderRadius.circular(32.0)),
                                                                    minimumSize:
                                                                        Size(20,
                                                                            40),
                                                                    textStyle: const TextStyle(
                                                                        fontSize:
                                                                            23)),
                                                            child: Icon(Icons
                                                                .arrow_back_outlined),
                                                            onPressed: () {
                                                              backButton();
                                                            },
                                                          ),
                                                        )
                                                      : Container(),
                                                  Container(
                                                    margin: EdgeInsets.all(15),
                                                    child: ElevatedButton(
                                                      style: ElevatedButton
                                                          .styleFrom(
                                                              primary: Color
                                                                  .fromARGB(
                                                                      255,
                                                                      41,
                                                                      42,
                                                                      43),
                                                              elevation: 3,
                                                              // shape: RoundedRectangleBorder(
                                                              //     borderRadius: BorderRadius.circular(32.0)),
                                                              minimumSize:
                                                                  Size(20, 40),
                                                              textStyle:
                                                                  const TextStyle(
                                                                      fontSize:
                                                                          23)),
                                                      child: currentStep < 3
                                                          ? Text("לשלב הבא")
                                                          : Text("אשר וסיים"),
                                                      onPressed: () async {
                                                        if (currentStep < 3) {
                                                          nextButton();
                                                          scrollToTop();
                                                        } else {
                                                          setDataFireBase()
                                                              .then((value) {
                                                            print("efefefff");
                                                            //enterWebPage();
                                                          });
                                                        }
                                                      },
                                                    ),
                                                  ),
                                                ],
                                              )
                                            ],
                                          )),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      )
                    else
                      Column(
                        children: [
                          Container(
                            child: Directionality(
                              textDirection: TextDirection.rtl,
                              child: Container(
                                  decoration: BoxDecoration(
                                      border: Border.all(
                                        color:
                                            Color.fromARGB(255, 190, 190, 190),
                                      ),
                                      borderRadius: BorderRadius.only(
                                          topLeft: Radius.circular(6),
                                          topRight: Radius.circular(6))),
                                  margin: EdgeInsets.all(10),
                                  child: Column(
                                    children: [
                                      step(),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Container(
                                            margin: EdgeInsets.all(15),
                                            alignment: Alignment.bottomRight,
                                            child: ElevatedButton(
                                              style: ElevatedButton.styleFrom(
                                                  primary: Color.fromARGB(
                                                      255, 41, 42, 43),
                                                  elevation: 3,
                                                  // shape: RoundedRectangleBorder(
                                                  //     borderRadius: BorderRadius.circular(32.0)),
                                                  minimumSize: Size(20, 40),
                                                  textStyle: const TextStyle(
                                                      fontSize: 23)),
                                              child: Icon(
                                                  Icons.arrow_back_outlined),
                                              onPressed: () {
                                                backButton();
                                              },
                                            ),
                                          ),
                                          Container(
                                            margin: EdgeInsets.all(15),
                                            child: ElevatedButton(
                                              style: ElevatedButton.styleFrom(
                                                  primary: Color.fromARGB(
                                                      255, 41, 42, 43),
                                                  elevation: 3,
                                                  // shape: RoundedRectangleBorder(
                                                  //     borderRadius: BorderRadius.circular(32.0)),
                                                  minimumSize: Size(20, 40),
                                                  textStyle: const TextStyle(
                                                      fontSize: 23)),
                                              child: currentStep < 3
                                                  ? Text("לשלב הבא")
                                                  : Text("אשר וסיים"),
                                              onPressed: () async {
                                                if (currentStep < 3) {
                                                  nextButton();
                                                  scrollToTop();
                                                } else {
                                                  setDataFireBase()
                                                      .then((value) {
                                                    print("efefefff");
                                                    enterWebPage();
                                                  });
                                                }
                                              },
                                            ),
                                          ),
                                        ],
                                      )
                                    ],
                                  )),
                            ),
                          ),
                        ],
                      ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  backButton() async {
    final prefsIndex = await SharedPreferences.getInstance();
    setState(() {
      if (currentStep > 0) {
        currentStep--;
        prefsIndex.setString("scrollTopRegister", "true");
        prefsIndex.setString("indexRgister", currentStep.toString());
      } else {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => MyApp()));
      }
    });
  }

  bool isEmail(String input) {
    // Regular expression pattern for email validation
    final RegExp emailRegex =
        RegExp(r'^[\w-]+(\.[\w-]+)*@([a-zA-Z0-9-]+\.)+[a-zA-Z]{2,7}$');

    return emailRegex.hasMatch(input);
  }

  nextButton() async {
    final prefsIndex = await SharedPreferences.getInstance();
    if (currentStep == 0) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      dataBis.fullName = prefs.getString("FullName").toString();
      dataBis.phone = prefs.getString("Phone").toString();
      dataBis.NameBis = prefs.getString("NameBis").toString();
      dataBis.email = prefs.getString("Email").toString();
      dataBis.password = prefs.getString("Password").toString();
      dataBis.StreetName = prefs.getString("Street").toString();

      if (dataBis.fullName == "null" ||
          dataBis.phone == "null" ||
          dataBis.NameBis == "null" ||
          dataBis.email == "null" ||
          dataBis.password == "null") {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            // ignore: prefer_const_constructors
            content: Text(
          "חסר נתונים",
          textAlign: TextAlign.right,
        )));
      } else {
        if (isEmail(dataBis.email)) {
          setState(() {
            if (currentStep >= 0) {
              currentStep = 1;
              prefsIndex.setString("scrollTopRegister", "true");
              //prefsIndex.setString("indexRgister", currentStep.toString());
            }
          });
        } else {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              // ignore: prefer_const_constructors
              content: Text(
            "איימל אינו תקין",
            textAlign: TextAlign.right,
          )));
        }
      }
    } else if (currentStep == 1) {
      int count = 0;
      SharedPreferences prefsMyData = await SharedPreferences.getInstance();
      // print(
      //     "fffff-- " + prefsMyData.getString(deys[0]).toString().split(",")[0]);
      for (int i = 0; i < 6; i++) {
        if (prefsMyData.getString(deys[i]).toString().split(",")[0] ==
                " סגור " ||
            prefsMyData.getString(deys[i]).toString().split(",")[1] ==
                " סגור ") {
          count++;
        }
      }
      if (count == 6) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            // ignore: prefer_const_constructors
            content: Text(
          "הכנס לפחות יום עבודה",
          textAlign: TextAlign.right,
        )));
      } else {
        setState(() {
          if (currentStep >= 0) {
            currentStep = 2;
            prefsIndex.setString("scrollTopRegister", "true");
          }
        });
      }
    } else if (currentStep == 2) {
      final prefsListTypeRegister = await SharedPreferences.getInstance();
      final category = prefsListTypeRegister.getString("ListServiceRegister");
      print("qwfqwfqwfqf" + category!.isNotEmpty.toString());
      if (category.isNotEmpty) {
        if (currentStep >= 0) {
          setState(() {
            currentStep = 3;
            prefsIndex.setString("scrollTopRegister", "true");
          });
        }
      }
    }
  }

  Future<void> setDataFireBase() async {
    _showMyDialogCancelList();
    print("fwfwfwffff" + nameClient);
    SharedPreferences prefsMyData = await SharedPreferences.getInstance();

    UserCredential userCredential =
        await FirebaseAuth.instance.createUserWithEmailAndPassword(
      email: prefsMyData.getString("Email").toString(),
      password: prefsMyData.getString("Password").toString(),
    );
    //פרטי העסק
    refM.child(nameClient).child("פרטי העסק").update({
      "שם מלא": prefsMyData.getString("FullName").toString(),
      "טלפון": prefsMyData.getString("Phone").toString(),
      "רחוב": prefsMyData.getString("Street").toString(),
      "עיר": prefsMyData.getString("City").toString(),
      "שם עסק": prefsMyData.getString("NameBis").toString(),
      "איימל": prefsMyData.getString("Email").toString(),
      "סיסמה": prefsMyData.getString("Password").toString(),
    });

    //עובד מנהל
    refM
        .child(nameClient)
        .child("עובדים")
        .child(prefsMyData.getString("FullName").toString())
        .update({
      "שם מלא": prefsMyData.getString("FullName").toString(),
      "טלפון": prefsMyData.getString("Phone").toString(),
      "איימל": prefsMyData.getString("Email").toString(),
      "מנהל": "y",
    });

    //שעות פעילות
    getDataList().then((value) {
      for (int i = 0; i < 6; i++) {
        refM
            .child(nameClient)
            .child("פעילות")
            .child(prefsMyData.getString("FullName").toString())
            .child(i.toString() + "," + value[i].day)
            .update({
          "התחלה": value[i].start,
          "סיום": value[i].end,
        });
      }
    });
    //שירותי העסק
    getCategoryData().then((value) {
      for (int i = 0; i < 6; i++) {
        refM
            .child(nameClient)
            .child("שירותים")
            .child(i.toString() + "," + value[i].nameServer)
            .update({
          "זמן": value[i].time,
          "עלות": value[i].price,
          "כותרת": value[i].subTitle,
        });
      }
    });

    //עבודות תמונות
    refM.child(nameClient).child("תמונות").update({
      for (int i = 0; i < 3; i++) i.toString(): imageWork[i],
    });
  }

  Future<void> _showMyDialogCancelList() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (context) {
        return Container(
          alignment: Alignment.center,
          height: 100,
          child: AlertDialog(
            title: Text(
              style: TextStyle(
                //backgroundColor: Color.fromARGB(255, 178, 175, 175),
                color: Color.fromARGB(255, 53, 52, 52),
                fontWeight: FontWeight.bold,
                fontSize: 14.0,
              ),
              // ignore: prefer_interpolation_to_compose_strings
              // ignore: prefer_interpolation_to_compose_strings
              "מספר שניות תועבר לאתר",
              textAlign: TextAlign.right,
            ),
            content: Container(
              child: Image.asset(
                'assets/loadWeb.gif',
              ),
              height: 70,
              width: 70,
            ),
          ),
        );
      },
    );
  }

  Future<void> _showMyD() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (context) {
        return Container(
          alignment: Alignment.center,
          height: 100,
          child: AlertDialog(
            title: Text(
              style: TextStyle(
                //backgroundColor: Color.fromARGB(255, 178, 175, 175),
                color: Color.fromARGB(255, 53, 52, 52),
                fontWeight: FontWeight.bold,
                fontSize: 14.0,
              ),
              // ignore: prefer_interpolation_to_compose_strings
              // ignore: prefer_interpolation_to_compose_strings
              "לחץ על הקישור והתחל לעבוד",
              textAlign: TextAlign.right,
            ),
            content: Column(
              children: [],
            ),
          ),
        );
      },
    );
  }

  Future<void> enterWebPage() async {
    String url = "http://sapar-to1.surge.sh";
    html.window.open("http://sapar-to1.surge.sh", "_self");
  }

  Future<List<MyWoresHores>> getDataList() async {
    SharedPreferences prefsMyData = await SharedPreferences.getInstance();
    //שעות פעילות
    for (int i = 0; i < 6; i++) {
      print("ewfewfwefwef33 " + prefsMyData.getString(deys[i]).toString());

      if (prefsMyData.getString(deys[i]).toString() != "null") {
        dataWorks.add(MyWoresHores(
            prefsMyData.getString(deys[i]).toString().split(",")[2],
            prefsMyData.getString(deys[i]).toString().split(",")[0],
            prefsMyData.getString(deys[i]).toString().split(",")[1]));
      } else {
        if (i == 1) {
          // ignore: unnecessary_new
          dataWorks.add(new MyWoresHores("יום ראשון", " סגור ", " סגור "));
        }
        if (i == 2) {
          dataWorks.add(new MyWoresHores("יום שני", " סגור ", " סגור "));
        }
        if (i == 3) {
          // ignore: unnecessary_new
          dataWorks.add(new MyWoresHores("יום שלישי", " סגור ", " סגור "));
        }
        if (i == 4) {
          dataWorks.add(new MyWoresHores("יום רביעי", " סגור ", " סגור "));
        }
        if (i == 5) {
          dataWorks.add(new MyWoresHores("יום חמישי", " סגור ", " סגור "));
        }
        if (i == 6) {
          dataWorks.add(new MyWoresHores("יום שישי", " סגור ", " סגור "));
        }
      }
    }
    return dataWorks;
  }

  Future<List<typeServerModel>> getCategoryData() async {
    final prefsListTypeRegister = await SharedPreferences.getInstance();
    final category = prefsListTypeRegister.getString("ListServiceRegister");
    listTypeServer = List<typeServerModel>.from(
        List<Map<String, dynamic>>.from(jsonDecode(category.toString()))
            .map((e) => typeServerModel.fromJson(e))
            .toList());

    return listTypeServer;
  }

  getIndex() async {
    final prefsIndex = await SharedPreferences.getInstance();

    if (prefsIndex.getString("scrollTopRegister").toString() == "true") {
      scrollToTop();
      prefsIndex.setString("scrollTopRegister", "false");
    }

    if (prefsIndex.getString("indexRgister").toString() != "0") {
      setState(() {
        currentStep =
            int.parse(prefsIndex.getString("indexRgister").toString());
      });
    } else {
      setState(() {
        currentStep = 0;
      });
    }
  }

  Widget step() {
    return Container(
      child: Column(
        children: [
          Container(
              color: Color.fromARGB(255, 179, 178, 178),
              child: Container(
                width: double.infinity,
                child: StepProgressIndicator(
                    padding: 0.5,
                    totalSteps: 4,
                    currentStep: currentStep,
                    size: 57,
                    selectedColor: Color.fromARGB(255, 101, 101, 176),
                    unselectedColor: Color.fromARGB(255, 210, 210, 210),
                    customStep: (index, color, _) {
                      return Container(
                          color: index == currentStep
                              ? Color.fromARGB(255, 205, 205, 205)
                              : Color.fromARGB(255, 220, 220, 220),
                          child: GestureDetector(
                            onTap: () {
                              print("wfwfwfwf + " + test[index]);
                            },
                            child: Center(
                                child: Text(
                              test[index],
                              style: index == currentStep
                                  ? TextStyle(
                                      fontSize: 14,
                                      color: Color.fromARGB(255, 6, 6, 6),
                                      fontWeight: FontWeight.w600,
                                    )
                                  // ignore: prefer_const_constructors
                                  : TextStyle(
                                      fontSize: 12.5,
                                      color: Color.fromARGB(255, 118, 117, 117),
                                    ),
                            )),
                          ));
                    }),
              )),
          SizedBox(
            height: 20,
          ),
          if (currentStep == 0)
            Container(
              child: myDetails(),
              margin: EdgeInsets.all(10),
            ),
          if (currentStep == 1)
            Container(
              margin: EdgeInsets.all(10),
              child: horesWork(),
            ),
          if (currentStep == 2)
            Container(
                margin: EdgeInsets.all(10),
                child: myServices(
                  nameClient: nameClient,
                )),
          if (currentStep == 3)
            Container(margin: EdgeInsets.all(10), child: finishRegister()),
        ],
      ),
    );
  }
}

class typeServerModel {
  String nameServer = "";
  String? time;
  String? price;
  String? subTitle;
  typeServerModel(this.nameServer, this.time, this.price, this.subTitle);

  Map<String, dynamic> toJson() {
    return {
      'name': nameServer,
      'time': time,
      'price': price,
      'subTitle': subTitle
    };
  }

  typeServerModel.fromJson(Map<String, dynamic> json) {
    nameServer = json['name'];
    price = json['price'];
    time = json['time'];
    subTitle = json['subTitle'];
  }
}
