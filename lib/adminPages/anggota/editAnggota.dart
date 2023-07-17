import 'dart:convert';
import 'package:aplikasi_keuangan/adminPages/anggota/dataAnggota.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class editAnggota extends StatefulWidget {
  final dynamic anggotaData;
  const editAnggota({Key? key, required this.anggotaData}) : super(key: key);

  @override
  _editAnggotaState createState() => _editAnggotaState();
}

class _editAnggotaState extends State<editAnggota> {
  bool _isHidePassword = true;

  TextEditingController nama = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController nohp = TextEditingController();
  TextEditingController alamat = TextEditingController();
  TextEditingController password = TextEditingController();

  void _togglePassword() {
    setState(() {
      _isHidePassword = !_isHidePassword;
    });
  }

  @override
  void initState() {
    super.initState();
    setData();
  }

  void setData() {
    final anggotaData = widget.anggotaData;
    nama.text = anggotaData['nama'];
    email.text = anggotaData['email'];
    nohp.text = anggotaData['nohp'];
    alamat.text = anggotaData['alamat'];
    password.text = anggotaData['password'];
  }

  // FUNGSI TOMBOL SIMPAN
  Future<void> editAnggota(BuildContext context) async {
    final anggotaData = widget.anggotaData;
    final url = Uri.parse('http://apkeu2023.000webhostapp.com/editUser.php');
    final body = {
      'id_user': anggotaData['id_user'],
      'nama': nama.text,
      'email': email.text,
      'nohp': nohp.text,
      'alamat': alamat.text,
      'password': password.text,
    };

    final response = await http.post(url, body: body);
    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');

    if (response.statusCode == 200) {
      try {
        final result = json.decode(response.body);
        if (result['success'] == true) {
          await getDataAnggota();
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text("Data berhasil diperbarui!"),
                content: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                ),
                actions: <Widget>[
                  ElevatedButton(
                    child: Text("OK"),
                    onPressed: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => dataAnggota(),
                        ),
                      );
                    },
                  )
                ],
              );
            },
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Data gagal ditambahkan'),
              action: SnackBarAction(
                label: 'Oke',
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ),
          );
          print('Edit data gagal!');
        }
      } catch (e) {
        print('Gagal mengurai respons JSON: $e');
      }
    } else {
      print('Edit data gagal! Status code: ${response.statusCode}');
    }
  }

  Future<void> getDataAnggota() async {
    final url = Uri.parse('http://apkeu2023.000webhostapp.com/Users/getUser.php');
    final response = await http.get(url);
    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Anggota'),
      ),
      body: Padding(
        padding: EdgeInsets.fromLTRB(15, 20, 15, 40),
          child: ListView(
            children: [
              SizedBox(
                height: 50,
                child: Center(
                  child: Text('DATA ANGGOTA',
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
                  style: TextStyle(color: Colors.blue),
                  controller: nama,
                  decoration: InputDecoration(
                    labelText: 'Nama Anggota',
                    hintStyle: TextStyle(color: Colors.blue),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(5.0))
                    )
                  ),
                ),
              ),
              ListTile(
                title: TextField(
                  style: TextStyle(color: Colors.blue),
                  controller: email,
                  decoration: InputDecoration(
                    labelText: 'Email Anggota',
                    hintStyle: TextStyle(color: Colors.blue),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(5.0))
                    )
                  ),
                ),
              ),
              ListTile(
                title: TextField(
                  style: TextStyle(color: Colors.blue),
                  controller: nohp,
                  decoration: InputDecoration(
                    labelText: 'No. HP Anggota',
                    hintStyle: TextStyle(color: Colors.blue),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(5.0))
                    )
                  ),
                  keyboardType: TextInputType.number,
                ),
              ),
              ListTile(
                title: TextField(
                  style: TextStyle(color: Colors.blue),
                  controller: alamat,
                  decoration: InputDecoration(
                    labelText: 'Alamat Anggota',
                    hintStyle: TextStyle(color: Colors.blue),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(5.0))
                    )
                  ),
                ),
              ),
              ListTile(
                title: TextField(
                  style: TextStyle(color: Colors.blue),
                  controller: password,
                  obscureText: _isHidePassword,
                  decoration: InputDecoration(
                    labelText: 'Password',
                    hintStyle: TextStyle(color: Colors.blue),
                    suffixIcon: GestureDetector(
                      onTap: _togglePassword,
                      child: Icon(
                        _isHidePassword ? Icons.visibility_off : Icons.visibility,
                        color: _isHidePassword ? Colors.grey : Colors.blue,
                      ),
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(5.0))
                    ),
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: Container(
                      padding: EdgeInsets.fromLTRB(15, 50, 15, 40),
                      child: ElevatedButton(
                        child: Text('Simpan',
                          style: TextStyle(fontSize: 15),
                        ),
                        onPressed: () {
                          editAnggota(context);
                        }, 
                      ),
                    )
                  )
                ],
              ),
            ],
          ),
        ),
      );
    }
  }