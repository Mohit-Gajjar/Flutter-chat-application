import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:simplelogin/Helper/helper_functions.dart';
import 'package:simplelogin/user_auth/login_screen.dart';
import 'package:simplelogin/views/LoginPage.dart';
import 'package:simplelogin/views/NavigationHome.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Chat Application',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home:LoginScreen() 
        // Home()
        );
  }
}

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  void initState() {
    super.initState();
    getLoggedIn();
  }

  getLoggedIn() async {
    await HelperFunctions.getUserLoggedInSharedPreference().then((value) async {
      print(value);
      if (value! == true) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => HomeNav()),
        );
      } else {}
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      extendBodyBehindAppBar: true,
      body: LoginPage(),
    );
  }
}
