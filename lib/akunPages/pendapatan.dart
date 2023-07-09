import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class pendapatan extends StatefulWidget {
  @override
  pendapatanState createState() => pendapatanState();
}

class pendapatanState extends State<pendapatan> {
  List<dynamic> Data = [];

  @override
  void initState() {
    super.initState();
    fetchData();
  }


  Future<void> fetchData() async {
    final response = await http.get(Uri.parse('https://apkeu2023.000webhostapp.com/getdata.php'));
    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      final akun = jsonData.where((data) => data['neraca'] == 'Pendapatan').toList();
      setState(() {
        Data = akun;
      });
    } else {
      throw Exception('Gagal mengambil data!');
    }
  }


  @override
  Widget build(BuildContext context) {
    var getdata;
    return Scaffold(
      body: Data.isEmpty ? Center(
        child: CircularProgressIndicator()) : ListView(
          children: [
            DataTable(
              columns: [
                //DataColumn(label: Text('Kode')),
                DataColumn(label: Text('Nama Akun')),
                DataColumn(label: Text('Grup'))
              ], 
              rows: Data.map(
                (getdata) => DataRow(
                  cells: [
                    //DataCell(Text(getdata['kode_akun'].toString())),
                    DataCell(Text(getdata['nm_akun'].toString())),
                    DataCell(Text(getdata['grup'].toString())),
                  ]
                )
              ).toList()
            )
          ],
        )
    );
  }
}