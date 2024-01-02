// ignore_for_file: prefer_const_constructors, avoid_single_cascade_in_expression_statements

import 'dart:convert';
import 'dart:html';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/foundation.dart';
import 'dart:typed_data';
import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:my_tor/main.dart';
import 'package:shared_preferences/shared_preferences.dart';

class menuServiceWork extends StatefulWidget {
  final String nameClient;
  menuServiceWork({Key? key, required this.nameClient}) : super(key: key);

  @override
  State<menuServiceWork> createState() => _list(nameClient);
}

class typeServerModel {
  String nameServer = "";
  String? time;
  String? price;
  String? subTitle;
  int? Distans;
  String? Timer;
  typeServerModel(this.nameServer, this.time, this.price, this.subTitle,
      this.Distans, this.Timer);

  Map<String, dynamic> toJson() {
    return {
      'name': nameServer,
      'time': time,
      'price': price,
      'subTitle': subTitle,
      'Distans': Distans,
      "Timer": Timer,
    };
  }

  typeServerModel.fromJson(Map<String, dynamic> json) {
    nameServer = json['name'];
    price = json['price'];
    time = json['time'];
    subTitle = json['subTitle'];
    Timer = json['Timer'];
  }
}

class _list extends State<menuServiceWork> {
  int timeWorkService = 0;
  int timeWorkServiceIgnor = 0;
  int priceWorkService = 0;
  final myControllerNameSerive = TextEditingController();
  final myControllerSubTitleSerive = TextEditingController();
  bool visiIgnoeTor = false;
  final myControllerPhone = TextEditingController();
  final myControllerNameBis = TextEditingController();
  final myControllerEmail = TextEditingController();
  final myControllerPassword = TextEditingController();
  List<typeServerModel> listTypeService = [];
  List<typeServerModel> listTypeServicenew = [];
  List<String> listTypeRemove = [];
  String nameClient;
  _list(this.nameClient);
  DatabaseReference refM = FirebaseDatabase.instance.ref();

  ListTypeNameForRemove() async {
    DatabaseReference starCountRef =
        FirebaseDatabase.instance.ref('$nameClient/שירותים');
    starCountRef.onValue.listen((DatabaseEvent event) async {
      if (listTypeRemove.isNotEmpty) {
        print("sdsd ");
        listTypeRemove.clear();
      }
      if (event.snapshot.exists) {
        for (int i = 0; i < event.snapshot.children.length; i++) {
          listTypeRemove
              .add(event.snapshot.children.elementAt(i).key.toString());
        }
      }
    });
  }

  Future<List<typeServerModel>> getCategoryData() async {
    final prefsListType1 = await SharedPreferences.getInstance();
    final category = prefsListType1.getString("ListService");
    print("dffffr333--- " + category.toString());
    listTypeService = List<typeServerModel>.from(
        List<Map<String, dynamic>>.from(jsonDecode(category.toString()))
            .map((e) => typeServerModel.fromJson(e))
            .toList());

    setState(() {
      listTypeService;
    });

    return listTypeService;
  }

  // removeType(List<typeServerModel> list) async {
  //   SharedPreferences prefsListType = await SharedPreferences.getInstance();
  //   prefsListType.clear();
  //   print("fefefefr " + list.length.toString());
  //   String json = jsonEncode(list);
  //   prefsListType.setString("ListService1", json);
  // }

  @override
  void initState() {
    // setState(() {
    //   listTypeService.clear();
    //   listTypeRemove.clear();
    // });

    getCategoryData();
    ListTypeNameForRemove();
    // TODO: implement initState
    super.initState();
  }

  Widget build(BuildContext context) {
    if (listTypeService.isEmpty) {
      getCategoryData();
    }
    return Container(
      child: Column(children: [
        ConstrainedBox(
          constraints: BoxConstraints(minHeight: 50, maxWidth: 800),
          child: Divider(
            height: 40,
            thickness: 3,
          ),
        ),
        ConstrainedBox(
          constraints: BoxConstraints(minHeight: 50, maxWidth: 500),
          child: setDetatils(context),
        ),
        SizedBox(
          height: 10,
        ),
        ConstrainedBox(
            constraints: BoxConstraints(minHeight: 50, maxWidth: 500),
            child: Column(
              children: [
                listTypeService.isNotEmpty
                    ? Container(
                        alignment: Alignment.centerRight,
                        child: Text("שירותי העסק שלי",
                            // ignore: prefer_const_constructors
                            textAlign: TextAlign.right,
                            // ignore: prefer_const_constructors
                            style: TextStyle(
                              color: Color.fromARGB(255, 0, 0, 0),
                              fontWeight: FontWeight.bold,
                              fontSize: 17.0,
                            )))
                    : Text(""),
                SizedBox(
                  height: 5,
                ),
                listTypeService.isNotEmpty
                    ? Container(
                        alignment: Alignment.centerRight,
                        child: Text("החלק לצד למחיקת שירות",
                            // ignore: prefer_const_constructors
                            textAlign: TextAlign.right,
                            // ignore: prefer_const_constructors
                            style: TextStyle(
                              color: Color.fromARGB(255, 101, 100, 100),
                              //fontWeight: FontWeight.bold,
                              fontSize: 15.0,
                            )))
                    // ignore: prefer_const_constructors
                    : Text(""),
                SizedBox(
                  height: 10,
                ),
                dataType(),
              ],
            )),
        SizedBox(
          height: 35,
        ),
      ]),
    );
  }

  GetTime(String NameType, String Time, String price, String subTitleService,
      int DistansTime) async {
    String timeG = "";
    if (int.parse(Time) > 60) {
      int hours = int.parse(((int.parse(Time) / 60)).floor().toString());
      int mits = (int.parse(Time) - (hours * 60));
      timeG = (hours < 10 ? "0" + hours.toString() : hours.toString()) +
          ":" +
          (mits < 10 ? "0" + mits.toString() : mits.toString());
    } else {
      timeG = Time;
    }

    addService(NameType, Time, price, subTitleService, DistansTime, timeG);
  }

  addService(String NameType, String Time, String price, String subTitleService,
      int DistansTime, String timeG) async {
    print("wdddddddddddww-" + timeG);
    setState(() {
      listTypeService.add(
          // ignore: unnecessary_new
          new typeServerModel(NameType, Time, price + " ₪", subTitleService,
              DistansTime, timeG.toString()));
      listTypeServicenew.add(
          // ignore: unnecessary_new
          new typeServerModel(NameType, Time, price + " ₪", subTitleService,
              DistansTime, timeG.toString()));
    });
    SharedPreferences prefsScrollButton = await SharedPreferences.getInstance();
    prefsScrollButton.setString("ScrollBottonMenu", "true");
    print("efefef111 -" + listTypeService.length.toString());
  }

  setDetatils(context) {
    return Container(
        decoration: BoxDecoration(
            border: Border.all(
              color: Color.fromARGB(255, 199, 195, 195),
            ),
            borderRadius: BorderRadius.all(Radius.circular(5))),
        child: Container(
            margin: EdgeInsets.only(right: 15, left: 15),
            child: Column(children: [
              SizedBox(
                height: 20,
                width: 20,
              ),
              //שם שירות
              Container(
                alignment: Alignment.topRight,
                child: Column(
                  children: [
                    Container(
                      //margin: EdgeInsets.only(right: 10),
                      alignment: Alignment.topRight,
                      // ignore: prefer_const_constructors
                      child: Text("שם שירות",
                          // ignore: prefer_const_constructors
                          // textAlign: TextAlign.right,
                          // ignore: prefer_const_constructors
                          style: TextStyle(
                            color: Color.fromARGB(255, 0, 0, 0),
                            fontWeight: FontWeight.bold,
                            fontSize: 17.0,
                          )),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Container(
                      width: 400,
                      child: Directionality(
                          textDirection: TextDirection.rtl,
                          child: TextField(
                            controller: myControllerNameSerive,
                            textDirection: TextDirection.ltr,
                            textAlign: TextAlign.right,
                            onChanged: (value) async {
                              SharedPreferences prefs =
                                  await SharedPreferences.getInstance();
                              prefs
                                  .setString("ServiceName",
                                      myControllerNameSerive.text)
                                  .toString();
                            },
                            // ignore: prefer_const_constructors
                            // ignore: unnecessary_new
                            decoration: new InputDecoration(
                              filled: true,
                              prefixIcon: Icon(Icons.room_service_outlined),
                              labelStyle: TextStyle(
                                color: Color.fromARGB(255, 0, 0, 0),
                              ),
                              border: OutlineInputBorder(),
                            ),
                          )),
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    Container(
                      //margin: EdgeInsets.only(right: 10),
                      alignment: Alignment.topRight,
                      // ignore: prefer_const_constructors
                      child: Text("הסבר השירות",
                          // ignore: prefer_const_constructors
                          // textAlign: TextAlign.right,
                          // ignore: prefer_const_constructors
                          style: TextStyle(
                            color: Color.fromARGB(255, 0, 0, 0),
                            fontWeight: FontWeight.bold,
                            fontSize: 17.0,
                          )),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Container(
                      width: 400,
                      child: Directionality(
                          textDirection: TextDirection.rtl,
                          child: TextField(
                            controller: myControllerSubTitleSerive,
                            textDirection: TextDirection.ltr,
                            textAlign: TextAlign.right,
                            onChanged: (value) async {
                              SharedPreferences prefs =
                                  await SharedPreferences.getInstance();
                              prefs
                                  .setString("ServiceSubTitle",
                                      myControllerSubTitleSerive.text)
                                  .toString();
                            },
                            // ignore: prefer_const_constructors
                            // ignore: unnecessary_new
                            decoration: new InputDecoration(
                              filled: true,
                              prefixIcon: Icon(Icons.help_center),
                              labelStyle: TextStyle(
                                color: Color.fromARGB(255, 0, 0, 0),
                              ),
                              border: OutlineInputBorder(),
                            ),
                          )),
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    Divider(
                      height: 10,
                      thickness: 1,
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    //זמן שירות
                    Row(
                      children: [
                        Container(
                          //margin: EdgeInsets.only(right: 10),
                          //alignment: Alignment.topRight,
                          // ignore: prefer_const_constructors
                          child: Text("זמן השירות",
                              // ignore: prefer_const_constructors
                              // textAlign: TextAlign.right,
                              // ignore: prefer_const_constructors
                              style: TextStyle(
                                color: Color.fromARGB(255, 0, 0, 0),
                                fontWeight: FontWeight.bold,
                                fontSize: 17.0,
                              )),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Container(
                          //margin: EdgeInsets.only(right: 10),
                          // alignment: Alignment.topRight,
                          // ignore: prefer_const_constructors
                          child: Text("בדקות",
                              // ignore: prefer_const_constructors
                              // textAlign: TextAlign.right,
                              // ignore: prefer_const_constructors
                              style: TextStyle(
                                color: Color.fromARGB(255, 102, 101, 101),
                                fontWeight: FontWeight.bold,
                                fontSize: 14.0,
                              )),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    ConstrainedBox(
                      constraints: BoxConstraints(minHeight: 50, maxWidth: 300),
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Text(timeWorkService.toString() + " דקות ",
                                  // ignore: prefer_const_constructors
                                  // textAlign: TextAlign.right,
                                  // ignore: prefer_const_constructors
                                  style: TextStyle(
                                    color: Color.fromARGB(255, 102, 101, 101),
                                    fontWeight: FontWeight.bold,
                                    fontSize: 15.0,
                                  )),
                            ),
                            Expanded(
                              child: Container(
                                width: 110,
                                padding: EdgeInsets.only(left: 7, right: 7),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(5),
                                    color: Theme.of(context).accentColor),
                                child: Row(
                                  children: [
                                    InkWell(
                                        onTap: () {
                                          print("sdsdsd " +
                                              timeWorkService.toString());
                                          setState(() {
                                            timeWorkService =
                                                timeWorkService + 10;
                                          });
                                        },
                                        child: Icon(
                                          Icons.add,
                                          color: Colors.white,
                                          size: 25,
                                        )),
                                    Expanded(
                                      child: Container(
                                        margin:
                                            EdgeInsets.symmetric(horizontal: 3),
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 15, vertical: 10),
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(3),
                                            color: Colors.white),
                                        child: Text(
                                          timeWorkService.toString(),
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 16),
                                        ),
                                      ),
                                    ),
                                    InkWell(
                                        onTap: () {
                                          setState(() {
                                            if (timeWorkService >= 10) {
                                              timeWorkService =
                                                  timeWorkService - 10;
                                            }
                                          });
                                        },
                                        child: Icon(
                                          Icons.remove,
                                          color: Colors.white,
                                          size: 25,
                                        )),
                                  ],
                                ),
                              ),
                            ),
                          ]),
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    Divider(
                      height: 10,
                      thickness: 1,
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    //עלות שירות
                    Container(
                      //margin: EdgeInsets.only(right: 10),
                      alignment: Alignment.topRight,
                      // ignore: prefer_const_constructors
                      child: Text("מחיר השירות",
                          // ignore: prefer_const_constructors
                          // textAlign: TextAlign.right,
                          // ignore: prefer_const_constructors
                          style: TextStyle(
                            color: Color.fromARGB(255, 0, 0, 0),
                            fontWeight: FontWeight.bold,
                            fontSize: 17.0,
                          )),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    ConstrainedBox(
                      constraints: BoxConstraints(minHeight: 50, maxWidth: 300),
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Text(priceWorkService.toString() + "   ₪ ",

                                  // ignore: prefer_const_constructors
                                  // textAlign: TextAlign.right,
                                  // ignore: prefer_const_constructors
                                  style: TextStyle(
                                    color: Color.fromARGB(255, 102, 101, 101),
                                    fontWeight: FontWeight.bold,
                                    fontSize: 15.0,
                                  )),
                            ),
                            Expanded(
                              child: Container(
                                width: 110,
                                padding: EdgeInsets.only(left: 7, right: 7),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(5),
                                    color: Theme.of(context).accentColor),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    InkWell(
                                        onTap: () {
                                          setState(() {
                                            priceWorkService =
                                                priceWorkService + 10;
                                          });
                                        },
                                        child: Icon(
                                          Icons.add,
                                          color: Colors.white,
                                          size: 25,
                                        )),
                                    Expanded(
                                      child: Container(
                                        margin:
                                            EdgeInsets.symmetric(horizontal: 3),
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 15, vertical: 10),
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(3),
                                            color: Colors.white),
                                        child: Text(
                                          priceWorkService.toString(),
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 16),
                                        ),
                                      ),
                                    ),
                                    InkWell(
                                        onTap: () {
                                          setState(() {
                                            if (priceWorkService >= 10) {
                                              priceWorkService =
                                                  priceWorkService - 10;
                                            }
                                          });
                                        },
                                        child: Icon(
                                          Icons.remove,
                                          color: Colors.white,
                                          size: 25,
                                        )),
                                  ],
                                ),
                              ),
                            ),
                          ]),
                    ),

                    SizedBox(
                      height: 20,
                    ),
                    Divider(
                      height: 10,
                      thickness: 1,
                    ),
                    SizedBox(
                      height: 10,
                    ),

                    Container(
                      alignment: Alignment.bottomRight,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            elevation: 3,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12.0)),
                            minimumSize: Size(70, 50),
                            textStyle: const TextStyle(fontSize: 15)),
                        child: Text("הוסף שירות"),
                        onPressed: () {
                          if (myControllerNameSerive.text.isNotEmpty &&
                              timeWorkService != 0 &&
                              priceWorkService != 0) {
                            //toHores(timeWorkService);
                            GetTime(
                              myControllerNameSerive.text,
                              timeWorkService.toString(),
                              priceWorkService.toString(),
                              myControllerSubTitleSerive.text,
                              timeWorkService,
                            );
                            // addService(
                            //     myControllerNameSerive.text,
                            //     timeWorkService.toString(),
                            //     priceWorkService.toString(),
                            //     myControllerSubTitleSerive.text,
                            //     timeWorkService);
                            for (int i = 0, j = listTypeService.length;
                                i < listTypeServicenew.length;
                                i++, j++) {
                              refM
                                ..child(nameClient)
                                    .child("שירותים")
                                    .child(
                                        // ignore: prefer_interpolation_to_compose_strings
                                        refM.push().key.toString() +
                                            "~" +
                                            listTypeServicenew[i].nameServer)
                                    .update({
                                  "זמן": listTypeServicenew[i].time.toString(),
                                  "טימר": listTypeServicenew[i].Timer,
                                  "עלות": listTypeServicenew[i].price,
                                  "כותרת": listTypeServicenew[i].subTitle,
                                  "דיסטנס": listTypeServicenew[i].time,
                                });
                            }
                            listTypeServicenew.clear();
                            setState(() {
                              myControllerNameSerive.text = "";
                              myControllerSubTitleSerive.text = "";
                              timeWorkService = 0;
                              priceWorkService = 0;
                            });
                          } else {
                            Fluttertoast.showToast(
                                msg: "השלם פרטים",
                                //toastLength: Toast.LENGTH_SHORT,
                                gravity: ToastGravity.TOP,
                                timeInSecForIosWeb: 3,
                                // backgroundColor: Color.fromARGB(
                                //     255, 74, 72, 72),
                                textColor: Colors.white,
                                fontSize: 16.0);
                          }
                          //getCategoryData();
                        },
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Divider(
                      height: 10,
                      thickness: 1,
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Container(
                      alignment: Alignment.topRight,
                      child: Text(
                          "* במקרה שהשירות ארוך \n וברצונך לקבוע תורים נוספים בזמן הזה לחץ כאן",
                          style: TextStyle(
                            color: Color.fromARGB(255, 244, 9, 9),
                            fontSize: 13.0,
                          )),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    // ignore: prefer_const_literals_to_create_immutables
                    Row(
                      children: [
                        Container(
                          alignment: Alignment.bottomRight,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                elevation: 3,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12.0)),
                                minimumSize: Size(60, 40),
                                textStyle: const TextStyle(fontSize: 15)),
                            child: Text("בחר בשירות התעלמות"),
                            onPressed: () {
                              setState(() {
                                visiIgnoeTor = true;
                              });
                            },
                          ),
                        ),
                        SizedBox(
                          width: 5,
                        ),
                      ],
                    ),

                    Visibility(
                      visible: visiIgnoeTor,
                      child: Column(
                        children: [
                          SizedBox(
                            height: 5,
                          ),
                          Container(
                            alignment: Alignment.topRight,
                            child: Text(
                                "בחר משך זמן שירות התחלתי" +
                                    "\n"
                                        "*רק זמן זה התפס ביומן עבודה",
                                style: TextStyle(
                                  color: Color.fromARGB(255, 125, 124, 124),
                                  fontSize: 13.0,
                                )),
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          ConstrainedBox(
                            constraints:
                                BoxConstraints(minHeight: 50, maxWidth: 300),
                            child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: Text(
                                        timeWorkServiceIgnor.toString() +
                                            " דקות ",
                                        // ignore: prefer_const_constructors
                                        // textAlign: TextAlign.right,
                                        // ignore: prefer_const_constructors
                                        style: TextStyle(
                                          color: Color.fromARGB(
                                              255, 102, 101, 101),
                                          fontWeight: FontWeight.bold,
                                          fontSize: 15.0,
                                        )),
                                  ),
                                  Expanded(
                                    child: Container(
                                      width: 110,
                                      padding:
                                          EdgeInsets.only(left: 7, right: 7),
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(5),
                                          color: Theme.of(context).accentColor),
                                      child: Row(
                                        children: [
                                          InkWell(
                                              onTap: () {
                                                setState(() {
                                                  timeWorkServiceIgnor =
                                                      timeWorkServiceIgnor + 10;
                                                });
                                              },
                                              child: Icon(
                                                Icons.add,
                                                color: Colors.white,
                                                size: 25,
                                              )),
                                          Expanded(
                                            child: Container(
                                              margin: EdgeInsets.symmetric(
                                                  horizontal: 3),
                                              padding: EdgeInsets.symmetric(
                                                  horizontal: 15, vertical: 10),
                                              decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(3),
                                                  color: Colors.white),
                                              child: Text(
                                                timeWorkServiceIgnor.toString(),
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                    color: Colors.black,
                                                    fontSize: 16),
                                              ),
                                            ),
                                          ),
                                          InkWell(
                                              onTap: () {
                                                setState(() {
                                                  if (timeWorkServiceIgnor >=
                                                      10) {
                                                    timeWorkServiceIgnor =
                                                        timeWorkServiceIgnor -
                                                            10;
                                                  }
                                                });
                                              },
                                              child: Icon(
                                                Icons.remove,
                                                color: Colors.white,
                                                size: 25,
                                              )),
                                        ],
                                      ),
                                    ),
                                  ),
                                ]),
                          ),
                          Container(
                            alignment: Alignment.bottomRight,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  elevation: 3,
                                  shape: RoundedRectangleBorder(
                                      borderRadius:
                                          BorderRadius.circular(12.0)),
                                  minimumSize: Size(60, 40),
                                  textStyle: const TextStyle(fontSize: 15)),
                              child: Text("הוסף שירות התעלמות"),
                              onPressed: () {
                                if (myControllerNameSerive.text.isNotEmpty &&
                                    timeWorkService != 0 &&
                                    priceWorkService != 0 &&
                                    timeWorkServiceIgnor != 0) {
                                  GetTime(
                                    myControllerNameSerive.text,
                                    timeWorkService.toString(),
                                    priceWorkService.toString(),
                                    myControllerSubTitleSerive.text,
                                    timeWorkService,
                                  );
                                  // addService(
                                  //     myControllerNameSerive.text,
                                  //     timeWorkService.toString(),
                                  //     priceWorkService.toString(),
                                  //     myControllerSubTitleSerive.text,
                                  //     timeWorkServiceIgnor);
                                  for (int i = 0, j = listTypeService.length;
                                      i < listTypeServicenew.length;
                                      i++, j++) {
                                    refM
                                      ..child(nameClient)
                                          .child("שירותים")
                                          .child(
                                              // ignore: prefer_interpolation_to_compose_strings
                                              refM.push().key.toString() +
                                                  "~" +
                                                  listTypeServicenew[i]
                                                      .nameServer)
                                          .update({
                                        "זמן": listTypeServicenew[i].time,
                                        "טימר": listTypeServicenew[i].Timer,
                                        "עלות": listTypeServicenew[i].price,
                                        "כותרת": listTypeServicenew[i].subTitle,
                                        "דיסטנס": timeWorkServiceIgnor,
                                      });
                                  }
                                  listTypeServicenew.clear();
                                  setState(() {
                                    myControllerNameSerive.text = "";
                                    myControllerSubTitleSerive.text = "";
                                    timeWorkService = 0;
                                    priceWorkService = 0;
                                  });
                                } else {
                                  Fluttertoast.showToast(
                                      msg: "השלם פרטים",
                                      //toastLength: Toast.LENGTH_SHORT,
                                      gravity: ToastGravity.TOP,
                                      timeInSecForIosWeb: 3,
                                      // backgroundColor: Color.fromARGB(
                                      //     255, 74, 72, 72),
                                      textColor: Colors.white,
                                      fontSize: 16.0);
                                }
                                //getCategoryData();
                              },
                            ),
                          ),
                        ],
                      ),
                    ),

                    SizedBox(
                      height: 20,
                    ),
                  ],
                ),
              ),
            ])));
  }

  String toHores(int time) {
    int hours = int.parse(((time / 60)).floor().toString());
    int mits = (time - (hours * 60));
    String timeG = hours.toString() + ":" + mits.toString();

    return timeG.toString();
  }

  dataType() {
    return Container(
      margin: EdgeInsets.only(bottom: 5, top: 5),
      padding: EdgeInsets.only(left: 3, right: 3),
      width: double.maxFinite,
      child: ListView.separated(
          physics: NeverScrollableScrollPhysics(),
          itemCount: listTypeService.length,
          separatorBuilder: (context, index) {
            return Divider(
              height: 13,
              thickness: 1,
            );
          },
          shrinkWrap: true,
          itemBuilder: (context, index) {
            print("efefef111 --" + listTypeService.length.toString());

            return listTypeService.length > 0
                ? Container(
                    child: Card(
                      shadowColor: Color.fromARGB(255, 0, 0, 0),
                      shape: RoundedRectangleBorder(
                        side: BorderSide(
                          width: 1.0,
                          color: Color.fromARGB(255, 143, 141, 141),
                        ),
                        borderRadius:
                            BorderRadius.circular(10.0), //<-- SEE HERE
                      ),
                      elevation: 25,
                      child: listTypeService.length > 0
                          ? Dismissible(
                              background: Container(
                                color: Colors.red, // Set the desired color here
                                child: Align(
                                  alignment: Alignment.centerRight,
                                  child: Padding(
                                    padding: EdgeInsets.only(right: 20.0),
                                    child: Icon(
                                      Icons.delete,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                              key: Key(
                                  listTypeService[index].nameServer.toString()),
                              onDismissed: (direction) async {
                                listRemoveFireBase(listTypeRemove, index);
                                // ignore: prefer_interpolation_to_compose_strings

                                if (listTypeService.length == 1) {
                                  print("cccccccccccccddddd " +
                                      listTypeRemove.length.toString());
                                  final prefsListType1 =
                                      await SharedPreferences.getInstance();
                                  prefsListType1.remove("ListService");
                                }
                                setState(() {
                                  //listTypeRemove.removeAt(index);

                                  listTypeService.removeAt(index);
                                });
                              },
                              child: ListTile(
                                title: Text(
                                  maxLines: 2,
                                  listTypeService[index].nameServer.toString(),
                                  style: TextStyle(
                                    color: Color.fromARGB(255, 0, 0, 0),
                                    fontWeight: FontWeight.bold,
                                    fontSize: 15.0,
                                  ),
                                ),
                                subtitle: listTypeService[index]
                                            .subTitle!
                                            .isNotEmpty &&
                                        listTypeService[index].subTitle !=
                                            "null"
                                    ? Text(
                                        maxLines: 2,
                                        listTypeService[index]
                                            .subTitle
                                            .toString(),
                                        style: TextStyle(
                                          color: Color.fromARGB(
                                              255, 115, 114, 114),
                                          fontWeight: FontWeight.w600,
                                          fontSize: 14.0,
                                        ),
                                      )
                                    : null,

                                selectedTileColor: Color.fromARGB(255, 0, 0, 0),
                                textColor: Color.fromARGB(255, 0, 0, 0),
                                trailing: RichText(
                                  text: TextSpan(
                                    style: TextStyle(
                                      //backgroundColor: Color.fromARGB(255, 178, 175, 175),
                                      color: Color.fromARGB(255, 81, 79, 79),
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15.0,
                                    ),
                                    // ignore: prefer_const_literals_to_create_immutables
                                    children: [
                                      // ignore: prefer_interpolation_to_compose_strings
                                      TextSpan(
                                        text: listTypeService[index]
                                            .price
                                            .toString(),
                                      ),
                                      TextSpan(text: "  |  "),
                                      //TextSpan(text: listTypeServer[index].time.toString()),
                                      TextSpan(
                                          text: listTypeService[index]
                                              .Timer
                                              .toString()),
                                      TextSpan(text: " "),

                                      WidgetSpan(
                                        // ignore: prefer_const_constructors
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 0.0),
                                          child: Icon(
                                            Icons.alarm_outlined,
                                            size: 18,
                                          ),
                                        ),
                                      ),

                                      // ignore: prefer_const_constructors

                                      //TextSpan(text: 'By Michael'),
                                    ],
                                  ),
                                ),

                                // Text(
                                //   listTypeServer[index].nameServer.toString(),
                                //   style: TextStyle(
                                //     color: Color.fromARGB(255, 0, 0, 0),
                                //     fontWeight: FontWeight.bold,
                                //     fontSize: 18.0,
                                //   ),
                                //),
                                onTap: () {},
                              ),
                            )
                          : Text("ffffffffff"),
                    ),
                  )
                : Text("ffffffffff");
          }),
    );
  }

  listRemoveFireBase(List<String> listRemove, int index) async {
    final ref = FirebaseDatabase.instance.ref();
    final snapshot = await ref.child("$nameClient/שירותים/").get();
    if (snapshot.hasChild(listRemove[index])) {
      print("ssssww22 -- " + listRemove[index]);

      DatabaseReference ref = FirebaseDatabase.instance.ref(
          // ignore: prefer_interpolation_to_compose_strings
          "$nameClient/שירותים/" + listRemove[index]);
      ref.remove();
      setState(() {
        listTypeRemove.removeAt(index);
      });
    }
  }
}
