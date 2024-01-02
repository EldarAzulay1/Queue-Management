// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, unused_field, non_constant_identifier_names, prefer_interpolation_to_compose_strings, use_build_context_synchronously, unnecessary_null_comparison, avoid_single_cascade_in_expression_statements

import 'dart:async';
import 'dart:convert';
//import 'dart:html';
import 'dart:ui';
import 'package:animations/animations.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:my_tor/Login.dart';
import 'package:my_tor/main.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:video_player/video_player.dart';
import '../mengerBus/menuAndReshi/adminMenu.dart';
import 'package:video_player_web/video_player_web.dart';
import 'package:gif/gif.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import '../registerNew/tableRegisterUser.dart';
import '../tableTor/tableSendTor.dart';
import 'package:http/http.dart' as http;
import 'package:delayed_widget/delayed_widget.dart';
import 'package:path_provider/path_provider.dart';
//import 'dart:convert';
import 'dart:io';

class webSites extends StatelessWidget {
  final String nameClient;
  webSites({Key? key, required this.nameClient}) : super(key: key);

  Widget build(BuildContext context) {
    // ignore: prefer_const_constructors
    return Scaffold(
        body: Directionality(
            textDirection: TextDirection.rtl,
            // ignore: sort_child_properties_last
            child: Scaffold(
              backgroundColor: Color.fromARGB(235, 0, 0, 0),
              appBar: AppBar(
                centerTitle: true,
                // ignore: prefer_const_constructors
                // shape: RoundedRectangleBorder(
                //     borderRadius: BorderRadius.vertical(
                //   bottom: Radius.circular(5),
                // )),
                title: Text(
                    // ignore: prefer_const_constructors
                    nameClient.split("/").last,
                    // ignore: prefer_const_constructors
                    style: TextStyle(
                      fontFamily: 'Gisha',
                      color: Color.fromARGB(255, 255, 255, 255),
                      fontWeight: FontWeight.bold,
                      fontSize: 17.0,
                    )),
                iconTheme:
                    IconThemeData(color: Color.fromARGB(255, 255, 255, 255)),
                backgroundColor: Color.fromARGB(230, 7, 7, 7),
              ),
              drawer: NavigationDrawer(nameClient: nameClient),
              body: list(nameClient: nameClient),
              //ignore: prefer_const_constructors
            )));
  }
}

class list extends StatefulWidget {
  String nameClient;
  list({Key? key, required this.nameClient}) : super(key: key);
  @override
  State<list> createState() => _webOffice(nameClient);
}

class _webOffice extends State<list> with TickerProviderStateMixin {
  String nameClient;
  _webOffice(this.nameClient);
  List<StartEndWork> listStartEndWork = [];
  double? Height;
  int activePage = 0, pagePosition1 = 0;
  late PageController _pageController;
  ImageProvider logo = AssetImage("assets/barber1.jpg");
  AssetImage? assetImage;
  bool VisMess = true;
  String textCustum = "null", linkFec = "null", linkIns = "null";
  String NameDay = "",
      NumberMunth = "",
      NameMonth = "",
      NameMonthForDate = "",
      dateNow = "";
  String MessMenger = "null", phoneMenger = "", streetMenger = "", city = "";

  List<String> images = [];
  DatabaseReference refM = FirebaseDatabase.instance.ref();

  late Timer _timer;
  List<TorRemmber> listTodayTors = [];

  ScrollController _scrollController = ScrollController();
  String give = "null";
  Future setClickNull() async {
    final ref = FirebaseDatabase.instance.ref();
    final snapshot = await ref.child(nameClient + '/' + 'עובדים').get();
    for (int i = 0; i < snapshot.children.length; i++) {
      if (snapshot.children.elementAt(i).hasChild("מנהל")) {
        setState(() {
          give = snapshot.children.elementAt(i).key.toString();
        });
      }
    }
    return give;
  }

  @override
  void initState() {
    getImage();
    getCall();
    DateTime now = DateTime.now();
    DateTime day1 = DateTime(now.year, now.month, now.day);
    NumberMunth = day1.toString().split("-").last.split(" ").first;

    getDay(day1.weekday);
    getDate(day1.month);
    setState(() {
      dateNow = day1.toIso8601String().split("T").first +
          " - " +
          NameDay +
          " , " +
          NumberMunth +
          " " +
          NameMonth +
          " " +
          day1.year.toString();
    });
    getVideo();
    getTimeWorkToday();
    setClickNull().then((value) {
      getDataStartEndHores(value.toString());
    });
    riestIndex();
    String namec = nameClient.split("/")[1].toString();

    loadAssetMedia(namec).then(
      (value) {
        print("wddwddd-- ");
        setState(() {
          linkFec = value.split("|").first;
          linkIns = value.split("|").last;
        });
        print("wddwdddwwwvv--  " + value);
      },
    );
    super.initState();
  }

  getTimeWorkToday() async {
    DatabaseReference refM = FirebaseDatabase.instance.ref();

    final event = await refM
        .child(nameClient)
        .child("תורים")
        .child("כללי")
        .child(dateNow)
        .onValue
        .listen((event) {
      listTodayTors.clear();
      for (int i = 0; i < event.snapshot.children.length; i++) {
        listTodayTors.add(TorRemmber(
            dateNow,
            event.snapshot.children
                .elementAt(i)
                .child("התחלה")
                .value
                .toString(),
            event.snapshot.children
                .elementAt(i)
                .child("שירות")
                .value
                .toString(),
            event.snapshot.children.elementAt(i).child("שם").value.toString(),
            event.snapshot.children
                .elementAt(i)
                .child("פלאפון")
                .value
                .toString()));
      }
    });
  }

  getImage() async {
    SharedPreferences prefsListImageWork =
        await SharedPreferences.getInstance();
    final category = prefsListImageWork.getString("ListImageWork");
    images = List<String>.from(json.decode(category.toString()));
  }

  getCall() async {
    SharedPreferences prefsMyData = await SharedPreferences.getInstance();
    setState(() {
      MessMenger = prefsMyData.getString("textMessage").toString();
      phoneMenger = prefsMyData.getString("Phone").toString();
      streetMenger = prefsMyData.getString("Street").toString();
      city = prefsMyData.getString("City").toString();
    });
  }

  riestIndex() async {
    final prefsIndex = await SharedPreferences.getInstance();
    prefsIndex.setString("indexTor", "0");
  }

  Future<String> loadAsset(String namec) async {
    print("wddwddd-- " + "assets/עסקים/textUsers/" + "$namec" + ".txt");

    String user = "assets/עסקים/textUsers/" + "$namec" + ".txt";

    return await DefaultAssetBundle.of(context).loadString(user);
  }

  Future<String> loadAssetMedia(String namec) async {
    String user = "assets/עסקים/link_madie_frinde/" + "$namec" + ".txt";

    return await DefaultAssetBundle.of(context).loadString(user);
  }

  @override
  Widget build(BuildContext context) {
    Size size = WidgetsBinding.instance.window.physicalSize;
    late PageController _pageController;

    Height = MediaQuery.of(context).size.height - 70;
    String namec = nameClient.split("/")[1].toString();
    if (textCustum == "null") {
      loadAsset(namec).then(
        (value) {

          setState(() {
            textCustum = value;
          });
        },
      );
    }
    return Stack(
      children: [
        SingleChildScrollView(
          controller: _scrollController,
          child: Column(
            children: [
              // SizedBox(
              //   height: 3,
              // ),
              Stack(
                children: [
                  getVideo(),
                  MessMenger != "null"
                      ? DelayedWidget(
                          delayDuration:
                              Duration(milliseconds: 500), // Not required
                          animationDuration:
                              Duration(seconds: 1), // Not required
                          animation: DelayedAnimations.SLIDE_FROM_TOP,
                          child: Opacity(
                            opacity: 0.8,
                            child: Visibility(
                              visible: VisMess,
                              child: Container(
                                alignment: Alignment.center,
                                child: Card(
                                    color: Color.fromARGB(255, 0, 0, 0),
                                    //margin: EdgeInsets.all(30),
                                    shadowColor: Color.fromARGB(255, 0, 0, 0),
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.only(
                                            topLeft: Radius.circular(10),
                                            topRight: Radius.circular(10),
                                            bottomLeft: Radius.circular(10),
                                            bottomRight: Radius.circular(
                                                10)) //<-- SEE HERE
                                        ),
                                    elevation: 25,
                                    child: Column(
                                      children: [
                                        ConstrainedBox(
                                          constraints: BoxConstraints(
                                              minHeight: 10, maxWidth: 500),
                                          child: Container(
                                              margin: EdgeInsets.all(13),
                                              //height: 150,
                                              width: MediaQuery.of(context)
                                                  .size
                                                  .width,
                                              child: Text(MessMenger,
                                                  textAlign: TextAlign.center,
                                                  style: TextStyle(
                                                    fontFamily: 'Gisha',
                                                    fontSize: 17,
                                                    color: Color.fromARGB(
                                                        255, 255, 255, 255),
                                                    fontWeight: FontWeight.w500,
                                                  ))),
                                        ),
                                        IconButton(
                                          icon: Icon(Icons.clear),
                                          iconSize: 23,
                                          color: Colors.red,
                                          onPressed: () {
                                            setState(() {
                                              print("fwfwfwf - " +
                                                  VisMess.toString());
                                              VisMess = false;
                                            });
                                            print("fwfwfwf - " +
                                                VisMess.toString());
                                          },
                                        )
                                      ],
                                    )),
                              ),
                            ),
                          ),
                        )
                      : Container(),
                ],
              ),
              SizedBox(
                height: 10,
              ),
              Card(
                color: Color.fromARGB(255, 250, 125, 0),
                shadowColor: Color.fromARGB(255, 0, 0, 0),
                shape: RoundedRectangleBorder(
                  side: BorderSide(
                    width: 1.5,
                    color: Color.fromARGB(255, 171, 171, 171),
                  ),
                  borderRadius: BorderRadius.circular(5.0), //<-- SEE HERE
                ),
                elevation: 25,
                margin: EdgeInsets.all(5),
                child: Container(
                  margin:
                      EdgeInsets.only(left: 30, right: 30, top: 7, bottom: 7),
                  child: Text(
                    "על המספרה",
                    style: TextStyle(
                      fontFamily: 'Gisha',
                      fontSize: 17,
                      color: Colors.black,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
              ConstrainedBox(
                constraints: BoxConstraints(minHeight: 10, maxWidth: 500),
                child: Container(
                    margin: EdgeInsets.only(left: 10, right: 10),
                    width: double.infinity,
                    //height: 120,
                    child: Column(
                      children: [
                        Container(
                            alignment: Alignment.center,
                            margin:
                                EdgeInsets.only(left: 40, right: 40, top: 10),
                            child: Text(
                              textCustum,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontFamily: 'Gisha',
                                fontSize: 14,
                                color: Color.fromARGB(255, 255, 255, 255),
                                fontWeight: FontWeight.w400,
                              ),
                            )),
                        SizedBox(
                          height: 5,
                        ),
                        //IconsFrendly(),
                      ],
                    )),
              ),
              ConstrainedBox(
                constraints: BoxConstraints(minHeight: 10, maxWidth: 500),
                child: Divider(
                  color: Colors.white,
                  height: 40,
                  thickness: 1,
                ),
              ),
              ConstrainedBox(
                  constraints: BoxConstraints(minHeight: 10, maxWidth: 500),
                  child: imageMyWork()),
              ConstrainedBox(
                constraints: BoxConstraints(minHeight: 10, maxWidth: 500),
                child: Divider(
                  color: Colors.white,
                  height: 40,
                  thickness: 1,
                ),
              ),
              ConstrainedBox(
                  constraints: BoxConstraints(minHeight: 10, maxWidth: 500),
                  child: callMe()),
              ConstrainedBox(
                constraints: BoxConstraints(minHeight: 10, maxWidth: 500),
                child: Divider(
                  color: Colors.white,
                  height: 40,
                  thickness: 1,
                ),
              ),
              ConstrainedBox(
                constraints: BoxConstraints(minHeight: 10, maxWidth: 500),
                child: HoresWork(),
              ),
              SizedBox(
                height: 10,
              ),
              ConstrainedBox(
                constraints: BoxConstraints(minHeight: 10, maxWidth: 500),
                child: Divider(
                  color: Colors.white,
                  height: 40,
                  thickness: 1,
                ),
              ),
              ConstrainedBox(
                constraints: BoxConstraints(minHeight: 10, maxWidth: 500),
                child: IconsFrendly(),
              ),

              SizedBox(
                height: 100,
              ),
            ],
          ),
        ),
        DelayedWidget(
          delayDuration: Duration(milliseconds: 200), // Not required
          animationDuration: Duration(seconds: 1), // Not required
          animation: DelayedAnimations.SLIDE_FROM_BOTTOM, // Not required
          child: Container(
            margin: EdgeInsets.only(bottom: 20),
            alignment: Alignment.bottomCenter,
            child: ConstrainedBox(
              constraints: BoxConstraints(minHeight: 10, maxWidth: 500),
              child: Container(
                margin: EdgeInsets.only(left: 15, right: 15),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      //Color.fromARGB(255, 41, 42, 43),
                      primary: Color.fromARGB(255, 60, 61, 62),
                      elevation: 10,
                      shadowColor: Color.fromARGB(255, 255, 255, 255),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(7.0)),
                      minimumSize: Size(450, 55),
                      textStyle:
                          const TextStyle(fontFamily: 'Gisha', fontSize: 17)),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.calendar_month_rounded,
                        color: Color.fromARGB(255, 250, 125, 0),
                        size: 20,
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      Text(
                        'לחץ לבחירת תור',
                        style: TextStyle(
                          fontFamily: 'Gisha',
                          color: Color.fromARGB(255, 255, 255, 255),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      PageRouteBuilder(
                        transitionDuration: Duration(milliseconds: 500),
                        pageBuilder: (context, animation, secondaryAnimation) {
                          return tableSendTor(nameClient: nameClient);
                        },
                        transitionsBuilder:
                            (context, animation, secondaryAnimation, child) {
                          return FadeTransition(
                            opacity: animation,
                            child: child,
                          );
                        },
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  getVideo() {
    String nameC = nameClient.toString().split("/")[1].toString();
    return Stack(
      children: [
        DelayedWidget(
          delayDuration: Duration(milliseconds: 200), // Not required
          animationDuration: Duration(seconds: 1), // Not required
          animation: DelayedAnimations.SLIDE_FROM_TOP, // Not required
          child: Opacity(
            opacity: 0.5,
            child: Container(
              alignment: Alignment.center,
              child: Image.asset(
                'assets/עסקים/imag/$nameC.jpg',
                fit: BoxFit.cover,
                width: double.infinity,
                height: Height,
              ),
            ),
          ),
        ),
        DelayedWidget(
            delayDuration: Duration(milliseconds: 200), // Not required
            animationDuration: Duration(seconds: 1), // Not required
            animation: DelayedAnimations.SLIDE_FROM_BOTTOM, // Not required
            child: Column(
              children: [
                Container(
                  margin: EdgeInsets.only(top: 250),
                  alignment: Alignment.bottomCenter,
                  child: Text(
                      // ignore: prefer_const_constructors
                      "ברוך הבא",
                      // ignore: prefer_const_constructors
                      style: TextStyle(
                          fontFamily: 'Gisha',
                          color: Color.fromARGB(255, 255, 255, 255),
                          fontWeight: FontWeight.w600,
                          fontSize: 40.0,
                          shadows: [
                            Shadow(
                              color: Color.fromARGB(255, 135, 134, 133)
                                  .withOpacity(0.5),
                              offset: Offset(4, 2),
                              blurRadius: 0.5,
                            ),
                          ])),
                ),
                Container(
                  // margin: EdgeInsets.only(top: 300),
                  alignment: Alignment.bottomCenter,
                  child: Text(
                      // ignore: prefer_const_constructors
                      "מחכים לך במספרה",
                      // ignore: prefer_const_constructors
                      style: TextStyle(
                        fontFamily: 'Gisha',
                        color: Color.fromARGB(255, 255, 255, 255),
                        fontSize: 25.0,
                      )),
                ),
                Container(
                    margin: EdgeInsets.only(top: 50),
                    child: IconButton(
                      icon: Image.asset('assets/tow_arrow_down.png'),
                      iconSize: 52,
                      onPressed: () {
                        _scrollController.animateTo(
                          (MediaQuery.of(context).size.height - 70),
                          duration: Duration(milliseconds: 500),
                          curve: Curves.ease,
                        );
                      },
                    ))
              ],
            )),
      ],
    );
  }

  imageMyWork() {
    _pageController = PageController(viewportFraction: 0.8, initialPage: 0);
    // Timer(Duration(seconds: 5), () {
    //   print("Yeah, this line is printed after 3 seconds");
    //   if (activePage >= 0) {
    //     activePage++;
    //     _pageController.jumpToPage(activePage);
    //   }

    //   if (activePage == images.length - 1) {
    //     activePage = 0;
    //   }
    // });
    return Container(
      child: Column(
        children: [
          Card(
            color: Color.fromARGB(255, 250, 125, 0),
            shadowColor: Color.fromARGB(255, 0, 0, 0),
            shape: RoundedRectangleBorder(
              side: BorderSide(
                width: 1.5,
                color: Color.fromARGB(255, 171, 171, 171),
              ),
              borderRadius: BorderRadius.circular(5.0), //<-- SEE HERE
            ),
            elevation: 25,
            margin: EdgeInsets.all(5),
            child: Container(
              margin: EdgeInsets.only(left: 26, right: 26, top: 7, bottom: 7),
              child: Text(
                "העבודות שלנו",
                style: TextStyle(
                  fontFamily: 'Gisha',
                  fontSize: 17,
                  color: Colors.black,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Container(
            //margin: EdgeInsets.only(right: 15),
            //alignment: Alignment.centerRight,
            child: Row(
              //mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  //margin: EdgeInsets.only(right: 18),
                  child: IconButton(
                    icon: Image.asset("assets/arrow_right.png"),
                    iconSize: 32,
                    onPressed: () async {
                      setState(() {
                        if (activePage > 0) {
                          activePage--;
                          _pageController.jumpToPage(activePage);
                        }else{
                               activePage =  images.length;
                          _pageController.jumpToPage(activePage);
                        }
                      });
                    },
                  ),
                ),
                Expanded(
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width,
                    height: 200,
                    child: PageView.builder(
                        itemCount: images.length,
                        //pageSnapping: true,
                        controller: _pageController,
                        onPageChanged: (page) {
                          setState(() {
                            activePage = page;
                          });
                        },
                        itemBuilder: (context, pagePosition) {
                          String base64String = images[pagePosition];
                          Uint8List bytes = base64.decode(base64String);
                          bool active = pagePosition == activePage;
                          return GestureDetector(
                            onTap: () {
                              _showMyDialogFullImage(
                                  context, images[pagePosition]);
                              print("rgrgrg" + images[pagePosition]);
                            },
                            child: Container(
                              constraints: BoxConstraints.expand(
                                height: MediaQuery.of(context).size.height,
                                width: MediaQuery.of(context).size.width,
                              ),
                              child: Container(
                                margin: active == true
                                    ? EdgeInsets.all(10)
                                    : EdgeInsets.all(20),
                                child: AnimatedContainer(
                                  duration: Duration(milliseconds: 500),
                                  curve: Curves.linear,
                                  child: Center(
                                    child: Image.memory(
                                      bytes,
                                      fit: BoxFit.fitHeight,
                                      // height: 200,
                                      // width: 270,
                                    ), // Display the image
                                  ),
                                ),
                              ),
                            ),
                          );
                        }),
                  ),
                ),
                Container(
                  child: IconButton(
                    icon: Image.asset("assets/arrow_left.png"),
                    iconSize: 32,
                    onPressed: () async {
                      setState(() {
                        if (activePage < images.length - 1) {
                          activePage++;
                          _pageController.jumpToPage(activePage);
                        }else{
                           activePage = 0;
                          _pageController.jumpToPage(activePage);
                        }
                      });
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

//   AnimatedContainer slider(images, pagePosition, active) {
//     String base64String = "your_base64_string_here";
// Uint8List bytes = base64.decode(base64String);
//     double margin = active ? 2 : 10;
//     return AnimatedContainer(
//       duration: Duration(milliseconds: 500),
//       curve: Curves.linear,
//       margin: EdgeInsets.only(left: margin, right: margin),
//       decoration: Image.memory(bytes)
//     );
//   }

  callMe() {
    return Container(
      margin: EdgeInsets.only(left: 20, right: 15),
      //margin: EdgeInsets.only(right: 15, left: 15),
      child: DelayedWidget(
        delayDuration: Duration(milliseconds: 200), // Not required
        animationDuration: Duration(seconds: 1), // Not required
        animation: DelayedAnimations.SLIDE_FROM_BOTTOM,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                IconButton(
                  icon: Image.asset('assets/phonecall.png'),
                  iconSize: 22,
                  onPressed: () async {
                    callPhone(phoneMenger);
                  },
                ),
                GestureDetector(
                  onTap: () {
                    callPhone(phoneMenger);
                  },
                  child: Column(
                    children: [
                      Text(
                        "דבר איתנו",
                        style: TextStyle(
                          fontFamily: 'Gisha',
                          fontSize: 15,
                          color: Color.fromARGB(255, 255, 255, 255),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        phoneMenger,
                        style: TextStyle(
                          fontFamily: 'Gisha',
                          fontSize: 13,
                          color: Color.fromARGB(255, 161, 159, 159),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(
              width: 10,
            ),
            Row(
              children: [
                IconButton(
                  icon: Image.asset('assets/place.png'),
                  iconSize: 22,
                  onPressed: () async {
                    enterWaze();
                  },
                ),
                GestureDetector(
                  onTap: () {
                    enterWaze();
                  },
                  child: Column(
                    children: [
                      Text(
                        "מיקום העסק",
                        style: TextStyle(
                          fontFamily: 'Gisha',
                          fontSize: 15,
                          color: Color.fromARGB(255, 255, 255, 255),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        streetMenger + '\n' + city,
                        style: TextStyle(
                          fontFamily: 'Gisha',
                          fontSize: 13,
                          color: Color.fromARGB(255, 161, 159, 159),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  text() {}
  // ignore: non_constant_identifier_names
  HoresWork() {
    return FutureBuilder<List<StartEndWork>>(
        //future: give != "null" ? getDataStartEndHores(give) : text(),
        builder: (context, snapshot) {
      if (listStartEndWork.isNotEmpty) {
        return DelayedWidget(
          delayDuration: Duration(milliseconds: 200), // Not required
          animationDuration: Duration(seconds: 1), // Not required
          animation: DelayedAnimations.SLIDE_FROM_BOTTOM,
          child: Container(
            margin: EdgeInsets.only(left: 15, right: 15, top: 10, bottom: 10),
            decoration: BoxDecoration(
                border: Border.all(
                  color: Color.fromARGB(255, 199, 195, 195),
                ),
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(5),
                    topRight: Radius.circular(5),
                    bottomLeft: Radius.circular(5),
                    bottomRight: Radius.circular(5))),
            child: Container(
              margin: EdgeInsets.only(right: 15, left: 15, bottom: 5),
              child: Column(
                children: [
                  Container(
                    margin: EdgeInsets.only(right: 5, top: 5),
                    child: Row(
                      //mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Icon(
                          color: Color.fromARGB(255, 250, 125, 0),
                          Icons.query_builder,
                          size: 20,
                        ),
                        Text(
                          "  שעות פעילות  ",
                          style: TextStyle(
                            fontFamily: 'Gisha',
                            fontSize: 14,
                            color: Color.fromARGB(255, 242, 240, 240),
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 10,
                    width: 20,
                  ),
                  for (int i = 0; i < 6; i++)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        SizedBox(
                          height: 25,
                        ),
                        Expanded(
                          child: Container(
                            //margin: EdgeInsets.only(right: 10),
                            alignment: Alignment.topRight,
                            // ignore: prefer_const_constructors
                            child: Text(listStartEndWork[i].day,
                                maxLines: 2,
                                // ignore: prefer_const_constructors
                                // textAlign: TextAlign.right,
                                // ignore: prefer_const_constructors
                                style: TextStyle(
                                  fontFamily: 'Gisha',
                                  color: Color.fromARGB(255, 255, 255, 255),
                                  fontWeight: FontWeight.w600,
                                  fontSize: 14.0,
                                )),
                          ),
                        ),
                        Expanded(
                          child: Container(
                            //margin: EdgeInsets.only(right: 10),
                            alignment: Alignment.topLeft,
                            // ignore: prefer_const_constructors
                            child: listStartEndWork[i].start != " סגור "
                                ? Text(
                                    listStartEndWork[i].end +
                                        " - " +
                                        listStartEndWork[i].start,
                                    textDirection: TextDirection.ltr,
                                    maxLines: 2,
                                    // ignore: prefer_const_constructors
                                    // textAlign: TextAlign.right,
                                    // ignore: prefer_const_constructors
                                    style: TextStyle(
                                      fontFamily: 'Gisha',
                                      color: Color.fromARGB(255, 255, 255, 255),
                                      fontSize: 14.0,
                                    ))
                                : Container(
                                    width: 100,
                                    color: Color.fromARGB(255, 224, 220, 220),
                                    child: Text(" סגור ",
                                        textDirection: TextDirection.ltr,
                                        maxLines: 2,
                                        textAlign: TextAlign.center,
                                        // ignore: prefer_const_constructors
                                        // textAlign: TextAlign.right,
                                        // ignore: prefer_const_constructors
                                        style: TextStyle(
                                          fontFamily: 'Gisha',
                                          color:
                                              Color.fromARGB(255, 68, 67, 67),
                                          fontSize: 15.0,
                                        )),
                                  ),
                          ),
                        ),
                      ],
                    ),
                ],
              ),
            ),
          ),
        );
      } else {
        return Container(
          margin: EdgeInsets.only(top: 20),
          child: Column(
            // ignore: prefer_const_literals_to_create_immutables
            children: [
              CircularProgressIndicator(color: Colors.black),
              Container(
                child: Center(
                  child: Text("טעון נתונים...",
                      textDirection: TextDirection.rtl,
                      style: TextStyle(
                        fontFamily: 'Gisha',
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

  Future<List<StartEndWork>> getDataStartEndHores(String give) async {
    final prefsStartEndWork = await SharedPreferences.getInstance();
    final category = prefsStartEndWork.getString("listStartEndWork");
    listStartEndWork = List<StartEndWork>.from(
        List<Map<String, dynamic>>.from(jsonDecode(category.toString()))
            .map((e) => StartEndWork.fromJson(e))
            .toList());

    //   final snapshot = await ref.child("$nameClient/פעילות/$give").get();
    //   if (snapshot.exists) {
    //     for (int i = 0; i < 6; i++) {
    //       // ignore: unnecessary_new
    //       listStartEndWork.add(new StartEndWork(
    //         snapshot.children.elementAt(i).key.toString().split(",").last,
    //         snapshot.children.elementAt(i).child("התחלה").value.toString(),
    //         snapshot.children.elementAt(i).child("סיום").value.toString(),
    //       ));
    //       print("fefefffff = " +
    //           snapshot.children.elementAt(i).key.toString().split(",").last);
    //     }
    //   }
    // }

    return listStartEndWork;
  }

  IconsFrendly() {
    return Container(
      color: Color.fromARGB(255, 68, 68, 67),
      child: Column(
        children: [
          SizedBox(
            height: 10,
          ),
          Card(
            color: Color.fromARGB(255, 250, 125, 0),
            shadowColor: Color.fromARGB(255, 0, 0, 0),
            shape: RoundedRectangleBorder(
              side: BorderSide(
                width: 1.5,
                color: Color.fromARGB(255, 171, 171, 171),
              ),
              borderRadius: BorderRadius.circular(5.0), //<-- SEE HERE
            ),
            elevation: 25,
            margin: EdgeInsets.all(5),
            child: Container(
              margin: EdgeInsets.only(left: 30, right: 30, top: 7, bottom: 7),
              child: Text(
                "עקבו אחרינו",
                style: TextStyle(
                  fontFamily: 'Gisha',
                  fontSize: 16,
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // IconButton(
              //   icon: Image.asset('assets/phone.png'),
              //   iconSize: 25,
              //   onPressed: () {},
              // ),
              IconButton(
                icon: Image.asset('assets/whatspp.png'),
                iconSize: 25,
                onPressed: () {
                  whatapp(phoneMenger);
                },
              ),
              IconButton(
                icon: Image.asset('assets/face.png'),
                iconSize: 25,
                onPressed: () {
                  enterFacbook(linkFec);
                },
              ),
              IconButton(
                icon: Image.asset('assets/inst.png'),
                iconSize: 38,
                onPressed: () {
                  enterInstegram(linkIns);
                },
              ),
              IconButton(
                icon: Image.asset('assets/waze.png'),
                iconSize: 25,
                onPressed: () {
                  enterWaze();
                },
              )
            ],
          ),
          SizedBox(
            height: 10,
          ),
          Text(
            "Torit",
            style: TextStyle(
              fontFamily: 'Gisha',
              fontSize: 18,
              color: Color.fromARGB(255, 255, 255, 255),
              fontWeight: FontWeight.w600,
            ),
          ),
          // Text(
          //   "החברה שמנהלת לך את התורים",
          //   style: TextStyle(
          //     fontFamily: 'Gisha',
          //     fontSize: 15,
          //     color: Color.fromARGB(255, 255, 255, 255),
          //     fontWeight: FontWeight.w400,
          //   ),
          // ),
          SizedBox(
            height: 6,
          ),
          TextButton(
            onPressed: () async {
              String url = 'https://wa.me/+972546602833';
              if (await canLaunch(url)) {
                await launch(url);
              } else {
                throw 'Could not launch $url';
              }
            },
            child: Text(
              "רוצה כזה לעסק שלך ? לחץ כאן",
              style: TextStyle(
                fontFamily: 'Gisha',
                fontSize: 14,
                color: Color.fromARGB(255, 255, 255, 255),
                fontWeight: FontWeight.w300,
              ),
            ),
          ),
          SizedBox(
            height: 10,
          ),
        ],
      ),
    );
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

  Future<void> enterFacbook(String urlFec) async {
    String url = urlFec;
    print("Ssssssssssssssssssssss");
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  Future<void> enterInstegram(String urlnst) async {
    String url = urlnst;
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  Future<void> enterWaze() async {
    String streetcity = streetMenger + " " + city;
    String url = "https://waze.com/ul?q=$streetcity";
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
          NameDay = "יום רביעי";
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
}

class NavigationDrawer extends StatelessWidget {
  String nameClient;
  NavigationDrawer({Key? key, required this.nameClient}) : super(key: key);

  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 60),
      alignment: Alignment.topRight,
      child: SizedBox(
        height: 320,
        child: Drawer(
            width: MediaQuery.of(context).size.width / 1.5,
            backgroundColor: Color.fromARGB(235, 0, 0, 0).withAlpha(200),
            child: buildMenuItmes(context, nameClient)),
      ),
    );
  }
}

Widget buildMenuItmes(BuildContext context, String nameClient) => Container(
    padding: const EdgeInsets.only(top: 50, bottom: 60),
    child: Container(
      //alignment: Alignment.topCenter,
      child: Wrap(
        alignment: WrapAlignment.spaceBetween,
        runSpacing: 10,
        children: [
          Container(
              alignment: Alignment.center,
              child: Column(
                children: [
                  ListTile(
                    leading: const Icon(Icons.home_outlined,
                        color: Color.fromARGB(255, 250, 125, 0)),
                    title: const Text("דף הבית",
                        style: TextStyle(
                          fontFamily: 'Gisha',
                          color: Color.fromARGB(255, 255, 255, 255),
                          //fontWeight: FontWeight.bold,
                          fontSize: 20.0,
                        )),
                    onTap: () {
                      Navigator.push(
                        context,
                        PageRouteBuilder(
                          transitionDuration: Duration(milliseconds: 500),
                          pageBuilder:
                              (context, animation, secondaryAnimation) {
                            return webSites(nameClient: nameClient);
                          },
                          transitionsBuilder:
                              (context, animation, secondaryAnimation, child) {
                            return FadeTransition(
                              opacity: animation,
                              child: child,
                            );
                          },
                        ),
                      );

                      // Navigator.of(context).push(
                      //     MaterialPageRoute(builder: (context) => const adminMenu()));
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.login,
                        color: Color.fromARGB(255, 250, 125, 0)),
                    title: const Text("התחברות",
                        style: TextStyle(
                          fontFamily: 'Gisha',
                          color: Color.fromARGB(255, 255, 255, 255),
                          //fontWeight: FontWeight.bold,
                          fontSize: 20.0,
                        )),
                    onTap: () async {
                      SharedPreferences UseremailPass =
                          await SharedPreferences.getInstance();

                      if (UseremailPass.getString("UseremailPass")
                              .toString()
                              .split("|")
                              .first
                              .toString() !=
                          "null") {
                        UserCredential userCredential = await FirebaseAuth
                            .instance
                            .signInWithEmailAndPassword(
                                email: UseremailPass.getString("UseremailPass")
                                    .toString()
                                    .split("|")
                                    .first
                                    .toString(),
                                password:
                                    UseremailPass.getString("UseremailPass")
                                        .toString()
                                        .split("|")[1]
                                        .toString());

                        if (userCredential != null) {
                          Navigator.push(
                            context,
                            PageRouteBuilder(
                              transitionDuration: Duration(milliseconds: 500),
                              pageBuilder:
                                  (context, animation, secondaryAnimation) {
                                return adminMenu(
                                    nameClient: nameClient,
                                    howUser:
                                        UseremailPass.getString("UseremailPass")
                                            .toString()
                                            .split("|")
                                            .last
                                            .toString());
                              },
                              transitionsBuilder: (context, animation,
                                  secondaryAnimation, child) {
                                return FadeTransition(
                                  opacity: animation,
                                  child: child,
                                );
                              },
                            ),
                          );
                        }
                      } else {
                        Navigator.push(
                          context,
                          PageRouteBuilder(
                            transitionDuration: Duration(milliseconds: 500),
                            pageBuilder:
                                (context, animation, secondaryAnimation) {
                              return Login(
                                nameClient: nameClient,
                              );
                            },
                            transitionsBuilder: (context, animation,
                                secondaryAnimation, child) {
                              return FadeTransition(
                                opacity: animation,
                                child: child,
                              );
                            },
                          ),
                        );
                      }
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.add_business_rounded,
                        color: Color.fromARGB(255, 250, 125, 0)),
                    title: const Text("קבע תור",
                        style: TextStyle(
                          fontFamily: 'Gisha',
                          color: Color.fromARGB(255, 255, 255, 255),
                          //fontWeight: FontWeight.bold,
                          fontSize: 20.0,
                        )),
                    onTap: () {
                      Navigator.push(
                        context,
                        PageRouteBuilder(
                          transitionDuration: Duration(milliseconds: 500),
                          pageBuilder:
                              (context, animation, secondaryAnimation) {
                            return tableSendTor(nameClient: nameClient);
                          },
                          transitionsBuilder:
                              (context, animation, secondaryAnimation, child) {
                            return FadeTransition(
                              opacity: animation,
                              child: child,
                            );
                          },
                        ),
                      );
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.remove_red_eye_outlined,
                        color: Color.fromARGB(255, 250, 125, 0)),
                    title: const Text("צפה בתור קיים",
                        style: TextStyle(
                          fontFamily: 'Gisha',
                          color: Color.fromARGB(255, 255, 255, 255),
                          //fontWeight: FontWeight.bold,
                          fontSize: 20.0,
                        )),
                    onTap: () async {
                      SharedPreferences numberPhoneGetTor =
                          await SharedPreferences.getInstance();
                      String data =
                          numberPhoneGetTor.getString("dateTor").toString();
                      SharedPreferences prefsImot =
                          await SharedPreferences.getInstance();
                      print("gg444" +
                          numberPhoneGetTor.getString("phoneTor").toString());

                      (numberPhoneGetTor.getString("phoneTor").toString() ==
                              "null")
                          ? _showMyDialogTor(context, nameClient, 0)
                          : getDataTor(
                                  numberPhoneGetTor
                                      .getString("phoneTor")
                                      .toString(),
                                  nameClient)
                              .then((value) {
                              print("efefefef  " + value[0].data.toString());

                              value.isNotEmpty &&
                                      value[0].data.toString() != "null"
                                  ? _showMyDialogTor1(
                                      context,
                                      value,
                                      nameClient,
                                      numberPhoneGetTor
                                          .getString("phoneTor")
                                          .toString(),
                                      0)
                                  : _showMyDialogTorEmpty(context, nameClient);
                            });
                    },
                  ),
                  ListTile(),
                ],
              ))
        ],
      ),
    ));

// ignore: unused_element
Future<void> _showMyDialogTor(
    BuildContext context, String nameClient, int index) async {
  bool Visible = true;
  final myControllerPhone = TextEditingController();
  return showDialog<void>(
    context: context,
    barrierDismissible: false, // user must tap button!
    builder: (context) {
      return AlertDialog(
        title: Text(
          style: TextStyle(
            fontFamily: 'Gisha',
            //backgroundColor: Color.fromARGB(255, 178, 175, 175),
            color: Color.fromARGB(255, 53, 52, 52),
            fontWeight: FontWeight.bold,
            fontSize: 17.0,
          ),
          // ignore: prefer_interpolation_to_compose_strings
          // ignore: prefer_interpolation_to_compose_strings
          "התור הקרוב שלך אצלנו",
          textAlign: TextAlign.right,
        ),
        content: Container(
          height: 110,
          child: Column(
            children: [
              Visibility(
                visible: Visible,
                child: Directionality(
                    textDirection: TextDirection.rtl,
                    child: TextField(
                      controller: myControllerPhone,
                      textAlign: TextAlign.right,
                      autofocus: true,
                      // ignore: prefer_const_constructors, unnecessary_new
                      decoration: new InputDecoration(
                        prefixIcon: Icon(Icons.phone),
                        labelStyle: TextStyle(
                          fontFamily: 'Gisha',
                          color: Color.fromARGB(255, 0, 0, 0),
                        ),
                        border: OutlineInputBorder(),
                        labelText: "מספר פלאפון",
                      ),
                    )),
              ),
              SizedBox(
                height: 20,
              ),
              Visibility(
                visible: Visible,
                child: Container(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        primary: Color.fromARGB(255, 41, 42, 43),
                        elevation: 3,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5.0)),
                        minimumSize: Size(30, 40),
                        textStyle:
                            const TextStyle(fontFamily: 'Gisha', fontSize: 15)),
                    child: Text("הצג תור"),
                    onPressed: () async {
                      SharedPreferences numberPhoneGetTor =
                          await SharedPreferences.getInstance();
                      numberPhoneGetTor
                          .setString("phoneTor", myControllerPhone.text)
                          .toString();
                      String number = myControllerPhone.text;
                      getDataTor(myControllerPhone.text, nameClient)
                          .then((value) {
                        Navigator.of(context).pop();

                        value.isNotEmpty &&
                                      value[0].data.toString() != "null"
                            ? _showMyDialogTor1(
                                context, value, nameClient, number, 0)
                            : _showMyDialogTorEmpty(context, nameClient);
                      });
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
        actions: <Widget>[
          TextButton(
            child: const Text('ביטול'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}

Future<List<TorCastum>> getDataTor(String number, String nameClient) async {
  TorCastum CurrentTor =
      TorCastum("null", "null", "null", "null", "null", "null", "null", "null");
  List<TorCastum> CurrentTor1 = [];
  List<StartEndWork> listTors = [];
  DateTime nowDate = new DateTime.now();
  DateTime ccurrentDateNow = DateTime(nowDate.year, nowDate.month, nowDate.day);
  DatabaseReference refM = FirebaseDatabase.instance.ref();
  final event = await refM
      .child(nameClient)
      .child("לקוחות")
      .child(number)
      .once(DatabaseEventType.value);

  DateTime afterDate = DateTime(2023, 8, 17);

  print("wfwfwf2222 == " + ccurrentDateNow.isAfter(afterDate).toString());

  print("Fffffff11 = " + event.snapshot.hasChild("תורים").toString());
  if (!event.snapshot.hasChild("תורים")) {
    CurrentTor1.add(TorCastum(
        "null", "null", "null", "null", "null", "null", "null", "null"));
  }
  for (int i = 0; i < event.snapshot.child("תורים").children.length; i++) {
    for (int j = 0;
        j < event.snapshot.child("תורים").children.elementAt(i).children.length;
        j++) {
      DateTime afterDate = DateTime(
          int.parse(event.snapshot
              .child("תורים")
              .children
              .elementAt(i)
              .key
              .toString()
              .split("-")[0]),
          int.parse(event.snapshot
              .child("תורים")
              .children
              .elementAt(i)
              .key
              .toString()
              .split("-")[1]),
          int.parse(event.snapshot
              .child("תורים")
              .children
              .elementAt(i)
              .key
              .toString()
              .split("-")[2]));

      if (ccurrentDateNow.isAfter(afterDate).toString() == "false") {
        CurrentTor1.add(TorCastum(
            event.snapshot.child("תורים").children.elementAt(i).key.toString(),
            event.snapshot
                .child("תורים")
                .children
                .elementAt(i)
                .children
                .elementAt(j)
                .key
                .toString(),
            event.snapshot
                .child("תורים")
                .children
                .elementAt(i)
                .children
                .elementAt(j)
                .child("שירות")
                .value
                .toString(),
            event.snapshot
                .child("תורים")
                .children
                .elementAt(i)
                .children
                .elementAt(j)
                .child("שם")
                .value
                .toString(),
            event.snapshot
                .child("תורים")
                .children
                .elementAt(i)
                .children
                .elementAt(j)
                .child("טיפול")
                .value
                .toString(),
            event.snapshot
                .child("תורים")
                .children
                .elementAt(i)
                .children
                .elementAt(j)
                .child("מחיר")
                .value
                .toString(),
            event.snapshot
                .child("תורים")
                .children
                .elementAt(i)
                .children
                .elementAt(j)
                .child("זמן")
                .value
                .toString(),
            event.snapshot
                .child("תורים")
                .children
                .elementAt(i)
                .children
                .elementAt(j)
                .child("פלאפון")
                .value
                .toString()));
      }
    }
  }

  // CurrentTor = event.snapshot.hasChild("תורים")
  //     ? TorCastum(
  //         event.snapshot.child("תורים").children.last.key.toString(),
  //         event.snapshot
  //             .child("תורים")
  //             .children
  //             .last
  //             .children
  //             .last
  //             .key
  //             .toString(),
  //         event.snapshot
  //             .child("תורים")
  //             .children
  //             .last
  //             .children
  //             .last
  //             .child("שירות")
  //             .value
  //             .toString(),
  //         event.snapshot
  //             .child("תורים")
  //             .children
  //             .last
  //             .children
  //             .last
  //             .child("שם")
  //             .value
  //             .toString(),
  //         event.snapshot
  //             .child("תורים")
  //             .children
  //             .last
  //             .children
  //             .last
  //             .child("טיפול")
  //             .value
  //             .toString(),
  //         event.snapshot
  //             .child("תורים")
  //             .children
  //             .last
  //             .children
  //             .last
  //             .child("מחיר")
  //             .value
  //             .toString(),
  //         event.snapshot
  //             .child("תורים")
  //             .children
  //             .last
  //             .children
  //             .last
  //             .child("זמן")
  //             .value
  //             .toString(),
  //         event.snapshot
  //             .child("תורים")
  //             .children
  //             .last
  //             .children
  //             .last
  //             .child("פלאפון")
  //             .value
  //             .toString())
  //     : TorCastum(
  //         "null", "null", "null", "null", "null", "null", "null", "null");

  print("ccccww " + CurrentTor1.isEmpty.toString());

  return CurrentTor1;
}

Future<void> _showMyDialogTorEmpty(
    BuildContext context, String nameClient) async {
  bool Visible = true;
  final myControllerPhone = TextEditingController();
  return showDialog<void>(
    context: context,
    barrierDismissible: false, // user must tap button!
    builder: (context) {
      return AlertDialog(
        title: Text(
          style: TextStyle(
            fontFamily: 'Gisha',
            //backgroundColor: Color.fromARGB(255, 178, 175, 175),
            color: Color.fromARGB(255, 53, 52, 52),
            fontWeight: FontWeight.bold,
            fontSize: 17.0,
          ),
          // ignore: prefer_interpolation_to_compose_strings
          // ignore: prefer_interpolation_to_compose_strings
          "אין לך תור קרוב",
          textAlign: TextAlign.right,
        ),
        content: Container(
          height: 60,
          child: Center(
            child: Container(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                    primary: Color.fromARGB(255, 41, 42, 43),
                    elevation: 3,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5.0)),
                    minimumSize: Size(30, 40),
                    textStyle:
                        const TextStyle(fontFamily: 'Gisha', fontSize: 15)),
                child: Text("לחץ כאן לבחירת תור"),
                onPressed: () async {
                  Navigator.push(
                    context,
                    PageRouteBuilder(
                      transitionDuration: Duration(milliseconds: 500),
                      pageBuilder: (context, animation, secondaryAnimation) {
                        return tableSendTor(nameClient: nameClient);
                      },
                      transitionsBuilder:
                          (context, animation, secondaryAnimation, child) {
                        return FadeTransition(
                          opacity: animation,
                          child: child,
                        );
                      },
                    ),
                  );
                },
              ),
            ),
          ),
        ),
        actions: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              TextButton(
                child: const Text(
                  "התנתק",
                  style: TextStyle(fontFamily: 'Gisha', color: Colors.red),
                ),
                onPressed: () async {
                  SharedPreferences numberPhoneGetTor =
                      await SharedPreferences.getInstance();
                  SharedPreferences prefsImot =
                      await SharedPreferences.getInstance();
                  prefsImot.remove("nameCas");
                  prefsImot.remove("phoneCas");

                  numberPhoneGetTor.remove("phoneTor");
                  Navigator.of(context).pop();
                },
              ),
              TextButton(
                child: const Text("אישור"),
                onPressed: () {
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

// ignore: unused_element
Future<void> _showMyDialogFullImage(BuildContext context, String url) async {
  Uint8List bytes = base64.decode(url);

  bool Visible = true;
  final myControllerPhone = TextEditingController();
  return showDialog<void>(
    context: context,
    barrierDismissible: false, // user must tap button!
    builder: (context) {
      return AlertDialog(
        content: Stack(children: <Widget>[
          Image.memory(
            bytes,
            fit: BoxFit.cover,
            // height: 300,
            // width: 500,
          )
          // Image.network(
          // fit: BoxFit.fill,
          // url,
          // height: 300,
          // width: 500,
          // ),
        ]),
        actions: <Widget>[
          TextButton(
            child: const Text("סגור"),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}

// ignore: unused_element
Future<void> _showMyDialogTor1(BuildContext context, List<TorCastum> data,
    String nameClient, String number, int index) async {
  print("efwfwfwfw11" + number.toString());
  // final myControllerPhone = TextEditingController();
  return showDialog<void>(
    context: context,
    barrierDismissible: false, // user must tap button!
    builder: (context) {
      return AlertDialog(
        title: Text(
          style: TextStyle(
            fontFamily: 'Gisha',
            //backgroundColor: Color.fromARGB(255, 178, 175, 175),
            color: Color.fromARGB(255, 53, 52, 52),
            fontWeight: FontWeight.bold,
            fontSize: 17.0,
          ),
          // ignore: prefer_interpolation_to_compose_strings
          // ignore: prefer_interpolation_to_compose_strings
          "התור הקרוב שלך אצלנו",
          textAlign: TextAlign.right,
        ),
        content: Container(
          height: 120,
          child: Column(
            children: [
              Text(
                style: TextStyle(
                  fontFamily: 'Gisha',
                  //backgroundColor: Color.fromARGB(255, 178, 175, 175),
                  color: Color.fromARGB(255, 53, 52, 52),
                  fontWeight: FontWeight.w600,
                  fontSize: 16.0,
                ),
                // ignore: prefer_interpolation_to_compose_strings
                // ignore: prefer_interpolation_to_compose_strings
                data[index].data.split(" - ").last,
                textAlign: TextAlign.right,
              ),
              SizedBox(
                height: 20,
              ),
              Text(
                style: TextStyle(
                  fontFamily: 'Gisha',
                  //backgroundColor: Color.fromARGB(255, 178, 175, 175),
                  color: Color.fromARGB(255, 53, 52, 52),
                  fontWeight: FontWeight.w600,
                  fontSize: 16.0,
                ),
                // ignore: prefer_interpolation_to_compose_strings
                // ignore: prefer_interpolation_to_compose_strings
                data[index]
                        .startAndEnd
                        .split("-")
                        .last
                        .split(",")
                        .last
                        .substring(0, 2) +
                    ":" +
                    data[index]
                        .startAndEnd
                        .split("-")
                        .last
                        .split(",")
                        .last
                        .substring(2, 4) +
                    " - " +
                    data[index]
                        .startAndEnd
                        .split("-")
                        .last
                        .split(",")
                        .first
                        .substring(0, 2) +
                    ":" +
                    data[index]
                        .startAndEnd
                        .split("-")
                        .last
                        .split(",")
                        .first
                        .substring(2, 4),
                textAlign: TextAlign.right,
              ),
              SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        primary: Color.fromRGBO(247, 7, 7, 1),
                        elevation: 3,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5.0)),
                        minimumSize: Size(30, 40),
                        textStyle:
                            const TextStyle(fontFamily: 'Gisha', fontSize: 15)),
                    child: Text(
                      "מחק תור",
                      style: TextStyle(
                          fontFamily: 'Gisha',
                          color: Color.fromARGB(255, 255, 255, 255)),
                    ),
                    onPressed: () async {
                      Navigator.of(context).pop();
                      _showMyDialogRemoveTor(
                          context, data, nameClient, number, index);
                    },
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        primary: Color.fromARGB(255, 41, 42, 43),
                        elevation: 3,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5.0)),
                        minimumSize: Size(30, 40),
                        textStyle:
                            const TextStyle(fontFamily: 'Gisha', fontSize: 15)),
                    child: Text("שינוי תור"),
                    onPressed: () async {
                      final prefsIndex = await SharedPreferences.getInstance();
                      final prefs = await SharedPreferences.getInstance();

                      prefsIndex.setString("indexTor", "2");
                      prefs
                          .setString("userType", data[index].service)
                          .toString();
                      prefs
                          .setString("userGiveService", data[index].give)
                          .toString();

                      prefs.setString("TypeTime", data[index].time).toString();
                      prefs
                          .setString("TypePrice", data[index].price)
                          .toString();

                      prefs
                          .setString("ChangeTorData", data[index].data)
                          .toString();
                      prefs
                          .setString("ChangeTorTime", data[index].startAndEnd)
                          .toString();

                      prefs
                          .setString("ChangeTorPhone", data[index].phone)
                          .toString();
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  tableSendTor(nameClient: nameClient)));
                    },
                  ),
                ],
              )
            ],
          ),
        ),
        actions: <Widget>[
          Container(
            margin: EdgeInsets.only(left: 3),
            alignment: Alignment.center,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                data.length > 1
                    ? TextButton(
                        child: const Text("לתור הבא"),
                        onPressed: () {
                          if (index < data.length - 1) {
                            index++;
                          } else {
                            index = 0;
                          }
                          Navigator.of(context).pop();
                          _showMyDialogTor1(
                              context, data, nameClient, number, index);
                        },
                      )
                    : Container(),
                TextButton(
                  child: const Text("אישור"),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            ),
          ),
          SizedBox(
            height: 20,
          ),
          Center(
            child: TextButton(
              child: const Text(
                "התנתק",
                style: TextStyle(fontFamily: 'Gisha', color: Colors.red),
              ),
              onPressed: () async {
                SharedPreferences numberPhoneGetTor =
                    await SharedPreferences.getInstance();
                SharedPreferences prefsImot =
                    await SharedPreferences.getInstance();
                prefsImot.remove("nameCas");
                prefsImot.remove("phoneCas");

                numberPhoneGetTor.remove("phoneTor");
                Navigator.of(context).pop();
              },
            ),
          )
        ],
      );
    },
  );
}

Future<void> _showMyDialogRemoveTor(BuildContext context, List<TorCastum> data,
    String nameClient, String number, int index) async {
  bool Visible = true;
  final myControllerPhone = TextEditingController();
  return showDialog<void>(
    context: context,
    barrierDismissible: false, // user must tap button!
    builder: (context) {
      return AlertDialog(
        title: Text(
          style: TextStyle(
            fontFamily: 'Gisha',
            //backgroundColor: Color.fromARGB(255, 178, 175, 175),
            color: Color.fromARGB(255, 53, 52, 52),
            fontWeight: FontWeight.bold,
            fontSize: 17.0,
          ),
          // ignore: prefer_interpolation_to_compose_strings
          // ignore: prefer_interpolation_to_compose_strings
          "מחק תור קיים",
          textAlign: TextAlign.right,
        ),
        content: Container(
          height: 60,
          child: Center(
            child: Text(
              style: TextStyle(
                fontFamily: 'Gisha',
                //backgroundColor: Color.fromARGB(255, 178, 175, 175),
                color: Color.fromARGB(255, 53, 52, 52),
                fontWeight: FontWeight.w600,
                fontSize: 16.0,
              ),
              // ignore: prefer_interpolation_to_compose_strings
              // ignore: prefer_interpolation_to_compose_strings
              "בטוח שברצונך למחוק את התור ?",
              textAlign: TextAlign.right,
            ),
          ),
        ),
        actions: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              TextButton(
                child: const Text("ביטול"),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              TextButton(
                child: const Text("אישור"),
                onPressed: () async {
                  Navigator.of(context).pop();
                  DateTime rangeStart1 = new DateTime.now();

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

                  String give = data[index].give,
                      dateCancelCurrent = data[index].data,
                      time = data[index].startAndEnd;

                  String StartTime = data[index]
                          .startAndEnd
                          .split(",")
                          .first
                          .substring(0, 2) +
                      ":" +
                      data[index].startAndEnd.split(",").first.substring(2, 4);

                  DatabaseReference ref111 = FirebaseDatabase.instance.ref(
                      "$nameClient/לקוחות/$number/תורים" +
                          "/" +
                          dateCancelCurrent +
                          "/" +
                          time);
                  ref111.remove();

                  DatabaseReference ref1 = FirebaseDatabase.instance.ref(
                      "$nameClient/תורים/כללי/$dateCancelCurrent" +
                          "/" +
                          data[index].startAndEnd +
                          " | " +
                          give);
                  ref1.remove();

                  DatabaseReference ref11 = FirebaseDatabase.instance.ref(
                      "$nameClient/תורים/עובדים/$give" +
                          "/" +
                          dateCancelCurrent +
                          "/" +
                          time);
                  ref11.remove().then((value) async {
                    DatabaseReference refM = FirebaseDatabase.instance.ref();

                    DatabaseReference refRmoveTorim = FirebaseDatabase.instance
                        .ref("torim/$nowdateTorim/$number/$StartTime");
                    refRmoveTorim.remove();

                    String name = data[index].name;
                    final snapshot =
                        await refM.child("$nameClient/פרטי העסק/טלפון").get();
                    String dataRemove = dateCancelCurrent.split(" - ").last;
                    String Start = time.split(",").first.substring(0, 2) +
                        ":" +
                        time.split(",").first.substring(2, 4);

                    var headers = {
                      'Content-Type': 'application/x-www-form-urlencoded'
                    };
                    var request = http.Request(
                        'POST',
                        Uri.parse(
                            'https://api.ultramsg.com/instance51382/messages/chat'));
                    request.bodyFields = {
                      'token': '29c9fnwlhvrbrlqa',
                      'to': snapshot.value.toString(),
                      'body': "בוטל תור !"
                          " $name"
                          "\n"
                          "$dataRemove"
                          " | "
                          "$Start"
                    };
                    request.headers.addAll(headers);

                    http.StreamedResponse response = await request.send();

                    if (response.statusCode == 200) {
                      print(await response.stream.bytesToString());
                    } else {
                      print(response.reasonPhrase);
                    }
                    if (index == 0) {
                      Navigator.of(context).pop();

                      _showMyDialogTorEmpty(context, nameClient);
                    } else {
                      data.removeAt(index);
                      index = index - 1;
                      Navigator.of(context).pop();

                      _showMyDialogTor1(
                          context, data, nameClient, number, index);
                    }
                  });
                },
              ),
            ],
          ),
        ],
      );
    },
  );
}

class TorCastum {
  String data = "";
  String startAndEnd = "";
  String give = "";
  String name = "";
  String service = "";
  String price = "";
  String time = "";
  String phone = "";
  TorCastum(this.data, this.startAndEnd, this.give, this.name, this.service,
      this.price, this.time, this.phone);
}

class TorRemmber {
  String data = "";
  String startAndEnd = "";
  String give = "";
  String name = "";
  String phone = "";
  TorRemmber(this.data, this.startAndEnd, this.give, this.name, this.phone);
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
