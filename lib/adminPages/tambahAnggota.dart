import 'package:flutter/material.dart';

class tambahAnggota extends StatefulWidget {

  @override
  tambahAnggotaState createState() => tambahAnggotaState();
}

class tambahAnggotaState extends State<tambahAnggota> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Tambah Anggota'
        ),
      ),
    );
  }
}