import 'package:aplikasi_keuangan/PERCOBAAN/test2.dart';
import 'package:aplikasi_keuangan/PERCOBAAN/test6.dart';
import 'package:aplikasi_keuangan/adminPages/anggota/dataAnggota.dart';
import 'package:aplikasi_keuangan/adminPages/anggota/tambahAnggota.dart';
import 'package:aplikasi_keuangan/adminPages/laporan/labaRugi.dart';
import 'package:aplikasi_keuangan/adminPages/laporan/posisiKeuangan.dart';
import 'package:aplikasi_keuangan/adminPages/profilAdmin.dart';
import 'package:aplikasi_keuangan/adminPages/transaksi/inputAdmin.dart';
import 'package:aplikasi_keuangan/PERCOBAAN/pdf.dart';
import 'package:aplikasi_keuangan/adminPages/transaksi/transaksiAdmin.dart';
import 'package:aplikasi_keuangan/akunPages/tabBarAkun.dart';
import 'package:aplikasi_keuangan/mainPage/loginPage.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;


class adminPage extends StatefulWidget {
  final dynamic level;
  adminPage({super.key, required this.level}); 

  @override
  _adminPageState createState() => _adminPageState();
}

class _adminPageState extends State<adminPage>{
  late final Widget? endDrawer;
  int _selectedIndex = 0;
  var selectedPage =  [
    transaksiAdmin(),
    //tabBarAkun(),
    //ProfilPage()
    profilAdmin(),
    // profilAdmin(), 
  ];
  List<dynamic> user = [];

  @override
  void initState() {
    super.initState();
    fetchData();
    var level = widget.level;
  }

  Future<void> fetchData() async {
    final response = await http.get(Uri.parse('https://apkeu2023.000webhostapp.com/getUser.php'));
    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      final admin = jsonData.where((data) => data['level'] == 'admin').toList();
      setState(() {
        user = admin;
      });
    } else {
      throw Exception('Gagal mengambil data!');
    }
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
            _drawerHeader(context, user),
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
                var data;
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
                    builder:(BuildContext context) => LaporanPosisiKeuangan()
                  )
                );
              }
              ),
            Divider(height: 15, thickness: 1),
            // _drawerItem(
            //   icon: Icons.settings,
            //   text: 'Pengaturan',
            //   onTap: () {}
            // ),
            _drawerItem(
              icon: Icons.logout,
              text: 'Keluar',
              onTap: () {
                clearLoginData();
                // Navigasi ke halaman login
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
              // IconButton(
              //   onPressed: () {
              //     selectedPage[1];
              //     setState(() {
              //       _selectedIndex = 1;
              //       print('Halaman Nama Akun');
              //     });
              //   }, 
              //   icon: Icon(
              //     Icons.category_outlined,
              //     color: _selectedIndex == 1 ? Colors.black : Colors.white,
              //   ),
              //   iconSize: 30,
              // ),
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

Widget _drawerHeader(BuildContext context, List<dynamic> user) {
  
  return UserAccountsDrawerHeader(
    accountName: Text('${user.isNotEmpty ? user[0]['usaha'] : ''}'),
    accountEmail: Text('${user.isNotEmpty ? user[0]['alamat'] : ''}'),
  );
}

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
          child: Text(
            text,
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    ),
    onTap: onTap,
  );
}