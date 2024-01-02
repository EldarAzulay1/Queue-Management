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
import 'package:my_tor/registerNew/tableRegisterUser.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_email_sender/flutter_email_sender.dart';

class myServices extends StatefulWidget {
  final String nameClient;

  myServices({Key? key, required this.nameClient}) : super(key: key);

  @override
  State<myServices> createState() => _list(nameClient);
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

class _list extends State<myServices> {
  String nameClient;
  _list(this.nameClient);
  int timeWorkService = 0;
  int priceWorkService = 0;
  final myControllerNameSerive = TextEditingController();
  final myControllerSubTitleSerive = TextEditingController();
  final myControllerPhone = TextEditingController();
  final myControllerNameBis = TextEditingController();
  final myControllerEmail = TextEditingController();
  final myControllerPassword = TextEditingController();
  bool _passwordVisible = true, subTitleBool = false;
  List<typeServerModel> listTypeService = [];
  List<String> servicesList = [];
  Color borderColor = Color.fromARGB(255, 67, 67, 68);

  // remove() async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   setState(() {
  //     prefs.clear();
  //   });
  // }

  @override
  void initState() {
    //remove();
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
          height: 10,
        ),
        ConstrainedBox(
          constraints: BoxConstraints(minHeight: 50, maxWidth: 500),
          child: setDetatils(context),
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
                Container(
                    alignment: Alignment.centerRight,
                    child: Text("החלק לצד למחיקת שירות",
                        // ignore: prefer_const_constructors
                        textAlign: TextAlign.right,
                        // ignore: prefer_const_constructors
                        style: TextStyle(
                          color: Color.fromARGB(255, 101, 100, 100),
                          //fontWeight: FontWeight.bold,
                          fontSize: 15.0,
                        ))),
                dataType(),
              ],
            )),

        SizedBox(
          height: 20,
        ),
      ],
    ));
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
                            addService(
                                myControllerNameSerive.text,
                                timeWorkService.toString(),
                                priceWorkService.toString(),
                                myControllerSubTitleSerive.text);
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
                        },
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

  addService(
      String NameType, String Time, String price, String SubTitle) async {
    setState(() {
      listTypeService
          .add(new typeServerModel(NameType, Time, price + " ₪", SubTitle));
    });

    String json = jsonEncode(listTypeService);
    SharedPreferences prefsListTypeRegister =
        await SharedPreferences.getInstance();
    prefsListTypeRegister.setString("ListServiceRegister", json);
    myControllerNameSerive.text = "";
    myControllerSubTitleSerive.text = "";
    priceWorkService = 0;
    timeWorkService = 0;
    tableRegisterUser test = new tableRegisterUser(nameClient: nameClient);
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        // ignore: prefer_const_constructors
        content: Text(
      "השירות נוסף בהצלחה",
      textAlign: TextAlign.right,
    )));
    SharedPreferences prefsScrollButton = await SharedPreferences.getInstance();
    prefsScrollButton.setString("ScrollButton", "true");
    test.test1();
  }

  get() async {
    final prefsListTypeRegister = await SharedPreferences.getInstance();
    final category = prefsListTypeRegister.getString("ListServiceRegister");
    listTypeService = List<typeServerModel>.from(
        List<Map<String, dynamic>>.from(jsonDecode(category.toString()))
            .map((e) => typeServerModel.fromJson(e))
            .toList());
    setState(() {
      listTypeService;
    });
  }

  setNewList(List<typeServerModel> list) async {
    final prefsListTypeRegister = await SharedPreferences.getInstance();

    String json = jsonEncode(list);
    prefsListTypeRegister.setString("ListServiceRegister", json);
  }

  dataType() {
    get();
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
            return Container(
              child: Card(
                shadowColor: Color.fromARGB(255, 0, 0, 0),
                shape: RoundedRectangleBorder(
                  side: BorderSide(
                    width: 1.0,
                    color: borderColor = Color.fromARGB(255, 143, 141, 141),
                  ),
                  borderRadius: BorderRadius.circular(10.0), //<-- SEE HERE
                ),
                elevation: 25,
                child: Dismissible(
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
                  key: Key(listTypeService[index].nameServer.toString()),
                  onDismissed: (direction) {
                    setState(() {
                      listTypeService.removeAt(index);
                    });
                    setNewList(listTypeService);
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
                    subtitle: listTypeService[index].subTitle!.isNotEmpty &&
                            listTypeService[index].subTitle != "null"
                        ? Text(
                            maxLines: 2,
                            listTypeService[index].subTitle.toString(),
                            style: TextStyle(
                              color: Color.fromARGB(255, 115, 114, 114),
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
                            text: listTypeService[index].price.toString(),
                          ),
                          TextSpan(text: "  |  "),
                          //TextSpan(text: listTypeServer[index].time.toString()),
                          TextSpan(
                              text: listTypeService[index].time.toString()),
                          TextSpan(text: " "),

                          WidgetSpan(
                            // ignore: prefer_const_constructors
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 0.0),
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
                    //onTap: () {},
                  ),
                ),
              ),
            );
          }),
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
              "assets/service.png",
              width: 150.0,
              height: 150.0,
              fit: BoxFit.fill,
            ),
          ),
        ),
        SizedBox(width: 15),
        // ignore: prefer_const_constructors
        Text("שירותי העסק",
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
