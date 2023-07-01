// import 'package:aplikasi_keuangan/transaksiPage/loginPage.dart';
// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'dart:convert';

// class profilAdmin extends StatefulWidget {
//   @override
//   _profilAdminState createState() => _profilAdminState();
// }

// class _profilAdminState extends State<profilAdmin>{
//   bool isLoading = true;
//   Map<String, dynamic> data = {};

//   @override
//   void initState() {
//     super.initState();
//     fetchData('admin'); // Ganti 'admin' dengan level user yang diinginkan
//   }

//   Future<void> fetchData(String level) async {
//     final url = 'https://apkeu2023.000webhostapp.com/getprofil.php?level=admin';
//     final response = await http.get(Uri.parse(url));

//     if (response.statusCode == 200) {
//       setState(() {
//         data = json.decode(response.body);
//         isLoading = false;
//       });
//     } else {
//       throw Exception('Failed to load data from API');
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       extendBodyBehindAppBar: true,
//       extendBody: true,
//       body: isLoading ? CircularProgressIndicator() : SingleChildScrollView(
//         child: Column(
//           children: <Widget>[
//             ProfilHeader(
//               title: data['nm_usaha'] ?? '',
//               subtitle: data['alamat'] ?? '',
//             ),
//             SizedBox(height: 20,),
//             adminInfo(
//               data: data,
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// class adminInfo extends StatelessWidget {
//   final Map<String, dynamic> data;

//   const adminInfo({
//     required this.data,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       padding: EdgeInsets.all(10),
//       child: Column(
//         children: <Widget>[
//           ListTile(
//             title: Text(
//               'Informasi Karyawan',
//               style: TextStyle(
//                 fontSize: 16,
//               ),
//               textAlign: TextAlign.left,
//             ),
//             trailing: Row(
//               mainAxisSize: MainAxisSize.min,
//               children: <Widget>[
//                 IconButton(
//                   onPressed: () {},
//                   icon: Icon(
//                     Icons.edit,
//                     color: Colors.black,
//                   ),
//                 )
//               ],
//             ),
//           ),
//           Card(
//             child: Container(
//               alignment: Alignment.topLeft,
//               padding: EdgeInsets.all(15),
//               child: Column(
//                 children: <Widget>[
//                   Column(
//                     children: <Widget>[
//                       ...ListTile.divideTiles(
//                         color: Colors.blue,
//                         tiles: [
//                           ListTile(
//                             contentPadding: EdgeInsets.symmetric(
//                                 horizontal: 12,
//                                 vertical: 4
//                             ),
//                             leading: Icon(
//                                 Icons.local_activity
//                             ),
//                             title: Text(
//                                 "Nama Karyawan"
//                             ),
//                             subtitle: Text(
//                                 "Arisky"
//                             ),
//                           ),
//                           ListTile(
//                             leading: Icon(
//                                 Icons.local_activity
//                             ),
//                             title: Text(
//                                 "Nama Admin"
//                             ),
//                             subtitle: Text(
//                                 "Andray"
//                             ),
//                           ),
//                           ListTile(
//                             leading: Icon(
//                                 Icons.local_activity
//                             ),
//                             title: Text(
//                                 "Nama Admin"
//                             ),
//                             subtitle: Text(
//                                 "Andray"
//                             ),
//                           )
//                         ],
//                       )
//                     ],
//                   )
//                 ],
//               ),
//             ),
//           ),
//           SizedBox(height: 30,),
//           Row(
//             children: <Widget>[
//               Expanded(
//                   child: Padding(
//                     padding: EdgeInsets.fromLTRB(4, 50, 4, 15),
//                     child: ElevatedButton(
//                       style: ElevatedButton.styleFrom(
//                           backgroundColor: Colors.blue
//                       ),
//                       child: Text('Keluar'),
//                       onPressed: () {
//                         Navigator.pushAndRemoveUntil(
//                           context,
//                           MaterialPageRoute(builder: (context) => loginPage()),
//                               (Route<dynamic> route) => false,
//                         );
//                       },
//                     ),
//                   )
//               )
//             ],
//           ),
//         ],
//       ),
//     );
//   }
// }

// class ProfilHeader extends StatelessWidget {
//   final String title;
//   final String subtitle;

//   const ProfilHeader({
//     required this.title,
//     required this.subtitle,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Stack(
//       children: <Widget>[
//         Container(
//           width: double.infinity,
//           margin: EdgeInsets.only(top: 30),
//           child: Column(
//             children: <Widget>[
//               Text(
//                 title,
//                 style: Theme.of(context).textTheme.headline6,
//               ),
//               if (subtitle != null) ...[
//                 SizedBox(
//                   height: 5.0,
//                 ),
//                 Text(
//                   subtitle,
//                   style: Theme.of(context).textTheme.subtitle1,
//                 )
//               ]
//             ],
//           ),
//         )
//       ],
//     );
//   }
// }
