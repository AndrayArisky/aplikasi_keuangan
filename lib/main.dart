import 'package:aplikasi_keuangan/PERCOBAAN/tes9.dart';
import 'package:aplikasi_keuangan/PERCOBAAN/test2.dart';
import 'package:aplikasi_keuangan/PERCOBAAN/test3.dart';
import 'package:aplikasi_keuangan/PERCOBAAN/test8.dart';
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
      //home: editTesting(),
      //home: karyawanPage(level: 'karyawan',),
      home: adminPage(level: 'admin'),
      //home: MyWidget(),
      initialRoute: '/',
      routes: {
        '/editAnggota': (context) => editAnggota(level: 'admin', id_user: 1,),
        '/dataAnggota': (context) => dataAnggota(),
        //'/editTransaksi': (context) => editTransaksi(level: 'admin')
      },
    );
  }
}