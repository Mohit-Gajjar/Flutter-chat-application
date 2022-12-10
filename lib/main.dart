import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:simplelogin/Helper/helper_functions.dart';
import 'package:simplelogin/views/homepage.dart';
import 'package:simplelogin/views/onboarding.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  getLoggedIn();
  runApp(MyApp());
}

bool _isLoggedin = false;
getLoggedIn() async {
  HelperFunctions.getUserLoggedInSharedPreference().then((value) {
    if (value == true) {
      _isLoggedin = true;
    }
    if (value == false && value == null) {
      _isLoggedin = false;
    }
  });
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Chat Application',
        theme: ThemeData(
            primarySwatch: Colors.blue,
            textTheme: GoogleFonts.poppinsTextTheme()),
        home: _isLoggedin ? HomeNav() : OnBoardingScreen());
  }
}
