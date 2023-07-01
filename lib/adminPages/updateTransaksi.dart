import 'dart:convert';
import 'package:aplikasi_keuangan/adminPages/adminPage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;

class Tipe {
  final String title;
  final String type;

  Tipe({required this.title, required this.type});
}

class updateTransaksi extends StatefulWidget {
  final id_user;
  updateTransaksi({required this.id_user});

  @override
  updateTransaksiState createState() => updateTransaksiState();
}

class updateTransaksiState extends State<updateTransaksi> {
  List<Tipe> pemasukanData = [
    Tipe(title: 'Pendapatan Jasa', type: 'Pemasukan'),
    Tipe(title: 'Pendapatan Giveaway', type: 'Pemasukan'),
    Tipe(title: 'Dapat Dari Baim Wong', type: 'Pemasukan'),
  ];
  List<Tipe> pengeluaranData = [
    Tipe(title: 'Harga Pokok Penjualan', type: 'Pengeluaran'),
    Tipe(title: 'Beban Perlengkapan/ATK', type: 'Pengeluaran'),
    Tipe(title: 'Beban Gaji Karyawan', type: 'Pengeluaran'),
    Tipe(title: 'Beban Sewa', type: 'Pengeluaran'),
    Tipe(title: 'Beban Listrik', type: 'Pengeluaran'),
    Tipe(title: 'Beban Air', type: 'Pengeluaran'),
    Tipe(title: 'Beban Lain-lain', type: 'Pengeluaran'),
  ];

  // DI CHATGPT BUAT MUNCUL DATA DI SHOWMODALBUTTON

  int? selected = -1;
  int selectedIndex = 2;
  String status = 'Pengeluaran';
  DateTime selectedDate = DateTime.now();
  String _formatNominal = '';
  late dynamic id_user;
  String? selectedOption;

  final kategori = TextEditingController();
  final nominal = TextEditingController();
  final keterangan = TextEditingController();

  // FUNGSI TOMBOL SIMPAN
  void updateTransaksi(String noTransaksi, Map<String, String> updatedData) async {
    var url = Uri.parse('http://apkeu2023.000webhostapp.com/updateData.php');
    var body = {
      'no_transaksi': noTransaksi,
      'updated_data' : json.encode(updatedData)
    };

    var response = await http.post(url, body: body);
    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');
    print('ID USER : ${widget.id_user}, selectedDate $selectedDate');

    if (response.statusCode == 200) {
      final result = json.decode(response.body);
      if (result['message'] == 'Data berhasil disimpan') {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text("Data berhasil disimpan!"),
              content: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
              ),
              actions: <Widget>[
                ElevatedButton(
                  child: Text("OK"),
                  onPressed: () {
                    //Navigator.of(context).pop();
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (context) => adminPage(id_user: 11)),
                    );
                  },
                )
              ],
            );
          },
        );
      } else {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text("Gagal menyimpan data!"),
              content: Text("Pastikan data yang anda input sudah benar!"),
              // content: Text(result["message"]),
              actions: <Widget>[
                ElevatedButton(
                  child: Text("OK"),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                )
              ],
            );
          },
        );
      }
    }
  }

  // FUNGSI TOMBOL
  void onChanged(int? value) {
    setState(() {
      this.selected = value;
    });
  }

  // FUNGSI NOMINAL
  void formatNominal(String value) {
    if (value.isEmpty) {
      setState(() {
        _formatNominal = '';
      });
      return;
    }

    final numberFormat = NumberFormat.simpleCurrency(locale: 'id_ID');
    try {
      final amount = double.parse(value);
      setState(() {
        _formatNominal = numberFormat.format(amount);
      });
    } catch (e) {
      setState(() {
        _formatNominal = '';
      });
    }
  }

  void addExpense() {
    setState(() {
      status = 'Pengeluaran';
      selectedIndex = 2;
      kategori.clear();
    });
  }

  void addIncome() {
    setState(() {
      status = 'Pemasukan';
      selectedIndex = 1;
      kategori.clear();
    });
  }

  void _showModalBottomSheet(List<Tipe> data) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          padding: EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              ListView.builder(
                shrinkWrap: true,
                itemCount: data.length,
                itemBuilder: (BuildContext context, int index) {
                  Tipe transaction = data[index];
                  return ListTile(
                    title: Text(transaction.title),
                    onTap: () {
                      setState(() {
                        selectedOption = transaction.title;
                        kategori.text = transaction.title;
                      });
                      Navigator.pop(context);
                    },
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Update Data Transaksi'),
        actions: [
          IconButton(
            icon: Icon(Icons.delete),
            onPressed: () {
            // Aksi yang ingin dilakukan saat ikon ditekan
            },
          ),
        ],
      ),
      body: Container(
        padding:
            EdgeInsets.only(top: 35, right: 20, left: 20, bottom: 20),
        child: Column(
          children: <Widget>[
            // TOMBOL PEMASUKAN DAN PENGELUARAN
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor:
                          selectedIndex == 2 ? Colors.red : Colors.grey,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.zero),
                    ),
                    child: Text(
                      "PENGELUARAN",
                      style: TextStyle(fontSize: 15),
                    ),
                    onPressed: () {
                      addExpense();
                      setState(() {
                        selectedIndex = 2;
                        status = 'Pengeluaran';
                      });
                    },
                  ),
                ),
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor:
                          selectedIndex == 1 ? Colors.green : Colors.grey,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.zero),
                    ),
                    child: Text(
                      "PEMASUKAN",
                      style: TextStyle(
                        fontSize: 15,
                      ),
                    ),
                    onPressed: () {
                      addIncome();
                      setState(() {
                        selectedIndex = 1;
                        status = 'Pemasukan';
                      });
                    },
                  ),
                ),
              ],
            ),

            SizedBox(height: 10.0),
            if (status == 'Pengeluaran')
              TextField(
                controller: kategori,
                decoration: InputDecoration(
                  icon: Icon(Icons.category_outlined),
                  labelText: "Kategori $status",
                  suffixIcon: IconButton(
                    onPressed: () {
                      // Lakukan sesuatu saat tombol ikon ditekan
                      _showModalBottomSheet(pengeluaranData);
                    },
                    icon: Icon(Icons.add),
                  ),
                ),
              ),
            if (status == 'Pemasukan')
              TextField(
                controller: kategori,
                decoration: InputDecoration(
                  icon: Icon(Icons.category_outlined),
                  labelText: "Kategori $status",
                  suffixIcon: IconButton(
                    onPressed: () {
                      // Lakukan sesuatu saat tombol ikon ditekan
                      _showModalBottomSheet(pemasukanData);
                    },
                    icon: Icon(Icons.add),
                  ),
                ),
              ),

            SizedBox(height: 10.0),
            // TANGGAL
            TextField(
              controller: TextEditingController(
                  text:
                      "${DateFormat('EEEE, dd MMMM yyyy', 'id_ID').format(selectedDate)}"),
              decoration: InputDecoration(
                  icon: Icon(Icons.calendar_month_sharp),
                  labelText: "Tanggal",
                  border: OutlineInputBorder(
                      borderRadius:
                          BorderRadius.all(Radius.circular(5.0)))),
              readOnly: true,
              onTap: () {
                showDatePicker(
                        context: context,
                        initialDate: selectedDate,
                        firstDate: DateTime(2000),
                        lastDate: DateTime(2101))
                    .then((value) {
                  if (value != null) {
                    setState(() {
                      selectedDate = value;
                      print(selectedDate);
                    });
                  }
                });
              },
            ),

            SizedBox(height: 10.0),
            // NOMINAL
            TextField(
              controller: nominal,
              onChanged: formatNominal,
              decoration: InputDecoration(
                  icon: Icon(Icons.attach_money),
                  labelText: "Nominal",
                  border: OutlineInputBorder(
                      borderRadius:
                          BorderRadius.all(Radius.circular(5.0)))),
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            ),

            SizedBox(height: 10.0),
            // KETERANGAN
            TextField(
              controller: keterangan,
              decoration: InputDecoration(
                  icon: Icon(Icons.edit_note_rounded),
                  labelText: "Keterangan",
                  border: OutlineInputBorder(
                      borderRadius:
                          BorderRadius.all(Radius.circular(5.0)))),
            ),

            // SizedBox(
            //   height: 20.0,
            // ),
            // Row(
            //   children: <Widget>[
            //     Radio(
            //         value: 0,
            //         groupValue: this.selected,
            //         onChanged: (int? value) {
            //           onChanged(value);
            //         }),
            //     Container(
            //       width: 8.0,
            //     ),
            //     Text('Cash'),
            //     Radio(
            //         value: 1,
            //         groupValue: this.selected,
            //         onChanged: (int? value) {
            //           onChanged(value);
            //         }),
            //     Container(
            //       width: 8.0,
            //     ),
            //     Text('Non-cash')
            //   ],
            // ),

            SizedBox(height: 25.0),
            // TOMBOL SIMPAN
            Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue
                      ),
                      onPressed: () {
                        updateTransaksi;
                      },
                      child: Text(
                        "SIMPAN",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ])
          ],
        ),
      ),
    );
  }
}