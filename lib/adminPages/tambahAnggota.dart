import 'dart:convert';

import 'package:aplikasi_keuangan/adminPages/adminPage.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;

class tambahAnggota extends StatefulWidget {
  final id_user;
  const tambahAnggota({super.key, required this.id_user});

  @override
  _tambahAnggotaState createState() => _tambahAnggotaState();
}

class _tambahAnggotaState extends State<tambahAnggota> {

  bool _isHidePassword = true;
  late dynamic id_user;
  String usaha = "Tidak Ada Nama Usaha";
  String level = "karyawan";

  void _togglePassword() {
    setState(() {
      _isHidePassword = !_isHidePassword;
    });
  }

    void resetData() {
    setState(() {
      nama.clear();
      username.clear();
      email.clear();
      nohp.clear();
      alamat.clear();
      password.clear();
    });
  }
  
  final nama = new TextEditingController();
  final username = new TextEditingController();
  final email = new TextEditingController();
  final nohp = new TextEditingController();
  final alamat = new TextEditingController();
  final password = new TextEditingController();

  // FUNGSI TOMBOL SIMPAN
  void tambahAnggota() async {
    var url = Uri.parse('http://apkeu2023.000webhostapp.com/inputAnggota.php');
    var body = {
      'id_user': widget.id_user.toString(),
      'nama': nama.text,
      'username' : username.text,
      'email': email.text,
      'nohp': nohp.text,
      'usaha': usaha,
      'alamat' : alamat.text,
      'password': password.text,
      'level' : level,
    };

    var response = await http.post(url, body: body);
    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');
    print('ID USER : ${widget.id_user}');
    
    if (response.statusCode == 200) {
      final result = json.decode(response.body);
      if (result['message'] == 'Berhasil menambah anggota baru') {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text("Berhasil menambah anggota baru!"),
              content: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
              ),
              actions: <Widget>[
                ElevatedButton(
                  child: Text("OK"),
                  onPressed: () {
                    //Navigator.of(context).pop();
                    Navigator.pushReplacement(
                      context, 
                      MaterialPageRoute(
                        builder: (context) => adminPage(id_user: 11)
                      )
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
              content:
                  Text("Pastikan data yang anda input sudah benar!"),
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
        title: Text('Tambah Anggota'),
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
                  'DATA ANGGOTA BARU',
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
                  controller: username,
                  decoration: InputDecoration(
                    labelText: 'Username Anggota',
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
                          tambahAnggota();
                          resetData();
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
