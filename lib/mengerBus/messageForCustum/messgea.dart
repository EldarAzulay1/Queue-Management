// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class messgea extends StatelessWidget {
  final myControllerImage = TextEditingController();
  final String nameClient;
  messgea({Key? key, required this.nameClient}) : super(key: key);
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
              body: list(nameClient: nameClient),
              //ignore: prefer_const_constructors
            )));
  }
}

class list extends StatefulWidget {
  String nameClient;
  list({Key? key, required this.nameClient}) : super(key: key);
  @override
  State<list> createState() => _timeWorks(nameClient);
}

class _timeWorks extends State<list> {
  ScrollController _scrollController = ScrollController();
  final myControllerMessage = TextEditingController();
  String StaticMess = "כרגע אין הודעה , נתן לרשום הודעה למעלה";
  DatabaseReference refM = FirebaseDatabase.instance.ref();
  String nameClient;
  _timeWorks(this.nameClient);
  @override
  void initState() {
    getMess();
    super.initState();
  }

  getMess() async {
    final ref = FirebaseDatabase.instance.ref();
    final snapshot = await ref.child(nameClient).get();
    if (snapshot.hasChild('הודעה')) {
      setState(() {
        StaticMess = snapshot.child('הודעה').value.toString();
      });
    } else {
      setState(() {
        StaticMess = "כרגע אין הודעה , נתן לרשום הודעה למעלה";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        child: Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: Color.fromARGB(255, 240, 240, 240),
        body: SingleChildScrollView(
          controller: _scrollController,
          child: Center(
            child: ConstrainedBox(
              constraints: BoxConstraints(minHeight: 50, maxWidth: 800),
              child: Container(
                  margin: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                      border: Border.all(
                        color: Color.fromARGB(255, 190, 190, 190),
                      ),
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(6),
                          topRight: Radius.circular(6))),
                  alignment: Alignment.center,
                  child: Column(
                    children: [
                      Container(
                          child: Column(
                        children: [
                          Container(
                            margin: EdgeInsets.only(right: 15, top: 10),
                            alignment: Alignment.topRight,
                            // ignore: prefer_const_constructors
                            child: Text(
                                // ignore: prefer_interpolation_to_compose_strings
                                "הודעה ללקוחות",
                                // ignore: prefer_const_constructors
                                style: TextStyle(
                                  color: Color.fromARGB(255, 56, 55, 55),
                                  fontWeight: FontWeight.bold,
                                  fontSize: 24.0,
                                )),
                          ),
                          Container(
                            margin: EdgeInsets.only(right: 15, top: 3),
                            alignment: Alignment.topRight,
                            child: Text("עדכן לקוחות בחופשה או דברים נוספים",
                                // ignore: prefer_const_constructors
                                style: TextStyle(
                                  color: Color.fromARGB(255, 101, 100, 100),
                                  //fontWeight: FontWeight.bold,
                                  fontSize: 15.0,
                                )),
                          ),
                        ],
                      )),
                      ConstrainedBox(
                        constraints:
                            BoxConstraints(minHeight: 50, maxWidth: 800),
                        child: Divider(
                          height: 40,
                          thickness: 3,
                        ),
                      ),
                      Container(
                        child: Column(
                          children: [
                            Container(
                              margin: EdgeInsets.only(right: 15),
                              alignment: Alignment.topRight,
                              // ignore: prefer_const_constructors
                              child: Text("רשום הודעה",
                                  // ignore: prefer_const_constructors
                                  // textAlign: TextAlign.right,
                                  // ignore: prefer_const_constructors
                                  style: TextStyle(
                                    color: Color.fromARGB(255, 0, 0, 0),
                                    fontWeight: FontWeight.bold,
                                    fontSize: 17.0,
                                  )),
                            ),
                            Container(
                              margin: EdgeInsets.only(right: 15, top: 3),
                              alignment: Alignment.topRight,
                              child: Text("ההודעה תוצג באתר",
                                  // ignore: prefer_const_constructors
                                  style: TextStyle(
                                    color: Color.fromARGB(255, 101, 100, 100),
                                    //fontWeight: FontWeight.bold,
                                    fontSize: 15.0,
                                  )),
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            Container(
                              margin: EdgeInsets.all(20),
                              alignment: Alignment.topRight,
                              //width: 400,
                              child: Directionality(
                                  textDirection: TextDirection.rtl,
                                  child: TextField(
                                    maxLines: 10, // <-- SEE HERE
                                    minLines: 4,
                                    controller: myControllerMessage,
                                    textDirection: TextDirection.ltr,
                                    textAlign: TextAlign.right,
                                    autofocus: true,
                                    onChanged: (value) async {},
                                    // ignore: prefer_const_constructors
                                    // ignore: unnecessary_new
                                    decoration: new InputDecoration(
                                      filled: true,

                                      prefixIcon: Icon(
                                        Icons.message,
                                        size: 30,
                                      ),
                                      labelStyle: TextStyle(
                                        color: Color.fromARGB(255, 0, 0, 0),
                                      ),
                                      border: OutlineInputBorder(),
                                      //labelText: "איימל",
                                    ),
                                  )),
                            ),
                          ],
                        ),
                      ),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            //primary: Color.fromARGB(255, 41, 42, 43),
                            elevation: 3,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.0)),
                            minimumSize: Size(250, 50),
                            textStyle: const TextStyle(fontSize: 20)),
                        child: Text("שלח הודעה"),
                        onPressed: () {
                          setState(() {
                            myControllerMessage.text;
                          });
                          refM
                              .child(nameClient)
                              .child("הודעה")
                              .set(myControllerMessage.text);
                        },
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Divider(
                        height: 2,
                        thickness: 2,
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Container(
                        margin: EdgeInsets.only(right: 15),
                        alignment: Alignment.topRight,
                        // ignore: prefer_const_constructors
                        child: Text("הודעה נוכחית",
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
                          //height: 100,
                          margin: EdgeInsets.all(15),
                          decoration: BoxDecoration(
                              border: Border.all(
                                width: 2,
                                color: Color.fromARGB(255, 241, 29, 33),
                              ),
                              borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(6),
                                  topRight: Radius.circular(6))),
                          alignment: Alignment.topRight,
                          // ignore: prefer_const_constructors
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  Container(
                                    margin: EdgeInsets.only(right: 5, top: 3),
                                    child: Icon(
                                      color: Color.fromARGB(255, 232, 64, 64),
                                      Icons.mail,
                                      size: 20,
                                    ),
                                  ),
                                  Container(
                                    margin: EdgeInsets.only(right: 5, top: 3),
                                    alignment: Alignment.topRight,
                                    // ignore: prefer_const_constructors
                                    child: Text(":עידכון",
                                        textDirection: TextDirection.ltr,
                                        // ignore: prefer_const_constructors
                                        // textAlign: TextAlign.right,
                                        // ignore: prefer_const_constructors
                                        style: TextStyle(
                                          color: Color.fromARGB(255, 0, 0, 0),
                                          fontWeight: FontWeight.bold,
                                          fontSize: 17.0,
                                        )),
                                  ),
                                ],
                              ),
                              Container(
                                margin: EdgeInsets.only(
                                    left: 10, right: 15, top: 10, bottom: 10),
                                alignment: Alignment.topRight,
                                child: Text(
                                    myControllerMessage.text.isEmpty
                                        ? StaticMess
                                        : myControllerMessage.text,
                                    // ignore: prefer_const_constructors
                                    // textAlign: TextAlign.right,
                                    // ignore: prefer_const_constructors
                                    style: TextStyle(
                                      color: Color.fromARGB(255, 71, 71, 71),
                                      fontWeight: FontWeight.w600,
                                      fontSize: 16.0,
                                    )),
                              ),
                            ],
                          )),
                      Container(
                        alignment: Alignment.topRight,
                        margin: EdgeInsets.only(right: 15, top: 3),
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              primary: Color.fromARGB(255, 237, 11, 11),
                              elevation: 3,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10.0)),
                              minimumSize: Size(50, 40),
                              textStyle: const TextStyle(fontSize: 15)),
                          child: Text("מחק הודעה"),
                          onPressed: () {
                            setState(() {
                              myControllerMessage.text = "";
                              StaticMess =
                                  "כרגע אין הודעה , נתן לרשום הודעה למעלה";
                            });
                            refM.child(nameClient).child("הודעה").remove();
                          },
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                    ],
                  )),
            ),
          ),
        ),
      ),
    ));
  }
}
