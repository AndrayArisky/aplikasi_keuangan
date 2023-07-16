// import 'package:aplikasi_keuangan/PERCOBAAN/ANGGOTA/edit.dart';
// import 'package:aplikasi_keuangan/PERCOBAAN/ANGGOTA/tambah.dart';
// import 'package:flutter/material.dart';
// import 'dart:convert';
// import 'package:http/http.dart' as http;

// class DataAnggota extends StatefulWidget {
//   @override
//   DataAnggotaState createState() => DataAnggotaState();
// }

// class DataAnggotaState extends State<DataAnggota> {
//   List<dynamic> anggota = [];

//   @override
//   void initState() {
//     super.initState();
//     fetchData();
//   }

//   Future<void> fetchData() async {
//     final response = await http.get(Uri.parse('https://apkeu2023.000webhostapp.com/getUser.php'));
//     if (response.statusCode == 200) {
//       final jsonData = json.decode(response.body);
//       final karyawan = jsonData.where((data) => data['level'] == 'karyawan').toList();
//       setState(() {
//         anggota = karyawan;
//       });
//     } else {
//       throw Exception('Gagal mengambil data!');
//     }
//   }

//   Future<void> hapusAnggota(String IDuser) async {
//     final response = await http.post(
//       Uri.parse('http://apkeu2023.000webhostapp.com/delete.php'),
//       body: {'id_user': IDuser},
//     );

//     if (response.statusCode == 200) {
//       setState(() {
//         anggota.removeWhere((data) => data['id_user'] == IDuser);
//       });
//     } else {
//       throw Exception('Failed to delete data');
//     }
//   } 

//   void navigateToEditAnggota(dynamic anggotaData) {
//     Navigator.push(
//       context,
//       MaterialPageRoute(
//         builder: (context) => EditAnggota(anggotaData: anggotaData),
//       ),
//     );
//   }

//   void confirmDeleteAnggota(dynamic anggotaData) {
//     showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return AlertDialog(
//           title: Text('Hapus Anggota'),
//           content: Text('Yakin ingin menghapus data anggota?'),
//           actions: <Widget>[
//             TextButton(
//               onPressed: () {
//                 Navigator.of(context).pop();
//               },
//               child: Text('Batal'),
//             ),
//             TextButton(
//               onPressed: () {
//                 hapusAnggota(anggotaData['id_user']);
//                 Navigator.of(context).pop();
//               },
//               child: Text('Yakin'),
//             )
//           ],
//         );
//       },
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Data Karyawan'),
//         actions: [
//           IconButton(
//             icon: Icon(
//               Icons.person_add,
//               color: Colors.black,
//             ),
//             onPressed: () {
//               Navigator.push(
//                 context,
//                 MaterialPageRoute(
//                   builder: (context) => TambahAnggota(level: 'admin'),
//                 ),
//               );
//             }, 
//           ),
//         ],
//       ),
//       body: Container(
//         padding: EdgeInsets.all(15),
//         child: ListView.separated(
//           separatorBuilder: (BuildContext context, int index) => Divider(),
//           shrinkWrap: true,
//           physics: NeverScrollableScrollPhysics(),
//           itemCount: anggota.length,
//           itemBuilder: (BuildContext context, int index) {
//             return Padding(
//               padding: const EdgeInsets.all(2.0),
//               child: ListTile(
//                 onTap: () {
//                   // Code for displaying member details in a modal bottom sheet
//                 },
//                 subtitle: Row(
//                   children: <Widget>[
//                     anggota[index]['level'] == 'karyawan' ? Icon(Icons.person, color: Colors.blue,) : Icon(Icons.people),
//                     SizedBox(width: 20.0),
//                     Expanded(
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Text(
//                             '${anggota[index]['nama']}',
//                             style: TextStyle(
//                               fontSize: 14,
//                               fontWeight: FontWeight.bold,
//                               color: Colors.black),
//                           ),
//                           Text('${anggota[index]['alamat']}'),
//                         ],
//                       ),
//                     ),
//                     IconButton(
//                       onPressed: () {
//                         navigateToEditAnggota(anggota[index]);
//                       }, 
//                       icon: Icon(
//                         Icons.edit,
//                         color: Colors.blue,
//                       )
//                     ),
//                     IconButton(
//                       onPressed: () {
//                         confirmDeleteAnggota(anggota[index]);
//                       }, 
//                       icon: Icon(
//                         Icons.delete,
//                         color: Colors.red,
//                       )
//                     )
//                   ],
//                 ),
//               ),
//             );
//           },
//         ),
//       ),
//     );
//   }
// }
