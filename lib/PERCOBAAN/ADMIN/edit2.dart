// import 'dart:convert';
// import 'dart:io';
// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';
// import 'package:http/http.dart' as http;
// import 'package:intl/date_symbol_data_local.dart';
// import 'package:path_provider/path_provider.dart';
// import 'package:pdf/widgets.dart' as pw;
// import 'package:printing/printing.dart';
// import 'package:flutter/services.dart' show rootBundle;
// import 'package:pdf/pdf.dart';

// class posisiKeuangan extends StatefulWidget {
//   @override
//   _posisiKeuanganState createState() => _posisiKeuanganState();
// }

// class _posisiKeuanganState extends State<posisiKeuangan>
//     with SingleTickerProviderStateMixin {
//   List<dynamic> dataTransaksi = [];
//   List<dynamic> sortedDates = [];
//   List<String> distinctMonthAndYear = [];

//   Map<String, int> totalEkuitas = {
//     'Saldo Laba (Defisit)': 0,
//     'Modal': 0,
//   };

//   int saldoLabaBulanan = 0;
//   int modalBulanDepan = 0;

//   @override
//   void initState() {
//     super.initState();
//     fetchData();
//   }

//   void fetchData() async {
//     final response = await http.get(Uri.parse('http://apkeu2023.000webhostapp.com/getTransaksi.php'));
//     if (response.statusCode == 200) {
//       setState(() {
//         dataTransaksi = json.decode(response.body);
//         sortedDates = [];
//         for (var i = 0; i < dataTransaksi.length; i++) {
//           String tglTransaksi = dataTransaksi[i]['tgl_transaksi'];
//           DateTime dateTime = DateTime.parse(tglTransaksi);
//           sortedDates.add(dateTime);
//         }
//         sortedDates.sort((a, b) => a.compareTo(b));
//         if (sortedDates != null && sortedDates.isNotEmpty) {
//           distinctMonthAndYear = _getDistinctMonthAndYear();
//         }
//         _hitungLabaBulanan();
//       });
//     } else {
//       throw Exception('Failed to load data');
//     }
//   }

// void _hitungLabaBulanan() {
//   saldoLabaBulanan = 0;
//   modalBulanDepan = 0;

//   DateTime now = DateTime.now();
//   var formatBulan = DateFormat.MMM();
//   String namaBulanSekarang = formatBulan.format(now);
//   String namaBulanDepan = formatBulan.format(now.add(Duration(days: 30)));

//   for (var i = 0; i < dataTransaksi.length; i++) {
//     if (dataTransaksi[i] is Map<String, dynamic>) {
//       String tglTransaksi = dataTransaksi[i]['tgl_transaksi'];
//       DateTime dateTime = DateTime.parse(tglTransaksi);
//       var formatBulan = DateFormat.MMM();
//       String namaBulan = formatBulan.format(dateTime);
//       String monthAndYearTransaction =
//           "$namaBulan ${dateTime.year.toString().substring(2)}";

//       int nilaiTransaksi = int.parse(dataTransaksi[i]['nominal'].toString());

//       if (monthAndYearTransaction == namaBulanSekarang) {
//         saldoLabaBulanan += nilaiTransaksi;
//       } else if (monthAndYearTransaction == namaBulanDepan) {
//         modalBulanDepan += nilaiTransaksi;
//       }
//     }
//   }

//   // Menghitung laba setelah pajak
//   double pajakPersentase = 0.025;
//   double pajak = saldoLabaBulanan * pajakPersentase;
//   double labaSetelahPajak = saldoLabaBulanan - pajak;

//   // Menambahkan laba setelah pajak ke dalam akun "Saldo Laba"
//   totalEkuitas['Saldo Laba (Defisit)'] = labaSetelahPajak.toInt();

//   // Menambahkan modal dari transaksi
//   if (totalEkuitas.containsKey('Modal')) {
//     // Jika akun "Modal" sudah ada, tambahkan nominal transaksi ke akun yang sudah ada
//     totalEkuitas['Modal'] = (totalEkuitas['Modal'] ?? 0) + modalBulanDepan;
//   } else {
//     // Jika akun "Modal" belum ada, tambahkan akun baru ke grup ekuitas
//     totalEkuitas['Modal'] = modalBulanDepan;
//   }
// }


//   List<String> _getDistinctMonthAndYear() {
//     List<String> distinctMonthAndYear = [];
//     initializeDateFormatting('id_ID');
//     DateTime now = DateTime.now();
//     var formatBulan = DateFormat.MMM();
//     String namaBulan = formatBulan.format(now);
//     var formatTahun = DateFormat('yy');
//     String tahun = formatTahun.format(now);
//     String monthAndYear = "$namaBulan $tahun";
//     for (var i = 0; i < sortedDates.length; i++) {
//       DateTime dateTime = sortedDates[i];
//       var formatBulan = DateFormat.MMM();
//       String namaBulan = formatBulan.format(dateTime);
//       String monthAndYear = "$namaBulan ${dateTime.year.toString().substring(2)}";
//       if (!distinctMonthAndYear.contains(monthAndYear)) {
//         bool bulanPunyaData = false;
//         for (var j = 0; j < dataTransaksi.length; j++) {
//           String tglTransaksi = dataTransaksi[j]['tgl_transaksi'];
//           DateTime dateTime = DateTime.parse(tglTransaksi);
//           var formatBulan = DateFormat.MMM();
//           String namaBulan = formatBulan.format(dateTime);
//           String monthAndYearTransaction =
//               "$namaBulan ${dateTime.year.toString().substring(2)}";
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
//     decimalDigits: 0,
//   );

//   Map<String, int> totalTransactions = {};

//   @override
//   Widget build(BuildContext context) {
//     if (distinctMonthAndYear.isEmpty) {
//       return Scaffold(
//         appBar: AppBar(
//           title: Text('Laporan Laba Rugi'),
//           actions: [
//             IconButton(
//               icon: Icon(Icons.picture_as_pdf_rounded),
//               onPressed: () {
//                 //cetakPdf();
//               },
//             ),
//           ],
//         ),
//         body: Center(
//           child: Text(
//             'Membaca laporan Laba Rugi',
//             textAlign: TextAlign.center,
//           ),
//         ),
//       );
//     } else {
//       int initialIndex = DateTime.now().month + 1;
//       if (initialIndex >= distinctMonthAndYear.length) {
//         initialIndex = distinctMonthAndYear.length - 1;
//       }
//       return DefaultTabController(
//         length: distinctMonthAndYear.length,
//         initialIndex: initialIndex,
//         child: Scaffold(
//           appBar: AppBar(
//             title: Text('Laporan Laba Rugi'),
//             actions: [
//               IconButton(
//                 icon: Icon(Icons.picture_as_pdf_rounded),
//                 onPressed: () {
//                   //cetakPdf();
//                 },
//               ),
//             ],
//           ),
//           body: Column(
//             children: [
//               Container(
//                 child: Align(
//                   alignment: Alignment.centerLeft,
//                   child: TabBar(
//                     isScrollable: true,
//                     labelColor: Colors.blue,
//                     tabs: distinctMonthAndYear.map((monthAndYear) {
//                       return Tab(
//                         child: Text(
//                           monthAndYear,
//                           style: TextStyle(
//                             fontSize: 12,
//                             fontWeight: FontWeight.bold,
//                           ),
//                         ),
//                       );
//                     }).toList(),
//                     indicator: UnderlineTabIndicator(
//                         borderSide: BorderSide(color: Colors.blue, width: 4)),
//                   ),
//                 ),
//               ),
//               Expanded(
//                 child: TabBarView(
//                   children: distinctMonthAndYear.map((monthAndYear) {
//                     List<dynamic> transactions = dataTransaksi.where((transaction) {
//                       DateTime dateTime = DateTime.parse(transaction['tgl_transaksi']);
//                       var formatBulan = DateFormat.MMM();
//                       String namaBulan = formatBulan.format(dateTime);
//                       String monthAndYearTransaction = "$namaBulan ${dateTime.year.toString().substring(2)}";
//                       return monthAndYearTransaction == monthAndYear;
//                     }).toList();

//                     Map<String, int> totalGrupAset = {};
//                     Map<String, int> totalAsetLancar = {};
//                     Map<String, int> totalAsetTetap = {};
//                     Map<String, int> totalAkumulasiPenyusutan = {};

//                     Map<String, int> totalGrupLiabilitas = {};
//                     Map<String, int> totalJangkaPendek = {};
//                     Map<String, int> totalJangkaPanjang = {};
//                     Map<String, int> totalEkuitas = {};

//                     transactions.forEach((transaction) {
//                       String namaTransaksi = transaction['kategori'];
//                       int nilaiTransaksi = int.parse(transaction['nominal'].toString());
//                       String grup = transaction['grup'];

//                       if (grup.contains('Aset')) {
//                         totalGrupAset[grup] = (totalGrupAset[grup] ?? 0) + nilaiTransaksi;
//                       } else if (grup.contains('Liabilitas (Kewajiban)')) {
//                         totalGrupLiabilitas[grup] = (totalGrupLiabilitas[grup] ?? 0) + nilaiTransaksi;
//                       }

//                       if (grup == 'Aset Lancar') {
//                         totalAsetLancar[namaTransaksi] = (totalAsetLancar[namaTransaksi] ?? 0) + nilaiTransaksi;
//                       } else if (grup == 'Aset Tetap') {
//                         totalAsetTetap[namaTransaksi] = (totalAsetTetap[namaTransaksi] ?? 0) + nilaiTransaksi;
//                       } else if (grup == 'Akumulasi Penyusutan') {
//                         totalAkumulasiPenyusutan[namaTransaksi] = (totalAkumulasiPenyusutan[namaTransaksi] ?? 0) + nilaiTransaksi;
//                       } else if (grup == 'Liabilitas Jangka Pendek') {
//                         totalJangkaPendek[namaTransaksi] = (totalJangkaPendek[namaTransaksi] ?? 0) + nilaiTransaksi;
//                       } else if (grup == 'Liabilitas Jangka Panjang') {
//                         totalJangkaPanjang[namaTransaksi] = (totalJangkaPanjang[namaTransaksi] ?? 0) + nilaiTransaksi;
//                       } else if (grup == 'Ekuitas') {
//                         totalEkuitas[namaTransaksi] = (totalEkuitas[namaTransaksi] ?? 0) + nilaiTransaksi;
//                       }
//                     });

//                     int saldoLabaBulananNilai = (monthAndYear == distinctMonthAndYear.first) ? saldoLabaBulanan : 0;
//                     int modalBulanDepanNilai = (monthAndYear == distinctMonthAndYear.last) ? modalBulanDepan : 0;

//                     return Padding(
//                       padding: EdgeInsets.all(20),
//                       child: SingleChildScrollView(
//                         child: Column(
//                           crossAxisAlignment: CrossAxisAlignment.stretch,
//                           children: <Widget>[
//                             _buildJudulRow('Aset'),
//                             _buildItemRow('Aset Lancar'),
//                             SizedBox(height: 10.0),
//                             ...totalAsetLancar.entries.map((entry) => _buildAkunRow(entry.key, entry.value.toString())).toList(),
//                             Divider(),
//                             _buildTotalRow('Total Aset Lancar',
//                                 '${rupiah.format(totalAsetLancar.values.fold(0, (a, b) => a + b))}'),
//                             Divider(),
//                             SizedBox(height: 20.0),
//                             _buildItemRow('Aset Tetap'),
//                             SizedBox(height: 10.0),
//                             ...totalAsetTetap.entries.map((entry) => _buildAkunRow(entry.key, entry.value.toString())).toList(),
//                             Divider(),
//                             _buildTotalRow('Total Aset Tetap', '${rupiah.format(totalAsetTetap.values.fold(0, (a, b) => a + b))}'),
//                             Divider(),
//                             SizedBox(height: 20.0),
//                             _buildItemRow('Akumulasi Penyusutan'),
//                             SizedBox(height: 10.0),
//                             ...totalAkumulasiPenyusutan.entries.map((entry) => _buildAkunRow(entry.key, entry.value.toString())).toList(),
//                             Divider(),
//                             _buildTotalRow('Total Akumulasi Penyusutan', '${rupiah.format(totalAkumulasiPenyusutan.values.fold(0, (a, b) => a + b))}'),
//                             Divider(),
//                             _buildTotalRow('Total Aset','${rupiah.format(totalAsetLancar.values.fold(0, (a, b) => a + b) + totalAsetTetap.values.fold(0, (a, b) => a + b) + totalAkumulasiPenyusutan.values.fold(0, (a, b) => a + b))}'),
//                             Divider(),
//                             SizedBox(height: 30.0),

//                             _buildJudulRow('Liabilitas (Kewajiban)'),
//                             _buildItemRow('Liabilitas Jangka Pendek'),
//                             SizedBox(height: 10.0),
//                             ...totalJangkaPendek.entries.map((entry) => _buildAkunRow(entry.key, entry.value.toString())).toList(),
//                             Divider(),
//                             _buildTotalRow('Total Liabilitas Jangka Pendek',
//                                 '${rupiah.format(totalJangkaPendek.values.fold(0, (a, b) => a + b))}'),
//                             Divider(),
//                             SizedBox(height: 20.0),
//                             _buildItemRow('Liabilitas Jangka Panjang'),
//                             SizedBox(height: 10.0),
//                             ...totalJangkaPanjang.entries.map((entry) => _buildAkunRow(entry.key, entry.value.toString())).toList(),
//                             Divider(),
//                             _buildTotalRow('Total Liabilitas Jangka Panjang', '${rupiah.format(totalJangkaPanjang.values.fold(0, (a, b) => a + b))}'),
//                             Divider(),
//                             SizedBox(height: 20.0),
//                             _buildItemRow('Ekuitas'),
//                             SizedBox(height: 10.0),
//                             ...totalEkuitas.entries.map((entry) => _buildAkunRow(entry.key, entry.value.toString())).toList(),  
//                             Divider(),
//                             _buildTotalRow('Total Ekuitas', '${rupiah.format(totalEkuitas.values.fold(0, (a, b) => a + b))}'),
//                             Divider(),
//                             _buildTotalRow('Total Liabilitas (Kewajiban)','${rupiah.format(totalJangkaPendek.values.fold(0, (a, b) => a + b) + totalJangkaPanjang.values.fold(0, (a, b) => a + b) + totalEkuitas.values.fold(0, (a, b) => a + b))}'),
//                             Divider(),
//                             SizedBox(height: 30.0),
//                           ],
//                         ),
//                       ),
//                     );
//                   }).toList(),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       );
//     }
//   }

//   Widget _buildJudulRow(String title) {
//     return Text(
//       title,
//       style: TextStyle(
//         fontWeight: FontWeight.bold,
//         fontSize: 16.0,
//         color: Color.fromARGB(255, 37, 22, 179),
//       ),
//     );
//   }

//   Widget _buildItemRow(String title) {
//     return Text(
//       title,
//       style: TextStyle(
//         fontWeight: FontWeight.bold,
//         fontSize: 14.0,
//       ),
//     );
//   }

//   Widget _buildAkunRow(String namaAkun, String nilai) {
//     return Row(
//       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//       children: [
//         Text(namaAkun),
//         Text(
//           nilai,
//           style: TextStyle(
//             fontWeight: FontWeight.bold,
//           ),
//         ),
//       ],
//     );
//   }

//   Widget _buildTotalRow(String title, String nilai) {
//     return Row(
//       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//       children: [
//         Text(
//           title,
//           style: TextStyle(
//             fontWeight: FontWeight.bold,
//             fontSize: 14.0,
//           ),
//         ),
//         Text(
//           nilai,
//           style: TextStyle(
//             fontWeight: FontWeight.bold,
//             fontSize: 14.0,
//           ),
//         ),
//       ],
//     );
//   }
// }

