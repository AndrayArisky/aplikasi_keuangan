import 'package:aplikasi_keuangan/PERCOBAAN/inputFake.dart';
import 'package:aplikasi_keuangan/PERCOBAAN/test.dart';
import 'package:aplikasi_keuangan/PERCOBAAN/test5.dart';
import 'package:aplikasi_keuangan/adminPages/anggota/dataAnggota.dart';
import 'package:aplikasi_keuangan/adminPages/laporan/labaRugi.dart';
import 'package:aplikasi_keuangan/adminPages/transaksiAdmin.dart';
import 'package:aplikasi_keuangan/akunPages/tabBarAkun.dart';
import 'package:aplikasi_keuangan/PERCOBAAN/inputFake.dart';
import 'package:aplikasi_keuangan/karyawanPages/inputKaryawan.dart';
import 'package:aplikasi_keuangan/karyawanPages/karyawanPage.dart';
import 'package:aplikasi_keuangan/karyawanPages/profilKaryawan.dart';
import 'package:aplikasi_keuangan/karyawanPages/transaksiKaryawan.dart';
import 'package:aplikasi_keuangan/mainPage/loginPage.dart';
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
      home: LR()
      //home: adminPage(level: 'admin',)
      //home: YourWidget(),
    );
  }
}