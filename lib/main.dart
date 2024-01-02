// ignore_for_file: prefer_const_constructors, unnecessary_new, use_build_context_synchronously
import 'dart:async';
import 'dart:convert';
import 'dart:html';
import 'dart:io' show Platform;
import 'dart:math';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:my_tor/registerNew/tableRegisterUser.dart';
import 'package:my_tor/tableTor/tableSendTor.dart';
import 'package:my_tor/tableTor/type_server.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:my_tor/websites/beforWeb.dart';
import 'package:my_tor/websites/web_sites.dart';
import 'package:my_tor/websites/web_sites_women.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';
import 'Login.dart';
import 'mengerBus/menuAndReshi/adminMenu.dart';
import 'firebase_options.dart';
import 'package:syncfusion_localizations/syncfusion_localizations.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:sizer/sizer.dart';
import 'package:provider/provider.dart';
import 'package:animations/animations.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Firebase.initializeApp();
  await Firebase.initializeApp(
    //name: "myapptor",
    options: DefaultFirebaseOptions.currentPlatform,
  );
  //initializeDateFormatting().then((_) => runApp(MyApp()));
  runApp(const MyApp());
}

class UserData {
  String? name;
  String? start;
  String? finish;
  String? giveServer;
  String? type;

  UserData({this.name, this.start, this.finish, this.giveServer, this.type});
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return Sizer(builder: (context, orientation, deviceType) {
      return MaterialApp(
        // ignore: prefer_const_literals_to_create_immutables
        // ignore: prefer_const_literals_to_create_immutables
        localizationsDelegates: [GlobalMaterialLocalizations.delegate],
        // ignore: prefer_const_literals_to_create_immutables
        //supportedLocales: [const Locale('he'), const Locale('IL')],
        debugShowCheckedModeBanner: false,
        title: 'the-campus',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: MyHomePage(title: 'Flutter Demo Home Page'),
      );
    });
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

String l1 = "עסקים/0504560086" , numberL = "מספרת הקמפוס", nameBis = "", give = "";



class _MyHomePageState extends State<MyHomePage> {
  // ignore: unnecessary_new
  @override
  initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // ignore: prefer_interpolation_to_compose_strings
    return SplashPage(nameClient: l1 + "/" + numberL);
  }
}
