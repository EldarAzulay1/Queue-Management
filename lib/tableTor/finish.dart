// ignore_for_file: unnecessary_new, prefer_const_constructors, unnecessary_this, depend_on_referenced_packages, unrelated_type_equality_checks, prefer_interpolation_to_compose_strings, avoid_single_cascade_in_expression_statements, unused_local_variable, prefer_const_literals_to_create_immutables, use_build_context_synchronously

import 'dart:convert';
import 'dart:math';

import 'package:firebase_database/firebase_database.dart';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:my_tor/main.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:pinput/pinput.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core_web/firebase_core_web.dart';
import 'package:firebase_auth_web/firebase_auth_web.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;
import 'package:toast/toast.dart';

import '../websites/web_sites.dart';

class finish extends StatefulWidget {
  final myControllerImage = TextEditingController();
  final String nameClient;

  finish({Key? key, required this.nameClient}) : super(key: key);

  @override
  State<finish> createState() => _list(nameClient);
}

class _list extends State<finish> {
  final myControllerMessage = TextEditingController();
  DatabaseReference refM = FirebaseDatabase.instance.ref();
  String nameClient;
  _list(this.nameClient);
  final myControllerName = TextEditingController();
  final myControllerPhone = TextEditingController();
  DateTime rangeStart1 = new DateTime.now();

  int currentStep = 0;
  List<typeServerModel> listTypeServer = [];
  String? color, colorType, click;
  String type = "",
      give = "",
      start = "1000",
      end = "",
      date = "",
      dateHebro = "",
      TypeTime = "",
      Timer = "",
      TypePrice = "";
  String NameDay = "",
      NumberMunth = "",
      NameMonth = "",
      NameMonthForDate = "",
      dateNow = "",
      lokData = "";
  String nameWeb = "null";
  String userNamePhoneCode = "eldar053@walla.com",
      keyClickSend = "46FCBDCE-D579-C133-3502-388E176D7581",
      toSend = "",
      messFinish = "";
  FirebaseAuth auth = FirebaseAuth.instance;
  String veriId = "";
  var phone = '+972524228073';
  final otpController = TextEditingController();
  ConfirmationResult? confirmationResult;
  Color borderColor = Color.fromARGB(255, 67, 67, 68);
  int? selectedIndex;
  bool mengerTor = false;
  String nameCas = "null", phoneCas = "null";
  get() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    SharedPreferences prefsImot = await SharedPreferences.getInstance();
    SharedPreferences prefsMangTor = await SharedPreferences.getInstance();

    setState(() {
      type = prefs.getString("userType").toString();
      give = prefs.getString("userGiveService").toString();
      start = prefs.getString("userStart").toString();
      end = prefs.getString("userEnd").toString();
      date = prefs.getString("userDate").toString();
      if (prefsMangTor.getString("MangTor").toString() == "true") {
        print("cdsssddd - " + prefsMangTor.getString("MangTor").toString());

        setState(() {
          //mengerTor = true;
          nameCas = "null";
          phoneCas = "null";
        });
      } else {
        nameCas = prefsImot.getString("nameCas").toString();
        phoneCas = prefsImot.getString("phoneCas").toString();
      }

      if (date != "null") {
        print("cdddd - " + date.toString());
        rangeStart1 = new DateTime(
            int.parse(date.toString().split("-")[2]),
            int.parse(date.toString().split("-")[1]),
            int.parse(date.toString().split("-")[0]));

        DateTime day1 = new DateTime(
            int.parse(date.toString().split("-")[2]),
            int.parse(date.toString().split("-")[1]),
            int.parse(date.toString().split("-")[0]));
        getDay(day1.weekday);
        getDate(day1.month);
        NumberMunth = day1.toString().split("-").last.split(" ").first;

        date = NameDay +
            " , " +
            NumberMunth +
            " " +
            NameMonth +
            " " +
            day1.year.toString();
      }
      dateHebro = prefs.getString("dateHebro").toString();
      TypeTime = prefs.getString("TypeTime").toString();
      Timer = prefs.getString("Timer").toString();
      TypePrice = prefs.getString("TypePrice").toString();
    });
  }

  Future<String> loadAsset(String namec) async {
    String nameWeb = "assets/עסקים/webSiite/" + "$namec" + ".txt";

    print("fwfwfwwwww-- " +
        DefaultAssetBundle.of(context).loadString(nameWeb).toString());

    return await DefaultAssetBundle.of(context).loadString(nameWeb);
  }

  Widget build(BuildContext context) {
    get();

    String namec = nameClient.split("/")[1].toString();
    if (nameWeb == "null") {
      loadAsset(namec).then(
        (value) {
          setState(() {
            nameWeb = value;
          });
        },
      );
    }

    return Container(
      child: Container(
          child: Column(
        // ignore: prefer_const_literals_to_create_immutables
        children: [
          // ignore: prefer_const_constructors
          ConstrainedBox(
            constraints: BoxConstraints(minHeight: 50, maxWidth: 600),
            child: nameStep(),
          ),
          // ignore: prefer_const_constructors
          ConstrainedBox(
            constraints: BoxConstraints(minHeight: 50, maxWidth: 600),
            child: Divider(
              height: 40,
              thickness: 3,
            ),
          ),

          getTor(),
          SizedBox(
            height: 10,
          ),
          ConstrainedBox(
            constraints: BoxConstraints(minHeight: 50, maxWidth: 600),
            child: Divider(
              height: 10,
              thickness: 1,
            ),
          ),

          SizedBox(
            height: 20,
          ),
          nameAndPhone(),
          SizedBox(
            height: 50,
          ),
        ],
      )),
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
          // ignore: prefer_const_constructors
          child: ClipRRect(
            borderRadius: BorderRadius.circular(50.0),
            child: Image.asset(
              "assets/finish.png",
              width: 110.0,
              height: 110.0,
              fit: BoxFit.fill,
            ),
          ),
        ),
        SizedBox(width: 15),
        // ignore: prefer_const_constructors
        Text(nameCas == "null" && phoneCas == "null" ? "בצע אימות" : "קבע תור",
            // ignore: prefer_const_constructors
            style: TextStyle(
              color: Color.fromARGB(255, 0, 0, 0),
              fontWeight: FontWeight.bold,
              fontSize: 30.0,
            ))
      ],
    );
  }

  getTor() {
    return date != "null"
        ? ConstrainedBox(
            constraints: BoxConstraints(minHeight: 50, maxWidth: 450),
            child: Container(
                // width: 430,
                // height: 135,
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

                    // ignore: prefer_const_literals_to_create_immutables
                    child: Column(
                      children: [
                        SizedBox(
                          height: 15,
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          // ignore: prefer_const_literals_to_create_immutables
                          children: [
                            Text.rich(
                              TextSpan(
                                style: TextStyle(
                                  //backgroundColor: Color.fromARGB(255, 178, 175, 175),
                                  color: Color.fromARGB(255, 40, 39, 39),
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16.0,
                                ),
                                children: [
                                  WidgetSpan(child: Icon(Icons.date_range)),
                                  TextSpan(text: " "),
                                  TextSpan(
                                      // ignore: prefer_interpolation_to_compose_strings
                                      text: dateHebro),
                                  TextSpan(text: "  "),
                                ],
                              ),
                            ),
                            SizedBox(
                              height: 15,
                            ),
                            Text.rich(
                              TextSpan(
                                style: TextStyle(
                                  //backgroundColor: Color.fromARGB(255, 178, 175, 175),
                                  color: Color.fromARGB(255, 8, 8, 8),
                                  fontWeight: FontWeight.bold,
                                  fontSize: 23.0,
                                ),
                                // ignore: prefer_const_literals_to_create_immutables
                                children: [
                                  WidgetSpan(
                                      child: Icon(
                                    Icons.access_time_outlined,
                                    size: 22,
                                  )),
                                  TextSpan(
                                      // ignore: prefer_interpolation_to_compose_strings
                                      text: " בשעה " +
                                          start.substring(0, 2) +
                                          ":" +
                                          start.substring(2, 4)),
                                ],
                              ),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Container(
                              alignment: Alignment.center,
                              child: Text.rich(
                                TextSpan(
                                  style: TextStyle(
                                    //backgroundColor: Color.fromARGB(255, 178, 175, 175),
                                    color: Color.fromARGB(255, 40, 39, 39),
                                    fontWeight: FontWeight.bold,
                                    fontSize: 17.0,
                                  ),
                                  children: [
                                    TextSpan(text: " "),
                                    TextSpan(text: type),
                                  ],
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                  margin: EdgeInsets.only(right: 15, bottom: 5),
                                  child: Text.rich(
                                    TextSpan(
                                      style: TextStyle(
                                        //backgroundColor: Color.fromARGB(255, 178, 175, 175),
                                        color: Color.fromARGB(255, 53, 52, 52),
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16.0,
                                      ),
                                      children: [
                                        TextSpan(text: " "),
                                        TextSpan(text: give),
                                      ],
                                    ),
                                  ),
                                ),
                                Container(
                                  margin: EdgeInsets.only(left: 15, bottom: 2),
                                  child: Text.rich(
                                    TextSpan(
                                      style: TextStyle(
                                        //backgroundColor: Color.fromARGB(255, 178, 175, 175),
                                        color: Color.fromARGB(255, 53, 52, 52),
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16.0,
                                      ),
                                      children: [
                                        TextSpan(text: " "),
                                        TextSpan(
                                            text: TypePrice +
                                                "    |    " +
                                            Timer),
                                        TextSpan(text: " "),
                                        WidgetSpan(
                                            child: Icon(
                                          Icons.alarm_outlined,
                                          size: 18,
                                        )),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ))),
          )
        : Container();
  }

  nameAndPhone() {
    return Container(
        width: 200,
        child: Column(
          // ignore: prefer_const_literals_to_create_immutables
          children: [
            TextField(
              enableSuggestions: false,
              textAlign: TextAlign.center,
              controller: myControllerName,
              //maxLength: 100,
              decoration: InputDecoration(
                labelStyle: TextStyle(
                  color: Color.fromARGB(255, 6, 6, 6),
                ),
                filled: true,
                fillColor: Color.fromARGB(255, 254, 253, 255),
                labelText: nameCas == "null" && phoneCas == "null"
                    ? "רשום שם מלא"
                    : nameCas,
                enabled: nameCas == "null" && phoneCas == "null" ? true : false,
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            TextField(
              keyboardType: TextInputType.number,
              enableSuggestions: false,
              textAlign: TextAlign.center,
              controller: myControllerPhone,
              //maxLength: 100,
              decoration: InputDecoration(
                labelStyle: TextStyle(
                  color: Color.fromARGB(255, 6, 6, 6),
                ),
                filled: true,
                fillColor: Color.fromARGB(255, 254, 253, 255),
                labelText: nameCas == "null" && phoneCas == "null"
                    ? "מספר פלאפון לאימות"
                    : phoneCas,
                enabled: nameCas == "null" && phoneCas == "null" ? true : false,
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(
              height: 30,
            ),
            ElevatedButton(
                style: ElevatedButton.styleFrom(
                    primary: Color.fromARGB(255, 41, 42, 43),
                    elevation: 3,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0)),
                    minimumSize: Size(150, 50),
                    textStyle: const TextStyle(fontSize: 20)),
                child: nameCas == "null" && phoneCas == "null"
                    ? Text("בצע אימות")
                    : Text("קבע תור"),
                onPressed: () async {
                  // send http post request to sms server
                  // ignore: avoid_single_cascade_in_expression_statements
                  SharedPreferences prefs =
                      await SharedPreferences.getInstance();
                  DatabaseReference refM = FirebaseDatabase.instance.ref();
                  final event = await refM
                      .child(nameClient)
                      .child("לקוחות")
                      .child(phoneCas == "null"
                          ? myControllerPhone.text.toString()
                          : phoneCas)
                      .once(DatabaseEventType.value);

                  int cont = 0;
                  for (int i = 0;
                      i < event.snapshot.child("תורים").children.length;
                      i++) {
                    cont += event.snapshot
                        .child("תורים")
                        .children
                        .elementAt(i)
                        .children
                        .length;
                  }
                  SharedPreferences prefsMangTor =
                      await SharedPreferences.getInstance();

                  SharedPreferences prefsImot =
                      await SharedPreferences.getInstance();

                  var rndnumber = "";

                  if (prefsMangTor.getString("MangTor").toString() == "true") {
                    prefsMangTor.setString("MangTor", "false");
                    if (myControllerName.text.toString().isNotEmpty) {
                      var rnd = new Random();
                      for (var i = 0; i < 4; i++) {
                        rndnumber = rndnumber + rnd.nextInt(9).toString();
                      }
                    }

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

                    _showMyDialogBefor();
                    addTorFireBAse(nowdateTorim);

                    final snapshot =
                        await refM.child("$nameClient/פרטי העסק/טלפון").get();

                    final snapshotNameBis =
                        await refM.child("$nameClient/פרטי העסק/שם עסק").get();

                    final snapshotNameBos =
                        await refM.child("$nameClient/פרטי העסק/שם מלא").get();

                    DatabaseReference ref1 = FirebaseDatabase.instance.ref(
                        "$nameClient/תורים/עובדים/$give" +
                            "/" +
                            prefs.getString("ChangeTorData").toString() +
                            "/" +
                            prefs.getString("ChangeTorTime").toString());
                    ref1.remove();

                    String phone = prefs.getString("ChangeTorPhone").toString();

                    DatabaseReference refCastum = FirebaseDatabase.instance.ref(
                        "$nameClient/לקוחות/$phone/תורים" +
                            "/" +
                            prefs.getString("ChangeTorData").toString() +
                            "/" +
                            prefs.getString("ChangeTorTime").toString());
                    refCastum.remove();

                    DatabaseReference refGenral = FirebaseDatabase.instance.ref(
                        "$nameClient/תורים/כללי" +
                            "/" +
                            prefs.getString("ChangeTorData").toString() +
                            "/" +
                            prefs.getString("ChangeTorTime").toString() +
                            " | " +
                            give);
                    refGenral.remove();

                    rangeStart1 = new DateTime(
                        int.parse(prefs
                            .getString("userDate")
                            .toString()
                            .split("-")[2]),
                        int.parse(prefs
                            .getString("userDate")
                            .toString()
                            .split("-")[1]),
                        int.parse(prefs
                            .getString("userDate")
                            .toString()
                            .split("-")[0]));
                  } else {
                    if (cont < 3) {
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

                      //code eldar
                      var rndnumber = "";
                      if (nameCas == "null" && phoneCas == "null") {
                        if (nameCas == "null" && phoneCas == "null") {
                          if (myControllerName.text.toString().isNotEmpty &&
                              myControllerPhone.text.toString().isNotEmpty) {
                            var rnd = new Random();
                            for (var i = 0; i < 4; i++) {
                              rndnumber = rndnumber + rnd.nextInt(9).toString();
                            }
                          }
                        }
                        _showMyDialog(rndnumber, cont, nowdateTorim);
                      } else {
                        _showMyDialogBefor();
                        addTorFireBAse(nowdateTorim);
                      }

                      final snapshot =
                          await refM.child("$nameClient/פרטי העסק/טלפון").get();

                      final snapshotNameBis = await refM
                          .child("$nameClient/פרטי העסק/שם עסק")
                          .get();

                      final snapshotNameBos = await refM
                          .child("$nameClient/פרטי העסק/שם מלא")
                          .get();

                      DatabaseReference ref1 = FirebaseDatabase.instance.ref(
                          "$nameClient/תורים/עובדים/$give" +
                              "/" +
                              prefs.getString("ChangeTorData").toString() +
                              "/" +
                              prefs.getString("ChangeTorTime").toString());
                      ref1.remove();

                      String phone =
                          prefs.getString("ChangeTorPhone").toString();

                      DatabaseReference refCastum = FirebaseDatabase.instance
                          .ref("$nameClient/לקוחות/$phone/תורים" +
                              "/" +
                              prefs.getString("ChangeTorData").toString() +
                              "/" +
                              prefs.getString("ChangeTorTime").toString());
                      refCastum.remove();

                      DatabaseReference refGenral = FirebaseDatabase.instance
                          .ref("$nameClient/תורים/כללי" +
                              "/" +
                              prefs.getString("ChangeTorData").toString() +
                              "/" +
                              prefs.getString("ChangeTorTime").toString() +
                              " | " +
                              give);
                      refGenral.remove();

                      rangeStart1 = new DateTime(
                          int.parse(prefs
                              .getString("userDate")
                              .toString()
                              .split("-")[2]),
                          int.parse(prefs
                              .getString("userDate")
                              .toString()
                              .split("-")[1]),
                          int.parse(prefs
                              .getString("userDate")
                              .toString()
                              .split("-")[0]));

                      if (nameCas == "null" && phoneCas == "null") {
                        String phoneCus = phoneCas == "null"
                            ? myControllerPhone.text.toString().substring(1)
                            : phoneCas.substring(1);
                        String nameCastum = nameCas == "null"
                            ? myControllerName.text.toString()
                            : nameCas;
                        String phone1 = snapshot.value.toString().substring(1);
                        String nameBis = snapshot
                            .child("פרטי העסק")
                            .child("שם העסק")
                            .value
                            .toString();
                        String startTime =
                            start.substring(0, 2) + ":" + start.substring(2, 4);

                        String nameEsek = nameClient.split("/").last;

                        String nameBos = snapshotNameBos.value.toString();

                        final Map<String, dynamic> requestBody = {
                          "chatId": "972$phoneCus@c.us",
                          "message":
                              
                               "שלום , זוהי הודעה אוטומטית ממערכת ניהול התורים של" " $nameEsek " "\n"
                                  "קוד האימות שלך הוא: $rndnumber"
                        };
                        final response = await http.post(
                          Uri.parse(
                              "https://api.green-api.com/waInstance7103842369/SendMessage/6ce4a58af3494bf5822b1d5a2edd6eba07ffe68b45414fc2ab"),
                          headers: {
                            'Content-Type': 'application/json',
                          },
                          body: jsonEncode(requestBody),
                        );

                        if (response.statusCode == 200) {
                          print('Request successful: ${response.body}');
                        } else {
                          print(
                              'Failed to send the request. Status code: ${response.statusCode}');
                        }
                      }
                    } else {
                      _showMyDialogUp3Tor();
                    }
                  }
                }),
          ],
        ));
  }

  addTorFireBAse(String nowdateTorim) {
    refM
      ..child(nameClient)
          .child("תורים")
          .child("כללי")
          .child(rangeStart1.toIso8601String().split("T").first + " - " + date)
          .child(
            start + "," + end + " | " + give,
          )
          .update({
        "שם": nameCas == "null" ? myControllerName.text.toString() : nameCas,
        "פלאפון":
            phoneCas == "null" ? myControllerPhone.text.toString() : phoneCas,
        "התחלה": start,
        "סיום": end,
        "טיפול": type,
        "שירות": give,
        "מחיר": TypePrice,
        "זמן": TypeTime,
        "טימר": Timer,
      });
    // ignore: avoid_single_cascade_in_expression_statements
    refM
      ..child(nameClient)
          .child("תורים")
          .child("עובדים")
          .child(give)
          .child(rangeStart1.toIso8601String().split("T").first + " - " + date)
          .child(start + "," + end)
          .update({
        "שם": nameCas == "null" ? myControllerName.text.toString() : nameCas,
        "פלאפון":
            phoneCas == "null" ? myControllerPhone.text.toString() : phoneCas,
        "התחלה": start,
        "סיום": end,
        "טיפול": type,
        "שירות": give,
        "מחיר": TypePrice,
        "זמן": TypeTime,
         "טימר": Timer,
      });

    // ignore: avoid_single_cascade_in_expression_statements
    refM
      ..child(nameClient)
          .child("לקוחות")
          .child(
              phoneCas == "null" ? myControllerPhone.text.toString() : phoneCas)
          .update({
        "שם": nameCas == "null" ? myControllerName.text.toString() : nameCas,
        "פלאפון":
            phoneCas == "null" ? myControllerPhone.text.toString() : phoneCas,
      });

    refM
      ..child("torim")
          .child(nowdateTorim)
          .child(
              phoneCas == "null" ? myControllerPhone.text.toString() : phoneCas)
          .child(start.substring(0, 2) + ":" + start.substring(2, 4))
          .update({
        "businessName": nameClient.split("/").last,
        "businessWebsite": nameWeb,
        "fullName":
            nameCas == "null" ? myControllerName.text.toString() : nameCas,
        "hour": start.substring(0, 2) + ":" + start.substring(2, 4),
        "phone": phoneCas == "null"
            ? myControllerPhone.text.toString().substring(1)
            : phoneCas.substring(1),
      });

    refM
      ..child(nameClient)
          .child("לקוחות")
          .child(
              phoneCas == "null" ? myControllerPhone.text.toString() : phoneCas)
          .child("תורים")
          .child(rangeStart1.toIso8601String().split("T").first + " - " + date)
          .child(start + "," + end)
          .update({
        "שם": nameCas == "null" ? myControllerName.text.toString() : nameCas,
        "פלאפון":
            phoneCas == "null" ? myControllerPhone.text.toString() : phoneCas,
        "התחלה": start,
        "סיום": end,
        "טיפול": type,
        "שירות": give,
        "מחיר": TypePrice,
        "זמן": TypeTime,
         "טימר": Timer,
      }).then((value) async {
        SharedPreferences numberPhoneGetTor =
            await SharedPreferences.getInstance();
        numberPhoneGetTor.setString("phoneTor",
            phoneCas == "null" ? myControllerPhone.text.toString() : phoneCas);
        setState(() {
          if (nameCas != "null") {
            messFinish =
                " היי $nameCas 📢 התור נקבע בהצלחה תקבל תזכורת לפני התור , נפגש.. ";
          } else {
            String Name = myControllerName.text.toString();
            messFinish =
                " היי $Name 📢 התור נקבע בהצלחה תקבל תזכורת לפני התור , נפגש.. ";
          }
        });

        String phoneCus = phoneCas == "null"
            ? myControllerPhone.text.toString().substring(1)
            : phoneCas.substring(1);
        String nameCastum =
            nameCas == "null" ? myControllerName.text.toString() : nameCas;

        final snapshotNameBis =
            await refM.child("$nameClient/פרטי העסק/שם עסק").get();
        String startTime = start.substring(0, 2) + ":" + start.substring(2, 4);
        final Map<String, dynamic> requestBodyCus = {
          "chatId": "972$phoneCus@c.us",
          "message": "היי $nameCastum 📢"
                  "\n"
                  'התור נקבע בהצלחה !'
                  "\n"
                  "$date"
                  " | "
                  "$startTime" +
              "\n" +
              "\n" +
              snapshotNameBis.value.toString()
        };
        final responseCus = await http.post(
          Uri.parse(
              "https://api.green-api.com/waInstance7103842369/SendMessage/6ce4a58af3494bf5822b1d5a2edd6eba07ffe68b45414fc2ab"),
          headers: {
            'Content-Type': 'application/json',
          },
          body: jsonEncode(requestBodyCus),
        );
        Navigator.of(context).pop();
        _showMyDialogAfterRegister();

        if (responseCus.statusCode == 200) {
          print('Request successful: ${responseCus.body}');
        } else {
          print(
              'Failed to send the request. Status code: ${responseCus.statusCode}');
        }
      });
  }

  Future<void> _showMyDialogUp3Tor() async {
    String codeClick = "";
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
              fontSize: 14.0,
            ),
            // ignore: prefer_interpolation_to_compose_strings
            // ignore: prefer_interpolation_to_compose_strings
            "לא ניתן לקבוע מעל 3 תורים",
            textAlign: TextAlign.right,
          ),
          actions: <Widget>[
            TextButton(
              child: const Text("אישור"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _showMyDialogBefor() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (context) {
        return Container(
          alignment: Alignment.center,
          height: 100,
          child: AlertDialog(
            title: Text(
              style: TextStyle(
                //backgroundColor: Color.fromARGB(255, 178, 175, 175),
                color: Color.fromARGB(255, 53, 52, 52),
                fontWeight: FontWeight.bold,
                fontSize: 14.0,
              ),
              // ignore: prefer_interpolation_to_compose_strings
              // ignore: prefer_interpolation_to_compose_strings
              messFinish,
              textAlign: TextAlign.right,
            ),
            content: Container(
                child: Image.asset(
              "assets/loadWeb.gif",
              width: 100,
              height: 100,
            )),
          ),
        );
      },
    );
  }

  Future<void> _showMyDialogAfterRegister() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (context) {
        return Container(
          alignment: Alignment.center,
          width: 100,
          height: 100,
          child: AlertDialog(
            title: Text(
              style: TextStyle(
                //backgroundColor: Color.fromARGB(255, 178, 175, 175),
                color: Color.fromARGB(255, 53, 52, 52),
                fontWeight: FontWeight.bold,
                fontSize: 14.0,
              ),
              // ignore: prefer_interpolation_to_compose_strings
              // ignore: prefer_interpolation_to_compose_strings
              messFinish,
              textAlign: TextAlign.right,
            ),
            content: Container(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                    primary: Color.fromARGB(255, 41, 42, 43),
                    elevation: 3,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5.0)),
                    minimumSize: Size(30, 40),
                    textStyle:
                        const TextStyle(fontFamily: 'Gisha', fontSize: 15)),
                child: Text("לחץ כאן לחזור לאתר"),
                onPressed: () async {
                  SharedPreferences prefsMangTor =
                      await SharedPreferences.getInstance();
                  prefsMangTor.setString("MangTor", "false");
                  Navigator.of(context).pop();

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
                },
              ),
            ),
          ),
        );
      },
    );
  }

  // @override
  // void dispose() {
  //   super.dispose();
  //   Navigator.of(context).pop();
  // }

  Future<void> _showMyDialog(
      String code, int count, String nowdateTorim) async {
    String codeClick = "";
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (context) {
        return ScaffoldMessenger(child: Builder(builder: ((context) {
          return Scaffold(
              body: AlertDialog(
            title: Text(
              style: TextStyle(
                //backgroundColor: Color.fromARGB(255, 178, 175, 175),
                color: Color.fromARGB(255, 53, 52, 52),
                fontWeight: FontWeight.bold,
                fontSize: 14.0,
              ),
              // ignore: prefer_interpolation_to_compose_strings
              // ignore: prefer_interpolation_to_compose_strings
              dateHebro.toString() +
                  " | " +
                  "בשעה " +
                  start.substring(0, 2) +
                  ":" +
                  start.substring(2, 4) +
                  " " +
                  "\n" "\n" 'רשום קוד אימות ',
              textAlign: TextAlign.right,
            ),
            content: SingleChildScrollView(
              child: ListBody(
                children: <Widget>[
                  Pinput(
                    length: 4,
                    showCursor: true,
                    onCompleted: (pin) => {codeClick = pin},
                  ),
                ],
              ),
            ),
            actions: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextButton(
                    child: const Text('ביטול'),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                  TextButton(
                    child: const Text('קבע תור'),
                    onPressed: () async {
                      if (code == codeClick) {
                        Navigator.of(context).pop();
                        _showMyDialogBefor();

                        addTorFireBAse(nowdateTorim);

                        SharedPreferences prefsImot =
                            await SharedPreferences.getInstance();
                        prefsImot.setString(
                            "nameCas", myControllerName.text.toString());

                        prefsImot.setString(
                            "phoneCas", myControllerPhone.text.toString());
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Text(
                            "קוד אימות שגוי",
                            textAlign: TextAlign.right,
                          ),
                        ));
                      }
                    },
                  ),
                ],
              ),
            ],
          ));
        })));
      },
    );
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
          NameDay = "יום רבעי";
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

class typeServerModel {
  final String? nameServer;
  final String? time;
  final String? price;
  //final String? city;
  typeServerModel(this.nameServer, this.time, this.price);
}
