import 'package:aplikasi_keuangan/LOGOUT/login.dart';
import 'package:aplikasi_keuangan/LOGOUT/propilkaryawan.dart';
import 'package:aplikasi_keuangan/akunPages/tabBarAkun.dart';
import 'package:aplikasi_keuangan/karyawanPages/inputKaryawan.dart';
import 'package:aplikasi_keuangan/karyawanPages/profilKaryawan.dart';
import 'package:aplikasi_keuangan/karyawanPages/transaksiKaryawan.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class karyawanPage extends StatefulWidget {
  final dynamic level;
  const karyawanPage({super.key, required this.level}); 

  @override
  karyawanPageState createState() => karyawanPageState();
}

class karyawanPageState extends State<karyawanPage>{
  //late dynamic level;
  int _selectedIndex = 0;
  var selectedPage =  [
    transaksiKaryawan(),
    //tabBarAkun(),
    profilKaryawan() 
  ];

  Future<void> clearLoginData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }

  void handleLogout() {
    clearLoginData(); // Panggil fungsi untuk logout dan hapus data
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => loginPage()),
      (Route<dynamic> route) => false,
    );
  }

  @override
  void initState() {
    super.initState();
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
              builder: (context) => inputKaryawan(level: 'karyawan')
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