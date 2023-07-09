// import 'dart:convert';
// import 'package:aplikasi_keuangan/adminPages/adminPage.dart';
// import 'package:aplikasi_keuangan/PERCOBAAN/inputFake.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:intl/date_symbol_data_local.dart';
// import 'package:intl/intl.dart';
// import 'package:http/http.dart' as http;

// class editTesting extends StatefulWidget {
//   @override
//   _editTestingState createState() => _editTestingState();
// }

// class _editTestingState extends State<editTesting> {
//   List<dynamic> dataTransaksi = [];
//   List<dynamic> sortedDates = [];
//   List<String> distinctMonthAndYear = [];

//   @override
//   void initState() {
//     super.initState();
//     fetchData();
//   }

//   void fetchData() async {
//     final response = await http.get(Uri.parse('http://apkeu2023.000webhostapp.com/getTransaksi.php?'));
//     if (response.statusCode == 200) {
//       setState(() {
//         dataTransaksi = json.decode(response.body);
//         // tambahkan setState pada sortedDates
//         sortedDates = [];
//         for (var i = 0; i < dataTransaksi.length; i++) {
//           String tglTransaksi = dataTransaksi[i]['tgl_transaksi'];
//           DateTime dateTime = DateTime.parse(tglTransaksi);
//           sortedDates.add(dateTime);
//           //print('sortedDates : $sortedDates');
//         }
//         sortedDates.sort((a, b) => a.compareTo(b));
//         if (sortedDates != null && sortedDates.isNotEmpty) {
//           distinctMonthAndYear = _getDistinctMonthAndYear();
//           //print('distinctMonthAndYear : $distinctMonthAndYear');
//         }
//       });
//     } else {
//       throw Exception('Failed to load data');
//     }
//   }

//   List<String> _getDistinctMonthAndYear() {
//     List<String> distinctMonthAndYear = [];
//     initializeDateFormatting('id_ID');
//     // ambil waktu sekarang
//     DateTime now = DateTime.now();
//     // ubah nama bulan menjadi bahasa Indonesia
//     var formatBulan = DateFormat.MMM();
//     String namaBulan = formatBulan.format(now);
//     // buat format untuk menampilkan tahun dalam 2 digit
//     var formatTahun = DateFormat('yy');
//     String tahun = formatTahun.format(now);
//     // gabungkan nama bulan dan tahun
//     String monthAndYear = "$namaBulan $tahun";
//     // tambahkan ke list
//     // distinctMonthAndYear.add(monthAndYear);
//     for (var i = 0; i < sortedDates.length; i++) {
//       DateTime dateTime = sortedDates[i];
//       // tambahkan baris kode berikut untuk mengubah nama bulan
//       var formatBulan = DateFormat.MMM();
//       String namaBulan = formatBulan.format(dateTime);
//       String monthAndYear = "$namaBulan ${dateTime.year.toString().substring(2)}"; // format string
//       if (!distinctMonthAndYear.contains(monthAndYear)) {
//         // tambahkan baris kode berikut untuk mengecek apakah bulan ini memiliki data atau tidak
//         bool bulanPunyaData = false;
//         for (var j = 0; j < dataTransaksi.length; j++) {
//           String tglTransaksi = dataTransaksi[j]['tgl_transaksi'];
//           DateTime dateTime = DateTime.parse(tglTransaksi);
//           var formatBulan = DateFormat.MMM();
//           String namaBulan = formatBulan.format(dateTime);
//           String monthAndYearTransaction = "$namaBulan ${dateTime.year.toString().substring(2)}";
//           if (monthAndYearTransaction == monthAndYear) {
//             bulanPunyaData = true;
//             break;
//           }
//         }
//         if (bulanPunyaData) {
//           distinctMonthAndYear.add(monthAndYear);
//         }
//       }
//     }
//     return distinctMonthAndYear;
//   }

//   var rupiah = NumberFormat.currency(
//     locale: 'id_ID', 
//     symbol: 'Rp. ', 
//     decimalDigits: 0
//   );

//   @override
//   Widget build(BuildContext context) {
//     // List<String> distinctMonthAndYear = _getDistinctMonthAndYear();
//     if (distinctMonthAndYear.isEmpty) {
//       return DefaultTabController(
//         length: 0,
//         initialIndex: 0,                                                                                                                                                                              
//         child: Scaffold(
//           body: Center(
//             child: Text(
//               'Membaca riwayat transaksi',
//               textAlign: TextAlign.center
//             ),
//           ),
//         )
//       );
//     } else {
//       int initialIndex = DateTime.now().month + 1;
//       if (initialIndex >= distinctMonthAndYear.length) {
//         initialIndex = distinctMonthAndYear.length - 1;
//       }
//       return DefaultTabController(
//         length: distinctMonthAndYear.length,
//         initialIndex: initialIndex,
//         // tampilan halaman yg berjalan
//         child: Scaffold(
//           appBar: TabBar(
//             isScrollable: true,
//             labelColor: Colors.blue,
//             tabs: distinctMonthAndYear.map((monthAndYear) {
//               return Tab(
//                 child: Text(
//                   monthAndYear,
//                   style: TextStyle(
//                     fontSize: 12,
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//               );
//             }).toList(),
//             indicator: UnderlineTabIndicator(
//               borderSide: BorderSide(
//                 color: Colors.blue, 
//                 width: 4
//               )
//             ),
//           ),
//           body: Padding(
//             padding: EdgeInsets.fromLTRB(16, 16, 16, 30),
//             child: TabBarView(
//               children: distinctMonthAndYear.map((monthAndYear) {
// // REFERENSI DROPDOWN
//                 List<dynamic> transactions = dataTransaksi.where((transaction) {
//                   DateTime dateTime = DateTime.parse(transaction['tgl_transaksi']);
//                   var formatBulan = DateFormat.MMM();
//                   String namaBulan = formatBulan.format(dateTime);
//                   String monthAndYearTransaction = "$namaBulan ${dateTime.year.toString().substring(2)}";
//                   return monthAndYearTransaction == monthAndYear;
//                 }).toList();
//                 initializeDateFormatting('id_ID');
//                 Map<String, List<dynamic>> groupedTransactions = Map();
//                 transactions.forEach((transaction) {
//                   DateTime dateTime = DateTime.parse(transaction['tgl_transaksi']);
//                   String date = DateFormat('EEEE, dd MMMM yyyy', 'ID').format(dateTime);
//                   if (groupedTransactions.containsKey(date)) {
//                     groupedTransactions[date]!.add(transaction);
//                   } else {
//                     groupedTransactions[date] = [transaction];
//                   }
//                 });

//                 int PemasukanTotal = 0;
//                 int PengeluaranTotal = 0;

//                 for (int i = 0; i < transactions.length; i++) {
//                   String nilaiTransaksiString = transactions[i]['nominal'].toString();
//                   if (nilaiTransaksiString.isNotEmpty) {
//                     try {
//                       int nilaiTransaksi = int.parse(nilaiTransaksiString);
//                       if (transactions[i]['status'] == 'Pemasukan') {
//                         PemasukanTotal += nilaiTransaksi;
//                       } else {
//                         PengeluaranTotal += nilaiTransaksi;
//                       }
//                     } catch (e) {
//                       // Penanganan jika terjadi kesalahan saat mengonversinilai_transaksi ke integer
//                       print('Error parsing nilai_transaksi: $e');
//                     }
//                   }
//                 }

//                 return Column(
//                   children: <Widget>[
//                     // Box total pemasukan dan pengeluaran
//                     Card(
//                       elevation: 2.0,
//                       color: Colors.white,
//                       child: Row(
//                         children: <Widget>[
//                           Expanded(
//                             child: ListTile(
//                               leading: Container(
//                                 alignment: Alignment.bottomCenter,
//                                 width: 45,
//                                 child: Icon(
//                                   Icons.download,
//                                   color: Colors.green,
//                                   size: 40,
//                                 ),
//                               ),
//                               title: Text(
//                                 'Pemasukan',
//                                 style: TextStyle(
//                                   fontSize: 13,
//                                   fontWeight: FontWeight.bold
//                                 ),
//                               ),
//                               subtitle: Text(
//                                 '${rupiah.format(PemasukanTotal)}',
//                                 style: TextStyle(
//                                   fontSize: 15,
//                                 ),
//                               ),
//                             ),
//                           ),
//                           VerticalDivider(),
//                           Expanded(
//                             child: ListTile(
//                               leading: Container(
//                                 alignment: Alignment.bottomCenter,
//                                 width: 45,
//                                 child: Icon(
//                                   Icons.upload,
//                                   color: Colors.red,
//                                   size: 40,
//                                 ),
//                               ),
//                               title: Text(
//                                 'Pengeluaran',
//                                 style: TextStyle(
//                                   fontSize: 13,
//                                   fontWeight: FontWeight.bold),
//                               ),
//                               subtitle: Text(
//                                 '${rupiah.format(PengeluaranTotal)}',
//                                 style: TextStyle(
//                                   fontSize: 15,
//                                 ),
//                               ),
//                             ),
//                           ),
//                         ],
//                       )
//                     ),

//                     SizedBox(height: 20),
//                     Expanded(
//                       child: ListView.separated(
//                         itemCount: groupedTransactions.length,
//                         itemBuilder: (context, index) {
//                           String date = groupedTransactions.keys.elementAt(index);
//                           List<dynamic> transactions = groupedTransactions.values.elementAt(index);                       
//                           return Card(
//                             margin: EdgeInsets.symmetric(vertical: 2.0),
//                             elevation: 2,
//                             child: Column(
//                               crossAxisAlignment: CrossAxisAlignment.start,
//                               children: [
//                                 Container(
//                                   padding: EdgeInsets.all(8.0),                                 
//                                   child: Column(
//                                     children: [
//                                       ListTile(
//                                         title: Text(
//                                           date,
//                                           style: TextStyle(
//                                             fontWeight: FontWeight.bold,
//                                             fontSize: 14,
//                                           ),
//                                           textAlign: TextAlign.left,
//                                         ),
//                                       ),
//                                     ],
//                                   ),          
//                                 ),

//                                 VerticalDivider(),
//                                 ListView.separated(
//                                   separatorBuilder: (BuildContext context, int index) => Divider(),
//                                   shrinkWrap: true,
//                                   physics: NeverScrollableScrollPhysics(),
//                                   itemCount: transactions.length,
//                                   itemBuilder: (BuildContext context, int index) {
//                                     // Menampilkan data total pemasukan dan pengeluaran
//                                     return Padding(
//                                       padding: const EdgeInsets.all(2.0),
//                                       child: ListTile(
// // ONTAP UPDATE
//                                         onTap: () {
//                                           Navigator.push(
//                                             context,
//                                             MaterialPageRoute(
//                                               builder: (context) => editTransaksiForm(transactions[index])
//                                             ),
//                                           );
//                                         },       
//                                         subtitle: Row(
//                                           children: [
//                                             transactions[index]['status'] ==  'Pemasukan' ? 
//                                             Icon(
//                                               Icons.download,
//                                               color: Colors.green
//                                             ) : Icon(
//                                               Icons.upload,
//                                               color: Colors.red
//                                             ),
//                                             SizedBox(width: 20.0),
//                                             Expanded(
//                                               child: Column(
//                                                 crossAxisAlignment: CrossAxisAlignment.start,
//                                                 children: [
//                                                   Text(
//                                                     '${transactions[index]['kategori']}',
//                                                     style: TextStyle(
//                                                       fontSize: 14,
//                                                       fontWeight: FontWeight.bold,
//                                                       color: Colors.black
//                                                     ),
//                                                   ),
//                                                   SizedBox(height: 0.0),
//                                                   Text(
//                                                     '${transactions[index]['keterangan']}',
//                                                     style: TextStyle(
//                                                       fontSize: 13,
//                                                       color: Colors.black
//                                                     ),
//                                                   ),
//                                                 ],
//                                               ),
//                                             ),
//                                             SizedBox(width: 10.0),
//                                             Text(
//                                               '${rupiah.format(transactions[index]['nominal'])}',
//                                               style: TextStyle(
//                                                 fontSize: 14,
//                                                 fontWeight: FontWeight.bold,
//                                                 color: transactions[index]['status'] == 'Pemasukan' ? Colors.green : Colors.red
//                                               ),
//                                             ),
//                                           ],
//                                         ),
//                                       ),
//                                     );
//                                   },
//                                 ),
//                               ],
//                             ),
//                           );
//                         },
//                         separatorBuilder: (BuildContext context, int index) => Divider(),
//                       ),
//                     ),
//                   ],
//                 );
//               }).toList(),
//             ),
//           ),
//         ),
//       );
//     }
//   }
// }

// class editTransaksiForm extends StatefulWidget {
//   final dynamic transaction;

//   editTransaksiForm(this.transaction);

//   @override
//   _editTransaksiFormState createState() => _editTransaksiFormState();
// }

// class _editTransaksiFormState extends State<editTransaksiForm> {
//   TextEditingController _controllerNominal = TextEditingController();
//   TextEditingController _controllerKeterangan = TextEditingController();
//   late String _newValue;
//   List<String> _kategori = [
//     'Pemasukan',
//     'Pengeluaran',
//   ];

//   @override
//   void initState() {
//     super.initState();
//     _controllerNominal.text = widget.transaction['nominal'].toString();
//     _controllerKeterangan.text = widget.transaction['keterangan'];
//     _newValue = widget.transaction['status'];
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Edit Transaksi'),
//         actions: [
//           IconButton(
//             icon: Icon(Icons.delete),
//             onPressed: () {
//               showDialog(
//                 context: context,
//                 builder: (BuildContext context) {
//                   return AlertDialog(
//                     title: Text('Hapus Transaksi'),
//                     content: Text('Apakah Anda yakin ingin menghapus transaksi ini?'),
//                     actions: [
//                       TextButton(
//                         child: Text('Tidak'),
//                         onPressed: () {
//                           Navigator.pop(context);
//                         },
//                       ),
//                       TextButton(
//                         child: Text('Ya'),
//                         onPressed: () async {
//                           // hapus transaksi
//                           String idTransaksi = widget.transaction['no_transaksi'];
//                           final response = await http.get(Uri.parse('http://apkeu2023.000webhostapp.com/delete.php?no_transaksi=$idTransaksi'));
//                           if (response.statusCode == 200) {
//                             Navigator.pushAndRemoveUntil(
//                               context,
//                               MaterialPageRoute(builder: (context) => editTesting()),
//                               (route) => false,
//                             );
//                           } else {
//                             throw Exception('Failed to delete transaction');
//                           }
//                         },
//                       ),
//                     ],
//                   );
//                 }
//               );
//             },
//           ),
//         ],
//       ),
//       body: Container(
//         padding: EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.stretch,
//           children: [
//             Text(
//               'Kategori',
//               style: TextStyle(
//                 fontSize: 18.0,
//                 fontWeight: FontWeight.bold,
//               ),
//             ),
//             DropdownButton<String>(
//               value: _newValue,
//               items: _kategori.map((String value) {
//                 return DropdownMenuItem<String>(
//                   value: value,
//                   child: Text(value),
//                 );
//               }).toList(),
//               onChanged: (String? newValue) {
//                 setState(() {
//                   _newValue = newValue!;
//                 });
//               },
//             ),
//             SizedBox(height: 20.0),
//             Text(
//               'Nominal',
//               style: TextStyle(
//                 fontSize: 18.0,
//                 fontWeight: FontWeight.bold,
//               ),
//             ),
//             TextFormField(
//               controller: _controllerNominal,
//               keyboardType: TextInputType.number,
//               decoration: InputDecoration(
//                 hintText: 'Masukkan nominal',
//               ),
//               validator: (value) {
//                 if (value!.isEmpty) {
//                   return 'Mohon masukkan nominal';
//                 }
//                 return null;
//               },
//             ),
//             SizedBox(height: 20.0),
//             Text(
//               'Keterangan',
//               style: TextStyle(
//                 fontSize: 18.0,
//                 fontWeight: FontWeight.bold,
//               ),
//             ),
//             TextFormField(
//               controller: _controllerKeterangan,
//               decoration: InputDecoration(
//                 hintText: 'Masukkan keterangan',
//               ),
//               validator: (value) {
//                 if (value!.isEmpty) {
//                   return 'Mohon masukkan keterangan';
//                 }
//                 return null;
//               },
//             ),
//             SizedBox(height: 20.0),
//             ElevatedButton(
//               onPressed: () async {
//                 // edit transaksi
//                 String idTransaksi = widget.transaction['no_transaksi'];
//                 String nominal = _controllerNominal.text;
//                 String keterangan = _controllerKeterangan.text;
//                 String status = _newValue;
//                 final response = await http.get(Uri.parse('http://apkeu2023.000webhostapp.com/edit.php?no_transaksi=$idTransaksi&nominal=$nominal&keterangan=$keterangan&status=$status'));
//                 if (response.statusCode == 200) {
//                   Navigator.pushAndRemoveUntil(
//                     context,
//                     MaterialPageRoute(builder: (context) => editTesting()),
//                     (route) => false,
//                   );
//                 } else {
//                   throw Exception('Failed to edit transaction');
//                 }
//               },
//               child: Text('Simpan'),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
