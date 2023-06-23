import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class beban extends StatefulWidget {
  @override
  bebanState createState() => bebanState();
}

class bebanState extends State<beban> {
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
      // List<dynamic> data = jsonDecode(response.body);
      
      setState(() {
        Data = jsonData;
      });
      
      // Lakukan filter atau manipulasi data sesuai kebutuhan Anda
    //List<dynamic> filteredData = data.where((getdata) => getdata['neraca'] == 'Aset').toList();
    
    // Mengubah filteredData menjadi List<Item>
    //List<Items> itemList = filteredData.map((item) => Items.fromJson(item)).toList();
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
                DataColumn(label: Text('Kode')),
                DataColumn(label: Text('Nama Akun')),
                DataColumn(label: Text('Grup'))
              ], 
              rows: Data.map(
                (getdata) => DataRow(
                  cells: [
                    DataCell(Text(getdata['kode_akun'].toString())),
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