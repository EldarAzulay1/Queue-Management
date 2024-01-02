// ignore_for_file: unnecessary_new, prefer_const_constructors, prefer_const_literals_to_create_immutables, unnecessary_null_comparison

import 'dart:convert';
import 'package:firebase_database/firebase_database.dart';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class typeServer extends StatefulWidget {
  final myControllerImage = TextEditingController();
  //var listTypeServer;

  //, required this.listTypeServer

  typeServer({Key? key}) : super(key: key);

  @override
  State<typeServer> createState() => _list();
}

class _list extends State<typeServer> {
  final myControllerMessage = TextEditingController();
  List<typeServerModel> listTypeServer1 = [];
  List<MyDataList> listTypeServer31 = [];
  final List<MyDataList> listTypeServer15 = [];

  final DatabaseReference database = FirebaseDatabase.instance.reference();

  setPrefDataUser(String typeService, String price, String time,
      String subTitleService, String DistansTime , String Timer) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    setState(() {
      prefs.setString("userType", typeService).toString();
      prefs.setString("subTitleService", subTitleService).toString();
      prefs.setString("TypeTime", time).toString();
      prefs.setString("Timer", Timer).toString();
      prefs.setInt("DistansTime", int.parse(DistansTime));
      prefs.setString("TypePrice", price).toString();
    });
  }

  _list();

  int currentStep = 0;
  //List<typeServerModel> listTypeServer = [];
  String? color, colorType, click;
  bool click1 = false;
  Color borderColor = Color.fromARGB(255, 67, 67, 68);
  int? selectedIndex;
  int count = 0;
  @override
  void initState() {
    getCategoryData();
  }

  //לוקח סוגי שירות של העסק
  Future<List<typeServerModel>> getCategoryData() async {
    if (listTypeServer1.isNotEmpty) {
      listTypeServer1.clear();
    }
    final prefsListType1 = await SharedPreferences.getInstance();
    final category = prefsListType1.getString("ListService");
    listTypeServer1 = List<typeServerModel>.from(
        List<Map<String, dynamic>>.from(jsonDecode(category.toString()))
            .map((e) => typeServerModel.fromJson(e))
            .toList());

    return listTypeServer1;
  }

  Widget build(BuildContext context) {
    return Column(
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
            constraints: BoxConstraints(minHeight: 50, maxWidth: 600),
            child: dataType()),
        SizedBox(
          height: 40,
        )

        // ignore: prefer_const_constructors
      ],
    );
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
              "assets/typeService.jpg",
              width: 110.0,
              height: 110.0,
              fit: BoxFit.fill,
            ),
          ),
        ),
        SizedBox(width: 15),
        Text("בחר סוג שירות",
            style: TextStyle(
              color: Color.fromARGB(255, 0, 0, 0),
              fontWeight: FontWeight.bold,
              fontSize: 30.0,
            ))
      ],
    );
  }

  //מציג נתוני שירות
  dataType() {
    return FutureBuilder<List<typeServerModel>>(builder: (context, snapshot) {
      List<MyDataList> dataList = [];

      if (listTypeServer1.isNotEmpty) {
        return Container(
          child: ListView.separated(
              physics: const NeverScrollableScrollPhysics(),
              itemCount: listTypeServer1.length,
              separatorBuilder: (context, index) {
                return Divider(
                  height: 30,
                  thickness: 1,
                );
              },
              shrinkWrap: true,
              itemBuilder: (context, index) {
                final typeServerModel data = listTypeServer1[index];

                return Container(
                  child: Card(
                    shadowColor: Color.fromARGB(255, 0, 0, 0),
                    shape: RoundedRectangleBorder(
                      side: BorderSide(
                        width: 1.0,
                        color: borderColor = Color.fromARGB(255, 143, 141, 141),
                      ),
                      borderRadius: BorderRadius.circular(5.0), //<-- SEE HERE
                    ),
                    elevation: 10,
                    child: ListTile(
                      title: Text(
                        data.nameServer.toString(),
                        style: TextStyle(
                          color: Color.fromARGB(255, 0, 0, 0),
                          fontWeight: FontWeight.bold,
                          fontSize: 15.0,
                        ),
                      ),
                      subtitle:
                          data.subTitle!.isNotEmpty && data.subTitle != "null"
                              ? Text(
                                  maxLines: 2,
                                  data.subTitle.toString(),
                                  style: TextStyle(
                                    color: Color.fromARGB(255, 115, 114, 114),
                                    fontWeight: FontWeight.w600,
                                    fontSize: 14.0,
                                  ),
                                )
                              : null,
                      trailing: RichText(
                        text: TextSpan(
                          style: TextStyle(
                            //backgroundColor: Color.fromARGB(255, 178, 175, 175),
                            color: Color.fromARGB(255, 81, 79, 79),
                            fontWeight: FontWeight.bold,
                            fontSize: 14.0,
                          ),
                          // ignore: prefer_const_literals_to_create_immutables
                          children: [
                            // ignore: prefer_interpolation_to_compose_strings
                            TextSpan(
                              text: data.price.toString(),
                            ),
                            TextSpan(text: "  |  "),
                            //TextSpan(text: listTypeServer[index].time.toString()),
                            TextSpan(text: data.Timer.toString()),
                            TextSpan(text: " "),

                            WidgetSpan(
                              // ignore: prefer_const_constructors
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 0.0),
                                child: Icon(
                                  Icons.alarm_outlined,
                                  size: 13,
                                ),
                              ),
                            ),

                            // ignore: prefer_const_constructors

                            //TextSpan(text: 'By Michael'),
                          ],
                        ),
                      ),
                      selectedTileColor: Color.fromARGB(255, 0, 0, 0),
                      textColor: Color.fromARGB(255, 0, 0, 0),
                      onTap: () {
                        setIndex();
                        setPrefDataUser(
                            data.nameServer.toString(),
                            data.price.toString(),
                            data.time.toString(),
                            data.subTitle.toString(),
                            data.Distans.toString(),
                             data.Timer.toString()
                            );
                        setState(() {
                          selectedIndex = index;
                        });
                      },
                    ),
                  ),
                );
              }),
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

  setIndex() async {
    final prefsIndex = await SharedPreferences.getInstance();
    setState(() {
      prefsIndex.setString("scrollTop", "true");
      prefsIndex.setString("indexTor", "1");
    });
  }
}

class MyDataList {
  final String nameServer;
  final String time;
  final String price;

  MyDataList(
      {required this.nameServer, required this.time, required this.price});
}

class typeServerModel {
  String? nameServer;
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
      'Timer': Timer,
    };
  }

  typeServerModel.fromJson(Map<String, dynamic> json) {
    nameServer = json['name'];
    price = json['price'];
    time = json['time'];
    subTitle = json['subTitle'];
    Distans = json['Distans'];
    Timer = json['Timer'];
  }
}
