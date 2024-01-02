// ignore_for_file: unnecessary_new, file_names, camel_case_types

import 'dart:convert';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
// ignore: unused_import
import '../main.dart';

class giveService extends StatefulWidget {
  final myControllerImage = TextEditingController();
  final String nameClient;

  giveService({Key? key, required this.nameClient}) : super(key: key);
  @override
  State<giveService> createState() => _list(nameClient);
}

class _list extends State<giveService> {
  final myControllerMessage = TextEditingController();
  final String nameClient;

  _list(this.nameClient);
  int currentStep = 0;
  List<workerListModel> listGiveService = [];
  int? selectedIndex;

  setPrefDataUser(String giveService) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString("userGiveService", giveService).toString();
  }

  @override
  void initState() {
    getCategoryDataGiveService();
  }

  //מביאי נותני שירות
  getCategoryDataGiveService() async {
    final prefsListWorker = await SharedPreferences.getInstance();
    final category = prefsListWorker.getString("ListWorker");
    listGiveService = List<workerListModel>.from(
        List<Map<String, dynamic>>.from(jsonDecode(category.toString()))
            .map((e) => workerListModel.fromJson(e))
            .toList());

    if (listGiveService.isEmpty) {
      DatabaseReference starCountRef =
          // '$l1/$numberL/עובדים'
          FirebaseDatabase.instance.ref('$nameClient/עובדים');
      starCountRef.onValue.listen((DatabaseEvent event) async {
        if (listGiveService.isNotEmpty) {
          listGiveService.clear();
        }
        if (event.snapshot.exists) {
          for (int i = 0; i < event.snapshot.children.length; i++) {
            listGiveService.add(new workerListModel(
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
        }
      });

      starCountRef.onChildRemoved.listen((event) {
        if (listGiveService.isNotEmpty) {
          listGiveService.clear();
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
            listGiveService.add(new workerListModel(
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
        }
      });
    }
    return listGiveService;
  }

  Widget build(BuildContext context) {
    return Container(
        child: Column(
      // ignore: prefer_const_literals_to_create_immutables
      children: [
        // ignore: prefer_const_constructors
        ConstrainedBox(
          constraints: BoxConstraints(minHeight: 50, maxWidth: 600),
          child: nameStep(),
        ),
        ConstrainedBox(
          constraints: BoxConstraints(minHeight: 50, maxWidth: 600),
          // ignore: prefer_const_constructors
          child: Divider(
            height: 40,
            thickness: 3,
          ),
        ),
        ConstrainedBox(
          constraints: BoxConstraints(minHeight: 50, maxWidth: 600),
          // ignore: prefer_const_constructors
          child: dataGive(),
        ),
        // ignore: prefer_const_constructors
        SizedBox(
          height: 40,
        )
        // ignore: prefer_const_constructors
      ],
    ));
  }

  nameStep() {
    return Row(
      children: <Widget>[
        SizedBox(width: 15),
        Container(
          //margin: EdgeInsets.all(20),
          width: 55,
          height: 55,
          // ignore: prefer_const_constructors
          child: ClipRRect(
            borderRadius: BorderRadius.circular(50.0),
            child: Image.asset(
              "assets/give.jpg",
              width: 110.0,
              height: 110.0,
              fit: BoxFit.fill,
            ),
          ),
        ),
        SizedBox(width: 15),
        // ignore: prefer_const_constructors
        Text("בחר נותן שירות",
            // ignore: prefer_const_constructors
            style: TextStyle(
              color: Color.fromARGB(255, 0, 0, 0),
              fontWeight: FontWeight.bold,
              fontSize: 30.0,
            ))
      ],
    );
  }

  //מציג נותני שירות
  dataGive() {
    return Container(
      padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
      width: double.maxFinite,
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
                  // ignore: prefer_const_constructors
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
                      setIndex();
                      setPrefDataUser(
                          listGiveService[index].nameWorker.toString());
                      setState(() {
                        selectedIndex = index;
                      });
                    },
                  ),
                ),
              ),
            );
          }),
    );
  }

  setIndex() async {
    final prefsIndex = await SharedPreferences.getInstance();
    setState(() {
      prefsIndex.setString("scrollTop", "true");
      prefsIndex.setString("indexTor", "2");
    });
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
