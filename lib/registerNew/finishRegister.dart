// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors, unnecessary_new, prefer_interpolation_to_compose_strings

import 'dart:convert';
import 'dart:html';
import 'dart:async';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/foundation.dart';
import 'dart:typed_data';
import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:my_tor/main.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_email_sender/flutter_email_sender.dart';

class finishRegister extends StatefulWidget {
  finishRegister({Key? key}) : super(key: key);

  @override
  State<finishRegister> createState() => _list();
}

class typeServerModel {
  String? nameServer;
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

class MyData {
  String fullName = "";
  String phone = "";
  String NameBis = "";
  String StreetName = "";
  String email = "";
  String password = "";
}

class MyWoresHores {
  String day = "";
  String start = "";
  String end = "";

  MyWoresHores(this.day, this.start, this.end);
}

class _list extends State<finishRegister> {
  _list();

  List<typeServerModel> listTypeService = [];
  List<String> servicesList = [];
  List<String> deys = [
    "יום ראשון",
    "יום שני",
    "יום שלישי",
    "יום רביעי",
    "יום חמישי",
    "יום שישי"
  ];
  String fullName = "", phone = "", nameBis = "", email = "", password = "";
  late MyData dataBis = new MyData();
  List<MyWoresHores> dataWorks = [];
  int indexDef = 0;
  getPef() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      indexDef = prefs.getInt("index1")!;
    });
  }

  @override
  void initState() {
    getDataListService();
    super.initState();
  }

  Widget build(BuildContext context) {
    return Container(
        child: Column(
      mainAxisSize: MainAxisSize.min,
      // ignore: prefer_const_literals_to_create_immutables
      children: [
        ConstrainedBox(
          constraints: BoxConstraints(minHeight: 50, maxWidth: 500),
          child: nameStep(),
        ),

        // ignore: prefer_const_constructors
        ConstrainedBox(
          constraints: BoxConstraints(minHeight: 50, maxWidth: 500),
          child: Divider(
            height: 40,
            thickness: 3,
          ),
        ),

        SizedBox(
          height: 5,
        ),
        ConstrainedBox(
          constraints: BoxConstraints(minHeight: 10, maxWidth: 500),
          child: Container(
            padding: EdgeInsets.all(8),
            decoration: BoxDecoration(
                color: Color.fromARGB(255, 177, 175, 175),
                border: Border.all(
                  color: Color.fromARGB(255, 199, 195, 195),
                ),
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(5), topRight: Radius.circular(5))),
            //margin: EdgeInsets.only(right: 10),
            alignment: Alignment.topRight,
            // ignore: prefer_const_constructors
            child: Text("פרטי העסק",
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
        ConstrainedBox(
          constraints: BoxConstraints(minHeight: 50, maxWidth: 500),
          child: myDetails(),
        ),

        SizedBox(
          height: 10,
        ),
        ConstrainedBox(
          constraints: BoxConstraints(minHeight: 10, maxWidth: 500),
          child: Container(
            padding: EdgeInsets.all(8),
            decoration: BoxDecoration(
                color: Color.fromARGB(255, 177, 175, 175),
                border: Border.all(
                  color: Color.fromARGB(255, 199, 195, 195),
                ),
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(5), topRight: Radius.circular(5))),
            //margin: EdgeInsets.only(right: 10),
            alignment: Alignment.topRight,
            // ignore: prefer_const_constructors
            child: Text("שעות פעילות",
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
        ConstrainedBox(
          constraints: BoxConstraints(minHeight: 50, maxWidth: 500),
          child: worksHors(),
        ),
        SizedBox(
          height: 10,
        ),
        ConstrainedBox(
          constraints: BoxConstraints(minHeight: 10, maxWidth: 500),
          child: Container(
            padding: EdgeInsets.all(8),
            decoration: BoxDecoration(
                color: Color.fromARGB(255, 177, 175, 175),
                border: Border.all(
                  color: Color.fromARGB(255, 199, 195, 195),
                ),
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(5), topRight: Radius.circular(5))),
            //margin: EdgeInsets.only(right: 10),
            alignment: Alignment.topRight,
            // ignore: prefer_const_constructors
            child: Text("שירותי העסק",
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
        ConstrainedBox(
          constraints: BoxConstraints(minHeight: 50, maxWidth: 500),
          child: listService(),
        ),
      ],
    ));
  }

  myDetails() {
    return FutureBuilder(
        future: getData(),
        builder: (context, snapshot) {
          if (dataBis.fullName != "null") {
            return Container(
                decoration: BoxDecoration(
                    border: Border.all(
                      color: Color.fromARGB(255, 199, 195, 195),
                    ),
                    borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(5),
                        bottomRight: Radius.circular(5))),
                child: Container(
                  margin: EdgeInsets.only(right: 15, left: 15),
                  child: Column(
                    children: [
                      SizedBox(
                        height: 10,
                        width: 20,
                      ),
                      Container(
                        alignment: Alignment.topRight,
                        child: Text("שם פרטי וטלפון",
                            textAlign: TextAlign.right,
                            // ignore: prefer_const_constructors
                            // textAlign: TextAlign.right,
                            // ignore: prefer_const_constructors
                            style: TextStyle(
                              color: Color.fromARGB(255, 0, 0, 0),
                              fontWeight: FontWeight.bold,
                              fontSize: 15.0,
                            )),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Container(
                              //margin: EdgeInsets.only(right: 10),
                              alignment: Alignment.topRight,
                              // ignore: prefer_const_constructors
                              child: Text(dataBis.fullName,
                                  maxLines: 2,
                                  // ignore: prefer_const_constructors
                                  // textAlign: TextAlign.right,
                                  // ignore: prefer_const_constructors
                                  style: TextStyle(
                                    color: Color.fromARGB(255, 68, 67, 67),
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14.0,
                                  )),
                            ),
                          ),
                          Expanded(
                            child: Container(
                              //margin: EdgeInsets.only(right: 10),
                              alignment: Alignment.topLeft,
                              // ignore: prefer_const_constructors
                              child: Text(dataBis.phone,
                                  maxLines: 2,
                                  // ignore: prefer_const_constructors
                                  // textAlign: TextAlign.right,
                                  // ignore: prefer_const_constructors
                                  style: TextStyle(
                                    color: Color.fromARGB(255, 68, 67, 67),
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14.0,
                                  )),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Divider(
                        height: 10,
                        thickness: 3,
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Container(
                        alignment: Alignment.topRight,
                        child: Text("איימל וסיסמה",
                            textAlign: TextAlign.right,
                            // ignore: prefer_const_constructors
                            // textAlign: TextAlign.right,
                            // ignore: prefer_const_constructors
                            style: TextStyle(
                              color: Color.fromARGB(255, 0, 0, 0),
                              fontWeight: FontWeight.bold,
                              fontSize: 15.0,
                            )),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Container(
                              //margin: EdgeInsets.only(right: 10),
                              alignment: Alignment.topRight,
                              // ignore: prefer_const_constructors
                              child: Text(dataBis.email,
                                  maxLines: 2,
                                  textDirection: TextDirection.ltr,
                                  // ignore: prefer_const_constructors
                                  // textAlign: TextAlign.right,
                                  // ignore: prefer_const_constructors
                                  style: TextStyle(
                                    color: Color.fromARGB(255, 68, 67, 67),
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14.0,
                                  )),
                            ),
                          ),
                          Expanded(
                            child: Container(
                              //margin: EdgeInsets.only(right: 10),
                              alignment: Alignment.topLeft,
                              // ignore: prefer_const_constructors
                              child: Text(dataBis.password,
                                  maxLines: 2,
                                  // ignore: prefer_const_constructors
                                  // textAlign: TextAlign.right,
                                  // ignore: prefer_const_constructors
                                  style: TextStyle(
                                    color: Color.fromARGB(255, 68, 67, 67),
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14.0,
                                  )),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Divider(
                        height: 10,
                        thickness: 3,
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Container(
                        alignment: Alignment.topRight,
                        child: Text("שם העסק",
                            textAlign: TextAlign.right,
                            // ignore: prefer_const_constructors
                            // textAlign: TextAlign.right,
                            // ignore: prefer_const_constructors
                            style: TextStyle(
                              color: Color.fromARGB(255, 0, 0, 0),
                              fontWeight: FontWeight.bold,
                              fontSize: 15.0,
                            )),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Container(
                        //margin: EdgeInsets.only(right: 10),
                        alignment: Alignment.topRight,
                        // ignore: prefer_const_constructors
                        child: Text(dataBis.NameBis,
                            maxLines: 2,
                            textDirection: TextDirection.ltr,
                            // ignore: prefer_const_constructors
                            // textAlign: TextAlign.right,
                            // ignore: prefer_const_constructors
                            style: TextStyle(
                              color: Color.fromARGB(255, 68, 67, 67),
                              fontWeight: FontWeight.bold,
                              fontSize: 14.0,
                            )),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Divider(
                        height: 10,
                        thickness: 3,
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Container(
                        alignment: Alignment.topRight,
                        child: Text("שם הרחוב",
                            textAlign: TextAlign.right,
                            textDirection: TextDirection.ltr,

                            // ignore: prefer_const_constructors
                            // textAlign: TextAlign.right,
                            // ignore: prefer_const_constructors
                            style: TextStyle(
                              color: Color.fromARGB(255, 0, 0, 0),
                              fontWeight: FontWeight.bold,
                              fontSize: 15.0,
                            )),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Container(
                        //margin: EdgeInsets.only(right: 10),
                        alignment: Alignment.topRight,
                        // ignore: prefer_const_constructors
                        child: Text(dataBis.StreetName,
                            maxLines: 2,
                            textDirection: TextDirection.ltr,
                            // ignore: prefer_const_constructors
                            // textAlign: TextAlign.right,
                            // ignore: prefer_const_constructors
                            style: TextStyle(
                              color: Color.fromARGB(255, 68, 67, 67),
                              fontWeight: FontWeight.bold,
                              fontSize: 14.0,
                            )),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                    ],
                  ),
                ));
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

  Future<List<MyWoresHores>> getDataList() async {
    dataWorks.clear();
    SharedPreferences prefsMyData = await SharedPreferences.getInstance();
    print("wfffff11 " + prefsMyData.getString(deys[0]).toString());
    //שעות פעילות
    for (int i = 0; i < 6; i++) {
      if (prefsMyData.getString(deys[i]).toString().split(",")[0] != " סגור ") {
        dataWorks.add(new MyWoresHores(
            deys[i],
            prefsMyData.getString(deys[i]).toString().split(",")[0],
            prefsMyData.getString(deys[i]).toString().split(",")[1]));
      } else {
        if (i == 0) {
          dataWorks.add(new MyWoresHores("יום ראשון", "סגור", "סגור"));
        }
        if (i == 1) {
          dataWorks.add(new MyWoresHores("יום שני", "סגור", "סגור"));
        }
        if (i == 2) {
          dataWorks.add(new MyWoresHores("יום שלישי", "סגור", "סגור"));
        }
        if (i == 3) {
          dataWorks.add(new MyWoresHores("יום רביעי", "סגור", "סגור"));
        }
        if (i == 4) {
          dataWorks.add(new MyWoresHores("יום חמישי", "סגור", "סגור"));
        }
        if (i == 5) {
          dataWorks.add(new MyWoresHores("יום שישי", "סגור", "סגור"));
        }
      }
      print("wfffff11 " + dataWorks[0].day.toString());
    }
    return dataWorks;
  }

  Future<MyData> getData() async {
    SharedPreferences prefsMyData = await SharedPreferences.getInstance();
    // פרטי העסק
    dataBis.fullName = prefsMyData.getString("FullName").toString();
    dataBis.phone = prefsMyData.getString("Phone").toString();
    dataBis.NameBis = prefsMyData.getString("NameBis").toString();
    dataBis.email = prefsMyData.getString("Email").toString();
    dataBis.password = prefsMyData.getString("Password").toString();
    dataBis.StreetName = prefsMyData.getString("Street").toString();
    print("fefefefvvvv1 - " + prefsMyData.getString("FullName").toString());
    return dataBis;
  }

  Future<List<typeServerModel>> getCategoryData() async {
    final prefsListTypeRegister = await SharedPreferences.getInstance();
    final category = prefsListTypeRegister.getString("ListServiceRegister");
    listTypeService = List<typeServerModel>.from(
        List<Map<String, dynamic>>.from(jsonDecode(category.toString()))
            .map((e) => typeServerModel.fromJson(e))
            .toList());

    print("eldaros " + listTypeService.first.nameServer.toString());

    return listTypeService;
  }

  Future<List<typeServerModel>> getDataListService() async {
    setState(() {
      indexDef++;
    });
    if (indexDef > 3) {
      listTypeService.clear();
    }
    SharedPreferences prefsListTypeRegister =
        await SharedPreferences.getInstance();

    Map<String, dynamic> result = jsonDecode(
        prefsListTypeRegister.getString("ListServiceRegister").toString());

    print("eldaros " + result.toString());

    return listTypeService;
  }

  worksHors() {
    return FutureBuilder(
        future: getDataList(),
        builder: (context, snapshot) {
          if (dataWorks.isNotEmpty) {
            return Container(
              decoration: BoxDecoration(
                  border: Border.all(
                    color: Color.fromARGB(255, 199, 195, 195),
                  ),
                  borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(5),
                      bottomRight: Radius.circular(5))),
              child: Container(
                margin: EdgeInsets.only(right: 15, left: 15),
                child: Column(
                  children: [
                    SizedBox(
                      height: 10,
                      width: 20,
                    ),
                    for (int i = 0; i < dataWorks.length; i++)
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
                              child: Text(dataWorks[i].day,
                                  maxLines: 2,
                                  // ignore: prefer_const_constructors
                                  // textAlign: TextAlign.right,
                                  // ignore: prefer_const_constructors
                                  style: TextStyle(
                                    color: Color.fromARGB(255, 68, 67, 67),
                                    fontWeight: FontWeight.bold,
                                    fontSize: 15.0,
                                  )),
                            ),
                          ),
                          Expanded(
                            child: Container(
                              //margin: EdgeInsets.only(right: 10),
                              alignment: Alignment.topLeft,
                              // ignore: prefer_const_constructors
                              child: dataWorks[i].start != "סגור"
                                  ? Text(
                                      dataWorks[i].end +
                                          " - " +
                                          dataWorks[i].start,
                                      textDirection: TextDirection.ltr,
                                      maxLines: 2,
                                      // ignore: prefer_const_constructors
                                      // textAlign: TextAlign.right,
                                      // ignore: prefer_const_constructors
                                      style: TextStyle(
                                        color: Color.fromARGB(255, 68, 67, 67),
                                        fontSize: 14.0,
                                      ))
                                  : Container(
                                      width: 100,
                                      color: Color.fromARGB(255, 224, 220, 220),
                                      child: Text("סגור",
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

  listService() {
    return FutureBuilder(
        future: getCategoryData(),
        builder: (context, snapshot) {
          if (listTypeService.isNotEmpty) {
            return Container(
              decoration: BoxDecoration(
                  border: Border.all(
                    color: Color.fromARGB(255, 199, 195, 195),
                  ),
                  borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(5),
                      bottomRight: Radius.circular(5))),
              child: Container(
                margin: EdgeInsets.only(right: 15, left: 15),
                child: Column(
                  children: [
                    SizedBox(
                      height: 10,
                      width: 20,
                    ),
                    Container(
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
                            return Container(
                              child: Card(
                                shadowColor: Color.fromARGB(255, 0, 0, 0),
                                shape: RoundedRectangleBorder(
                                  side: BorderSide(
                                    width: 1.0,
                                  ),
                                  borderRadius: BorderRadius.circular(
                                      10.0), //<-- SEE HERE
                                ),
                                elevation: 25,
                                child: ListTile(
                                  title: Text(
                                    maxLines: 2,
                                    listTypeService[index]
                                        .nameServer
                                        .toString(),
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

                                  selectedTileColor:
                                      Color.fromARGB(255, 0, 0, 0),
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
                                                .time
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
                                  // onTap: () {},
                                ),
                              ),
                            );
                          }),
                    )
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

  nameStep() {
    return Row(
      children: <Widget>[
        SizedBox(width: 15),
        Container(
          //margin: EdgeInsets.all(20),
          width: 55,
          height: 55,

          child: ClipRRect(
            borderRadius: BorderRadius.circular(50.0),
            child: Image.asset(
              "assets/finish_register.jpg",
              width: 150.0,
              height: 150.0,
              fit: BoxFit.fill,
            ),
          ),
        ),
        SizedBox(width: 15),
        // ignore: prefer_const_constructors
        Text("סיום הרשמה",
            // ignore: prefer_const_constructors
            style: TextStyle(
              color: Color.fromARGB(255, 0, 0, 0),
              fontWeight: FontWeight.bold,
              fontSize: 30.0,
            ))
      ],
    );
  }
}
