// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, unused_field, non_constant_identifier_names, prefer_interpolation_to_compose_strings, use_build_context_synchronously

import 'dart:async';
import 'dart:convert';
import 'dart:html';
import 'package:animations/animations.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:my_tor/Login.dart';
import 'package:my_tor/main.dart';
import 'package:my_tor/tableTor/times.dart';
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
import 'package:photo_view/photo_view.dart';

class webSitesW extends StatelessWidget {
  final String nameClient, nameBis;

  webSitesW({Key? key, required this.nameClient, required this.nameBis})
      : super(key: key);
  Widget build(BuildContext context) {
    // ignore: prefer_const_constructors
    return Scaffold(
        body: Directionality(
            textDirection: TextDirection.rtl,
            // ignore: sort_child_properties_last
            child: Scaffold(
              backgroundColor: Color.fromARGB(255, 240, 240, 240),
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
                      color: Color.fromARGB(255, 255, 255, 255),
                      fontWeight: FontWeight.bold,
                      fontSize: 17.0,
                    )),
                iconTheme:
                    IconThemeData(color: Color.fromARGB(255, 255, 255, 255)),
                backgroundColor: Color.fromARGB(255, 208, 117, 98),
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
  List<TorRemmber> listTodayTors = [];
  String NameDay = "",
      NumberMunth = "",
      NameMonth = "",
      NameMonthForDate = "",
      dateNow = "";
  String textCustum = "", linkFec = "null", linkIns = "null";
  double? Height;
  Timer? _timer;
  int activePage = 0, pagePosition1 = 0;
  late PageController _pageController;
  ImageProvider logo = AssetImage("assets/barber1.jpg");
  AssetImage? assetImage;
  bool VisMess = true;
  String MessMenger = "null",
      phoneMenger = "null",
      streetMenger = "null",
      city = "";
  // List<String> images = [
  //   'https://i.postimg.cc/zB9hqQqv/1.jpg'
  //       'https://i.postimg.cc/SNb95HZt/2.jpg',
  //   'https://i.postimg.cc/VsCMKzFC/3.jpg',
  //   'https://i.postimg.cc/7h02hNLV/4.jpg',
  //   'https://i.postimg.cc/FsbSQG8F/5.jpg',
  //   'https://i.postimg.cc/Z5TdYpz8/6.webp',
  // ];

  List<String> images = [];
  String image =
      'https://images.unsplash.com/photo-1522205408450-add114ad53fe?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=368f45b0888aeb0b7b08e3a1084d3ede&auto=format&fit=crop&w=1950&q=80';
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
    getCall();

    assetImage = AssetImage("assets/barber1.jpg");
    DateTime now = DateTime.now();
    DateTime day1 = DateTime(now.year, now.month, now.day);
    NumberMunth = day1.toString().split("-").last.split(" ").first;
    getImage();

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
    setClickNull().then((value) {
      getDataStartEndHores(value.toString());
    });
    getTimeWorkToday();
    riestIndex();
    String namec = nameClient.split("/").first.toString();

    loadAssetMedia(namec).then(
      (value) {
        print("wddwddd-- ");
        setState(() {
          linkFec = value.split("|").first;
          linkIns = value.split("|").last;
        });
        print("wddwdddwwwvv--  " + linkFec);
      },
    );
    super.initState();
  }

  riestIndex() async {
    final prefsIndex = await SharedPreferences.getInstance();
    prefsIndex.setString("indexTor", "0");
  }

  Future<String> loadAssetMedia(String namec) async {
    String user = "assets/link_madie_frinde/" + "$namec" + ".txt";

    return await DefaultAssetBundle.of(context).loadString(user);
  }

  getImage() async {
    SharedPreferences prefsListImageWork =
        await SharedPreferences.getInstance();
    final category = prefsListImageWork.getString("ListImageWork");
    images = List<String>.from(json.decode(category.toString()));
    print("Fffffcc--1 " + images.length.toString());
  }

  getCall() async {
    SharedPreferences prefsMyData = await SharedPreferences.getInstance();

    MessMenger = prefsMyData.getString("textMessage").toString();
    phoneMenger = prefsMyData.getString("Phone").toString();
    streetMenger = prefsMyData.getString("Street").toString();
    city = prefsMyData.getString("City").toString();
    print("Fffffcc--1 " + prefsMyData.getString("Phone").toString());
  }

  //Future<List<StartEndWork>>
  getTimeWorkToday() async {
    DatabaseReference refM = FirebaseDatabase.instance.ref();
    // final event1 = await refM
    //     .child(nameClient)
    //     .child("תורים")
    //     .child("כללי")
    //     .child(dateNow)
    //     .once(DatabaseEventType.value);

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

        print("efefff bb " + listTodayTors[i].startAndEnd);
      }
    });
  }

  Future<String> loadAsset(String namec) async {
    String user = "assets/textUsers/" + "$namec" + ".txt";
    return await DefaultAssetBundle.of(context).loadString(user);
  }

  @override
  Widget build(BuildContext context) {
    Size size = WidgetsBinding.instance.window.physicalSize;
    late PageController _pageController;
    Height = MediaQuery.of(context).size.height - 70;
    String namec = nameClient.split("/").first.toString();
    if (textCustum == "") {
      loadAsset(namec).then(
        (value) {
          print("wddwddd-- ");
          setState(() {
            textCustum = value;
          });
        },
      );
    }

    Container(
      child: Text(""),
    );

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
                              Duration(milliseconds: 550), // Not required
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
                                    color: Color.fromARGB(255, 208, 117, 98),
                                    //margin: EdgeInsets.all(30),
                                    shadowColor: Color.fromARGB(255, 0, 0, 0),
                                    shape: RoundedRectangleBorder(
                                        // side: BorderSide(
                                        //   // width: 3.0,
                                        //   color:
                                        //       Color.fromARGB(255, 19, 19, 19),
                                        // ),
                                        borderRadius: BorderRadius.only(
                                            bottomLeft: Radius.circular(25),
                                            bottomRight: Radius.circular(
                                                25)) //<-- SEE HERE
                                        ),
                                    elevation: 25,
                                    child: Column(
                                      children: [
                                        ConstrainedBox(
                                          constraints: BoxConstraints(
                                              minHeight: 10, maxWidth: 500),
                                          child: Container(
                                              margin: EdgeInsets.all(20),
                                              //height: 150,
                                              width: MediaQuery.of(context)
                                                  .size
                                                  .width,
                                              child: Text(MessMenger,
                                                  textAlign: TextAlign.center,
                                                  style: TextStyle(
                                                    fontSize: 17,
                                                    color: Color.fromARGB(
                                                        255, 8, 8, 8),
                                                    fontWeight: FontWeight.w600,
                                                  ))),
                                        ),
                                        IconButton(
                                          icon: Icon(Icons.clear),
                                          iconSize: 23,
                                          color: Colors.white,
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
                color: Color.fromARGB(255, 255, 255, 255),
                shadowColor: Color.fromARGB(255, 230, 227, 227),
                shape: RoundedRectangleBorder(
                  side: BorderSide(
                    width: 1.5,
                    color: Color.fromARGB(255, 208, 117, 98),
                  ),
                  borderRadius: BorderRadius.circular(5.0), //<-- SEE HERE
                ),
                elevation: 25,
                margin: EdgeInsets.all(5),
                child: Container(
                  margin:
                      EdgeInsets.only(left: 30, right: 30, top: 7, bottom: 7),
                  child: Text(
                    "קצת עלינו",
                    style: TextStyle(
                      fontSize: 17,
                      color: Color.fromARGB(255, 208, 117, 98),
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
                                fontSize: 20,
                                color: Color.fromARGB(255, 61, 61, 61),
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
                  color: Color.fromARGB(255, 157, 154, 154),
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
                  color: Color.fromARGB(255, 157, 154, 154),
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
                  color: Color.fromARGB(255, 157, 154, 154),
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
                  color: Color.fromARGB(255, 157, 154, 154),
                  height: 40,
                  thickness: 1,
                ),
              ),
              ConstrainedBox(
                constraints: BoxConstraints(minHeight: 10, maxWidth: 500),
                child: IconsFrendly(),
              ),

              SizedBox(
                height: 85,
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
                      primary: Color.fromARGB(255, 255, 255, 255),
                      elevation: 30,
                      shadowColor: Color.fromARGB(255, 208, 117, 98),
                      shape: RoundedRectangleBorder(
                        side: BorderSide(
                          width: 1.5,
                          color: Color.fromARGB(255, 208, 117, 98),
                        ),
                        borderRadius: BorderRadius.circular(7.0), //<-- SEE HERE
                      ),
                      minimumSize: Size(450, 55),
                      textStyle: const TextStyle(fontSize: 17)),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.calendar_month_rounded,
                        color: Color.fromARGB(255, 208, 117, 98),
                        size: 20,
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      Text(
                        'לחץ לבחירת תור',
                        style: TextStyle(
                          color: Color.fromARGB(255, 208, 117, 98),
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
    String nameC = nameClient.toString().split("/").first.toString();
    return Container(
      color: Color.fromARGB(255, 55, 55, 55),
      child: Stack(
        alignment: Alignment.center, // <---------
        children: [
          DelayedWidget(
              delayDuration: Duration(milliseconds: 200), // Not required
              animationDuration: Duration(seconds: 2), // Not required
              animation: DelayedAnimations.SLIDE_FROM_TOP, // Not required
              child: Opacity(
                opacity: 0.5,
                child: Container(
                  alignment: Alignment.center,
                  child: Image.asset(
                    'assets/vfvfv.jpg',
                    fit: BoxFit.fill,
                    width: double.infinity,
                    height: Height,
                  ),
                ),
              )),
          Column(
            children: [
              DelayedWidget(
                delayDuration: Duration(milliseconds: 200), // Not required
                animationDuration: Duration(seconds: 1), // Not required
                animation: DelayedAnimations.SLIDE_FROM_BOTTOM, // Not required
                child: Container(
                    //margin: EdgeInsets.only(top: 230),
                    alignment: Alignment.bottomCenter,
                    child: Column(
                      children: [
                        Text(
                            // ignore: prefer_const_constructors
                            "ברוך הבא",
                            // ignore: prefer_const_constructors
                            style: TextStyle(
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
                        Container(
                          // margin: EdgeInsets.only(top: 300),
                          alignment: Alignment.bottomCenter,
                          child: Text(
                              // ignore: prefer_const_constructors
                              "מחכים לך",
                              // ignore: prefer_const_constructors
                              style: TextStyle(
                                color: Color.fromARGB(255, 255, 255, 255),
                                fontSize: 27.0,
                              )),
                        ),
                        Container(
                            margin: EdgeInsets.only(top: 30),
                            child: IconButton(
                              icon:
                                  Image.asset('assets/tow_arrow_down_who.png'),
                              iconSize: 45,
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
              ),
            ],
          ),
        ],
      ),
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
      //color: Color.fromARGB(255, 230, 230, 230),
      child: Column(
        children: [
          Card(
            color: Color.fromARGB(255, 255, 255, 255),
            shadowColor: Color.fromARGB(255, 230, 227, 227),
            shape: RoundedRectangleBorder(
              side: BorderSide(
                width: 1.5,
                color: Color.fromARGB(255, 208, 117, 98),
              ),
              borderRadius: BorderRadius.circular(5.0), //<-- SEE HERE
            ),
            elevation: 25,
            margin: EdgeInsets.all(5),
            child: Container(
              margin: EdgeInsets.only(left: 30, right: 30, top: 7, bottom: 7),
              child: Text(
                "העבודות שלנו",
                style: TextStyle(
                  fontSize: 17,
                  color: Color.fromARGB(255, 208, 117, 98),
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
                    icon: Image.asset("assets/arrow_right_who.png"),
                    iconSize: 32,
                    onPressed: () async {
                      setState(() {
                        if (activePage > 0) {
                          activePage--;
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
                                child: slider(images, pagePosition, active)),
                          );
                          //return slider(images, pagePosition, active);
                        }),
                  ),
                ),
                Container(
                  child: IconButton(
                    icon: Image.asset("assets/arrow_left_who.png"),
                    iconSize: 32,
                    onPressed: () async {
                      setState(() {
                        if (activePage < images.length - 1) {
                          activePage++;
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

  AnimatedContainer slider(images, pagePosition, active) {
    double margin = active ? 2 : 10;
    return AnimatedContainer(
      // height: 200,
      // width: 200,
      duration: Duration(milliseconds: 500),
      curve: Curves.linear,
      margin: EdgeInsets.only(left: margin, right: margin),
      decoration: BoxDecoration(
          image: DecorationImage(image: NetworkImage(images[pagePosition]))),
    );
  }

  callMe() {
    return Container(
      margin: EdgeInsets.only(left: 20, right: 15),
      //margin: EdgeInsets.only(right: 15, left: 15),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              IconButton(
                icon: Image.asset('assets/phonecall_who.png'),
                iconSize: 5,
                onPressed: () async {
                  callPhone("324324");
                },
              ),
              Column(
                children: [
                  Text(
                    "דבר איתנו",
                    style: TextStyle(
                      fontSize: 15,
                      color: Color.fromARGB(255, 5, 5, 5),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    phoneMenger,
                    style: TextStyle(
                      fontSize: 13,
                      color: Color.fromARGB(255, 161, 159, 159),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ],
          ),
          SizedBox(
            width: 10,
          ),
          Row(
            children: [
              IconButton(
                icon: Image.asset('assets/place_who.png'),
                iconSize: 5,
                onPressed: () async {
                  enterWaze();
                },
              ),
              Column(
                children: [
                  Text(
                    "מיקום העסק",
                    style: TextStyle(
                      fontSize: 15,
                      color: Color.fromARGB(255, 7, 7, 7),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    streetMenger + '\n' + city,
                    style: TextStyle(
                      fontSize: 13,
                      color: Color.fromARGB(255, 161, 159, 159),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ],
          )
        ],
      ),
    );
  }

  text() {}
  // ignore: non_constant_identifier_names
  HoresWork() {
    return FutureBuilder(
        future: give != "null" ? getDataStartEndHores(give) : text(),
        builder: (context, snapshot) {
          if (listStartEndWork.isNotEmpty) {
            return Container(
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
                            color: Color.fromARGB(255, 208, 117, 98),
                            Icons.query_builder,
                            size: 20,
                          ),
                          Text(
                            "  שעות פעילות  ",
                            style: TextStyle(
                              fontSize: 14,
                              color: Color.fromARGB(255, 11, 11, 11),
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
                                    color: Color.fromARGB(255, 16, 15, 15),
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
                                      textAlign: TextAlign.center,
                                      maxLines: 2,
                                      // ignore: prefer_const_constructors
                                      // textAlign: TextAlign.right,
                                      // ignore: prefer_const_constructors
                                      style: TextStyle(
                                        color: Color.fromARGB(255, 9, 9, 9),
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

    return listStartEndWork;
  }

  IconsFrendly() {
    return Container(
      color: Color.fromARGB(255, 234, 207, 207),
      child: Column(
        children: [
          SizedBox(
            height: 10,
          ),
          Card(
            color: Color.fromARGB(255, 255, 255, 255),
            shadowColor: Color.fromARGB(255, 230, 227, 227),
            shape: RoundedRectangleBorder(
              side: BorderSide(
                width: 1.5,
                color: Color.fromARGB(255, 208, 117, 98),
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
                  fontSize: 17,
                  color: Color.fromARGB(255, 208, 117, 98),
                  fontWeight: FontWeight.w600,
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
                  whatapp("0524228073");
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
                iconSize: 40,
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
            "Tor4You",
            style: TextStyle(
              fontSize: 16,
              color: Color.fromARGB(255, 2, 2, 2),
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(
            height: 5,
          ),
          Text(
            "רוצה כזה לעסק שלך ? לחץ כאן",
            style: TextStyle(
              fontSize: 15,
              color: Color.fromARGB(255, 4, 4, 4),
              fontWeight: FontWeight.w500,
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
      alignment: Alignment.topCenter,
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
    padding: const EdgeInsets.only(top: 50, right: 25, bottom: 60),
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
                        color: Color.fromARGB(255, 208, 117, 98)),
                    title: const Text("דף הבית",
                        style: TextStyle(
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
                            return webSitesW(
                              nameClient: nameClient,
                              nameBis: nameBis,
                            );
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
                        color: Color.fromARGB(255, 208, 117, 98)),
                    title: const Text("קבע תור",
                        style: TextStyle(
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
                        color: Color.fromARGB(255, 208, 117, 98)),
                    title: const Text("צפה בתור קיים",
                        style: TextStyle(
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

                      prefsImot.getString("phoneCas").toString() == "null"
                          ? _showMyDialogTor(context, nameClient, 0)
                          : getDataTor(
                                  prefsImot.getString("phoneCas").toString(),
                                  nameClient)
                              .then((value) {
                              value[0].data != "null"
                                  ? _showMyDialogTor1(
                                      context,
                                      value,
                                      nameClient,
                                      prefsImot
                                          .getString("phoneCas")
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
Future<void> _showMyDialogFullImage(BuildContext context, String url) async {
  bool Visible = true;
  final myControllerPhone = TextEditingController();
  return showDialog<void>(
    context: context,
    barrierDismissible: false, // user must tap button!
    builder: (context) {
      return AlertDialog(
        content: Stack(children: <Widget>[
          Image.network(
            fit: BoxFit.fill,
            url,
            height: 300,
            width: 500,
          ),
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
                        textStyle: const TextStyle(fontSize: 15)),
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

                        print("dwdwdd  " + value[0].startAndEnd.toString());
                        print("dwdwdd  " + value[0].give);
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
  DatabaseReference refM = FirebaseDatabase.instance.ref();
  final event = await refM
      .child(nameClient)
      .child("לקוחות")
      .child(number)
      .once(DatabaseEventType.value);

  print("Fffffff11 = " + event.snapshot.hasChild("תורים").toString());
  if (!event.snapshot.hasChild("תורים")) {
    CurrentTor1.add(TorCastum(
        "null", "null", "null", "null", "null", "null", "null", "null"));
  }
  for (int i = 0; i < event.snapshot.child("תורים").children.length; i++) {
    for (int j = 0;
        j < event.snapshot.child("תורים").children.elementAt(i).children.length;
        j++) {
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

      print("Fffffff = " +
          event.snapshot
              .child("תורים")
              .children
              .elementAt(i)
              .children
              .elementAt(j)
              .value
              .toString());
    }
  }

  CurrentTor = event.snapshot.hasChild("תורים")
      ? TorCastum(
          event.snapshot.child("תורים").children.last.key.toString(),
          event.snapshot
              .child("תורים")
              .children
              .last
              .children
              .last
              .key
              .toString(),
          event.snapshot
              .child("תורים")
              .children
              .last
              .children
              .last
              .child("שירות")
              .value
              .toString(),
          event.snapshot
              .child("תורים")
              .children
              .last
              .children
              .last
              .child("שם")
              .value
              .toString(),
          event.snapshot
              .child("תורים")
              .children
              .last
              .children
              .last
              .child("טיפול")
              .value
              .toString(),
          event.snapshot
              .child("תורים")
              .children
              .last
              .children
              .last
              .child("מחיר")
              .value
              .toString(),
          event.snapshot
              .child("תורים")
              .children
              .last
              .children
              .last
              .child("זמן")
              .value
              .toString(),
          event.snapshot
              .child("תורים")
              .children
              .last
              .children
              .last
              .child("פלאפון")
              .value
              .toString())
      : TorCastum(
          "null", "null", "null", "null", "null", "null", "null", "null");

  print("ccccww " + CurrentTor.data);

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
                    textStyle: const TextStyle(fontSize: 15)),
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
                  "יציאה",
                  style: TextStyle(color: Colors.red),
                ),
                onPressed: () async {
                  SharedPreferences numberPhoneGetTor =
                      await SharedPreferences.getInstance();
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
                        textStyle: const TextStyle(fontSize: 15)),
                    child: Text(
                      "מחק תור",
                      style:
                          TextStyle(color: Color.fromARGB(255, 255, 255, 255)),
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
                        textStyle: const TextStyle(fontSize: 15)),
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
          Row(
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
          SizedBox(
            height: 20,
          ),
          Center(
            child: TextButton(
              child: const Text(
                "יציאה",
                style: TextStyle(color: Colors.red),
              ),
              onPressed: () async {
                SharedPreferences numberPhoneGetTor =
                    await SharedPreferences.getInstance();
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
                  String give = data[index].give,
                      dateCancelCurrent = data[index].data,
                      time = data[index].startAndEnd;

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
                  });

                  Navigator.of(context).pop();
                  Navigator.of(context).pop();
                  if (index == 0) {
                    _showMyDialogTorEmpty(context, nameClient);
                  } else {
                    data.removeAt(index);
                    index = index - 1;
                    _showMyDialogTor1(context, data, nameClient, number, index);
                  }
                },
              ),
            ],
          )
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
