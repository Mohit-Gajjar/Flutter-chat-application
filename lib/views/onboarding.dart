import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:simplelogin/views/authentication_screen.dart';

class OnBoardingScreen extends StatefulWidget {
  const OnBoardingScreen({Key? key}) : super(key: key);

  @override
  State<OnBoardingScreen> createState() => _OnBoardingScreenState();
}

class _OnBoardingScreenState extends State<OnBoardingScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Container(
        margin: EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              child: Image(
                image: AssetImage('assets/splash.png'),
              ),
            ),
            Spacer(),
            SizedBox(
              width: MediaQuery.of(context).size.width / 1.5,
              child: Text(
                "It's easy talking to your friends with ChatRoom",
                style: GoogleFonts.poppins(
                    textStyle: TextStyle(fontSize: 30, color: Colors.white)),
              ),
            ),
            SizedBox(height: 10),
            Text(
              "Message Your Friend Simply And Simple With ChatRoom",
              style: GoogleFonts.poppins(
                  textStyle: TextStyle(
                      fontSize: 18, color: Colors.white.withOpacity(.4))),
            ),
            SizedBox(height: 50),
            OutlinedButton(
                onPressed: () => Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (context) => AuthenticationScreen())),
                child: Text(
                  'Get Started',
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
                        borderRadius: BorderRadius.circular(18))))),
            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
