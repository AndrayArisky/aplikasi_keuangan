// import 'dart:convert';
// import 'package:aplikasi_keuangan/adminPages/transaksi/inputAdmin.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:intl/date_symbol_data_local.dart';
// import 'package:intl/intl.dart';
// import 'package:http/http.dart' as http;

// class transaksiAdmin extends StatefulWidget {
//   @override
//   _transaksiAdminState createState() => _transaksiAdminState();
// }

// class _transaksiAdminState extends State<transaksiAdmin> {
//   List<dynamic> dataTransaksi = [];
//   List<dynamic> sortedDates = [];
//   List<String> distinctMonthAndYear = [];
//   List<dynamic> searchResults = [];

//   TextEditingController search = TextEditingController();

//   void searchData(String keyword) {
//     setState(() {
//       searchResults = dataTransaksi.where((transaction) {
//         String kategori = transaction['kategori'];
//         String keterangan = transaction['keterangan'];
//         return kategori.toLowerCase().contains(keyword.toLowerCase()) ||
//           keterangan.toLowerCase().contains(keyword.toLowerCase());
//       }).toList();
//     });
//   }

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
//     DateTime now = DateTime.now(); // ambil waktu sekarang
//     var formatBulan = DateFormat.MMM(); // ubah nama bulan menjadi bahasa Indonesia
//     String namaBulan = formatBulan.format(now);
//     var formatTahun = DateFormat('yy'); // buat format untuk menampilkan tahun dalam 2 digit
//     String tahun = formatTahun.format(now);
//     String monthAndYear = "$namaBulan $tahun";

//     for (var i = 0; i < sortedDates.length; i++) {
//       DateTime dateTime = sortedDates[i];
//       var formatBulan = DateFormat.MMM(); // tambahkan baris kode berikut untuk mengubah nama bulan
//       String namaBulan = formatBulan.format(dateTime);
//       String monthAndYear = "$namaBulan ${dateTime.year.toString().substring(2)}"; // format string
//       if (!distinctMonthAndYear.contains(monthAndYear)) {
//         bool bulanPunyaData = false; // tambahkan baris kode berikut untuk mengecek apakah bulan ini memiliki data atau tidak
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
//     List<String> distinctMonthAndYear = _getDistinctMonthAndYear();
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
//                     Column(
//                       children: <Widget>[
//                         Material(
//                           elevation: 2,
//                           borderRadius: BorderRadius.all(
//                             Radius.circular(30)
//                           ),
//                           child: TextField(
//                             controller: search,
//                             onChanged: searchData,
//                             cursorColor: Colors.blue,
//                             decoration: InputDecoration(
//                               hintText: 'Cari Transaksi',
//                               hintStyle: TextStyle(
//                                 color: Colors.grey,
//                                 fontSize: 12
//                               ),
//                               prefixIcon: Padding(
//                                 padding: const EdgeInsets.only(left: 5),
//                                 child: Material(
//                                   borderRadius: BorderRadius.all(
//                                     Radius.circular(30)
//                                   ),
//                                   child: Icon(
//                                     Icons.search,
//                                     //color: Colors.black,
//                                   ),
//                                 ),
//                               ),
//                               //border: InputBorder.none,
//                               border: OutlineInputBorder(
//                                 borderRadius: BorderRadius.all(
//                                   Radius.circular(30)
//                                 ),
//                                 borderSide: BorderSide(width: 0.5),
//                               ),
//                               contentPadding: EdgeInsets.symmetric(
//                                 horizontal: 30,
//                                 vertical: 13
//                               ),
//                             ),
//                           ),
//                         )
//                       ],
//                     ),
//                     SizedBox(height: 10,),
//                     // Box total pemasukan dan pengeluaran
//                     Card(
//                       elevation: 2.0,
//                       color: Colors.white,
//                       child: Row(
//                         children: <Widget>[
//                           Expanded(
//                             child: ListTile(
//                               leading: Container(
//                                 alignment: Alignment.center,
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
//                                   fontSize: MediaQuery.of(context).size.width * 0.03,
//                                   fontWeight: FontWeight.bold
//                                 ),
//                               ),
//                               subtitle: Text(
//                                 '${rupiah.format(PemasukanTotal)}',
//                                 style: TextStyle(
//                                   fontSize: MediaQuery.of(context).size.width * 0.03,
//                                 ),
//                               ),
//                             ),
//                           ),
//                           VerticalDivider(),
//                           Expanded(
//                             child: ListTile(
//                               leading: Container(
//                                 alignment: Alignment.center,
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
//                                   fontSize: MediaQuery.of(context).size.width * 0.03,
//                                   fontWeight: FontWeight.bold),
//                               ),
//                               subtitle: Text(
//                                 '${rupiah.format(PengeluaranTotal)}',
//                                 style: TextStyle(
//                                   fontSize: MediaQuery.of(context).size.width * 0.03,
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
//                           if (search.text.isNotEmpty) {
//                             transactions = transactions.where((transaction) {
//                               String kategori = transaction['kategori'];
//                               String keterangan = transaction['keterangan'];
//                               return kategori.toLowerCase().contains(search.text.toLowerCase()) ||
//                                 keterangan.toLowerCase().contains(search.text.toLowerCase());
//                             }).toList();
//                           }                       
//                           return Card(
//                             margin: EdgeInsets.symmetric(vertical: 5.0),
//                             elevation: 2,
//                             child: Column(
//                               crossAxisAlignment: CrossAxisAlignment.start,
//                               children: [
//                                 Container(
//                                   padding: EdgeInsets.all(1.0),                                 
//                                   child: Column(
//                                     children: [
//                                       ListTile(
//                                         title: Text(
//                                           date,
//                                           style: TextStyle(
//                                             fontWeight: FontWeight.bold,
//                                             fontSize: 14,
//                                             color: Color.fromARGB(255, 37, 22, 179)
//                                           ),
//                                           textAlign: TextAlign.left,
//                                         ),
//                                       ),
//                                     ],
//                                   ),          
//                                 ),

//                                 //VerticalDivider(),
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
//                                           // Navigator.push(
//                                           //   context,
//                                           //   MaterialPageRoute(
//                                           //     builder: (context) => EditTransaksi(level: 'admin',)
//                                           //   ),
//                                           // );
                                          
//                                           // Navigator.of(context).popAndPushNamed(
//                                           //   '/editTransaksi',
//                                           //   arguments: [
//                                           //     transactions[index]['id_user'],
//                                           //     transactions[index]['kategori'],
//                                           //     transactions[index]['tgl_transaksi'],
//                                           //     transactions[index]['nominal'],
//                                           //     transactions[index]['keterangan'],
//                                           //     transactions[index]['status'],
//                                           //   ]
//                                           // );
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
//                                                     '${transactions[index]['keterangan']}'
//                                                   ),
//                                                 ],
//                                               ),
//                                             ),
//                                             Text(
//                                               'Rp. ${transactions[index]['nominal']}',
//                                               style: TextStyle(
//                                                 fontSize: 14,
//                                                 fontWeight: FontWeight.bold,
//                                                 color: Colors.black
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
//                         separatorBuilder: (context, index) {
//                           return Divider(
//                             height: 0,
//                             thickness: 1,
//                           );
//                         },
//                       ),
//                     ),
//                   ],
//                 );
//               }).toList(),
//             ),
//           ),
          
//           // floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
//           // floatingActionButton: FloatingActionButton(
//           //     backgroundColor: Colors.blue,
//           //     child: Icon(Icons.add_box, color: Colors.white),
//           //     onPressed: () {
//           //       Navigator.pushReplacement(
//           //         context,
//           //         MaterialPageRoute(builder: (context) => inputAdmin(level: 'admin',))
//           //       );
//           //     }
//           // ),

//         ),
//       );
//     }
//   }
// }

