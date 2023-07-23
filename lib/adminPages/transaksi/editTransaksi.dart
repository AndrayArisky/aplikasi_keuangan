import 'dart:convert';
import 'package:aplikasi_keuangan/adminPages/adminPage.dart';
import 'package:aplikasi_keuangan/akunPages/tabBarAkun.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

class Transaksi {
  final String title;
  final String type;
  Transaksi({required this.title, required this.type});
}

class Akun {
  final int id_akun;
  final String nama;
  final String tipe;
  Akun({required this.id_akun, required this.nama, required this.tipe});
}

class editTransaksi extends StatefulWidget {
  final Map<String, dynamic> transaksi;

  const editTransaksi({required this.transaksi});

  @override
  _editTransaksiState createState() => _editTransaksiState();
}

class _editTransaksiState extends State<editTransaksi> {
  int? selected = -1;
  String status = 'Pengeluaran';
  DateTime selectedDate = DateTime.now();
  String _formatNominal = '';

  List<Transaksi> pemasukanData = [];
  List<Transaksi> pengeluaranData = [];
  List<Akun> akunData = [];

  final kategori = TextEditingController();
  final nominal = TextEditingController();
  final keterangan = TextEditingController();

  void addExpense() {
    setState(() {
      kategori.clear();
      status = 'Pengeluaran';
      selected = 2;
    });
  }

  void addIncome() {
    setState(() {
      kategori.clear();
      status = 'Pemasukan';
      selected = 1;
    });
  }

  @override
  void initState() {
    super.initState();
    fetchTransaksiData().then((data) {
      setState(() {
        pemasukanData = data.where((tipe) => tipe.type == 'pm').toList();
        pengeluaranData = data.where((tipe) => tipe.type == 'pr').toList();
        selectCategory(widget.transaksi['kategori']);
      });
    }).catchError((error) {
      print('Error: $error');
    });

    fetchAkunData().then((data) {
      setState(() {
        akunData = data;
        selectAccount(widget.transaksi['id_akun']);
      });
    }).catchError((error) {
      print('Error: $error');
    });
    selected = widget.transaksi['kategori'] == 'Pemasukan' ? 1 : 2;
    kategori.text = widget.transaksi['kategori'];
    selectedDate = DateTime.parse(widget.transaksi['tgl_transaksi']);
    nominal.text = widget.transaksi['nominal'].toString();
    keterangan.text = widget.transaksi['keterangan'];
  }

  Future<List<Transaksi>> fetchTransaksiData() async {
    final response = await http.get(Uri.parse('http://apkeu2023.000webhostapp.com/getAkun.php'));

    if (response.statusCode == 200) {
      final data = json.decode(response.body) as List<dynamic>;
      return data.map((item) => Transaksi(
        title: item['nm_akun'],
        type: item['tipe'],
      )).toList();
    } else {
      throw Exception('Failed to fetch tipe data');
    }
  }

  Future<List<Akun>> fetchAkunData() async {
    final response = await http.get(Uri.parse('http://apkeu2023.000webhostapp.com/getAkun.php'));

    if (response.statusCode == 200) {
      final data = json.decode(response.body) as List<dynamic>;
      return data.map((item) => Akun(
        id_akun: int.parse(item['id_akun']),
        nama: item['nm_akun'],
        tipe: item['tipe'],
      )).toList();
    } else {
      throw Exception('Failed to fetch tipe data');
    }
  }


  void selectCategory(String category) {
    if (pemasukanData.any((tipe) => tipe.title == category)) {
      setState(() {
        selected = 1;
        status = 'Pemasukan';
        kategori.text = category;
      });
    } else if (pengeluaranData.any((tipe) => tipe.title == category)) {
      setState(() {
        selected = 2;
        status = 'Pengeluaran';
        kategori.text = category;
      });
    }
  }

  selectAccount(int accountId) {
    final selectedAccount = akunData.firstWhere(
      (account) => account.id_akun == accountId,
      orElse: () => Akun(id_akun: 0, nama: '', tipe: ''),
    );
    setState(() {
      selected = akunData.indexOf(selectedAccount) + 1;
  });
  }
  

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
  void editTransaksi() async {
    var url = Uri.parse('http://apkeu2023.000webhostapp.com/updateTransaksi.php');
    var selectedAccount = akunData.firstWhere(
      (account) => account.nama == kategori.text,
      orElse: () => Akun(id_akun: 0, nama: '', tipe: ''),
    );
    var body = {
      'no_transaksi': widget.transaksi['no_transaksi'],
      'id_akun': selectedAccount.id_akun.toString(),
      'kategori': kategori.text,
      'tgl_transaksi': selectedDate.toString(),
      'nominal': nominal.text,
      'keterangan': keterangan.text,
      'status': status,
    };

    var response = await http.post(url, body: body);
    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');

    if (response.statusCode == 200) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Transaksi berhasil diperbarui!"),
            content: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
            ),
            actions: <Widget>[
              ElevatedButton(
                child: Text("OK"),
                onPressed: () {
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
            title: Text("Gagal memperbarui transaksi!"),
            content: Text("Pastikan transaksi yang Anda input sudah benar!"),
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


  void _showModal(List<Transaksi> data) {
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
              Transaksi transaction = data[index];
              return ListTile(
                title: Text(transaction.title),
                onTap: () {
                  setState(() {
                    selected = index + 1;
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

  Future<void> hapusTransaksi() async {
  final response = await http.post(
    Uri.parse('http://apkeu2023.000webhostapp.com/deleteTransaksi.php'),
    body: {'no_transaksi': widget.transaksi['no_transaksi']},
  );
  if (response.statusCode == 200) {
    final result = json.decode(response.body);
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Hapus Transaksi!'),
          content: Text('Yakin ingin menghapus data transaksi?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Batal'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                    builder: (context) => adminPage(level: 'admin',),
                  ),
                  (route) => false,
                );
              },
              child: Text('Yakin'),
            )
          ],
        );
      },
    );
  } else {
    ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Gagal menghapus transaksi!'),
          action: SnackBarAction(
            label: 'Oke',
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ),
      );
  }
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Transaksi'),
        actions: [
          Tooltip(
            message: 'Hapus',
            child: IconButton(
              onPressed: () {
                hapusTransaksi();
                //confirmDeleteTransaction(akunData[]);
              },
              icon: Icon(Icons.delete),
            ),
          ),
        ],
      ),
      body: Container(
        padding: EdgeInsets.all(20.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: status == 'Pengeluaran' ? Colors.red : Colors.grey,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.zero
                      ),
                    ),
                    onPressed: () {
                      setState(() {
                        addExpense();
                        selected = -1;
                        status = 'Pengeluaran';
                      });
                    },
                    child: Text(
                      'PENGELUARAN', 
                      style: TextStyle(fontSize: 15)
                    ),
                  ),
                ),
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: status == 'Pemasukan' ? Colors.green : Colors.grey,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.zero
                      ),
                    ),
                    onPressed: () {
                      setState(() {
                        addIncome();
                        selected = -1;
                        status = 'Pemasukan';
                      });
                    },
                    child: Text('PEMASUKAN', style: TextStyle(
                        fontSize: 15,
                      ),),
                  ),
                ),
              ],
            ),
            SizedBox(height: 16.0),
            TextField(
              controller: kategori,
              readOnly: true,
              decoration: InputDecoration(
                icon: Icon(Icons.category_outlined),
                labelText: "Kategori $status",
                suffixIcon: IconButton(
                  onPressed: () {
                    _showModal(status == 'Pemasukan' ? pemasukanData : pengeluaranData);
                  },
                  icon: Icon(Icons.add),
                ),
              ),
            ),
            SizedBox(height: 16.0),
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
            ),

            SizedBox(height: 10.0),
            // KETERANGAN
            TextField(
              controller: keterangan, 
              decoration: InputDecoration(
                  icon: Icon(Icons.edit_note_rounded), 
                  labelText: "Keterangan", 
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(5.0))
                  )
              ),
            ),
            SizedBox(height: 25.0),
            // TOMBOL SIMPAN
            Row(
              mainAxisAlignment: MainAxisAlignment.center, 
              children: <Widget>[
                Expanded(
                  child: Container(
                    padding: EdgeInsets.only(top:20),
                    child: ElevatedButton(
                      child: Text("Edit",
                        style: TextStyle(fontSize: 15),
                      ),
                      onPressed: () {
                        editTransaksi();
                      },
                    ),
                  ) 
                )
              ]
            ),
          ],
        ),
      ),
    );
  }
}