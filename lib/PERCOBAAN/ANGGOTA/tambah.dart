// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;

// class TambahAnggota extends StatefulWidget {
//   final level;
//   const TambahAnggota({Key? key, required this.level}) : super(key: key);

//   @override
//   _TambahAnggotaState createState() => _TambahAnggotaState();
// }

// class _TambahAnggotaState extends State<TambahAnggota> {
//   bool _isHidePassword = true;
//   String usaha = "Tidak Ada Nama Usaha";
//   String level = "karyawan";

//   TextEditingController nama = TextEditingController();
//   TextEditingController email = TextEditingController();
//   TextEditingController nohp = TextEditingController();
//   TextEditingController alamat = TextEditingController();
//   TextEditingController password = TextEditingController();

//   void _togglePassword() {
//     setState(() {
//       _isHidePassword = !_isHidePassword;
//     });
//   }

//   void resetData() {
//     setState(() {
//       nama.clear();
//       email.clear();
//       nohp.clear();
//       alamat.clear();
//       password.clear();
//     });
//   }

//   void tambahAnggota() async {
//     var url = Uri.parse('http://apkeu2023.000webhostapp.com/inputAnggota.php');
//     var body = {
//       'nama': nama.text,
//       'email': email.text,
//       'nohp': nohp.text,
//       'usaha': usaha,
//       'alamat': alamat.text,
//       'password': password.text,
//       'level': level
//     };

//     var response = await http.post(url, body: body);
//     print('Response status: ${response.statusCode}');
//     print('Response body: ${response.body}');

//     if (response.statusCode == 200) {
//       final result = json.decode(response.body);
//       if (result['message'] == 'Data berhasil disimpan') {
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(
//             content: Text('Data berhasil ditambahkan'),
//             action: SnackBarAction(
//               label: 'Oke',
//               onPressed: () {
//                 Navigator.pushReplacementNamed(context, '/dataAnggota');
//               },
//             ),
//           ),
//         );
//       } else {
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(
//             content: Text('Data gagal ditambahkan'),
//             action: SnackBarAction(
//               label: 'Oke',
//               onPressed: () {
//                 Navigator.of(context).pop();
//               },
//             ),
//           ),
//         );
//       }
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Tambah Anggota'),
//       ),
//       body: Padding(
//         padding: EdgeInsets.fromLTRB(15, 20, 15, 40),
//         child: Container(
//           child: ListView(
//             children: <Widget>[
//               SizedBox(
//                 height: 50,
//                 child: Center(
//                   child: Text(
//                     'DATA ANGGOTA BARU',
//                     style: TextStyle(
//                       fontSize: 18,
//                       fontWeight: FontWeight.bold,
//                       color: Colors.blue,
//                     ),
//                   ),
//                 ),
//               ),
//               SizedBox(height: 20),
//               ListTile(
//                 title: TextField(
//                   style: TextStyle(color: Colors.blue),
//                   controller: nama,
//                   decoration: InputDecoration(
//                     labelText: 'Nama Anggota',
//                     hintStyle: TextStyle(color: Colors.blue),
//                     border: OutlineInputBorder(
//                         borderRadius: BorderRadius.all(Radius.circular(5.0))),
//                   ),
//                 ),
//               ),
//               ListTile(
//                 title: TextField(
//                   style: TextStyle(color: Colors.blue),
//                   controller: email,
//                   decoration: InputDecoration(
//                     labelText: 'Email Anggota',
//                     hintStyle: TextStyle(color: Colors.blue),
//                     border: OutlineInputBorder(
//                         borderRadius: BorderRadius.all(Radius.circular(5.0))),
//                   ),
//                 ),
//               ),
//               ListTile(
//                 title: TextField(
//                   style: TextStyle(color: Colors.blue),
//                   controller: nohp,
//                   decoration: InputDecoration(
//                     labelText: 'No. HP Anggota',
//                     hintStyle: TextStyle(color: Colors.blue),
//                     border: OutlineInputBorder(
//                         borderRadius: BorderRadius.all(Radius.circular(5.0))),
//                   ),
//                   keyboardType: TextInputType.number,
//                 ),
//               ),
//               ListTile(
//                 title: TextField(
//                   style: TextStyle(color: Colors.blue),
//                   controller: alamat,
//                   decoration: InputDecoration(
//                     labelText: 'Alamat Anggota',
//                     hintStyle: TextStyle(color: Colors.blue),
//                     border: OutlineInputBorder(
//                         borderRadius: BorderRadius.all(Radius.circular(5.0))),
//                   ),
//                 ),
//               ),
//               ListTile(
//                 title: TextField(
//                   style: TextStyle(color: Colors.blue),
//                   controller: password,
//                   obscureText: _isHidePassword,
//                   decoration: InputDecoration(
//                     labelText: 'Password',
//                     hintStyle: TextStyle(color: Colors.blue),
//                     suffixIcon: GestureDetector(
//                       onTap: _togglePassword,
//                       child: Icon(
//                         _isHidePassword
//                             ? Icons.visibility_off
//                             : Icons.visibility,
//                         color: _isHidePassword ? Colors.grey : Colors.blue,
//                       ),
//                     ),
//                     border: OutlineInputBorder(
//                         borderRadius: BorderRadius.all(Radius.circular(5.0))),
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
//                           'Tambah Anggota',
//                           style: TextStyle(fontSize: 15),
//                         ),
//                         onPressed: () {
//                           tambahAnggota();
//                           resetData();
//                         },
//                       ),
//                     ),
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
