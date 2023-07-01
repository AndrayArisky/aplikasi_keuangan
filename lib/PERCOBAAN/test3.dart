// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'dart:convert';

// class ModalButtonScreen extends StatefulWidget {
//   @override
//   _ModalButtonScreenState createState() => _ModalButtonScreenState();
// }

// class _ModalButtonScreenState extends State<ModalButtonScreen> {
//   bool isLoading = true;
//   List<dynamic> data = [];

//   @override
//   void initState() {
//     super.initState();
//     fetchData();
//   }

//   Future<void> fetchData() async {
//     // Ganti URL_API dengan URL dari API database Anda
//     final response = await http.get(Uri.parse('https://apkeu2023.000webhostapp.com/getdata.php'));
    
//     if (response.statusCode == 200) {
//       setState(() {
//         data = json.decode(response.body);
//         isLoading = false;
//       });
//     } else {
//       throw Exception('Failed to load data from API');
//     }
//   }

//   void _showModal(String tipe) {
//     List<dynamic> filteredData =
//         data.where((item) => item['tipe'] == tipe).toList();

//     showModalBottomSheet(
//       context: context,
//       builder: (BuildContext context) {
//         return Container(
//           height: 500,
//           child: ListView.builder(
//             itemCount: filteredData.length,
//             itemBuilder: (BuildContext context, int index) {
//               final item = filteredData[index];
//               return ListTile(
//                 title: Text(item['nm_akun']),
//                 onTap: () {
//                   // Aksi yang ingin Anda lakukan saat item di dalam modal diklik
//                 },
//               );
//             },
//           ),
//         );
//       },
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Modal Button'),
//       ),
//       body: isLoading
//           ? Center(
//               child: CircularProgressIndicator(),
//             )
//           : Column(
//               children: [
//                 ElevatedButton(
//                   onPressed: () {
//                     _showModal('pm');
//                   },
//                   child: Text('Pemasukan'),
//                 ),
//                 ElevatedButton(
//                   onPressed: () {
//                     _showModal('pr');
//                   },
//                   child: Text('Pengeluaran'),
//                 ),
//               ],
//             ),
//     );
//   }
// }
