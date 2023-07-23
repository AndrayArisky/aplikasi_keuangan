import 'package:aplikasi_keuangan/mainPage/login.dart';
import 'package:aplikasi_keuangan/LOGOUT/propiladmin.dart';
import 'package:aplikasi_keuangan/adminPages/anggota/dataAnggota.dart';
import 'package:aplikasi_keuangan/adminPages/anggota/tambahAnggota.dart';
import 'package:aplikasi_keuangan/adminPages/laporan/arusKas.dart';
import 'package:aplikasi_keuangan/adminPages/laporan/labaRugi.dart';
import 'package:aplikasi_keuangan/adminPages/laporan/posisiKeuangan.dart';
import 'package:aplikasi_keuangan/adminPages/profilAdmin.dart';
import 'package:aplikasi_keuangan/adminPages/transaksi/inputAdmin.dart';
import 'package:aplikasi_keuangan/akunPages/tabBarAkun.dart';
import 'package:aplikasi_keuangan/mainPage/loginPage.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:aplikasi_keuangan/adminPages/transaksi/transaksiAdmin.dart';


class adminPage extends StatefulWidget {
  final dynamic level;
  adminPage({super.key, required this.level}); 

  @override
  _adminPageState createState() => _adminPageState();
}


class _adminPageState extends State<adminPage>{
  String? usaha = "", alamat = "";
  late final Widget? endDrawer;
  int _selectedIndex = 0;
  var selectedPage =  [
    transaksiAdmin(),
    profilAdmin(),
  ];

  
  getPref() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      usaha = preferences.getString("usaha");
      alamat = preferences.getString("alamat");
    });
  }

  @override
  void initState() {
    super.initState();
    getPref();
  }

  Future<void> clearLoginData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Catatan Keuangan'),
        elevation: 2,
      ),
      endDrawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              decoration: BoxDecoration(color: Colors.blue,),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    '$usaha',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    '$alamat',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ),
            _drawerItem(
              icon: Icons.category_outlined,
              text: 'Daftar Akun',
              onTap: () {
                Navigator.of(context).push (
                  MaterialPageRoute (
                    builder:(BuildContext context) => tabBarAkun()
                  )
                );
              }
            ),
            Divider(height: 15, thickness: 1),
            Padding(
              padding: const EdgeInsets.only(left: 20.0, top: 5, bottom: 5),
              child: Text(
                "Manajemen Pengguna",
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.black54,
                )),
            ),
            _drawerItem(
              icon: Icons.add_circle_outline_sharp,
              text: 'Tambah Anggota',
              onTap: () {
                Navigator.of(context).push (
                  MaterialPageRoute (
                    builder:(BuildContext context) => tambahAnggota(level: 'admin')
                  )
                );
              }
            ),
            _drawerItem(
              icon: Icons.people_alt_rounded,
              text: 'Data Anggota',
              onTap: () {
                Navigator.of(context).push (
                  MaterialPageRoute (
                    builder:(BuildContext context) => dataAnggota()
                  )
                );
              }
            ),
            Divider(height: 15, thickness: 1),
            Padding(
              padding: const EdgeInsets.only(left: 20.0, top: 5, bottom: 5),
              child: Text("Laporan",
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.black54,
                )),
            ),
            _drawerItem(
              icon: Icons.payments,
              text: 'Arus Kas',
              onTap: () {
                Navigator.of(context).push (
                  MaterialPageRoute (
                    builder:(BuildContext context) => arusKas()
                  )
                );
              }
            ),
            _drawerItem(
              icon: Icons.bar_chart_outlined,
              text: 'Laba Rugi',
              onTap: () {
                Navigator.of(context).push (
                  MaterialPageRoute (
                    builder:(BuildContext context) => labaRugi()
                  )
                );
              }
            ),
            _drawerItem(
              icon: Icons.grain_rounded,
              text: 'Posisi Keuangan',
              onTap: () {
                Navigator.of(context).push (
                  MaterialPageRoute (
                    builder:(BuildContext context) => posisiKeuangan()
                  )
                );
              }
              ),
            Divider(height: 15, thickness: 1),
            _drawerItem(
              icon: Icons.logout,
              text: 'Keluar',
              onTap: () {
                clearLoginData();
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => loginPage()),
                  (Route<dynamic> route) => false,
                );
              }
            ),
          ]
        ),
      ),
      
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => inputAdmin(level: 'admin',)
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
          StadiumBorder(side: BorderSide()),
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

// Widget _drawerHeader() {
//   return UserAccountsDrawerHeader(
//     accountName: Text('$usaha'),
//     accountEmail: Text('$alamat'),
//   );
// }

Widget _drawerItem({
  required IconData icon, 
  required String text, 
  required GestureTapCallback onTap}) {
  return ListTile(
    title: Row(
      children: <Widget>[
        Icon(icon),
        Padding(
          padding: EdgeInsets.only(left: 25.0),
          child: Text(text,
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
      ],
    ),
    onTap: onTap,
  );
}