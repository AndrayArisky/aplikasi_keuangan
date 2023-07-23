import 'package:aplikasi_keuangan/adminPages/adminPage.dart';
import 'package:aplikasi_keuangan/adminPages/anggota/editAnggota.dart';
import 'package:aplikasi_keuangan/adminPages/anggota/tambahAnggota.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/widgets.dart';

class dataAnggota extends StatefulWidget {
  @override
  dataAnggotaState createState() => dataAnggotaState();
}

class dataAnggotaState extends State<dataAnggota> {
  List<dynamic> anggota = [];

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    final response = await http.get(Uri.parse('https://apkeu2023.000webhostapp.com/getUser.php'));
    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      final karyawan = jsonData.where((data) => data['level'] == 'karyawan').toList();
      setState(() {
        anggota = karyawan;
      });
    } else {
      throw Exception('Gagal mengambil data!');
    }
  }

  Future<void> hapusAnggota(String IDuser) async {
    final response = await http.post(
      Uri.parse('http://apkeu2023.000webhostapp.com/deleteUser.php'),
      body: {'id_user': IDuser},
    );
    if (response.statusCode == 200) {
      setState(() {
        anggota.removeWhere((data) => data['id_user'] == IDuser);
      });
    } else {
      throw Exception('Failed to delete data');
    }
  } 

  void confirmDeleteAnggota(dynamic anggotaData) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Hapus Anggota!'),
          content: Text('Yakin ingin menghapus data anggota?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Batal'),
            ),
            TextButton(
              onPressed: () {
                hapusAnggota(anggotaData['id_user']);
                Navigator.of(context).pop();
              },
              child: Text('Yakin'),
            )
          ],
        );
      },
    );
  }

  void navigateToEditAnggota(dynamic anggotaData) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => editAnggota(anggotaData: anggotaData),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (context) => adminPage(level: 'admin'),
          ),
          (route) => false,
        );
        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text('Data Anggota'),
          actions: [
            IconButton(
              icon: Icon(
                Icons.person_add,
                color: Colors.black,
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => tambahAnggota(level: 'admin')
                  ),
                );     
              }, 
            ),
          ],
        ),
        body: Container(
          padding: EdgeInsets.all(15),
          child: ListView.separated(
            separatorBuilder: (BuildContext context, int index) => Divider(),
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: anggota.length,
            itemBuilder: (BuildContext context, int index) {
              return Padding(
                padding: const EdgeInsets.all(2.0),
                child: ListTile(
                  onTap: () {
                    showModalBottomSheet(
                      context: context,
                      builder: (BuildContext context) {
                        return Container(
                          child: SingleChildScrollView(
                            padding: EdgeInsets.all(20),
                            child: Column(
                              children: <Widget>[
                                Column(
                                  children: <Widget>[
                                      Text('DETAIL DATA ANGGOTA',
                                        style: TextStyle(
                                          color: Colors.blue,
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold
                                        ),
                                      ),                          
                                    ...ListTile.divideTiles(
                                      color: Colors.blue,
                                      tiles: [
                                        ListTile(
                                          contentPadding: EdgeInsets.symmetric(
                                            horizontal: 12,
                                            vertical: 4
                                          ),
                                          leading: Icon(
                                            Icons.person,
                                            color: Colors.blue
                                          ),
                                          title: Text("Nama"),
                                          subtitle: Text('${anggota[index]['nama']}'),
                                        ),
                                        ListTile(
                                          leading: Icon(
                                            Icons.phone,
                                            color: Colors.blue
                                          ),
                                          title: Text("No. HP/Telp"),
                                          subtitle: Text('${anggota[index]['nohp']}'),
                                        ),
                                        ListTile(
                                          leading: Icon(
                                            Icons.mail_outlined,
                                            color: Colors.blue
                                          ),
                                          title: Text("Email"),
                                          subtitle: Text('${anggota[index]['email']}'),
                                        ),
                                        ListTile(
                                          leading: Icon(
                                            Icons.phone,
                                            color: Colors.blue
                                          ),
                                          title: Text("Alamat"),
                                          subtitle: Text('${anggota[index]['alamat']}'),
                                        ),
                                        ListTile(
                                          leading: Icon(
                                            Icons.phone,
                                            color: Colors.blue
                                          ),
                                          title: Text("Status"),
                                          subtitle: Text('${anggota[index]['level']}'),
                                        ),
                                      ]
                                    )
                                  ],
                                )
                              ],
                            ),
                          ),
                        );
                      },
                    );
                  },
                  subtitle: Row(
                    children: <Widget>[
                      anggota[index]['level'] == 'karyawan' ? Icon(Icons.person, color: Colors.blue,) : Icon(Icons.people),
                      SizedBox(width: 20.0),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '${anggota[index]['nama']}',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: Colors.black
                              ),
                            ),
                            Text('${anggota[index]['alamat']}'),
                          ],
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                          navigateToEditAnggota(anggota[index]);
                        }, 
                        icon: Icon(
                          Icons.edit,
                          color: Colors.blue,
                        )
                      ),
                      IconButton(
                        onPressed: () {
                          confirmDeleteAnggota(anggota[index]);
                        },  
                        icon: Icon(
                          Icons.delete,
                          color: Colors.red,
                        )
                      )
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}