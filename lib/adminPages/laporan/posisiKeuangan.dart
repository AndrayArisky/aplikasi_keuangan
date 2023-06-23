import 'package:flutter/material.dart';

class posisiKeuangan extends StatefulWidget {

  @override
  posisiKeuanganState createState() => posisiKeuanganState();
}

class posisiKeuanganState extends State<posisiKeuangan> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Laporan Laba Rugi'
        ),
      ),
    );
  }
}