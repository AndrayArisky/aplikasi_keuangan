import 'dart:convert';
import 'package:aplikasi_keuangan/adminPages/adminPage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;

class inputAdmin extends StatefulWidget {
  final id_user;
  inputAdmin({required this.id_user});

  @override
  inputAdminState createState() => inputAdminState();
}

class inputAdminState extends State<inputAdmin> {
  int? selected = -1;
  int selectedIndex = 2;
  //bool buttonStatus = true;
  //late int type;
  String status = 'Pemasukan';
  DateTime selectedDate = DateTime.now();
  String _formatNominal = '';
  late dynamic id_user;

  final kategori = TextEditingController();
  final nominal = TextEditingController();
  final keterangan = TextEditingController();

  // FUNGSI TOMBOL SIMPAN
  void tambahTransaksi() async {
    var url = Uri.parse('http://apkeu2023.000webhostapp.com/inputdata.php');
    var body = {
      'id_user': widget.id_user.toString(),
      'kategori': kategori.text,
      'tgl_transaksi': selectedDate.toString(),
      'nominal': nominal.text,
      'keterangan': keterangan.text,
      'status': status
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
                        builder: (context) => adminPage(id_user: 11)
                      )
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

  // @override
  // void initState() {
  //   super.initState();
  // }

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Tambah Transaksi'),
        ),
        body: Container(
          padding: EdgeInsets.all(20),
          child: Column(children: <Widget>[
            // TOMBOL PEMASUKAN DAN PENGELUARAN
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
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
                      setState(() {
                        selectedIndex = 1;
                        status = 'Pemasukan';
                      });
                    },
                  ),
                ),
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
                      setState(() {
                        selectedIndex = 2;
                        status = 'Pengeluaran';
                      });
                    },
                  ),
                ),
              ],
            ),

            SizedBox(height: 20.0),
            // KATEGORI
            TextField(
              controller: kategori, 
              decoration: InputDecoration(
                  icon: Icon(Icons.category_outlined),
                  labelText: "Kategori" 
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
            /*
            TextField(
              controller: date, //editing controller of this TextField
              decoration: InputDecoration(
                  icon: Icon(Icons.calendar_month_sharp), //icon of text field
                  labelText: "Tanggal", //label text of field
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(5.0)))),
              readOnly:
                  true, //set it true, so that user will not able to edit text
              onTap: () async {
                DateTime? pickedDate = await showDatePicker(
                    context: context,
                    initialDate: selectedDate,
                    firstDate: DateTime(
                        2000), //DateTime.now() - not to allow to choose before today.
                    lastDate: DateTime(2101));

                if (pickedDate != null) {
                  print(
                      pickedDate); //pickedDate output format => 2021-03-10 00:00:00.000
                  String formattedDate =
                      DateFormat('dd-MM-yyyy').format(pickedDate);
                  print(
                      formattedDate); //formatted date output using intl package =>  2021-03-16
                  //you can implement different kind of Date Format here according to your requirement

                  setState(() {
                    date.text =
                        formattedDate; //set output date to TextField value.
                  });
                } else {
                  print("Tentukan tanggal transaksi!");
                }
                /*
              showDatePicker (
                context: context,
                initialDate: selectedDate,
                firstDate: DateTime(2000), //DateTime.now() - not to allow to choose before today.
                lastDate: DateTime(2101)
              ).then((value) {
                if (value != null) {
                  setState(() {
                    selectedDate = value;
                    print(selectedDate);
                  });
                } else {
                  print("Tentukan tanggal transaksi!");
                  print('');
                }
              });
              */
              },
            ),
            */
            
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
            /*
            TextField(
              controller: nominal, //editing controller of this TextField
              decoration: InputDecoration(
                  icon: Icon(Icons.attach_money), //icon of text field
                  labelText: "Nominal", //label text of field
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(5.0)))),
              keyboardType: TextInputType.number,
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
                InputFormatterNominal()
              ],
            ),
            */
            
            SizedBox(height: 10.0),
            // KETERANGAN
            TextField(
              controller: keterangan, //editing controller of this TextField
              decoration: InputDecoration(
                  icon: Icon(Icons.edit_note_rounded), //icon of text field
                  labelText: "Keterangan", //label text of field
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(5.0)
                    )
                  )
              ),
            ),

            /*
            SizedBox(
              height: 20.0
            ),
            Row(
              children: <Widget>[
                Radio(
                  value: 0,
                  groupValue: this.selected,
                  onChanged: (int? value) {
                    onChanged(value);
                  }
                ),
                Container(
                  width: 8.0,
                ),
                Text('Cash'),
                Radio(
                  value: 1,
                  groupValue: this.selected,
                  onChanged: (int? value) {
                    onChanged(value);
                  }
                ),
                Container(
                  width: 8.0,
                ),
                Text('Non-cash')
              ],
            ),
            */

            SizedBox(height: 25.0),
            // TOMBOL SIMPAN
            Row(
              mainAxisAlignment: MainAxisAlignment.center, 
              children: <Widget>[
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.all(20),
                    child: ElevatedButton(
                      child: Text(
                        "Tambah",
                        style: TextStyle(fontSize: 15),
                      ),
                      onPressed: () {
                    /*
                    Navigator.pushReplacement(context,
                        MaterialPageRoute(builder: (context) {
                      return transaksi();
                    }));
                    */
                      print('Id User : ${widget.id_user}');
                      tambahTransaksi();
                  },
                ),
              ))
            ]),
          ]),
        ));
  }
}
