import 'package:aplikasi_keuangan/mainPage/login.dart';
import 'package:aplikasi_keuangan/LOGOUT/propilkaryawan.dart';
import 'package:aplikasi_keuangan/akunPages/tabBarAkun.dart';
import 'package:aplikasi_keuangan/karyawanPages/inputKaryawan.dart';
import 'package:aplikasi_keuangan/karyawanPages/profilKaryawan.dart';
import 'package:aplikasi_keuangan/karyawanPages/transaksiKaryawan.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class karyawanPage extends StatefulWidget {
  final VoidCallback onLogout;
  final dynamic level;
  const karyawanPage({super.key, required this.level, required this.onLogout}); 

  @override
  karyawanPageState createState() => karyawanPageState();
}

class karyawanPageState extends State<karyawanPage>{
  int _selectedIndex = 0;
  late List<Widget> selectedPage;

  void handleLogout() {
    widget.onLogout();
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => loginPage()),
      (Route<dynamic> route) => false,
    );
  }

  @override
  void initState() {
    super.initState();
    selectedPage =  [
    transaksiKaryawan(),
    profilKaryawan(onLogout: handleLogout) 
  ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      appBar: AppBar(
        title: Text('Catatan Keuangan'),
        actions: [
            Tooltip(
            message: 'Daftar Akun',
            child: IconButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => tabBarAkun(),
                  ),
                );
              },
              icon: Icon(Icons.category_outlined),
            ),
          ),
        ],
        elevation: 2,
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => inputKaryawan(level: 'karyawan', onLogout: handleLogout)
            )
          );
        },
        backgroundColor: Colors.blue,
        child: Icon(Icons.add, color: Colors.black),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,

      body: selectedPage[_selectedIndex],
      bottomNavigationBar: BottomAppBar(
        color: Colors.blue,
        shape: AutomaticNotchedShape(
              RoundedRectangleBorder(),
          StadiumBorder(
            side: BorderSide(),
          ),
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 30),
          child: Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              IconButton(
                onPressed: () {
                  selectedPage[0];
                  setState(() {
                    _selectedIndex = 0;
                    print('Halaman Transaksi');
                  });
                }, 
                icon: Icon(
                  Icons.home_outlined,
                  color: _selectedIndex == 0 ? Colors.black : Colors.white,
                ),
                iconSize: 30,
              ),
              IconButton(
                onPressed: () {
                  selectedPage[1];
                  setState(() {
                    _selectedIndex = 1;
                    print('Halaman Profil');
                  });
                }, 
                icon: Icon(
                  Icons.person,
                  color: _selectedIndex == 1 ? Colors.black : Colors.white,
                ),
                iconSize: 30,
              ),
            ],
          ),
        ),
      ),
    );
  }
}