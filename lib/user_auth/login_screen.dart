import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:simplelogin/Services/Authentication_services.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController phoneController = new TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Login"),
      ),
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 70),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: phoneController,
              decoration: InputDecoration(hintText: "Enter Mobile Number"),
              keyboardType: TextInputType.phone,
            ),
            ElevatedButton(
                onPressed: () {
                  if (phoneController.text.isNotEmpty) {
                    final phone = phoneController.text.trim();
                    AuthMethod().loginWithPhone(phone, context);
                  }
                },
                child: Center(
                  child: Text("Login"),
                ))
          ],
        ),
      ),
    );
  }
}
