import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:naariAndroid/constants/Database.dart';
import 'package:naariAndroid/constants/constants.dart';
import 'package:naariAndroid/screens/experiment.dart';
import 'package:naariAndroid/screens/home_Screen.dart';
import 'package:naariAndroid/screens/home_Screen_beta.dart';
import 'package:naariAndroid/screens/padcounter.dart';
import 'package:naariAndroid/screens/registration_Screen.dart';
import 'package:naariAndroid/screens/sign_Screen.dart';
import 'package:naariAndroid/screens/welcome_screen.dart';
import 'package:naariAndroid/screens/calendar_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'screens/Counter/Setting.dart';

int counter = 0;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp();
  SharedPreferences prefs = await SharedPreferences.getInstance();
  var email = prefs.getString('email');
  print(email);
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);

  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    theme: ThemeData(
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
        accentColor: Color(0xFF8CC4C4)),
    // home: registration_Screen(),
    home: email != null ? navBar() : welcome_Screen(),
    routes: {
      welcome_Screen.id: (context) => welcome_Screen(),
      sign_Screen.id: (context) => sign_Screen(),
      registration_Screen.id: (context) => registration_Screen(),
      home_Screen.id: (context) => home_Screen(),
      counter_Screen.id: (context) => counter_Screen(),
      navBar.id: (context) => navBar()
    },
  ));
}
