// import 'dart:convert';
// import 'package:aplikasi_keuangan/adminPages/adminPage.dart';
// import 'package:aplikasi_keuangan/karyawanPages/karyawanPage.dart';
// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'package:shared_preferences/shared_preferences.dart';

// class LoginPage extends StatefulWidget {
//   const LoginPage({super.key});

//   @override
//   State<LoginPage> createState() => _LoginPageState();
// }

// enum statusLogin { notSignIn, loginAdmin, loginKaryawan }

// class _LoginPageState extends State<LoginPage> {
//   statusLogin _statusLogin = statusLogin.notSignIn;
//   final formKey = GlobalKey<FormState>();
//   String? nama, password;

//   bool secureText = true;

//   showHide() {
//     setState(() {
//       secureText = !secureText;
//     });
//   }

//   submitForm() {
//     final form = formKey.currentState;
//     if (form!.validate()) {
//       form.save();
//       login();
//     }
//   }

//   login() async {
//     final response = await http.post(
//         Uri.parse('https://apkeu2023.000webhostapp.com/login.php'),
//         body: {"nama": nama, "password": password});

//     final data = jsonDecode(response.body);
//     int value = data['value'];
//     String pesan = data['message'];
//     String namaAPI = data['nama'];
//     String nohp = data['nohp'];
//     String email = data['email'];
//     String alamat = data['alamat'];
//     String usaha = data['usaha'];
//     String level = data['level'];
//     String id_user = data['id_user'];
//     if (value == 1) {
//       setState(() {
//         _statusLogin = statusLogin.loginAdmin;
//         _statusLogin = statusLogin.loginKaryawan;
//         savePref(value, namaAPI, nohp, email, alamat, usaha, level, id_user);
//       });
//       print(pesan);
//     } else {
//       print(pesan);
//     }
//   }

//   savePref(int value, String nama, String nohp, String email, String alamat, String usaha,
//       String level, String id_user) async {
//     SharedPreferences preferences = await SharedPreferences.getInstance();
//     setState(() {
//       preferences.setInt('value', value);
//       preferences.setString('nama', nama);
//       preferences.setString('nohp', nohp);
//       preferences.setString('email', email);
//       preferences.setString('alamat', alamat);
//       preferences.setString("usaha", usaha);
//       preferences.setString("level", level);
//       preferences.setString("id", id_user);

//       if (level == "admin") {
//         _statusLogin = statusLogin.loginAdmin;
//       } else if (level == "karyawan") {
//         _statusLogin = statusLogin.loginKaryawan;
//       } else {
//         _statusLogin = statusLogin.notSignIn;
//       }
//     });
//   }

//   getPref() async {
//     SharedPreferences preferences = await SharedPreferences.getInstance();
//     setState(() {
//       String? level = preferences.getString("level");

//       if (level == "admin") {
//         _statusLogin = statusLogin.loginAdmin;
//       } else if (level == "karyawan") {
//         _statusLogin = statusLogin.loginKaryawan;
//       } else {
//         _statusLogin = statusLogin.notSignIn;
//       }
//     });
//   }
//   signOut() async {
//     SharedPreferences preferences = await SharedPreferences.getInstance();
//     setState(() {
//       preferences.remove('level');
//       _statusLogin = statusLogin.notSignIn;
//     });
//   }

//   @override
//   void initState() {
//     super.initState();
//     getPref();
//   }

//   @override
//   Widget build(BuildContext context) {
//     switch (_statusLogin) {
//       case statusLogin.notSignIn:
//         return Scaffold(
//           body: Container(
//             child: Form(
//               key: formKey,
//               child: Container(
//                 padding: const EdgeInsets.fromLTRB(15, 100, 15, 25),
//                 child: ListView(
//                   children: [
//                     const SizedBox(
//                       height: 50,
//                       child: Center(
//                         child: Text(
//                           'APKEU - UMKM',
//                           style: TextStyle(
//                             fontSize: 20,
//                             fontWeight: FontWeight.bold,
//                             color: Colors.blue,
//                           ),
//                         ),
//                       ),
//                     ),
//                     SizedBox(height: 20),
//                     ListTile(
//                       title: TextFormField(
//                         style: const TextStyle(color: Colors.blue),
//                         validator: (e) {
//                           if (e!.isEmpty) {
//                             return 'Username tidak boleh kosong';
//                           }
//                           return null;
//                         },
//                         onSaved: (e) {
//                           nama = e!;
//                         },
//                         decoration: const InputDecoration(
//                           labelText: 'Username',
//                           hintStyle: TextStyle(color: Colors.blue),
//                           prefixIcon: Icon(
//                             Icons.person,
//                             color: Colors.blue,
//                           ),
//                         ),
//                       ),
//                     ),
//                     ListTile(
//                       title: TextFormField(
//                         style: const TextStyle(color: Colors.blue),
//                         obscureText: secureText,
//                         onSaved: (e) {
//                           password = e!;
//                         },
//                         decoration: InputDecoration(
//                           labelText: "Password",
//                           hintStyle: TextStyle(color: Colors.blue),
//                           suffixIcon: IconButton(
//                             onPressed: showHide,
//                             icon: Icon(secureText
//                                 ? Icons.visibility_off
//                                 : Icons.visibility),
//                           ),
//                           prefixIcon: Icon(
//                             Icons.lock,
//                             color: Colors.blue,
//                           ),
//                         ),
//                       ),
//                     ),
//                     SizedBox(height: 50),
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       children: <Widget>[
//                         Expanded(
//                           child: Container(
//                             padding: EdgeInsets.fromLTRB(15, 25, 15, 25),
//                             child: ElevatedButton(
//                               style: ElevatedButton.styleFrom(
//                                 backgroundColor: Colors.blue
//                               ),
//                               child: Text(
//                                 'Masuk',
//                                 style: TextStyle(
//                                   color: Colors.white,
//                                   fontSize: 15
//                                 ),
//                               ),
//                               onPressed: () {
//                                 submitForm();
//                               }, 
//                             ),
//                           )
//                         )
//                       ],
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           ),

//         );
//         break;
//       case statusLogin.loginAdmin:
//         return adminPage(level: 'admin');
//         break;
//       case statusLogin.loginKaryawan:
//         return karyawanPage(level: 'karyawan',);
//         break;
//     }
//   }
// }
