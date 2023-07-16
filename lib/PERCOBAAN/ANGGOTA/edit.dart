// import 'dart:convert';

// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;

// class EditAnggota extends StatefulWidget {
//   final dynamic anggotaData;
//   const EditAnggota({Key? key, required this.anggotaData}) : super(key: key);

//   @override
//   _EditAnggotaState createState() => _EditAnggotaState();
// }

// class _EditAnggotaState extends State<EditAnggota> {
//   TextEditingController namaController = TextEditingController();
//   TextEditingController emailController = TextEditingController();
//   TextEditingController nohpController = TextEditingController();
//   TextEditingController alamatController = TextEditingController();
//   TextEditingController passwordController = TextEditingController();

//   @override
//   void initState() {
//     super.initState();
//     setData();
//   }

//   void setData() {
//     final anggotaData = widget.anggotaData;
//     namaController.text = anggotaData['nama'];
//     emailController.text = anggotaData['email'];
//     nohpController.text = anggotaData['nohp'];
//     alamatController.text = anggotaData['alamat'];
//     passwordController.text = anggotaData['password'];
//   }

//   Future<void> EditAnggota() async {
//     final anggotaData = widget.anggotaData;
//     final url = Uri.parse('http://apkeu2023.000webhostapp.com/editBismillah.php');
//     final body = {
//       'id_user': anggotaData['id_user'],
//       'nama': namaController.text,
//       'email': emailController.text,
//       'nohp': nohpController.text,
//       'alamat': alamatController.text,
//       'password': passwordController.text,
//     };

//     final response = await http.post(url, body: body);
//     print('Response status: ${response.statusCode}');
//     print('Response body: ${response.body}');

//     if (response.statusCode == 200) {
//       final result = json.decode(response.body);
//       if (result['success'] == true) {
//         Navigator.of(context).pop();
//         // Tambahkan logika untuk mengambil data terbaru setelah berhasil mengedit
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
//         title: Text('Edit Anggota'),
//       ),
//       body: Padding(
//         padding: EdgeInsets.all(15),
//         child: ListView(
//           children: [
//             SizedBox(
//               height: 50,
//               child: Center(
//                 child: Text(
//                   'EDIT DATA ANGGOTA',
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
//                 style: TextStyle(color: Colors.blue),
//                 controller: namaController,
//                 decoration: InputDecoration(
//                   labelText: 'Nama Anggota',
//                   hintStyle: TextStyle(color: Colors.blue),
//                   border: OutlineInputBorder(
//                     borderRadius: BorderRadius.all(Radius.circular(5.0))
//                   )
//                 ),
//               ),
//             ),
//             ListTile(
//               title: TextField(
//                 style: TextStyle(color: Colors.blue),
//                 controller: emailController,
//                 decoration: InputDecoration(
//                   labelText: 'Email Anggota',
//                   hintStyle: TextStyle(color: Colors.blue),
//                   border: OutlineInputBorder(
//                     borderRadius: BorderRadius.all(Radius.circular(5.0))
//                   )
//                 ),
//               ),
//             ),
//             ListTile(
//               title: TextField(
//                 style: TextStyle(color: Colors.blue),
//                 controller: nohpController,
//                 decoration: InputDecoration(
//                   labelText: 'No. HP Anggota',
//                   hintStyle: TextStyle(color: Colors.blue),
//                   border: OutlineInputBorder(
//                     borderRadius: BorderRadius.all(Radius.circular(5.0))
//                   )
//                 ),
//                 keyboardType: TextInputType.number,
//               ),
//             ),
//             ListTile(
//               title: TextField(
//                 style: TextStyle(color: Colors.blue),
//                 controller: alamatController,
//                 decoration: InputDecoration(
//                   labelText: 'Alamat Anggota',
//                   hintStyle: TextStyle(color: Colors.blue),
//                   border: OutlineInputBorder(
//                     borderRadius: BorderRadius.all(Radius.circular(5.0))
//                   )
//                 ),
//               ),
//             ),
//             ListTile(
//               title: TextField(
//                 style: TextStyle(color: Colors.blue),
//                 controller: passwordController,
//                 decoration: InputDecoration(
//                   labelText: 'Password',
//                   hintStyle: TextStyle(color: Colors.blue),
//                   border: OutlineInputBorder(
//                     borderRadius: BorderRadius.all(Radius.circular(5.0))
//                   )
//                 ),
//               ),
//             ),
//             Row(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   Expanded(
//                     child: Container(
//                       padding: EdgeInsets.fromLTRB(15, 50, 15, 40),
//                       child: ElevatedButton(
//                         child: Text(
//                           'Simpan',
//                           style: TextStyle(fontSize: 15),
//                         ),
//                         onPressed: () {
//                           EditAnggota();
//                         }, 
//                       ),
//                     )
//                   )
//                 ],
//               ),
//           ],
//         ),
//       ),
//     );
//   }
// }
