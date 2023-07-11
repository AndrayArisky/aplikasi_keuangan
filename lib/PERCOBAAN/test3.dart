// import 'dart:convert';

// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;

// class editAnggota extends StatefulWidget {
//   final String level;
//   final int id_user;

//   const editAnggota({Key? key, required this.level, required this.id_user})
//       : super(key: key);

//   @override
//   _editAnggotaState createState() => _editAnggotaState();
// }

// class _editAnggotaState extends State<editAnggota> {
//   bool _isHidePassword = true;

//   void _togglePassword() {
//     setState(() {
//       _isHidePassword = !_isHidePassword;
//     });
//   }

//   final nama = TextEditingController();
//   final email = TextEditingController();
//   final nohp = TextEditingController();
//   final alamat = TextEditingController();
//   final password = TextEditingController();

//   @override
//   void initState() {
//     super.initState();
//     fetchData();
//   }

//   Future<void> fetchData() async {
//     final response =
//         await http.get(Uri.parse('https://apkeu2023.000webhostapp.com/getUser.php'));
//     if (response.statusCode == 200) {
//       final jsonData = json.decode(response.body);
//       final anggota = jsonData.firstWhere((data) => data['id_user'] == widget.id_user.toString());
//       setState(() {
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

//   Future<void> editAnggota(
//       int id_user, String nama, String email, String nohp, String alamat, String password) async {
//     var url = Uri.parse('http://apkeu2023.000webhostapp.com/editBismillah.php');
//     var body = {
//       'id_user': id_user.toString(),
//       'nama': nama,
//       'email': email,
//       'nohp': nohp,
//       'alamat': alamat,
//       'password': password,
//     };

//     var response = await http.post(url, body: body);
//     print('Response status: ${response.statusCode}');
//     print('Response body: ${response.body}');

//     if (response.statusCode == 200) {
//       final result = json.decode(response.body);
//       if (result['success'] == true) {
//         Navigator.of(context).popAndPushNamed(
//           '/dataAnggota',
//           arguments: [
//             widget.id_user,
//             nama,
//             email,
//             nohp,
//             alamat,
//             password,
//           ],
//         );
//       } else {
//         print('Edit data gagal!');
//       }
//     } else {
//       print('Edit data gagal! Status code: ${response.statusCode}');
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Update Data'),
//       ),
//       body: Padding(
//         padding: EdgeInsets.all(15),
//         child: ListView(
//           children: <Widget>[
//             SizedBox(
//               height: 50,
//               child: Center(
//                 child: Text(
//                   'DATA ANGGOTA',
//                   style: TextStyle(
//                     fontSize: 18,
//                     fontWeight: FontWeight.bold,
//                     color: Colors.blue,
//                   ),
//                 ),
//               ),
//             ),
//             SizedBox(height: 20),
//             ListTile(
//               title: TextField(
//                 controller: nama,
//                 decoration: InputDecoration(
//                   labelText: 'Nama Anggota',
//                 ),
//               ),
//             ),
//             ListTile(
//               title: TextField(
//                 controller: email,
//                 decoration: InputDecoration(
//                   labelText: 'Email Anggota',
//                 ),
//               ),
//             ),
//             ListTile(
//               title: TextField(
//                 controller: nohp,
//                 decoration: InputDecoration(
//                   labelText: 'No. HP Anggota',
//                 ),
//               ),
//             ),
//             ListTile(
//               title: TextField(
//                 controller: alamat,
//                 decoration: InputDecoration(
//                   labelText: 'Alamat Anggota',
//                 ),
//               ),
//             ),
//             ListTile(
//               title: TextField(
//                 controller: password,
//                 decoration: InputDecoration(
//                   labelText: 'Password',
//                 ),
//                 obscureText: _isHidePassword,
//               ),
//             ),
//             Row(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: <Widget>[
//                 Expanded(
//                   child: Container(
//                     padding: EdgeInsets.all(15),
//                     child: ElevatedButton(
//                       child: Text(
//                         'Simpan',
//                         style: TextStyle(fontSize: 15),
//                       ),
//                       onPressed: () {
//                         editAnggota(
//                           widget.id_user,
//                           nama.text,
//                           email.text,
//                           nohp.text,
//                           alamat.text,
//                           password.text,
//                         );
//                       },
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
