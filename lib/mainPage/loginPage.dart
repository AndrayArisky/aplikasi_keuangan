import 'dart:convert';
import 'package:aplikasi_keuangan/adminPages/adminPage.dart';
import 'package:aplikasi_keuangan/karyawanPages/karyawanPage.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class loginPage extends StatefulWidget {
  @override
  _loginPageState createState() => new _loginPageState();
}

class _loginPageState extends State<loginPage> {

  bool _isHidePassword = true;
  TextEditingController username = new TextEditingController();
  TextEditingController password = new TextEditingController();
  
  void _togglePassword() {
    setState(() {
      _isHidePassword = !_isHidePassword;
    });
  }

  
  void clear() {
    setState(() {
      username.clear();
      password.clear();
    });
  }

  Future<void> login() async {
    final result = await http.post(
      Uri.parse('https://apkeu2023.000webhostapp.com/login.php'),
      body: {
        "nama": username.text,
        "password": password.text,
      },
    );
  
    final datauser = json.decode(result.body);
  
    if (datauser.length == 0) {
      setState(() {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text("Gagal login"),
              content:Text("Username & Password Salah!"),
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
      });
    } else {
      if (datauser[0]['level'] == 'admin') {
        Navigator.pushReplacement(
          context, MaterialPageRoute(
            builder: (context) => adminPage(level: 'admin')
          )
        );
        print('Login Berhasil, Selamat Datang di Halaman Admin');
      } else if (datauser[0]['level'] == 'karyawan') {
        Navigator.pushReplacement(
          context, MaterialPageRoute(
            builder: (context) => karyawanPage(level: 'karyawan')
          )
        );
        print('Login Berhasil, Selamat Datang di Halaman Karyawan');
      }
      setState(() {
      // username = datauser[0]['username'];
      });
  }
  } 

  Widget _buildPageContent () {
    return Padding(
      padding: EdgeInsets.fromLTRB(15, 100, 15, 25),
      child: Container(
        child: ListView(
          children: <Widget>[
            SizedBox(
              height: 50,
              child: Center(
                child: Text(
                  'APKEU - UMKM',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue,    
                   ),
                ),
              ),
            ),
            SizedBox(height: 30),
            //USERNAME
            ListTile(
              title: TextField(
                style: TextStyle(
                  color: Colors.blue
                ),
                controller: username,
                decoration: InputDecoration(
                  hintText: 'Username',
                  hintStyle: TextStyle(
                    color: Colors.blue
                  ),
                  prefixIcon: Icon(
                    Icons.person,
                    color: Colors.blue,
                  ),
                ),
              ),
            ),
            SizedBox(height: 20),
            //PASSWORD
            ListTile(
              title: TextField(
                style: TextStyle(
                  color: Colors.blue
                ),
                controller: password,
                obscureText: _isHidePassword,
                decoration: InputDecoration(
                  hintText: 'Password',
                  hintStyle: TextStyle(
                    color: Colors.blue
                  ),
                  prefixIcon: Icon(
                    Icons.lock,
                    color: Colors.blue,
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
                      isDense: true,
                ),
              ),
            ),
            SizedBox(height: 50),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Expanded(
                  child: Container(
                    padding: EdgeInsets.fromLTRB(15, 25, 15, 25),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue
                      ),
                      child: Text(
                        'Masuk',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 15
                        ),
                      ),
                      onPressed: () {
                        login();
                        clear();
                      }, 
                    ),
                  )
                )
              ],
            ),
            // SizedBox(
            //   height: 30,
            // ),
            // Row(
            //   mainAxisAlignment: MainAxisAlignment.center,
            //   children: <Widget>[
            //     Text(
            //       'Belum punya akun?',
            //       style: TextStyle(
            //         color: Colors.black,
            //         fontSize: 12,
            //         fontWeight: FontWeight.normal
            //       ),
            //     ),
            //     TextButton(
            //       onPressed: () {
            //         // Navigator.pushReplacement(
            //         //   context, MaterialPageRoute(
            //         //     builder: (context) {
            //         //       return registerPage();
            //         //     }
            //         //   )
            //         // );                  
            //       }, 
            //       child: Text(
            //         'Daftar',
            //         style: TextStyle(
            //         color: Colors.blue,
            //         fontSize: 12,
            //         fontWeight: FontWeight.normal
            //       ),
            //       )
            //     )
            //   ],
            // )
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _buildPageContent(),
    );
  } 
}
