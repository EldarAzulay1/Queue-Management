// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:my_tor/tableTor/finish.dart';
import 'package:my_tor/mengerBus/freeAndPos/freeData.dart';
import 'package:my_tor/mengerBus/freeAndPos/posHours.dart';
import 'package:my_tor/tableTor/times.dart';
import 'package:my_tor/tableTor/type_server.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stepper_page_view/stepper_page_view.dart';
import 'package:step_indicator/step_indicator.dart';
import 'package:step_progress_indicator/step_progress_indicator.dart';
import '../../tableTor/give_Service.dart';
import 'dart:io' show Platform;

class magaerTimer extends StatelessWidget {
  final String nameClient, howUser;

  final myControllerImage = TextEditingController();
  magaerTimer({Key? key, required this.nameClient, required this.howUser})
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
              body: list(
                nameClient: nameClient,
                howUser: howUser,
              ),
              //ignore: prefer_const_constructors
            )));
  }
}

riestIndex() async {
  final prefsIndex = await SharedPreferences.getInstance();
  prefsIndex.setString("indexManagerTime", "0");
}

class list extends StatefulWidget {
  String nameClient, howUser;
  list({Key? key, required this.nameClient, required this.howUser})
      : super(key: key);
  @override
  State<list> createState() => _timeWorks(nameClient, howUser);
}

class _timeWorks extends State<list> {
  String nameClient, howUser;
  _timeWorks(this.nameClient, this.howUser);
  int step1 = 0, currentStep = 0;
  List<String> test = ["נותן שירות", "חופשה / הפסקה"];
  List<workerListModel> listGiveService = [];
  ScrollController _scrollController = ScrollController();
  int index = 0;
  bool scrool = true;
  bool pos = false, free = false, visiButton = true;
  String nameGiveService = "";
  @override
  void initState() {
    getCategoryDataGiveService().then((value) {
      if (howUser != "m") {
        setState(() {
          pos = true;
          currentStep = 1;
        });
      }
    });

    riestIndex();
    super.initState();
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

  scrollToTop() {
    _scrollController.jumpTo(0);
  }

  @override
  Widget build(BuildContext context) {
    setState(() {
      currentStep;
      getIndex();
    });
    return Container(
      child: Directionality(
        textDirection: TextDirection.rtl,
        child: Scaffold(
          backgroundColor: Color.fromARGB(255, 240, 240, 240),
          body: SingleChildScrollView(
            controller: _scrollController,
            child: Container(
              alignment: Alignment.center,
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: 10, maxWidth: 800),
                child: Stack(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Column(
                            //physics: NeverScrollableScrollPhysics(),
                            // controller: _scrollController,
                            children: [
                              Container(
                                child: Directionality(
                                  textDirection: TextDirection.rtl,
                                  child: ConstrainedBox(
                                    constraints: BoxConstraints(
                                        minHeight: 10, maxWidth: 800),
                                    child: Container(
                                        decoration: BoxDecoration(
                                            border: Border.all(
                                              color: Color.fromARGB(
                                                  255, 190, 190, 190),
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
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                currentStep > 0 &&
                                                        howUser == "m"
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
                                                          child: Icon(Icons
                                                              .arrow_back_outlined),
                                                          onPressed: () {
                                                            backButton();
                                                          },
                                                        ),
                                                      )
                                                    : Container(),
                                                // currentStep > 0
                                                //     ? Container(
                                                //         margin:
                                                //             EdgeInsets.all(15),
                                                //         alignment: Alignment
                                                //             .bottomLeft,
                                                //         child: ElevatedButton(
                                                //           style: ElevatedButton
                                                //               .styleFrom(
                                                //                   primary: Color
                                                //                       .fromARGB(
                                                //                           255,
                                                //                           41,
                                                //                           42,
                                                //                           43),
                                                //                   elevation: 3,
                                                //                   // shape: RoundedRectangleBorder(
                                                //                   //     borderRadius: BorderRadius.circular(32.0)),
                                                //                   minimumSize:
                                                //                       Size(20,
                                                //                           40),
                                                //                   textStyle:
                                                //                       const TextStyle(
                                                //                           fontSize:
                                                //                               23)),
                                                //           child:
                                                //               Text("לשלב הבא"),
                                                //           onPressed: () {
                                                //             setState(() {
                                                //               pos = false;
                                                //               free = false;
                                                //             });
                                                //             setIndex("2");
                                                //           },
                                                //         ),
                                                //       )
                                                //     : Container(),
                                              ],
                                            )
                                          ],
                                        )),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
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
                child: Text("נהל יומן עבודה",
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
                child: Text("בחר שעות הפסקה או ימי חופשה",
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
              if (currentStep == 1)
                Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: ConstrainedBox(
                            constraints:
                                BoxConstraints(minHeight: 10, maxWidth: 800),
                            child: Container(
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: Color.fromARGB(255, 106, 105, 105),
                                  ),
                                  borderRadius: BorderRadius.circular(6.0),
                                ),
                                margin: EdgeInsets.only(
                                    top: 10, bottom: 10, left: 10, right: 20),
                                alignment: Alignment.bottomLeft,
                                child: ElevatedButton.icon(
                                  style: ElevatedButton.styleFrom(
                                      primary:
                                          Color.fromARGB(255, 224, 222, 222),
                                      elevation: 3,
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(6.0),
                                      ),
                                      minimumSize: Size(double.infinity, 46),
                                      textStyle: const TextStyle(fontSize: 16)),
                                  onPressed: () {
                                    setState(() {
                                      free = false;
                                      pos = true;
                                    });
                                    // Your onPressed code here
                                  },
                                  icon: Icon(
                                      color: pos == true
                                          ? Colors.blue
                                          : Colors.black,
                                      Icons.coffee),
                                  label: Text(
                                    "הפסקה",
                                    style: TextStyle(
                                        color: pos == true
                                            ? Colors.blue
                                            : Colors.black),
                                  ),
                                )),
                          ),
                        ),
                        Expanded(
                          child: ConstrainedBox(
                            constraints:
                                BoxConstraints(minHeight: 10, maxWidth: 800),
                            child: Container(
                                decoration: BoxDecoration(
                                    border: Border.all(
                                      color: Color.fromARGB(255, 106, 105, 105),
                                    ),
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(6))),
                                margin: EdgeInsets.only(
                                    top: 10, bottom: 10, left: 20, right: 10),
                                alignment: Alignment.bottomRight,
                                child: ElevatedButton.icon(
                                  style: ElevatedButton.styleFrom(
                                      primary:
                                          Color.fromARGB(255, 224, 222, 222),
                                      elevation: 3,
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(5.0)),
                                      minimumSize: Size(double.infinity, 46),
                                      textStyle: const TextStyle(fontSize: 16)),
                                  onPressed: () {
                                    setState(() {
                                      free = true;
                                      pos = false;
                                    });

                                    // Your onPressed code here
                                  },
                                  icon: Icon(
                                      color: free == true
                                          ? Colors.blue
                                          : Colors.black,
                                      Icons.flight_takeoff),
                                  label: Text(
                                    "חופשה",
                                    style: TextStyle(
                                        color: free == true
                                            ? Colors.blue
                                            : Colors.black),
                                  ),
                                )),
                          ),
                        ),
                      ],
                    ),
                    Container(
                      margin: EdgeInsets.only(right: 10, top: 5),
                      alignment: Alignment.topRight,
                      child: Text(nameGiveService,
                          // ignore: prefer_const_constructors
                          style: TextStyle(
                            color: Color.fromARGB(255, 101, 100, 100),
                            //fontWeight: FontWeight.bold,
                            fontSize: 15.0,
                          )),
                    ),
                  ],
                ),
              pos == true
                  ? posHours(nameGive: nameGiveService, nameClient: nameClient)
                  : Container(),
              free == true
                  ? freeData(nameGive: nameGiveService, nameClient: nameClient)
                  : Container(),
              if (currentStep == 2) finish()
            ],
          ),
        ),
      ),
    );
  }

  finish() {
    return Column(
      children: [
        Container(
          margin: EdgeInsets.only(left: 15, right: 15),
          child: ConstrainedBox(
            constraints: BoxConstraints(minHeight: 10, maxWidth: 500),
            child: Container(
              padding: EdgeInsets.all(8),
              decoration: BoxDecoration(
                  color: Color.fromARGB(255, 177, 175, 175),
                  border: Border.all(
                    color: Color.fromARGB(255, 199, 195, 195),
                  ),
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(5),
                      topRight: Radius.circular(5))),
              //margin: EdgeInsets.only(right: 10),
              alignment: Alignment.topRight,
              // ignore: prefer_const_constructors
              child: Text("פרטי החופשה / הפסקה",
                  // ignore: prefer_const_constructors
                  // textAlign: TextAlign.right,
                  // ignore: prefer_const_constructors
                  style: TextStyle(
                    color: Color.fromARGB(255, 0, 0, 0),
                    fontWeight: FontWeight.bold,
                    fontSize: 15.0,
                  )),
            ),
          ),
        ),
        ConstrainedBox(
          constraints: BoxConstraints(minHeight: 0, maxWidth: 500),
          child: Container(
              padding: EdgeInsets.all(8),
              margin: EdgeInsets.only(left: 15, right: 15),
              width: double.infinity,
              decoration: BoxDecoration(
                  border: Border.all(
                    color: Color.fromARGB(255, 199, 195, 195),
                  ),
                  borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(5),
                      bottomRight: Radius.circular(5))),
              child: Column(
                children: [
                  Text(nameGiveService.toString(),
                      textAlign: TextAlign.right,
                      style: TextStyle(
                        color: Color.fromARGB(255, 0, 0, 0),
                        fontWeight: FontWeight.bold,
                        fontSize: 15.0,
                      )),
                ],
              )),
        )
      ],
    );
  }

  backButton() async {
    final prefsIndex = await SharedPreferences.getInstance();
    setState(() {
      if (currentStep > 0) {
        currentStep--;
        prefsIndex.setString("scrollTopManagerTime", "true");
        prefsIndex.setString("indexManagerTime", currentStep.toString());
        pos = false;
        free = false;
      }
    });
  }

  getIndex() async {
    final prefsIndex = await SharedPreferences.getInstance();

    if (prefsIndex.getString("scrollTopManagerTime").toString() == "true") {
      scrollToTop();
      prefsIndex.setString("scrollTopManagerTime", "false");
    }

    if (prefsIndex.getString("indexManagerTime").toString() != "0") {
      setState(() {
        if (howUser == "m") {
          currentStep =
              int.parse(prefsIndex.getString("indexManagerTime").toString());
        }

        if (currentStep == 1 && free == false) {
          pos = true;
        }
      });
    } else {
      if (howUser == "m") {
        setState(() {
          currentStep = 0;
        });
      }
    }
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
                      });
                      setIndex("1");
                      // setPrefDataUser(listGiveService[index].toString());
                    },
                  ),
                ),
              ),
            );
          }),
    );
  }

  setIndex(String index) async {
    final prefsIndex = await SharedPreferences.getInstance();
    setState(() {
      prefsIndex.setString("scrollTopManagerTime", "true");
      prefsIndex.setString("indexManagerTime", index);
    });
  }

  setPrefDataUser(String giveService) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString("userGiveServiceManagerTime", giveService).toString();
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
