import 'dart:convert';
import 'package:aplikasi_keuangan/adminPages/adminPage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;

class Tipe{
  final String title;
  final String type;

  Tipe({
    required this.title, 
    required this.type
  });
}

class inputAdmin extends StatefulWidget {
  final level;
  inputAdmin({required this.level});

  @override
  inputAdminState createState() => inputAdminState();
}

class inputAdminState extends State<inputAdmin> {

  int? selected = -1;
  int selectedIndex = 2;
  String status = 'Pengeluaran';
  DateTime selectedDate = DateTime.now();
  String _formatNominal = '';
  String id_user = '1';
  String? selectedOption;

  List<Tipe> pemasukanData = [];
  List<Tipe> pengeluaranData = [];

  final kategori = TextEditingController();
  final nominal = TextEditingController();
  final keterangan = TextEditingController();

  Future<List<Tipe>> fetchTipeData() async {
    var url = Uri.parse('http://apkeu2023.000webhostapp.com/getdata.php');
    var response = await http.get(url);

    if (response.statusCode == 200) {
      var data = json.decode(response.body) as List<dynamic>;
      return data.map((item) => Tipe(
        title: item['nm_akun'],
        type: item['tipe'],
      )).toList();
    } else {
      throw Exception('Failed to fetch tipe data');
    }
  }

  @override
  void initState() {
    super.initState();
    fetchTipeData().then((data) {
      setState(() {
        pemasukanData = data.where((tipe) => tipe.type == 'pm').toList();
        pengeluaranData = data.where((tipe) => tipe.type == 'pr').toList();
      });
    }).catchError((error) {
      print('Error: $error');
    });
  }

  // FUNGSI TOMBOL SIMPAN
  void tambahTransaksi() async {
    var url = Uri.parse('http://apkeu2023.000webhostapp.com/inputdata.php');
    var body = {
      'id_user': id_user,
      'kategori': kategori.text,
      'tgl_transaksi': selectedDate.toString(),
      'nominal': nominal.text,
      'keterangan': keterangan.text,
      'status': status
    };

    var response = await http.post(url, body: body);
    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');
    //print('ID USER : ${widget.id_user}, selectedDate $selectedDate');

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
                    Navigator.pushAndRemoveUntil(
                      context, 
                      MaterialPageRoute(
                        builder: (context) => adminPage(level: 'admin')
                      ),
                      (route) => false
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
              content:
                  Text("Pastikan data yang anda input sudah benar!"),
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
      nominal.clear();
      keterangan.clear();
    });
  }

  void addIncome() {
    setState(() {
      status = 'Pemasukan';
      selectedIndex = 1;
      kategori.clear();
      nominal.clear();
      keterangan.clear();
    });
  }

  void _showModal(List<Tipe> data) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          padding: EdgeInsets.all(16.0),
          height: 300,
          child: ListView.builder(
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
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Tambah Transaksi'),
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                  builder: (context) => adminPage(level: 'admin'),
                ),
                (route) => false,
              );
            },
          ),
        ),
        body: Container(
          padding: EdgeInsets.all(20),
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
                      backgroundColor: selectedIndex == 1 ? Colors.green : Colors.grey,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.zero
                      ),
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
                    _showModal(pengeluaranData);
                    // String text = kategori.text;
                    // print('Nilai yang dimasukkan: $text');
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
                    _showModal(pemasukanData);
                    // String text = kategori.text;
                    // print('Nilai yang dimasukkan: $text');
                  },
                  icon: Icon(Icons.add),
                ),
              ),
            ),
            
            SizedBox(height: 10.0),
            // TANGGAL
            TextField(
              controller: TextEditingController(
                text: "${DateFormat ('EEEE, dd MMMM yyyy', 'id_ID'). format(selectedDate)}"
              ),
              decoration: InputDecoration(
                icon: Icon(
                  Icons.calendar_month_sharp
                ), 
                labelText: "Tanggal",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(5.0))
                )
              ),
              readOnly: true,
              onTap: () {
                showDatePicker(
                  context: context, 
                  initialDate: selectedDate, 
                  firstDate: DateTime(2000),
                  lastDate: DateTime(2101)
                ).then((value) {
                  if(value != null) {
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
                  borderRadius: BorderRadius.all(Radius.circular(5.0))
                )
              ),
              keyboardType: TextInputType.number,
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly
              ], 
            ),
            
            SizedBox(height: 10.0),
            // KETERANGAN
            TextField(
              controller: keterangan, //editing controller of this TextField
              decoration: InputDecoration(
                  icon: Icon(Icons.edit_note_rounded), //icon of text field
                  labelText: "Keterangan", //label text of field
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(5.0))
                  )
              ),
            ),

            // SizedBox(
            //   height: 20.0
            // ),
            // Row(
            //   children: <Widget>[
            //     Radio(
            //       value: 0,
            //       groupValue: this.selected,
            //       onChanged: (int? value) {
            //         onChanged(value);
            //       }
            //     ),
            //     Container(
            //       width: 8.0,
            //     ),
            //     Text('Cash'),
            //     Radio(
            //       value: 1,
            //       groupValue: this.selected,
            //       onChanged: (int? value) {
            //         onChanged(value);
            //       }
            //     ),
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
                  child: Container(
                    padding: EdgeInsets.only(top:20),
                    child: ElevatedButton(
                      child: Text(
                        "Tambah",
                        style: TextStyle(fontSize: 15),
                      ),
                      onPressed: () {
                        print('Id User : ${widget.level}');
                        tambahTransaksi();
                      },
                    ),
                  ) 
                )
              ]
            ),
          ]
        ),
      )
    );
  }
}
