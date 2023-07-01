// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;

// class Tipe {
//   final String title;
//   final String type;

//   Tipe({required this.title, required this.type});
// }

// class inputAja extends StatefulWidget {
//   @override
//   inputAjaState createState() => inputAjaState();
// }

// class inputAjaState extends State<inputAja> {
//   bool isLoading = true;
//   List<Tipe> pemasukanData = [];
//   List<Tipe> pengeluaranData = [];

//   @override
//   void initState() {
//     super.initState();
//     fetchData();
//   }

//   Future<void> fetchData() async {
//     final response = await http.get(Uri.parse('https://apkeu2023.000webhostapp.com/getdata.php')); // Ganti URL_API dengan URL dari API yang menyediakan data tipe

//     if (response.statusCode == 200) {
//       final data = json.decode(response.body);
//       final List<dynamic> pemasukan = data['pm'];
//       final List<dynamic> pengeluaran = data['pr'];

//       setState(() {
//         pemasukanData = pemasukan
//             .map((item) => Tipe(title: item['nm_akun'], type: item['pr']))
//             .toList();
//         pengeluaranData = pengeluaran
//             .map((item) => Tipe(title: item['nm_akun'], type: item['pm']))
//             .toList();
//         isLoading = false;
//       });
//     } else {
//       throw Exception('Failed to load data from API');
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Tambah Transaksi'),
//       ),
//       body: Container(
//         padding: EdgeInsets.all(20),
//         child: Column(
//           children: <Widget>[
//             isLoading
//                 ? CircularProgressIndicator()
//                 : ListView.builder(
//                     shrinkWrap: true,
//                     itemCount: pemasukanData.length,
//                     itemBuilder: (BuildContext context, int index) {
//                       final tipe = pemasukanData[index];
//                       return ListTile(
//                         title: Text(tipe.title),
//                         onTap: () {
//                           // Lakukan sesuatu saat tipe pemasukan dipilih
//                         },
//                       );
//                     },
//                   ),
//             isLoading
//                 ? CircularProgressIndicator()
//                 : ListView.builder(
//                     shrinkWrap: true,
//                     itemCount: pengeluaranData.length,
//                     itemBuilder: (BuildContext context, int index) {
//                       final tipe = pengeluaranData[index];
//                       return ListTile(
//                         title: Text(tipe.title),
//                         onTap: () {
//                           // Lakukan sesuatu saat tipe pengeluaran dipilih
//                         },
//                       );
//                     },
//                   ),
//           ],
//         ),
//       ),
//     );
//   }
// }
