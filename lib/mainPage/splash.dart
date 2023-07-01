import 'dart:async';
//import 'package:apkeu/loginPage.dart';
import 'package:aplikasi_keuangan/transaksiPage/loginPage.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  //Colour Themes
  int colorline1 = 0xffec4a79;
  int colorline2 = 0xff3a8ac5;
  int colorline3 = 0xff68396d;
  int colorline4 = 0xff2baa7f;

  //THIS IS SPLASH SCREEN
  @override
  void initState() {
    super.initState();
    Timer(Duration(seconds: 2), () {
      Navigator.of(context).pushReplacement(MaterialPageRoute(
        builder: (context) => loginPage(),
      ));
    });
  }

  // added test yourself
  // and made the text to align at center
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text (
              'APKEU-UMKM',
              style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
                color: Colors.blue
              ),
            ),
            SizedBox(height: 20,),
            Text(
              "Aplikasi Keuangan UMKM",
              style: TextStyle(
                fontSize: 15.0,
                color: Colors.black,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}