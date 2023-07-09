// import 'dart:convert';
// import 'package:aplikasi_keuangan/adminPages/anggota/dataAnggota.dart';
// import 'package:aplikasi_keuangan/adminPages/adminPage.dart';
// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';
// import 'package:http/http.dart' as http;

// class editAnggota extends StatefulWidget {
//   final String level;
//   const editAnggota({super.key, required this.level});

//   @override
//   _editAnggotaState createState() => _editAnggotaState();
// }

// class _editAnggotaState extends State<editAnggota> {

//   bool _isHidePassword = true;
//   List<dynamic> anggota = [];

//   TextEditingController nama = TextEditingController();
//   TextEditingController email = TextEditingController();
//   TextEditingController nohp = TextEditingController();
//   TextEditingController alamat = TextEditingController();
//   TextEditingController password = TextEditingController();

//   @override
//   void initState() {
//     super.initState();
//     fetchData();
//   }

//   Future<void> fetchData() async {
//     //int id_user = widget.id_user;
//     final response = await http.get(Uri.parse('https://apkeu2023.000webhostapp.com/getUser.php'));
//     if (response.statusCode == 200) {
//       final jsonData = json.decode(response.body);
//       final anggota = jsonData.firstWhere((data) => data['id_user'] == 'id_user');
//       setState(() {
//         //id_user = widget.id_user;
//         nama.text = anggota['nama'];
//         email.text = anggota['email'];
//         nohp.text = anggota['nohp'];
//         alamat.text = anggota['alamat'];
//         password.text = anggota['password'];
//       });
//     } else {
//       throw Exception('Gagal mengambil data!');
//     }
//   }

//   void _togglePassword() {
//     setState(() {
//       _isHidePassword = !_isHidePassword;
//     });
//   }

//   // FUNGSI TOMBOL SIMPAN
//   Future<void> editAnggota() async {
//     var url = Uri.parse('http://apkeu2023.000webhostapp.com/editBismillah.php');
//     var body = {
//       //'id_user': widget.id_user,
//       'nama': nama,
//       'email': email,
//       'nohp': nohp,
//       'alamat': alamat,
//       'password': password,
//     };

//     var response = await http.post(url, body: body);
//     print('Response status: ${response.statusCode}');
//     print('Response body: ${response.body}');
//     //print('ID USER : $level');

//     if (response.statusCode == 200) {
//       final result = json.decode(response.body);
//       if (result['success'] == true) {
//         Navigator.of(context).popAndPushNamed(
//           '/dataAnggota',
//           arguments: [
//             // anggota[index]['id_user'],
//             // anggota[index]['nama'],
//             // anggota[index]['email'],
//             // anggota[index]['nohp'],
//             // anggota[index]['alamat'],
//             // anggota[index]['password']
//             nama,
//             email,
//             nohp,
//             alamat,
//             password
//            ]
//         );
//       } else {
//         print('Edit data gagal!');
//       }
//     } else {
//     print('Edit data gagal! Status code: ${response.statusCode}');
//   }
//   }
  
//   @override
//   Widget build(BuildContext context) {
//     // final args = ModalRoute.of(context)!.settings.arguments as List<dynamic>;
//     // if(args[1].isNotEmpty) {
//     //   nama.text = args[1];
//     // }
//     // if(args[2].isNotEmpty) {
//     //   email.text = args[2];
//     // }
//     // if(args[3].isNotEmpty) {
//     //   nohp.text = args[3];
//     // }
//     // if(args[4].isNotEmpty) {
//     //   alamat.text = args[4];
//     // }
//     // if(args[5].isNotEmpty) {
//     //   password.text = args[5];
//     // }
    
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Edit Anggota'),
//       ),
//       body: Padding(
//         padding: EdgeInsets.fromLTRB(15, 20, 15, 40),
//         child: Container(
//           child: ListView(
//             children: <Widget>[
//               SizedBox(
//               height: 50,
//               child: Center(
//                 child: Text(
//                   'DATA ANGGOTA',
//                   style: TextStyle(
//                     fontSize: 18,
//                     fontWeight: FontWeight.bold,
//                     color: Colors.blue,
//                    ),
//                 ),
//               ),
//             ),
//               SizedBox(height: 20),
//               ListTile(
//                 title: TextField(
//                   style: TextStyle(
//                     color: Colors.blue
//                   ),
//                   controller: nama,
//                   decoration: InputDecoration(
//                     labelText: 'Nama Anggota',
//                     hintStyle: TextStyle(
//                       color: Colors.blue
//                     ),
//                     border: OutlineInputBorder(
//                     borderRadius: BorderRadius.all(Radius.circular(5.0))
//                   )
//                   ),
//                 ),
//               ),
//               ListTile(
//                 title: TextField(
//                   style: TextStyle(
//                     color: Colors.blue
//                   ),
//                   controller: email,
//                   decoration: InputDecoration(
//                     labelText: 'Email Anggota',
//                     hintStyle: TextStyle(
//                       color: Colors.blue
//                     ),
//                     border: OutlineInputBorder(
//                       borderRadius: BorderRadius.all(Radius.circular(5.0))
//                     )
//                   ),
//                 ),
//               ),
//               ListTile(
//                 title: TextField(
//                   style: TextStyle(
//                     color: Colors.blue
//                   ),
//                   controller: nohp,
//                   decoration: InputDecoration(
//                     labelText: 'No. HP Anggota',
//                     hintStyle: TextStyle(
//                       color: Colors.blue
//                     ),
//                     border: OutlineInputBorder(
//                     borderRadius: BorderRadius.all(Radius.circular(5.0))
//                   )
//                   ),
//                   keyboardType: TextInputType.number,
//                 ),
//               ),
//               ListTile(
//                 title: TextField(
//                   style: TextStyle(
//                     color: Colors.blue
//                   ),
//                   controller: alamat,
//                   decoration: InputDecoration(
//                     labelText: 'Alamat Anggota',
//                     hintStyle: TextStyle(
//                       color: Colors.blue
//                     ),
//                     border: OutlineInputBorder(
//                     borderRadius: BorderRadius.all(Radius.circular(5.0))
//                   )
//                   ),
//                 ),
//               ),
//               ListTile(
//                 title: TextField(
//                   style: TextStyle(
//                     color: Colors.blue
//                   ),
//                   controller: password,
//                   decoration: InputDecoration(
//                     labelText: 'Password',
//                     hintStyle: TextStyle(
//                       color: Colors.blue
//                     ),
//                     suffixIcon: GestureDetector(
//                       onTap: () {
//                         _togglePassword();
//                       },
//                       child: Icon(
//                         _isHidePassword ? Icons.visibility_off : Icons.visibility,
//                         color: _isHidePassword ? Colors.grey : Colors.blue,
//                       ),
//                     ),
//                     border: OutlineInputBorder(
//                     borderRadius: BorderRadius.all(Radius.circular(5.0))
//                   )
//                   ),
//                 ),
//               ),
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: <Widget>[
//                   Expanded(
//                     child: Container(
//                       padding: EdgeInsets.fromLTRB(15, 50, 15, 40),
//                       child: ElevatedButton(
//                         child: Text(
//                           'Simpan',
//                           style: TextStyle(fontSize: 15),
//                         ),
//                         onPressed: () {
//                           editAnggota();
//                         }, 
//                       ),
//                     )
//                   )
//                 ],
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }