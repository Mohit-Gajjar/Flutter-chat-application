import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:simplelogin/Helper/helper_functions.dart';
import 'package:simplelogin/Services/Authentication_services.dart';
import 'package:simplelogin/Services/database.dart';
import 'package:simplelogin/views/forgot_password.dart';
import 'package:simplelogin/views/homepage.dart';

class AuthenticationScreen extends StatefulWidget {
  const AuthenticationScreen({Key? key}) : super(key: key);

  @override
  State<AuthenticationScreen> createState() => _AuthenticationScreenState();
}

class _AuthenticationScreenState extends State<AuthenticationScreen> {
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
  bool _isVisible = true;
  bool isSignUp = true;
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
              passwordTextEditingController.text, context)
          .then((value) {
        if (value != null) {
          HelperFunctions.saveUserLoggedInSharedPreference(true);
          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (builder) => HomeNav()));
        } else {
          setState(() {
            isLoading = false;
          });
        }
      });
    }
  }
//here...............................

//SignUp Configuration from here to
  signMeUp() async {
    if (formKey2.currentState!.validate()) {
      Map<String, String> userInfoMap = {
        "name": userNameTextEditingController.text,
        "email": emailTextEditingController.text,
      };

      setState(() {
        isLoading = true;
      });

      try {
        await FirebaseAuth.instance
            .createUserWithEmailAndPassword(
                email: emailTextEditingController.text,
                password: passwordTextEditingController.text)
            .then((val) {
          databaseMethods.uploadUserInfo(userInfoMap);
          HelperFunctions.saveUserLoggedInSharedPreference(true);
          HelperFunctions.saveUserNameSharedPreference(
              userNameTextEditingController.text);
          HelperFunctions.saveUserEmailSharedPreference(
              emailTextEditingController.text);
          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (builder) => HomeNav()));
        });
      } on FirebaseAuthException catch (e) {
        setState(() {
          isLoading = false;
        });
        SnackBar snackBar = SnackBar(content: Text(e.message!));
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
        emailTextEditingController.clear();
        passwordTextEditingController.clear();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff191720),
      resizeToAvoidBottomInset: false,
      body: !isLoading
          ? Container(
              decoration: BoxDecoration(
                  gradient: LinearGradient(
                      colors: [Color(0xff191720), Color(0xff191720)])),
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              child: isSignUp ? signUpWidget(context) : signInWidget(context))
          : Center(
              child: CircularProgressIndicator(),
            ),
      bottomSheet: Container(
        color: Color(0xff191720),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: RichText(
              textAlign: TextAlign.center,
              text: TextSpan(
                  text: "By creating account, you are agreeing to our\n",
                  style: const TextStyle(
                      fontWeight: FontWeight.w400, color: Colors.white),
                  children: [
                    TextSpan(
                        recognizer: TapGestureRecognizer()
                          ..onTap = () {
                            // showDialog(
                            //     context: context,
                            //     builder: (context) {
                            //       // return const TermsAndConditionsDialog();
                            //     });
                          },
                        text: "Terms & Conditions ",
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, color: Colors.white)),
                    const TextSpan(
                        text: "and ", style: TextStyle(color: Colors.white)),
                    TextSpan(
                        recognizer: TapGestureRecognizer()
                          ..onTap = () {
                            // showDialog(
                            //     context: context,
                            //     builder: (context) {
                            //       // return const PolicyDialog();
                            //     });
                          },
                        text: "Privacy Policy ",
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, color: Colors.white)),
                  ]),
            ),
          ),
        ),
        height: 50,
      ),
    );
  }

  Container signUpWidget(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20),
      child: Form(
        key: formKey2,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 80,
            ),
            Text(
              "Create New Account.",
              style: TextStyle(
                  fontSize: 50,
                  color: Colors.white,
                  fontWeight: FontWeight.bold),
            ),
            SizedBox(
              height: 70,
            ),
            TextFormField(
              validator: (val) {
                return val!.isEmpty || val.length < 3
                    ? "Enter Username 3+ characters"
                    : null;
              },
              controller: userNameTextEditingController,
              style: TextStyle(color: Colors.white.withOpacity(.3)),
              decoration: InputDecoration(
                  prefixIcon: Icon(Icons.person, color: Colors.white30),
                  hintText: 'Enter Username',
                  hintStyle: TextStyle(color: Colors.white.withOpacity(.3)),
                  contentPadding: const EdgeInsets.all(15),
                  focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.white30),
                      borderRadius: BorderRadius.circular(14)),
                  enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.white30),
                      borderRadius: BorderRadius.circular(14))),
            ),
            SizedBox(
              height: 20,
            ),
            TextFormField(
              controller: emailTextEditingController,
              validator: (val) {
                return RegExp(
                            r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                        .hasMatch(val!)
                    ? null
                    : "Please Enter Correct Email";
              },
              style: TextStyle(color: Colors.white.withOpacity(.3)),
              decoration: InputDecoration(
                  prefixIcon: Icon(Icons.email_outlined, color: Colors.white30),
                  hintText: 'Enter Email',
                  hintStyle: TextStyle(color: Colors.white.withOpacity(.3)),
                  contentPadding: const EdgeInsets.all(15),
                  focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.white30),
                      borderRadius: BorderRadius.circular(14)),
                  enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.white30),
                      borderRadius: BorderRadius.circular(14))),
            ),
            SizedBox(
              height: 20,
            ),
            TextFormField(
              controller: passwordTextEditingController,
              validator: (val) {
                return val!.length > 6 ? null : "Enter Password 6+ characters";
              },
              obscureText: _isVisible,
              style: TextStyle(color: Colors.white.withOpacity(.3)),
              decoration: InputDecoration(
                  prefixIcon:
                      Icon(Icons.password_outlined, color: Colors.white30),
                  suffixIcon: IconButton(
                    icon: Icon(Icons.visibility),
                    onPressed: _togglePass,
                  ),
                  hintText: 'Enter Password',
                  hintStyle: TextStyle(color: Colors.white.withOpacity(.3)),
                  contentPadding: const EdgeInsets.all(15),
                  enabled: true,
                  focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.white30),
                      borderRadius: BorderRadius.circular(14)),
                  enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.white30),
                      borderRadius: BorderRadius.circular(14))),
              onChanged: (value) {
                print(value);
              },
            ),
            Spacer(),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  "Already have an Account?",
                  style: TextStyle(color: Colors.white54),
                ),
                TextButton(
                    onPressed: () {
                      setState(() {
                        isSignUp = !isSignUp;
                      });
                    },
                    child: Text(
                      "Sign In",
                      style: TextStyle(color: Colors.white),
                    ))
              ],
            ),
            OutlinedButton(
                onPressed: () {
                  signMeUp();
                },
                child: Text(
                  'Sign Up',
                  style: GoogleFonts.poppins(
                      textStyle: TextStyle(
                    fontSize: 18,
                  )),
                ),
                style: ButtonStyle(
                    fixedSize: MaterialStateProperty.all(
                        Size(MediaQuery.of(context).size.width, 50)),
                    backgroundColor: MaterialStateProperty.all(Colors.white),
                    foregroundColor: MaterialStateProperty.all(Colors.black),
                    shape: MaterialStateProperty.all(RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14))))),
            SizedBox(
              height: 70,
            )
          ],
        ),
      ),
    );
  }

  Container signInWidget(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20),
      child: Form(
        key: formKey1,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Spacer(),
            Text(
              "Let's Sign You in.",
              style: TextStyle(
                  fontSize: 30,
                  color: Colors.white,
                  fontWeight: FontWeight.bold),
            ),
            Text(
              "Welcome back.",
              style: TextStyle(
                  fontSize: 30,
                  color: Colors.white.withOpacity(.5),
                  fontWeight: FontWeight.w300),
            ),
            Text(
              "You've been missed!",
              style: TextStyle(
                  fontSize: 30,
                  color: Colors.white.withOpacity(.5),
                  fontWeight: FontWeight.w300),
            ),
            SizedBox(
              height: 70,
            ),
            TextFormField(
              controller: emailTextEditingController,
              validator: (val) {
                return RegExp(
                            r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                        .hasMatch(val!)
                    ? null
                    : "Please Enter Correct Email";
              },
              style: TextStyle(color: Colors.white.withOpacity(.3)),
              decoration: InputDecoration(
                  prefixIcon: Icon(Icons.email_outlined, color: Colors.white30),
                  hintText: 'Enter Email',
                  hintStyle: TextStyle(color: Colors.white.withOpacity(.3)),
                  contentPadding: const EdgeInsets.all(15),
                  focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.white30),
                      borderRadius: BorderRadius.circular(14)),
                  enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.white30),
                      borderRadius: BorderRadius.circular(14))),
            ),
            SizedBox(
              height: 20,
            ),
            TextFormField(
              controller: passwordTextEditingController,
              validator: (val) {
                return val!.length > 6 ? null : "Enter Password 6+ characters";
              },
              obscureText: _isVisible,
              style: TextStyle(color: Colors.white.withOpacity(.3)),
              decoration: InputDecoration(
                  prefixIcon:
                      Icon(Icons.password_outlined, color: Colors.white30),
                  suffixIcon: IconButton(
                    icon: Icon(Icons.visibility),
                    onPressed: _togglePass,
                  ),
                  hintText: 'Enter Password',
                  hintStyle: TextStyle(color: Colors.white.withOpacity(.3)),
                  contentPadding: const EdgeInsets.all(15),
                  enabled: true,
                  focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.white30),
                      borderRadius: BorderRadius.circular(14)),
                  enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.white30),
                      borderRadius: BorderRadius.circular(14))),
            ),
            SizedBox(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => ForgotPass()));
                  },
                  child: Text(
                    "Forgot Password?",
                    style: TextStyle(
                        decoration: TextDecoration.underline,
                        color: Colors.white,
                        fontSize: 16),
                  ),
                ),
              ],
            ),
            Spacer(),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  "Don't have an Account?",
                  style: TextStyle(color: Colors.white54),
                ),
                TextButton(
                    onPressed: () {
                      setState(() {
                        isSignUp = !isSignUp;
                      });
                    },
                    child: Text(
                      "Register",
                      style: TextStyle(color: Colors.white),
                    ))
              ],
            ),
            SizedBox(
              height: 10,
            ),
            OutlinedButton(
                onPressed: () {
                  signIn();
                },
                child: Text(
                  'Sign In',
                  style: GoogleFonts.poppins(
                      textStyle: TextStyle(
                    fontSize: 18,
                  )),
                ),
                style: ButtonStyle(
                    fixedSize: MaterialStateProperty.all(
                        Size(MediaQuery.of(context).size.width, 50)),
                    backgroundColor: MaterialStateProperty.all(Colors.white),
                    foregroundColor: MaterialStateProperty.all(Colors.black),
                    shape: MaterialStateProperty.all(RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14))))),
            SizedBox(
              height: 70,
            )
          ],
        ),
      ),
    );
  }

  void _togglePass() {
    _isVisible = !_isVisible;
    setState(() {});
  }
}
