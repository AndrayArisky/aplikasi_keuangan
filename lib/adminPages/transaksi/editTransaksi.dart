// import 'dart:convert';
// import 'package:aplikasi_keuangan/adminPages/adminPage.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:intl/date_symbol_data_local.dart';
// import 'package:intl/intl.dart';
// import 'package:http/http.dart' as http;

// class Tipe {
//   final String title;
//   final String type;

//   Tipe({required this.title, required this.type});
// }

// class EditTransaksi extends StatefulWidget {
//   final id_user;
//   EditTransaksi({Key? key, required this.id_user}) : super(key: key);

//   @override
//   EditTransaksiState createState() => EditTransaksiState();
// }

// class EditTransaksiState extends State<EditTransaksi> {
//   List<Tipe> pemasukanData = [
//     Tipe(title: 'Pendapatan Jasa', type: 'Pemasukan'),
//     Tipe(title: 'Pendapatan Giveaway', type: 'Pemasukan'),
//     Tipe(title: 'Dapat Dari Baim Wong', type: 'Pemasukan'),
//   ];
//   List<Tipe> pengeluaranData = [
//     Tipe(title: 'Harga Pokok Penjualan', type: 'Pengeluaran'),
//     Tipe(title: 'Beban Perlengkapan/ATK', type: 'Pengeluaran'),
//     Tipe(title: 'Beban Gaji Karyawan', type: 'Pengeluaran'),
//     Tipe(title: 'Beban Sewa', type: 'Pengeluaran'),
//     Tipe(title: 'Beban Listrik', type: 'Pengeluaran'),
//     Tipe(title: 'Beban Air', type: 'Pengeluaran'),
//     Tipe(title: 'Beban Lain-lain', type: 'Pengeluaran'),
//   ];

//   int? selected = -1;
//   int selectedIndex = 2;
//   String status = 'Pengeluaran';
//   DateTime selectedDate = DateTime.now();
//   String _formatNominal = '';
//   late dynamic id_user;
//   String? selectedOption;

//   List<dynamic> dataTransaksi = [];
//   List<dynamic> sortedDates = [];
//   List<String> distinctMonthAndYear = [];

//   TextEditingController kategori = TextEditingController();
//   TextEditingController nominal = TextEditingController();
//   TextEditingController keterangan = TextEditingController();

//   @override
//   void initState() {
//     super.initState();
//     //fetchData();
//     kategori.text = widget.id_user.kategori;
//     nominal.text = widget.id_user.nominal;
//     keterangan.text = widget.id_user.keterangan;
//   }

//   // void fetchData() async {
//   //   final response = await http.get(Uri.parse('http://apkeu2023.000webhostapp.com/getTransaksi.php?'));
//   //   Map<String, dynamic> transaksi = await (widget.no_transaksi['no_transaksi']);
//   //   if (response.statusCode == 200) {
//   //     setState(() {
//   //       // dataTransaksi = json.decode(response.body);
//   //       // // tambahkan setState pada sortedDates
//   //       // sortedDates = [];
//   //       // for (var i = 0; i < dataTransaksi.length; i++) {
//   //       //   String tglTransaksi = dataTransaksi[i]['tgl_transaksi'];
//   //       //   DateTime dateTime = DateTime.parse(tglTransaksi);
//   //       //   sortedDates.add(dateTime);
//   //       //   print('sortedDates : $sortedDates');
//   //       // }
//   //       // sortedDates.sort((a, b) => a.compareTo(b));
//   //       // if (sortedDates != null && sortedDates.isNotEmpty) {
//   //       //   distinctMonthAndYear = _getDistinctMonthAndYear();
//   //       //   print('distinctMonthAndYear : $distinctMonthAndYear');
//   //       //}
//   //     status = transaksi['status'];
//   //     selectedOption = transaksi['kategori'];
//   //     kategori.text = transaksi['kategori'];
//   //     nominal.text = transaksi['nominal'];
//   //     keterangan.text = transaksi['keterangan'];
//   //     selectedDate = DateTime.parse(transaksi['tgl_transaksi']);
//   //     });
//   //   } else {
//   //     throw Exception('Failed to load data');
//   //   }
//   // }

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

//   void updateTransaksi(String no_transaksi, Map<String, String> updatedData) async {
//     var url = Uri.parse('http://apkeu2023.000webhostapp.com/update.php');
//     var body = {
//       'no_transaksi': no_transaksi,
//       'updated_data': json.encode(updatedData),
//     };

//     var response = await http.post(url, body: body);
//     print('Response status: ${response.statusCode}');
//     print('Response body: ${response.body}');
//     print('ID USER : ${widget.id_user}, selectedDate $selectedDate');

//     if (response.statusCode == 200) {
//       final result = json.decode(response.body);
//       if (result['message'] == 'Data berhasil disimpan') {
//         showDialog(
//           context: context,
//           builder: (BuildContext context) {
//             return AlertDialog(
//               title: Text("Data berhasil disimpan!"),
//               content: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 mainAxisSize: MainAxisSize.min,
//               ),
//               actions: <Widget>[
//                 ElevatedButton(
//                   child: Text("OK"),
//                   onPressed: () {
//                     Navigator.pushReplacement(
//                       context,
//                       MaterialPageRoute(
//                           builder: (context) => adminPage(id_user: 11)),
//                     );
//                   },
//                 )
//               ],
//             );
//           },
//         );
//       } else {
//         showDialog(
//           context: context,
//           builder: (BuildContext context) {
//             return AlertDialog(
//               title: Text("Gagal menyimpan data!"),
//               content: Text("Pastikan data yang anda input sudah benar!"),
//               actions: <Widget>[
//                 ElevatedButton(
//                   child: Text("OK"),
//                   onPressed: () {
//                     Navigator.of(context).pop();
//                   },
//                 )
//               ],
//             );
//           },
//         );
//       }
//     }
//   }

//   void onChanged(int? value) {
//     setState(() {
//       this.selected = value;
//     });
//   }

//   void formatNominal(String value) {
//     if (value.isEmpty) {
//       setState(() {
//         _formatNominal = '';
//       });
//       return;
//     }

//     final numberFormat = NumberFormat.simpleCurrency(locale: 'id_ID');
//     try {
//       final amount = double.parse(value);
//       setState(() {
//         _formatNominal = numberFormat.format(amount);
//       });
//     } catch (e) {
//       setState(() {
//         _formatNominal = '';
//       });
//     }
//   }

//   void addExpense() {
//     setState(() {
//       status = 'Pengeluaran';
//       selectedIndex = 2;
//       kategori.clear();
//     });
//   }

//   void addIncome() {
//     setState(() {
//       status = 'Pemasukan';
//       selectedIndex = 1;
//       kategori.clear();
//     });
//   }

//   void _showModalBottomSheet(List<Tipe> data) {
//     showModalBottomSheet(
//       context: context,
//       builder: (BuildContext context) {
//         return Container(
//           padding: EdgeInsets.all(16.0),
//           child: Column(
//             mainAxisSize: MainAxisSize.min,
//             crossAxisAlignment: CrossAxisAlignment.stretch,
//             children: [
//               ListView.builder(
//                 shrinkWrap: true,
//                 itemCount: data.length,
//                 itemBuilder: (BuildContext context, int index) {
//                   Tipe transaction = data[index];
//                   return ListTile(
//                     title: Text(transaction.title),
//                     onTap: () {
//                       setState(() {
//                         selectedOption = transaction.title;
//                         kategori.text = transaction.title;
//                       });
//                       Navigator.pop(context);
//                     },
//                   );
//                 },
//               ),
//             ],
//           ),
//         );
//       },
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Update Data Transaksi'),
//         actions: [
//           IconButton(
//             icon: Icon(Icons.delete),
//             onPressed: () {
//               showDialog(
//                 context: context,
//                 builder: (BuildContext context) {
//                   return AlertDialog(
//                     title: Text('Hapus Transaksi'),
//                     content: Text('Yakin ingin menghapus transaksi?'),
//                     actions: <Widget>[
//                       ElevatedButton(
//                         onPressed: () {
//                           Navigator.of(context).pop();
//                         },
//                         child: Text('Batal'),
//                       ),
//                       ElevatedButton(
//                         onPressed: () {
//                           Navigator.of(context).pop();
//                         },
//                         child: Text('Hapus'),
//                       )
//                     ],
//                   );
//                 },
//               );
//             },
//           ),
//         ],
//       ),
//       body: Container(
//         padding: EdgeInsets.only(top: 35, right: 20, left: 20, bottom: 20),
//         child: Column(
//           children: <Widget>[
//             Row(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: <Widget>[
//                 Expanded(
//                   child: ElevatedButton(
//                     style: ElevatedButton.styleFrom(
//                       foregroundColor: Colors.white,
//                       backgroundColor:
//                           selectedIndex == 2 ? Colors.red : Colors.grey,
//                       shape: RoundedRectangleBorder(
//                           borderRadius: BorderRadius.zero),
//                     ),
//                     child: Text(
//                       "PENGELUARAN",
//                       style: TextStyle(fontSize: 15),
//                     ),
//                     onPressed: () {
//                       addExpense();
//                       setState(() {
//                         selectedIndex = 2;
//                         status = 'Pengeluaran';
//                       });
//                     },
//                   ),
//                 ),
//                 Expanded(
//                   child: ElevatedButton(
//                     style: ElevatedButton.styleFrom(
//                       foregroundColor: Colors.white,
//                       backgroundColor:
//                           selectedIndex == 1 ? Colors.green : Colors.grey,
//                       shape: RoundedRectangleBorder(
//                           borderRadius: BorderRadius.zero),
//                     ),
//                     child: Text(
//                       "PEMASUKAN",
//                       style: TextStyle(
//                         fontSize: 15,
//                       ),
//                     ),
//                     onPressed: () {
//                       addIncome();
//                       setState(() {
//                         selectedIndex = 1;
//                         status = 'Pemasukan';
//                       });
//                     },
//                   ),
//                 ),
//               ],
//             ),
//             SizedBox(height: 10.0),
//             if (status == 'Pengeluaran')
//               TextField(
//                 controller: kategori,
//                 decoration: InputDecoration(
//                   icon: Icon(Icons.category_outlined),
//                   labelText: "Kategori $status",
//                   suffixIcon: IconButton(
//                     onPressed: () {
//                       _showModalBottomSheet(pengeluaranData);
//                     },
//                     icon: Icon(Icons.add),
//                   ),
//                 ),
//               ),
//             if (status == 'Pemasukan')
//               TextField(
//                 controller: kategori,
//                 decoration: InputDecoration(
//                   icon: Icon(Icons.category_outlined),
//                   labelText: "Kategori $status",
//                   suffixIcon: IconButton(
//                     onPressed: () {
//                       _showModalBottomSheet(pemasukanData);
//                     },
//                     icon: Icon(Icons.add),
//                   ),
//                 ),
//               ),
//             SizedBox(height: 10.0),
//             TextField(
//               controller: TextEditingController(
//                   text:
//                       "${DateFormat('EEEE, dd MMMM yyyy', 'id_ID').format(selectedDate)}"),
//               decoration: InputDecoration(
//                   icon: Icon(Icons.calendar_month_sharp),
//                   labelText: "Tanggal",
//                   border: OutlineInputBorder(
//                       borderRadius: BorderRadius.all(Radius.circular(5.0)))),
//               readOnly: true,
//               onTap: () {
//                 showDatePicker(
//                         context: context,
//                         initialDate: selectedDate,
//                         firstDate: DateTime(2000),
//                         lastDate: DateTime(2101))
//                     .then((value) {
//                   if (value != null) {
//                     setState(() {
//                       selectedDate = value;
//                       print(selectedDate);
//                     });
//                   }
//                 });
//               },
//             ),
//             SizedBox(height: 10.0),
//             TextField(
//               controller: nominal,
//               onChanged: formatNominal,
//               decoration: InputDecoration(
//                   icon: Icon(Icons.attach_money),
//                   labelText: "Nominal",
//                   border: OutlineInputBorder(
//                       borderRadius: BorderRadius.all(Radius.circular(5.0)))),
//               keyboardType: TextInputType.number,
//               inputFormatters: [FilteringTextInputFormatter.digitsOnly],
//             ),
//             SizedBox(height: 10.0),
//             TextField(
//               controller: keterangan,
//               decoration: InputDecoration(
//                   icon: Icon(Icons.edit_note_rounded),
//                   labelText: "Keterangan",
//                   border: OutlineInputBorder(
//                       borderRadius: BorderRadius.all(Radius.circular(5.0)))),
//             ),
//             SizedBox(height: 25.0),
//             Row(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: <Widget>[
//                 Expanded(
//                   child: ElevatedButton(
//                     style: ElevatedButton.styleFrom(
//                       backgroundColor: Colors.blue,
//                     ),
//                     onPressed: () {
//                       Map<String, String> updatedData = {
//                         'tgl_transaksi': DateFormat('yyyy-MM-dd').format(selectedDate),
//                         'status': status,
//                         'kategori': selectedOption!,
//                         'keterangan': keterangan.text,
//                         'nominal': nominal.text,
//                       };
//                       updateTransaksi(widget.id_user['no_transaksi'], updatedData);
//                     },
//                     child: Text(
//                       "SIMPAN",
//                       style: TextStyle(color: Colors.white),
//                     ),
//                   ),
//                 ),
//               ],
//             )
//           ],
//         ),
//       ),
//     );
//   }
// }
