import 'package:aplikasi_keuangan/PERCOBAAN/tombolCari.dart';
import 'package:aplikasi_keuangan/akunPages/tabBarAkun.dart';
import 'package:aplikasi_keuangan/karyawanPages/inputKaryawan.dart';
import 'package:aplikasi_keuangan/karyawanPages/profilKaryawan.dart';
import 'package:aplikasi_keuangan/karyawanPages/transaksiKaryawan.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';


class karyawanPage extends StatefulWidget {
  final dynamic level;
  karyawanPage({super.key, required this.level}); 

  @override
  karyawanPageState createState() => karyawanPageState();
}

class karyawanPageState extends State<karyawanPage>{
  //late dynamic level;
  int _selectedIndex = 0;
  var selectedPage =  [
    transaksiKaryawan(),
    //tabBarAkun(),
    profilKaryawan(), 
  ];

  Future<void> clearLoginData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.clear();
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
        
        // KOMENTAR
        /*     
        actions: <Widget>[
          IconButton(
            icon: Icon(
              Icons.menu
            ),
            onPressed: () {
              /*
              showModalBottomSheet(
                context: context, 
                builder: (BuildContext context) {
                  return Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(20),
                        topRight: Radius.circular(20)
                      ),
                      color: Colors.white
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          height: 150,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.2),
                                blurRadius: 6,
                                offset: Offset(0, 3)
                              )
                            ]
                          ),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Expanded(
                                child: Padding(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 10,
                                  ),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          Expanded(
                                            child: ElevatedButton(
                                              onPressed: () {

                                              }, 
                                              child: Text(
                                                'Laporan Laba Rugi',
                                                style: TextStyle(
                                                  fontSize: 14
                                                ),
                                              )
                                            ),
                                          ),
                                          SizedBox(width: 10),
                                          Expanded(
                                            child: ElevatedButton(
                                              onPressed: () {

                                              }, 
                                              child: Text(
                                                'Laporan Posisi Keuangan',
                                                style: TextStyle(
                                                  fontSize: 14
                                                ),
                                              )
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                        SizedBox(height: 10), 
                        Expanded(
                          child: SingleChildScrollView(
                            child: Column(
                              children: [
                                Card(
                                  child: ListTile(
                                    leading: Icon(
                                      Icons.settings
                                    ),
                                    title: Text('Pengaturan'),
                                  ),
                                ),
                                Card(
                                  child: ListTile(
                                    leading: Icon(
                                      Icons.logout
                                    ),
                                    title: Text('Logout'),
                                  ),
                                )
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
                  );
                }
              );
              */
            },
          ),

          /*
          TextButton(
            onPressed: () {
              Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => loginPage()),
                  (route) => false);
            }, child: Icon(
              Icons.menu,
              color: Colors.black,
            ),
          )*/
        
        ],
        */
      ),

      // KOMENTAR
      /*
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => tambahTransaksi()));
        },
        backgroundColor: Colors.blue,
        child: Icon(Icons.add, color: Colors.black),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      */

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