// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:my_tor/main.dart';
import 'package:my_tor/tableTor/finish.dart';
import 'package:my_tor/tableTor/times.dart';
import 'package:my_tor/tableTor/type_server.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:step_progress_indicator/step_progress_indicator.dart';
import '../mengerBus/menuAndReshi/adminMenu.dart';
import '../websites/beforWeb.dart';
import '../websites/web_sites.dart';
import 'give_Service.dart';
import 'dart:io' show Platform;

class tableSendTor extends StatefulWidget {
  final myControllerImage = TextEditingController();
  final String nameClient;
  tableSendTor({Key? key, required this.nameClient}) : super(key: key);

  @override
  State<tableSendTor> createState() => list(nameClient);
}

riestIndex() async {
  final prefsIndex = await SharedPreferences.getInstance();
  prefsIndex.setString("indexTor", "0");
}

class list extends State<tableSendTor> {
  int step1 = 0, currentStep = 0;
  List<String> test = ["סוג שירות", "נותן שירות", "תאריך ושעה", "סיום"];
  List<String> listTor = ["סוג שירות", "תאריך ושעה", "סיום"];
  String nameClient;
  list(this.nameClient);
  ScrollController _scrollController = ScrollController();
  int index = 0;
  //final isWindows = Platform.operatingSystem;

  @override
  void initState() {
    //riestIndex();
    super.initState();
  }

  scrollToTop() {
    print("scroolll -- ");

    _scrollController.jumpTo(0);
  }

  @override
  Widget build(BuildContext context) {
    bool web = Theme.of(context).platform == TargetPlatform.windows;

    setState(() {
      currentStep;
      getIndex();
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
                                                topRight: Radius.circular(6))),
                                        margin: EdgeInsets.all(10),
                                        child: Column(
                                          children: [
                                            step(),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Container(
                                                  margin: EdgeInsets.all(15),
                                                  alignment:
                                                      Alignment.bottomRight,
                                                  child: ElevatedButton(
                                                    style: ElevatedButton
                                                        .styleFrom(
                                                            primary:
                                                                Color.fromARGB(
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
                                                    child: Icon(Icons
                                                        .arrow_back_outlined),
                                                    onPressed: () async {
                                                      SharedPreferences
                                                          prefsMangTor =
                                                          await SharedPreferences
                                                              .getInstance();
                                                      prefsMangTor.setString(
                                                          "MangTor", "false");
                                                      backButton();
                                                    },
                                                  ),
                                                ),
                                                currentStep > 0
                                                    ? Container(
                                                        margin:
                                                            EdgeInsets.all(15),
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
                                                                  elevation: 3,
                                                                  // shape: RoundedRectangleBorder(
                                                                  //     borderRadius: BorderRadius.circular(32.0)),
                                                                  minimumSize:
                                                                      Size(20,
                                                                          40),
                                                                  textStyle:
                                                                      const TextStyle(
                                                                          fontSize:
                                                                              23)),
                                                          child:
                                                              Text("חזור לאתר"),
                                                          onPressed: () async {
                                                            SharedPreferences
                                                                prefsMangTor =
                                                                await SharedPreferences
                                                                    .getInstance();
                                                            SharedPreferences
                                                                UseremailPass =
                                                                await SharedPreferences
                                                                    .getInstance();

                                                            if (prefsMangTor
                                                                    .getString(
                                                                        "MangTor")
                                                                    .toString() ==
                                                                "true") {
                                                              prefsMangTor
                                                                  .setString(
                                                                      "MangTor",
                                                                      "false");
                                                            String howUser =  UseremailPass
                                                                      .getString(
                                                                          "UseremailPass")
                                                                  .toString()
                                                                  .split("|")
                                                                  .last
                                                                  .toString();
                                                              // ignore: use_build_context_synchronously
                                                              Navigator.push(
                                                                context,
                                                                PageRouteBuilder(
                                                                  transitionDuration:
                                                                      Duration(
                                                                          milliseconds:
                                                                              500),
                                                                  pageBuilder: (context,
                                                                      animation,
                                                                      secondaryAnimation) {
                                                                    return adminMenu(
                                                                      nameClient:
                                                                          nameClient,
                                                                          
                                                                          howUser: howUser,
                                                                    );
                                                                  },
                                                                  transitionsBuilder: (context,
                                                                      animation,
                                                                      secondaryAnimation,
                                                                      child) {
                                                                    return FadeTransition(
                                                                      opacity:
                                                                          animation,
                                                                      child:
                                                                          child,
                                                                    );
                                                                  },
                                                                ),
                                                              );
                                                            } else {
                                                              // ignore: use_build_context_synchronously
                                                              Navigator.push(
                                                                context,
                                                                PageRouteBuilder(
                                                                  transitionDuration:
                                                                      Duration(
                                                                          milliseconds:
                                                                              500),
                                                                  pageBuilder: (context,
                                                                      animation,
                                                                      secondaryAnimation) {
                                                                    return webSites(
                                                                      nameClient:
                                                                          nameClient,
                                                                    );
                                                                  },
                                                                  transitionsBuilder: (context,
                                                                      animation,
                                                                      secondaryAnimation,
                                                                      child) {
                                                                    return FadeTransition(
                                                                      opacity:
                                                                          animation,
                                                                      child:
                                                                          child,
                                                                    );
                                                                  },
                                                                ),
                                                              );
                                                            }
                                                          },
                                                        ),
                                                      )
                                                    : Container(),
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
                      //controller: _scrollController,
                      children: [
                        Container(
                          child: Directionality(
                            textDirection: TextDirection.rtl,
                            child: Container(
                                decoration: BoxDecoration(
                                    border: Border.all(
                                      color: Color.fromARGB(255, 190, 190, 190),
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
                                            child:
                                                Icon(Icons.arrow_back_outlined),
                                            onPressed: () {
                                              backButton();
                                            },
                                          ),
                                        ),
                                        currentStep > 0
                                            ? Container(
                                                margin: EdgeInsets.all(15),
                                                alignment:
                                                    Alignment.bottomRight,
                                                child: ElevatedButton(
                                                  style:
                                                      ElevatedButton.styleFrom(
                                                          primary:
                                                              Color.fromARGB(
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
                                                  child: Text("חזור לאתר"),
                                                  onPressed: () {
                                                    Navigator.push(
                                                      context,
                                                      PageRouteBuilder(
                                                        transitionDuration:
                                                            Duration(
                                                                milliseconds:
                                                                    500),
                                                        pageBuilder: (context,
                                                            animation,
                                                            secondaryAnimation) {
                                                          return webSites(
                                                            nameClient:
                                                                nameClient,
                                                          );
                                                        },
                                                        transitionsBuilder:
                                                            (context,
                                                                animation,
                                                                secondaryAnimation,
                                                                child) {
                                                          return FadeTransition(
                                                            opacity: animation,
                                                            child: child,
                                                          );
                                                        },
                                                      ),
                                                    );
                                                  },
                                                ),
                                              )
                                            : Container(),
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
    );
  }

  backButton() async {
    final prefsIndex = await SharedPreferences.getInstance();

    setState(() {
      if (currentStep > 0) {
        currentStep--;
        prefsIndex.setString("scrollTop", "true");
        prefsIndex.setString("indexTor", currentStep.toString());
      } else {
        Navigator.push(
          context,
          PageRouteBuilder(
            transitionDuration: Duration(milliseconds: 500),
            pageBuilder: (context, animation, secondaryAnimation) {
              return webSites(
                nameClient: nameClient,
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
      }
    });
  }

  getIndex() async {
    final prefsIndex = await SharedPreferences.getInstance();
    if (prefsIndex.getString("scrollTop").toString() == "true") {
      scrollToTop();
      prefsIndex.setString("scrollTop", "false");
    }

    if (prefsIndex.getString("indexTor").toString() != "0") {
      setState(() {
        currentStep = int.parse(prefsIndex.getString("indexTor").toString());
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
                      return GestureDetector(
                          onTap: () async {
                            if (index < currentStep) {
                              final prefsIndex =
                                  await SharedPreferences.getInstance();

                              setState(() {
                                currentStep = index;
                              });
                              prefsIndex.setString(
                                  "indexTor", currentStep.toString());
                            }
                            print("wfwfwfwf + " + test[index]);
                          },
                          child: Container(
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
              child: typeServer(),
              margin: EdgeInsets.all(10),
            ),
          if (currentStep == 1)
            Container(
              margin: EdgeInsets.all(10),
              child: giveService(nameClient: nameClient),
            ),
          if (currentStep == 2)
            Container(
                margin: EdgeInsets.all(10),
                child: times(nameClient: nameClient)),
          if (currentStep == 3)
            Container(
                margin: EdgeInsets.all(10),
                child: finish(
                  nameClient: nameClient,
                )),
        ],
      ),
    );
  }
}
