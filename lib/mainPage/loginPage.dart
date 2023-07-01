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
  
  void _togglePassword() {
    setState(() {
      _isHidePassword = !_isHidePassword;
    });
  }

  TextEditingController username = new TextEditingController();
  TextEditingController password = new TextEditingController();

Future<void> _login() async {
  final result = await http.post(
    Uri.parse('https://apkeu2023.000webhostapp.com/login.php'),
    body: {
      "username": username.text,
      "password": password.text,
    },
  );
 
  final datauser = json.decode(result.body);
 
  if (datauser.length == 0) {
    setState(() {
      print('Maaf, silakan Cek Username dan Password Anda');
    });
  } else {
    if (datauser[0]['level'] == 'admin') {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => adminPage(id_user: 11,)));
      print('Login Berhasil, Selamat Datang di Halaman Admin');
    } else if (datauser[0]['level'] == 'karyawan') {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => karyawanPage(id_user: 22,)));
      print('Login Berhasil, Selamat Datang di Halaman Karyawan');
    }
    setState(() {
    // username = datauser[0]['username'];
    });
 }
} 

  Widget _buildPageContent () {
    return Padding(
      padding: const EdgeInsets.all(20),
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
            SizedBox(height: 50),
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
            SizedBox(height: 30),
            Row(
              children: <Widget>[
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(15.0),
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
                        /*
                        if (username.value.text == 'admin' && password.value.text == 'admin') {
                          Navigator.pushReplacement(context,
                          MaterialPageRoute(builder: (context) {
                            return menu();
                          }));
                          // _sendDataToSecondScreen(context);
                        } else if (username.value.text == 'karyawan' && password.value.text == 'karyawan') {
                          Navigator.pushReplacement(context,
                          MaterialPageRoute(builder: (context) {
                            return Karyawan_Page();
                          }));
                          // _sendDataToSecondScreen(context);
                        } else {
                          error(context, "Username dan password salah!");
                        }
                        */
                        _login();
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

void error(BuildContext context, String error) {
    final scaffold = ScaffoldMessenger.of(context);
    scaffold.showSnackBar(
      SnackBar(
        content: Text(error),
        action: SnackBarAction(
          label: 'OK', 
          onPressed: scaffold.hideCurrentSnackBar
        ),
      ),
    );
  }

// source code flutter untuk menghitung sisa kas dari pemasukan dan pengeluaran per hari