import 'package:aplikasi_keuangan/mainPage/splash.dart';
import 'package:aplikasi_keuangan/adminPages/anggota/dataAnggota.dart';
import 'package:flutter/material.dart';
import 'package:aplikasi_keuangan/adminPages/adminPage.dart';


void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Aplikasi Keuangan UMKM",
      home: SplashScreen(),
      initialRoute: '/',
      routes: {
        '/adminPage': (context) => adminPage(level: 'admin'),
        '/dataAnggota': (context) => dataAnggota(),
      },
    );
  }
}