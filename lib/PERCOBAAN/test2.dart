// import 'dart:convert';
// import 'package:aplikasi_keuangan/adminPages/adminPage.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:intl/intl.dart';
// import 'package:http/http.dart' as http;

// // class Tipe{
// //   final String title;
// //   final String type;

// //   Tipe({
// //     required this.title, 
// //     required this.type
// //   });
// // }

// class inputSaya extends StatefulWidget {
//   final id_user;
//   inputSaya({required this.id_user});

//   @override
//   inputSayaState createState() => inputSayaState();
// }

// class inputSayaState extends State<inputSaya> {

//   // List<Tipe> pemasukanData = [
//   //   Tipe(title: 'Pendapatan Jasa', type: 'Pemasukan'),
//   //   Tipe(title: 'Pendapatan Giveaway', type: 'Pemasukan'),
//   //   Tipe(title: 'Dapat Dari Baim Wong', type: 'Pemasukan'),
//   // ];
//   // List<Tipe> pengeluaranData = [
//   //   Tipe(title: 'Harga Pokok Penjualan', type: 'Pengeluaran'),
//   //   Tipe(title: 'Beban Perlengkapan/ATK', type: 'Pengeluaran'),
//   //   Tipe(title: 'Beban Gaji Karyawan', type: 'Pengeluaran'),
//   //   Tipe(title: 'Beban Sewa', type: 'Pengeluaran'),
//   //   Tipe(title: 'Beban Listrik', type: 'Pengeluaran'),
//   //   Tipe(title: 'Beban Air', type: 'Pengeluaran'),
//   //   Tipe(title: 'Beban Lain-lain', type: 'Pengeluaran'),
//   // ];
  

//   // DI CHATGPT BUAT MUNCUL DATA DI SHOWMODALBUTTON

//   int? selected = -1;
//   int selectedIndex = 2;
//   String status = 'Pengeluaran';
//   DateTime selectedDate = DateTime.now();
//   String _formatNominal = '';
//   late dynamic id_user;
//   String? selectedOption;

//   bool isLoading = true;
//   List<dynamic> data = [];

//   final kategori = TextEditingController();
//   final nominal = TextEditingController();
//   final keterangan = TextEditingController();

//   // FUNGSI TOMBOL SIMPAN
//   void tambahTransaksi() async {
//     var url = Uri.parse('http://apkeu2023.000webhostapp.com/inputdata.php');
//     var body = {
//       'id_user': widget.id_user.toString(),
//       'kategori': kategori.text,
//       'tgl_transaksi': selectedDate.toString(),
//       'nominal': nominal.text,
//       'keterangan': keterangan.text,
//       'status': status
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
//                     //Navigator.of(context).pop();
//                     Navigator.pushReplacement(
//                       context, 
//                       MaterialPageRoute(
//                         builder: (context) => adminPage(id_user: 11)
//                       )
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
//               content:
//                   Text("Pastikan data yang anda input sudah benar!"),
//               // content: Text(result["message"]),
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
  
//   @override
//   void initState() {
//     super.initState();
//     fetchData();
//   }

//   // FUNGSI AMBIL DATA AKUN
//   Future<void> fetchData() async {
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


//   // FUNGSI TOMBOL
//   void onChanged(int? value) {
//     setState(() {
//       this.selected = value;
//     });
//   }

//   // FUNGSI NOMINAL
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

//   // FUNGSI PENGELUARAN
//   void addExpense() {
//     setState(() {
//       status = 'Pengeluaran';
//       selectedIndex = 2;
//       kategori.clear();
//     });
//   }

//   // FUNGSI PEMASUKAN
//   void addIncome() {
//     setState(() {
//       status = 'Pemasukan';
//       selectedIndex = 1;
//       kategori.clear();
//     });
//   }

//   void _showModalBottomSheet(String tipe) {
//     List<dynamic> filteredData = 
//     data.where((item) => item['tipe'] == tipe).toList();

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
//                 itemCount: filteredData.length,
//                 itemBuilder: (BuildContext context, int index) {
//                   //Tipe transaction = data[index];
//                   final item = filteredData[index];
//                   return ListTile(
//                     //title: Text(transaction.title),
//                     title: Text(item['nm_akun']),
//                     onTap: () {
//                       setState(() {
//                         selectedOption = item.title;
//                         kategori.text = item.title;
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
//         appBar: AppBar(
//           title: Text('Tambah Transaksi'),
//           leading: IconButton(
//             icon: Icon(Icons.arrow_back),
//             onPressed: () {
//               Navigator.pushAndRemoveUntil(
//                 context,
//                 MaterialPageRoute(
//                   builder: (context) => adminPage(id_user: 11),
//                 ),
//                 (route) => false,
//               );
//             },
//           ),
//         ),
//         body: isLoading ? Center (
//           child: CircularProgressIndicator(),
//         ) : Container(
//           padding: EdgeInsets.only(top: 35, right: 20, left: 20, bottom: 20),
//           child: Column(
//             children: <Widget>[
//             // TOMBOL PEMASUKAN DAN PENGELUARAN
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
//                       backgroundColor: selectedIndex == 1 ? Colors.green : Colors.grey,
//                       shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.zero
//                       ),
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
//             TextField(
//               controller: kategori, 
//               decoration: InputDecoration(
//                 icon: Icon(Icons.category_outlined),
//                 labelText: "Kategori $status",
//                 suffixIcon: IconButton(
//                   onPressed: () {
                    
//                     // Lakukan sesuatu saat tombol ikon ditekan
//                     _showModalBottomSheet('pr');
//                     // String text = kategori.text;
//                     // print('Nilai yang dimasukkan: $text');
//                   },
//                   icon: Icon(Icons.add),
//                 ),
//               ),
//             ),
//             if (status == 'Pemasukan')
//             TextField(
//               controller: kategori, 
//               decoration: InputDecoration(
//                 icon: Icon(Icons.category_outlined),
//                 labelText: "Kategori $status",
//                 suffixIcon: IconButton(
//                   onPressed: () {
                    
//                     // Lakukan sesuatu saat tombol ikon ditekan
//                     _showModalBottomSheet('pm');
//                     // String text = kategori.text;
//                     // print('Nilai yang dimasukkan: $text');
//                   },
//                   icon: Icon(Icons.add),
//                 ),
//               ),
//             ),
            
//             SizedBox(height: 10.0),
//             // TANGGAL
//             TextField(
//               controller: TextEditingController(
//                 text: "${DateFormat ('EEEE, dd MMMM yyyy', 'id_ID'). format(selectedDate)}"
//               ),
//               decoration: InputDecoration(
//                 icon: Icon(
//                   Icons.calendar_month_sharp
//                 ), 
//                 labelText: "Tanggal",
//                 border: OutlineInputBorder(
//                   borderRadius: BorderRadius.all(Radius.circular(5.0))
//                 )
//               ),
//               readOnly: true,
//               onTap: () {
//                 showDatePicker(
//                   context: context, 
//                   initialDate: selectedDate, 
//                   firstDate: DateTime(2000),
//                   lastDate: DateTime(2101)
//                 ).then((value) {
//                   if(value != null) {
//                     setState(() {
//                       selectedDate = value;
//                       print(selectedDate);
//                     });
//                   }
//                 });
//               },
//             ),
                       
//             SizedBox(height: 10.0),
//             // NOMINAL
//             TextField(
//               controller: nominal,
//               onChanged: formatNominal,
//               decoration: InputDecoration(
//                 icon: Icon(Icons.attach_money),
//                 labelText: "Nominal",
//                 border: OutlineInputBorder(
//                   borderRadius: BorderRadius.all(Radius.circular(5.0))
//                 )
//               ),
//               keyboardType: TextInputType.number,
//               inputFormatters: [
//                 FilteringTextInputFormatter.digitsOnly
//               ], 
//             ),
            
//             SizedBox(height: 10.0),
//             // KETERANGAN
//             TextField(
//               controller: keterangan, //editing controller of this TextField
//               decoration: InputDecoration(
//                   icon: Icon(Icons.edit_note_rounded), //icon of text field
//                   labelText: "Keterangan", //label text of field
//                   border: OutlineInputBorder(
//                     borderRadius: BorderRadius.all(Radius.circular(5.0)
//                     )
//                   )
//               ),
//             ),

//             SizedBox(
//               height: 20.0
//             ),
//             Row(
//               children: <Widget>[
//                 Radio(
//                   value: 0,
//                   groupValue: this.selected,
//                   onChanged: (int? value) {
//                     onChanged(value);
//                   }
//                 ),
//                 Container(
//                   width: 8.0,
//                 ),
//                 Text('Cash'),
//                 Radio(
//                   value: 1,
//                   groupValue: this.selected,
//                   onChanged: (int? value) {
//                     onChanged(value);
//                   }
//                 ),
//                 Container(
//                   width: 8.0,
//                 ),
//                 Text('Non-cash')
//               ],
//             ),

//             SizedBox(height: 25.0),
//             // TOMBOL SIMPAN
//             Row(
//               mainAxisAlignment: MainAxisAlignment.center, 
//               children: <Widget>[
//                 Expanded(
//                   child: Container(
//                     padding: EdgeInsets.only(top:20),
//                     child: ElevatedButton(
//                       child: Text(
//                         "Tambah",
//                         style: TextStyle(fontSize: 15),
//                       ),
//                       onPressed: () {
//                         print('Id User : ${widget.id_user}');
//                         tambahTransaksi();
//                       },
//                     ),
//                   ) 
//                 )
//               ]
//             ),
//           ]
//         ),
//       )
//     );
//   }
// }
