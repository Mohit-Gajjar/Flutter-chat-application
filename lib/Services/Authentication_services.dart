import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:simplelogin/Modals/user.dart';

class AuthMethod {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  UserId? _userFromFirebaseUser(User user) {
    //if the app crashed then this might be the reason
    return UserId(userId: user.uid);
  }

  Future signInWithEmailAndPassword(String email, String password) async {
    try {
      UserCredential result = await _firebaseAuth.signInWithEmailAndPassword(
          email: email, password: password);
      User? firebseuser = result.user;
      return _userFromFirebaseUser(firebseuser!);
    } catch (e) {
      print(e.toString());
    }
  }

  Future signUpWithEmailAndPassword(String email, String password) async {
    try {
      UserCredential result = await _firebaseAuth
          .createUserWithEmailAndPassword(email: email, password: password);
      User? firebaseuser = result.user;
      return _userFromFirebaseUser(firebaseuser!);
    } catch (e) {
      print(e.toString());
    }
  }

  Future resetPass(String email) async {
    try {
      return await _firebaseAuth.sendPasswordResetEmail(email: email);
    } catch (e) {
      print(e.toString());
    }
  }

  Future signOut() async {
    try {
      return await _firebaseAuth.signOut();
    } catch (e) {}
  }

  Future loginWithPhone(String phone, BuildContext context) async {
    TextEditingController codeController = new TextEditingController();
    _firebaseAuth.verifyPhoneNumber(
      phoneNumber: phone,
      timeout: Duration(seconds: 60),
      verificationCompleted: (AuthCredential authCredential) async {
        Navigator.of(context).pop();
        UserCredential result =
            await _firebaseAuth.signInWithCredential(authCredential);
        User? user = result.user;
        if (user != null) {
          print("User Is Logged in  (Methord One)");
        } else {
          print("Mobile Number Auth Error (Methord One)");
        }
      },
      verificationFailed: (FirebaseAuthException execption) {
        print(execption);
      },
      codeSent: (String id, [int? token]) {
        showDialog(
            barrierDismissible: false,
            context: context,
            builder: (context) {
              return AlertDialog(
                title: Text("Give the Code"),
                content: Column(
                  children: [
                    TextField(
                      controller: codeController,
                    ),
                  ],
                ),
                actions: [
                  TextButton(
                      onPressed: () async {
                        final code = codeController.text.trim();
                        AuthCredential userCredential =
                            PhoneAuthProvider.credential(
                                verificationId: id, smsCode: code);

                        UserCredential authCredential = await _firebaseAuth
                            .signInWithCredential(userCredential);
                        User? firebaseUser = authCredential.user;
                        if (firebaseUser != null) {
                          print("User Is Logged in  (Methord Two)");
                        } else {
                          print("Mobile Number Auth Error (Methord Two)");
                        }
                      },
                      child: Text("Confirm"))
                ],
              );
            });
      },
      codeAutoRetrievalTimeout: (String code) {},
    );
  }
}
