import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:simplelogin/Helper/helper_functions.dart';
import 'package:simplelogin/Services/Authentication_services.dart';
import 'package:simplelogin/Services/database.dart';
import 'package:simplelogin/views/ForgetPassword.dart';
import 'package:simplelogin/views/NavigationHome.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final formKey1 = GlobalKey<FormState>();
  final formKey2 = GlobalKey<FormState>();
  DatabaseMethods databaseMethods = new DatabaseMethods();
  AuthMethod authMethod = new AuthMethod();
  TextEditingController emailTextEditingController =
      new TextEditingController();
  TextEditingController passwordTextEditingController =
      new TextEditingController();
  TextEditingController userNameTextEditingController =
      new TextEditingController();
  bool isLoading = false;
  QuerySnapshot? snapshotUserInfo;

//Signin configuration from here to
  signIn() {
    if (formKey1.currentState!.validate()) {
      HelperFunctions.saveUserEmailSharedPreference(
          emailTextEditingController.text);

      databaseMethods
          .getUserByEmail(emailTextEditingController.text)
          .then((val) {
        snapshotUserInfo = val;
        HelperFunctions.saveUserNameSharedPreference(
            snapshotUserInfo!.docs[0]["name"]);
      });

      setState(() {
        isLoading = true;
      });

      authMethod
          .signInWithEmailAndPassword(emailTextEditingController.text,
              passwordTextEditingController.text)
          .then((value) {
        if (value != null) {
          HelperFunctions.saveUserLoggedInSharedPreference(true);
          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (builder) => HomeNav()));
        }
      });
    }
  }
//here...............................

//SignUp Configuration from here to
  signMeUp() {
    if (formKey2.currentState!.validate()) {
      Map<String, String> userInfoMap = {
        "name": userNameTextEditingController.text,
        "email": emailTextEditingController.text,
      };
      HelperFunctions.saveUserLoggedInSharedPreference(true);
      HelperFunctions.saveUserNameSharedPreference(
          userNameTextEditingController.text);
      HelperFunctions.saveUserEmailSharedPreference(
          emailTextEditingController.text);
      setState(() {
        isLoading = true;
      });
      authMethod
          .signUpWithEmailAndPassword(emailTextEditingController.text,
              passwordTextEditingController.text)
          .then((val) {
        databaseMethods.uploadUserInfo(userInfoMap);
        HelperFunctions.saveUserLoggedInSharedPreference(true);
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (builder) => HomeNav()));
      });
    }
  }

//here...............................

  int _pageState = 0;
  var _backColor = Color(0xFF5477E3);
  var _textColor = Color(0xFF8F7C7C);
  double _loginWidth = 0;
  double windowWidth = 0;
  double windowHeight = 0;
  double _loginYOffset = 0;
  double _loginXOffset = 0;
  double _signUpOffset = 0;
  double _loginOpacity = 1;
  bool isHidden = true;



  @override
  Widget build(BuildContext context) {
    windowHeight = MediaQuery.of(context).size.height;
    windowWidth = MediaQuery.of(context).size.width;

    switch (_pageState) {
      case 0:
        _backColor = Colors.white;
        _textColor = Color(0xFF160623);
        _loginYOffset = windowHeight;
        _signUpOffset = windowHeight;
        _loginXOffset = 0;
        _loginOpacity = 1;
        _loginWidth = windowWidth;
        break;
      case 1:
        _backColor = Color(0xFF160623);
        _textColor = Colors.white;
        _loginYOffset = 250;
        _signUpOffset = windowHeight;
        _loginXOffset = 0;
        _loginOpacity = 1;
        _loginWidth = windowWidth;
        break;
      case 2:
        _backColor = Color(0xFF160623);
        _textColor = Colors.white;
        _loginYOffset = 220;
        _signUpOffset = 250;
        _loginXOffset = 20;
        _loginOpacity = 0.7;
        _loginWidth = windowWidth - 40;
        break;
    }

    return Scaffold(
      body: Stack(children: [
        AnimatedContainer(
          curve: Curves.fastLinearToSlowEaseIn,
          duration: Duration(milliseconds: 1500),
          color: _backColor,
          alignment: Alignment.center,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                margin: EdgeInsets.only(top: 80),
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      _pageState = 0;
                    });
                  },
                  child: Container(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Text(
                          "Welcome",
                          style: TextStyle(
                              color: _textColor,
                              fontSize: 40,
                              fontFamily: 'Montserrat-Regular',
                              fontWeight: FontWeight.w400),
                        ),
                        Text(
                          "  People of the",
                          style: TextStyle(
                              color: Color(0xFF8F7C7C),
                              fontSize: 18,
                              fontFamily: 'Montserrat-Regular',
                              fontWeight: FontWeight.w400),
                        ),
                        Text(
                          "  internet.",
                          style: TextStyle(
                              color: Color(0xFF8F7C7C),
                              fontSize: 18,
                              fontFamily: 'Montserrat-Regular',
                              fontWeight: FontWeight.w400),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.all(50),
                child: Image(
                  image: AssetImage('assets/splash.png'),
                ),
              ),
              Container(
                  child: GestureDetector(
                onTap: () {
                  setState(() {
                    if (_pageState != 0) {
                      _pageState = 0;
                    } else {
                      _pageState = 1;
                    }
                  });
                },
                child: Container(
                  margin: EdgeInsets.all(34),
                  padding: EdgeInsets.all(20),
                  width: double.infinity,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30),
                      gradient: LinearGradient(
                          colors: [Color(0xFF5477E3), Color(0xFF0036CD)])),
                  child: Center(
                      child: Text(
                    "Get Started",
                    style: TextStyle(color: Colors.white, fontSize: 20),
                  )),
                ),
              )),
            ],
          ),
        ),
        AnimatedContainer(
          width: _loginWidth,
          curve: Curves.fastLinearToSlowEaseIn,
          duration: Duration(milliseconds: 1500),
          transform: Matrix4.translationValues(_loginXOffset, _loginYOffset, 1),
          decoration: BoxDecoration(
              color: Colors.white.withOpacity(_loginOpacity),
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(40), topRight: Radius.circular(40))),
          child: Container(
            child: Column(
              children: [
                SizedBox(height: 20),
                Text(
                  "Login To Continue",
                  style: TextStyle(fontSize: 20),
                ),
                SizedBox(height: 20),
                Form(
                  key: formKey1,
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 30),
                        child: Container(
                          height: 60,
                          width: 350,
                          decoration: BoxDecoration(
                              border: Border.all(
                                width: 2,
                                color: Color(0xFF3152BD),
                              ),
                              borderRadius: BorderRadius.circular(30)),
                          child: Padding(
                            padding: EdgeInsets.only(top: 4),
                            child: TextFormField(
                              controller: emailTextEditingController,
                              validator: (val) {
                                return RegExp(
                                            r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                                        .hasMatch(val!)
                                    ? null
                                    : "Please Enter Correct Email";
                              },
                              style: TextStyle(fontSize: 20),
                              decoration: InputDecoration(
                                prefixIcon: Icon(
                                  Icons.mail_outline,
                                  color: Color(0xFF3152BD),
                                ),
                                border: InputBorder.none,
                                hintText: 'Enter Email',
                                hintStyle: TextStyle(fontSize: 20),
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 20),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 30),
                        child: Container(
                          height: 60,
                          width: 350,
                          decoration: BoxDecoration(
                              border: Border.all(
                                width: 2,
                                color: Color(0xFF3152BD),
                              ),
                              borderRadius: BorderRadius.circular(30)),
                          child: Padding(
                            padding: EdgeInsets.only(top: 4),
                            child: TextFormField(
                              controller: passwordTextEditingController,
                              validator: (val) {
                                return val!.length > 6
                                    ? null
                                    : "Enter Password 6+ characters";
                              },
                              obscureText: isHidden,
                              style: TextStyle(fontSize: 20),
                              decoration: InputDecoration(
                                prefixIcon: Icon(
                                  Icons.lock_outline,
                                  color: Color(0xFF3152BD),
                                ),
                                suffixIcon: IconButton(
                                  icon: Icon(Icons.visibility),
                                  onPressed: _togglePass,
                                ),
                                border: InputBorder.none,
                                hintText: 'Enter Password',
                                hintStyle: TextStyle(fontSize: 20),
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 15),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 30),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            GestureDetector(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => ForgotPass()));
                              },
                              child: Text(
                                "Forgot Password?",
                                style: TextStyle(
                                    decoration: TextDecoration.underline,
                                    fontSize: 16),
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
                SizedBox(height: 100),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 30),
                  child: ElevatedButton(
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 50),
                      child: Text(
                        "Login",
                        style: TextStyle(color: Colors.white, fontSize: 20),
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                        primary: Color(0xFF3152BD),
                        onSurface: Colors.grey,
                        elevation: 1,
                        minimumSize: Size(350, 60),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30))),
                    onPressed: () => signIn(),
                  ),
                ),
                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Don't have An Account? ",
                        style: TextStyle(
                          fontSize: 16,
                        )),
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          _pageState = 2;
                        });
                      },
                      child: Text("Sign Up",
                          style: TextStyle(
                              fontSize: 16,
                              decoration: TextDecoration.underline)),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        AnimatedContainer(
            curve: Curves.fastLinearToSlowEaseIn,
            duration: Duration(milliseconds: 1500),
            transform: Matrix4.translationValues(0, _signUpOffset, 1),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20), topRight: Radius.circular(20)),
            ),
            child: Form(
              child: Column(children: [
                SizedBox(height: 15),
                Text(
                  "Create New Account",
                  style: TextStyle(fontSize: 20),
                ),
                SizedBox(height: 15),
                Form(
                  key: formKey2,
                  child: Column(children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 30),
                      child: Container(
                        height: 50,
                        width: 350,
                        decoration: BoxDecoration(
                            border: Border.all(
                              width: 2,
                              color: Color(0xFF3152BD),
                            ),
                            borderRadius: BorderRadius.circular(30)),
                        child: Padding(
                          padding: EdgeInsets.only(top: 3),
                          child: TextFormField(
                            validator: (val) {
                              return val!.isEmpty || val.length < 3
                                  ? "Enter Username 3+ characters"
                                  : null;
                            },
                            controller: userNameTextEditingController,
                            style: TextStyle(color: Colors.black, fontSize: 20),
                            decoration: InputDecoration(
                              prefixIcon: Icon(
                                Icons.person,
                                color: Color(0xFF3152BD),
                              ),
                              border: InputBorder.none,
                              hintText: 'Enter Username',
                              hintStyle: TextStyle(fontSize: 20),
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 10),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 30),
                      child: Container(
                        height: 50,
                        width: 350,
                        decoration: BoxDecoration(
                            border: Border.all(
                              width: 2,
                              color: Color(0xFF3152BD),
                            ),
                            borderRadius: BorderRadius.circular(30)),
                        child: Padding(
                          padding: EdgeInsets.only(top: 3),
                          child: TextFormField(
                            controller: emailTextEditingController,
                            validator: (val) {
                              return RegExp(
                                          r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                                      .hasMatch(val!)
                                  ? null
                                  : "Please Enter Correct Email";
                            },
                            style: TextStyle(fontSize: 20),
                            decoration: InputDecoration(
                              prefixIcon: Icon(
                                Icons.mail_outline,
                                color: Color(0xFF3152BD),
                              ),
                              border: InputBorder.none,
                              hintText: 'Enter Email',
                              hintStyle: TextStyle(fontSize: 20),
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 10),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 30),
                      child: Container(
                        height: 50,
                        width: 350,
                        decoration: BoxDecoration(
                            border: Border.all(
                              width: 2,
                              color: Color(0xFF3152BD),
                            ),
                            borderRadius: BorderRadius.circular(30)),
                        child: Padding(
                          padding: EdgeInsets.only(top: 3),
                          child: TextFormField(
                            validator: (val) {
                              return val!.length > 6
                                  ? null
                                  : "Enter Password 6+ characters";
                            },
                            controller: passwordTextEditingController,
                            obscureText: isHidden,
                            style: TextStyle(fontSize: 20),
                            decoration: InputDecoration(
                              prefixIcon: Icon(
                                Icons.lock_outline,
                                color: Color(0xFF3152BD),
                              ),
                              suffixIcon: IconButton(
                                icon: Icon(Icons.visibility),
                                onPressed: _togglePass,
                              ),
                              border: InputBorder.none,
                              hintText: 'Enter Password',
                              hintStyle: TextStyle(fontSize: 20),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ]),
                ),
                SizedBox(height: 150),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 30),
                  child: ElevatedButton(
                    child: Text(
                      "Create",
                      style: TextStyle(fontSize: 20),
                    ),
                    style: ElevatedButton.styleFrom(
                        primary: Color(0xFF3152BD),
                        onSurface: Colors.grey,
                        elevation: 1,
                        minimumSize: Size(350, 60),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30))),
                    onPressed: () {
                      signMeUp();
                      print(emailTextEditingController.text);
                    },
                  ),
                ),
                SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Already have An Account? ",
                        style: TextStyle(
                          fontSize: 16,
                        )),
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          _pageState = 1;
                        });
                      },
                      child: Text("Login",
                          style: TextStyle(
                              fontSize: 16,
                              decoration: TextDecoration.underline)),
                    ),
                  ],
                ),
              ]),
            ))
      ]),
    );
  }

  void _togglePass() {
    isHidden = !isHidden;
    setState(() {});
  }
}
