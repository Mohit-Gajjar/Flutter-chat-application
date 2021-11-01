import 'package:flutter/material.dart';
import 'package:simplelogin/Services/Authentication_services.dart';

// ignore: must_be_immutable
class ForgotPass extends StatelessWidget {
  TextEditingController emailTextEditingController =
      new TextEditingController();
  AuthMethod authMethod = new AuthMethod();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color(0xFF160623),
        appBar: AppBar(
          title: Text('Forget Password'),
        ),
        body: Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                margin: EdgeInsets.only(left: 23),
                height: 60,
                width: 350,
                decoration: BoxDecoration(
                    border: Border.all(
                      width: 5,
                      color: Color(0xFF3152BD),
                    ),
                    borderRadius: BorderRadius.circular(30)),
                child: Padding(
                  padding: EdgeInsets.only(left: 20),
                  child: TextFormField(
                    controller: emailTextEditingController,
                    validator: (val) {
                      return RegExp(
                                  r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                              .hasMatch(val!)
                          ? null
                          : "Please Enter Correct Email";
                    },
                    style: TextStyle(color: Colors.white, fontSize: 20),
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: 'Enter Email',
                      hintStyle: TextStyle(color: Colors.white, fontSize: 20),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.only(left: 23),
                child: ElevatedButton(
                  child: Text(
                    "Login",
                    style: TextStyle(color: Colors.white, fontSize: 20),
                  ),
                  style: ElevatedButton.styleFrom(
                      primary: Color(0xFF3152BD),
                      onSurface: Colors.grey,
                      elevation: 1,
                      minimumSize: Size(350, 60),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30))),
                  onPressed: () {
                    authMethod.resetPass(emailTextEditingController.text);
                    Navigator.of(context).pop();
                  },
                ),
              ),
            ],
          ),
        ));
  }
}
