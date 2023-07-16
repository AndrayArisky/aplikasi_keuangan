import 'package:aplikasi_keuangan/PERCOBAAN/login.dart';
import 'package:aplikasi_keuangan/mainPage/loginPage.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class profilKaryawan extends StatefulWidget {
  
  @override
  _profilKaryawanState createState() => _profilKaryawanState();
}

String? nama = "", nohp = "", email = "", usaha = "", alamat = "";

class _profilKaryawanState extends State<profilKaryawan>{
  //List<dynamic> Data = [];
  dynamic karyawan;
  String level = 'karyawan';
  String id_user = '';

  getPref() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      nama = preferences.getString("nama");
      nohp = preferences.getString("nohp");
      email = preferences.getString("email");
      usaha = preferences.getString("usaha");
      alamat = preferences.getString("alamat");
    });
  }

  @override
  void initState() {
    super.initState();
    //fetchData();
    getPref();
  }

  // Future<void> fetchData() async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   String loginData = prefs.getString('loginData') ?? '';
  //   dynamic userData = json.decode(loginData);
  //   id_user = userData['id_user'];
  //   final response = await http.get(Uri.parse('https://apkeu2023.000webhostapp.com/getTransaksi.php?id_user=$id_user'));
  //   if (response.statusCode == 200) {
  //     final jsonData = json.decode(response.body);
  //     setState(() {
  //       karyawan = jsonData.isNotEmpty ? jsonData[0] : null;
  //     });
  //   } else {
  //     throw Exception('Gagal mengambil data!');
  //   }
  // }

  Future<void> clearLoginData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }

  @override
  Widget build(BuildContext context) {
    // final String title = karyawan != null ? karyawan['usaha'] : '';
    // final String subtitle = karyawan != null ? karyawan['alamat'] : '';
    
    return Scaffold(
    extendBodyBehindAppBar: true,
    extendBody: true,
    body: SingleChildScrollView(
      child: Column(
        children: <Widget>[
          Container(
            padding: EdgeInsets.all(20),
            child: Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      '$nama',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 5),
                    Text(
                      '$alamat',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
            ),
            ),
            SizedBox(height: 10,),
            if (level == 'karyawan') ...[
            karyawanInfo(karyawan: karyawan),
            ]
          ],
        ),
      ),
    );
  }
}

class karyawanInfo extends StatelessWidget {
  final dynamic karyawan;
  const karyawanInfo({super.key, required this.karyawan});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10),
      child: Column(
        children: <Widget>[
          ListTile(
            title: Text(
              'Informasi Karyawan',
              style: TextStyle(
                fontSize: 16,
              ),
              textAlign: TextAlign.left,
            ),
            trailing: Row(
            mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                IconButton(
                  onPressed: () {}, 
                  icon: Icon(
                    Icons.edit,
                    color: Colors.black,
                  ), 
                )
              ],
            )
          ),
          Card(
            child: Container(
              alignment: Alignment.topLeft,
              padding: EdgeInsets.all(15),
              child: Column(
                children: <Widget>[
                  Column(
                    children: <Widget>[
                      ...ListTile.divideTiles(
                        color: Colors.blue,
                        tiles: [
                          ListTile(
                            contentPadding: EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 4
                            ),
                            leading: Icon(Icons.person),
                            title: Text("Nama Anggota"),
                            subtitle: Text('$nama'),
                          ),
                          ListTile(
                            leading: Icon(Icons.phone),
                            title: Text("No. HP/Telp"),
                            subtitle: Text('$nohp'),
                          ),
                          ListTile(
                            leading: Icon(Icons.mail_outlined),
                            title: Text("Email"),
                            subtitle: Text('$email'),
                          )
                        ]
                      )
                    ],
                  )
                ],
              ),
            ),
          ),
          SizedBox(height: 30,),
            Row(
              children: <Widget>[
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(4, 15, 4, 15),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue
                      ),
                      child: Text('Keluar'),
                      onPressed: () {
                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(builder: (context) => loginPage()),
                          (Route<dynamic> route) => false,
                        );
                      }, 
                    ),
                  )
                )
              ],
            ),
        ],
      ),
    );
  }
}
        // ScaffoldMessenger.of(context).showSnackBar(
        //   SnackBar(
        //     content: Text('Data berhasil ditambahkan'),
        //     action: SnackBarAction(
        //       label: 'Oke',
        //       onPressed: () {
        //         Navigator.pushReplacementNamed(context, '/dataAnggota');
        //       },
        //     ),
        //   ),  
        // );
