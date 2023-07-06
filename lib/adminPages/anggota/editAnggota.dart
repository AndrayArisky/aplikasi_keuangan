import 'dart:convert';

import 'package:aplikasi_keuangan/adminPages/adminPage.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;

class editAnggota extends StatefulWidget {
  final level;
  const editAnggota({super.key, required this.level});

  @override
  _editAnggotaState createState() => _editAnggotaState();
}

class _editAnggotaState extends State<editAnggota> {

  bool _isHidePassword = true;
  //late dynamic level;
  String usaha = "Tidak Ada Nama Usaha";
  String level = "karyawan";
  List<dynamic> anggota = [];

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    final response = await http
        .get(Uri.parse('https://apkeu2023.000webhostapp.com/getUser.php'));
    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      final karyawan = jsonData.where((data) => data['id_user'] == 'id_user');
      setState(() {
        anggota = karyawan;
      });
    } else {
      throw Exception('Gagal mengambil data!');
    }
  }

  void _togglePassword() {
    setState(() {
      _isHidePassword = !_isHidePassword;
    });
  }
  
  final nama = new TextEditingController();
  final email = new TextEditingController();
  final nohp = new TextEditingController();
  final alamat = new TextEditingController();
  final password = new TextEditingController();

  // FUNGSI TOMBOL SIMPAN
  void editAnggota() async {
    var url = Uri.parse('http://apkeu2023.000webhostapp.com/inputAnggota.php');
    var body = {
      'nama': nama.text,
      'email': email.text,
      'nohp': nohp.text,
      'usaha': usaha,
      'alamat' : alamat.text,
      'password': password.text,
      'level' : level
    };

    var response = await http.post(url, body: body);
    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');
    print('ID USER : ${widget.level}');
    
    if (response.statusCode == 200) {
      final result = json.decode(response.body);
      if (result['message'] == 'Berhasil memperbarui data anggota') {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text("Berhasil memperbarui data anggota!"),
              actions: <Widget>[
                ElevatedButton(
                  child: Text("OK"),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => adminPage(level: 'admin'),
                      ),
                    );
                  },
                )
              ],
            );
          },
        );
      } else {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text("Gagal menambah anggota!"),
              content: Text("Pastikan data yang anda input sudah benar!"),
              // content: Text(result["message"]),
              actions: <Widget>[
                ElevatedButton(
                  child: Text("OK"),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                )
              ],
            );
          },
        );
      }
    }
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Anggota'),
      ),
      body: Padding(
        padding: EdgeInsets.fromLTRB(15, 20, 15, 40),
        child: Container(
          child: ListView(
            children: <Widget>[
              SizedBox(
              height: 50,
              child: Center(
                child: Text(
                  'EDIT DATA ANGGOTA',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue,
                   ),
                ),
              ),
            ),
              SizedBox(height: 20),
              ListTile(
                title: TextField(
                  style: TextStyle(
                    color: Colors.blue
                  ),
                  controller: nama,
                  decoration: InputDecoration(
                    labelText: 'Nama Anggota',
                    hintStyle: TextStyle(
                      color: Colors.blue
                    ),
                    border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(5.0))
                  )
                  ),
                ),
              ),
              ListTile(
                title: TextField(
                  style: TextStyle(
                    color: Colors.blue
                  ),
                  controller: email,
                  decoration: InputDecoration(
                    labelText: 'Email Anggota',
                    hintStyle: TextStyle(
                      color: Colors.blue
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(5.0))
                    )
                  ),
                ),
              ),
              ListTile(
                title: TextField(
                  style: TextStyle(
                    color: Colors.blue
                  ),
                  controller: nohp,
                  decoration: InputDecoration(
                    labelText: 'No. HP Anggota',
                    hintStyle: TextStyle(
                      color: Colors.blue
                    ),
                    border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(5.0))
                  )
                  ),
                  keyboardType: TextInputType.number,
                ),
              ),
              ListTile(
                title: TextField(
                  style: TextStyle(
                    color: Colors.blue
                  ),
                  controller: alamat,
                  decoration: InputDecoration(
                    labelText: 'Alamat Anggota',
                    hintStyle: TextStyle(
                      color: Colors.blue
                    ),
                    border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(5.0))
                  )
                  ),
                ),
              ),
              ListTile(
                title: TextField(
                  style: TextStyle(
                    color: Colors.blue
                  ),
                  controller: password,
                  decoration: InputDecoration(
                    labelText: 'Password',
                    hintStyle: TextStyle(
                      color: Colors.blue
                    ),
                    suffixIcon: GestureDetector(
                      onTap: () {
                        _togglePassword();
                      },
                      child: Icon(
                        _isHidePassword ? Icons.visibility_off : Icons.visibility,
                        color: _isHidePassword ? Colors.grey : Colors.blue,
                      ),
                    ),
                    border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(5.0))
                  )
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                    child: Container(
                      padding: EdgeInsets.fromLTRB(15, 50, 15, 40),
                      child: ElevatedButton(
                        child: Text(
                          'Tambah Anggota',
                          style: TextStyle(fontSize: 15),
                        ),
                        onPressed: () {
                          editAnggota();
                        }, 
                      ),
                    )
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}