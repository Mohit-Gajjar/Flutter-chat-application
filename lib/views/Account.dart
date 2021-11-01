import 'package:flutter/material.dart';
import 'package:simplelogin/Helper/constants.dart';
import 'package:simplelogin/Helper/helper_functions.dart';
import 'package:simplelogin/Services/Authentication_services.dart';
import 'package:simplelogin/views/LoginPage.dart';

class Account extends StatefulWidget {
  const Account({Key? key}) : super(key: key);

  @override
  _AccountState createState() => _AccountState();
}

class _AccountState extends State<Account> {
  String username = "";
  String email = "";

  getEmail() async {
    email = await HelperFunctions.getUserEmailSharedPreference() as String;
    username = await HelperFunctions.getUserNameSharedPreference() as String;
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    getEmail();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF160623),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        title: Text(
          "Account",
          style: TextStyle(fontSize: 30, fontWeight: FontWeight.w200),
        ),
      ),
      body: Column(
        children: [
          Container(
              child: ListTile(
            leading: CircleAvatar(
              radius: 30,
              child: Text(Constants.myName[0],
                  style: TextStyle(fontSize: 30, color: Colors.white)),
            ),
            title: Text(
              username,
              style: TextStyle(fontSize: 20, color: Colors.white),
            ),
            subtitle: Text(email,
                style: TextStyle(fontSize: 15, color: Colors.white54)),
          )),
          ElevatedButton(
            onPressed: () {
              AuthMethod().signOut();
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => LoginPage()));
            },
            child: Text("Logout"),
            style: ElevatedButton.styleFrom(
              onPrimary: Colors.white,
              primary: Colors.purple,
              onSurface: Colors.grey,
              elevation: 20,
              minimumSize: Size(130, 40),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30)),
            ),
          ),
          Spacer(),
          Container(
            child: Stack(
              children: [
                Positioned(
                  top: 30,
                  left: 30,
                  child: Row(
                    children: [
                      Text("Developer email: ", style: TextStyle(fontSize: 15, color: Colors.white54),),
                      Text("gajjarmohit501@gmail.com ", style: TextStyle(fontSize: 15, color: Colors.white),),
                    ],
                  ),
                ),
                Positioned(
                  top: 50,
                  left: 30,
                  child: Text("Developed By:", style: TextStyle(fontSize: 15, color: Colors.white54),)),
                Padding(
                  padding: const EdgeInsets.only(left: 20),
                  child: Image(
                   
                    image: AssetImage('assets/logo.png')),
                ),
             
              ],
            ),
          )
        ],
      ),
    );
  }
}
