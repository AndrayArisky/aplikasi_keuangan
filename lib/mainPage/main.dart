import 'package:aplikasi_keuangan/adminPages/inputAdmin.dart';
import 'package:aplikasi_keuangan/adminPages/laporan/labaRugi.dart';
import 'package:aplikasi_keuangan/adminPages/transaksiAdmin.dart';
import 'package:aplikasi_keuangan/akunPages/tabBarAkun.dart';
import 'package:aplikasi_keuangan/PERCOBAAN/inputFake.dart';
import 'package:aplikasi_keuangan/karyawanPages/inputKaryawan.dart';
import 'package:aplikasi_keuangan/karyawanPages/karyawanPage.dart';
import 'package:aplikasi_keuangan/karyawanPages/transaksiKaryawan.dart';
import 'package:flutter/material.dart';
import 'package:aplikasi_keuangan/adminPages/adminPage.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Aplikasi Keuangan UMKM",
      home: adminPage(id_user: 22,)
      //home:  LR()
    );
  }
}