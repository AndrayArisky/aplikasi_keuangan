import 'package:aplikasi_keuangan/mainPage/loginPage.dart';
import 'package:aplikasi_keuangan/adminPages/anggota/dataAnggota.dart';
import 'package:aplikasi_keuangan/adminPages/anggota/editAnggota.dart';
import 'package:aplikasi_keuangan/adminPages/transaksi/editTransaksi.dart';
import 'package:aplikasi_keuangan/karyawanPages/karyawanPage.dart';
import 'package:aplikasi_keuangan/mainPage/splash.dart';
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
      home: adminPage(level: 'admin',),
      initialRoute: '/',
      routes: {
        '/adminPage': (context) => adminPage(level: 'admin'),
        //'/editAnggota': (context) => editAnggota(level: 'admin'),
        '/dataAnggota': (context) => dataAnggota(),
        //'/editTransaksi': (context) => editTransaksi(level: 'admin')
      },
    );
  }
}